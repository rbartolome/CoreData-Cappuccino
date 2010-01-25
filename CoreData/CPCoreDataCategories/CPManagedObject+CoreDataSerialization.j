//
//  CPManagedObject+CoreDataSerialization.j
//
//  Created by Raphael Bartolome on 14.01.10.
//

@import <Foundation/Foundation.j>

//global keys for serialization formats
CoreDataSerializationXMLFormat = "CoreDataSerializationXMLFormat";
CoreDataSerializationJSONFormat = "CoreDataSerializationJSONFormat";
CoreDataSerialization280NPLISTFormat = "CoreDataSerialization280NPLISTFormat";
CoreDataSerializationDictionaryFormat = "CoreDataSerializationDictionaryFormat";


//private keys for serialization
CPManagedObjectIDKey = "CPManagedObjectID";
CPDglobalID = "CPDglobalID";
CPDlocalID = "CPDlocalID";
CPDisTemporaryID = "CPDisTemporaryID";
CPEntityDescriptionName = "CPEntityDescriptionName";
CPDmodelName = "CPDmodelName";
CPDisUpdated = "CPDisUpdated";
CPDisDeleted = "CPDisDeleted";
CPDisFault = "CPDisFault";
CPDallProperties = "CPDallProperties";
CPDchangedProperties = "CPDchangedProperties";


@implementation CPManagedObject (CoreDataSerialization)


/*
 * ************
 *	XML format
 * ************
 */
+ (id)deserializeFromXML:(CPData) data withContext:(CPDContext) aContext
{
	var errorString;
	var propertyListFromData = [CPPropertyListSerialization propertyListFromData:data
															format:CPPropertyListXMLFormat_v1_0 errorDescription:errorString];
	
	return [CPManagedObject deserializeFromDictionary:propertyListFromData withContext:aContext];
}


- (CPData)serializeToXML:(BOOL) containsAllProperties
{
	var errorString;
	var result = [CPPropertyListSerialization dataFromPropertyList:[self serializeToDictionary:containsAllProperties] 
															format:CPPropertyListXMLFormat_v1_0 errorDescription:errorString];
									
	return result;
}


/*
 * *****************
 *	280NPLIST format
 * *****************
 */
+ (id)deserializeFrom280NPLIST:(CPData) data withContext:(CPDContext) aContext
{
	var errorString;
	var propertyListFromData = [CPPropertyListSerialization propertyListFromData:data
															format:CPPropertyList280NorthFormat_v1_0 errorDescription:errorString];
	
	return [CPManagedObject deserializeFromDictionary:propertyListFromData withContext:aContext];
}


- (CPData)serializeTo280NPLIST:(BOOL) containsAllProperties
{
	var errorString;
	var result = [CPPropertyListSerialization dataFromPropertyList:[self serializeToDictionary:containsAllProperties] 
															format:CPPropertyList280NorthFormat_v1_0 errorDescription:errorString];
									
	return result;
}


/*
 * ************
 *	JSON format
 * ************
 */
+ (id)deserializeFromJSON:(id) jsonObject withContext:(CPDContext) aContext
{
	var aDictionary = [CPDictionary dictionaryWithJSObject:jsonObject recursively:YES];
	var aObject = [CPManagedObject deserializeFromDictionary:aDictionary withContext:aContext];
	
	return aObject;
}


- (id)serializeToJSON:(BOOL) containsAllProperties
{
	var result =  [CPString JSONFromObject:[self serializeToDictionary:containsAllProperties]];
	return result;
}


/*
 * ******************
 *	Dictionary format
 * ******************
 */
+ (id)deserializeFromDictionary:(CPDictionary) aDictionary withContext:(CPDContext) aContext
{
	var aCPManagedObject = nil;
	
	if(aDictionary != nil)
	{
		var aModelName = [aDictionary objectForKey:CPDmodelName];
		var aModel = nil;
		if([[aContext model] isModelAllowedForMergeByName: aModelName])
		{		
			var aEntityName = [aDictionary objectForKey:CPEntityDescriptionName];
			var aEntity = [[aContext model] entityWithName:aEntityName];

			var allProperties = [aDictionary objectForKey:CPDallProperties];
			var changedProperties = [aDictionary objectForKey:CPDchangedProperties];

			var objIsDeleted = [aDictionary objectForKey:CPDisDeleted];
			var objIsUpdated = [aDictionary objectForKey:CPDisUpdated];
			var objIsFault = [aDictionary objectForKey:CPDisFault];

			//deserialize the ObjectID
			var aObjectID = [CPManagedObjectID deserializeFromDictionary: [aDictionary objectForKey:CPManagedObjectIDKey] withContext:aContext];
		
			//deserialize the CPManagedObject representation
			aCPManagedObject = [[CPManagedObject alloc] init];
			[aCPManagedObject setObjectID:aObjectID];
			[aCPManagedObject setEntity:aEntity];
			[aCPManagedObject setContext:aContext];
			[aCPManagedObject setFault:objIsFault];
			[aCPManagedObject setDeleted:objIsDeleted];
			[aCPManagedObject setUpdated:objIsUpdated];
			
			[aCPManagedObject _setData:[aCPManagedObject deserializeProperties:allProperties]];
			[aCPManagedObject _setChangedData:[aCPManagedObject deserializeProperties:allProperties]];
			
		}
		else
		{
			CPLog.error("*** Exception: Model '" + aModelName + "' is not mergeable***")
		}
		
	}

	return aCPManagedObject;
}


- (CPDictionary)serializeToDictionary:(BOOL) containsAllProperties
{
	var result = [[CPMutableDictionary alloc] init];
		
	[result setObject:[[self objectID] serializeToDictionary] forKey:CPManagedObjectIDKey];
	[result setObject:[[self entity] name] forKey:CPEntityDescriptionName];
	[result setObject:[self isFault] forKey:CPDisFault];
	[result setObject:[self isUpdated] forKey:CPDisUpdated];
	[result setObject:[self isDeleted] forKey:CPDisDeleted];
	
	[result setObject:[[[self entity] model] name] forKey:CPDmodelName];
	
	if(containsAllProperties)
		[result setObject:[self serializeProperties:[self data]] forKey:CPDallProperties];
		
	[result setObject:[self serializeProperties:[self changedData]] forKey:CPDchangedProperties];
	 	
	return result;
}

- (CPDictionary) deserializeProperties:(CPDictionary) aDictionary
{
	var result = [[CPMutableDictionary alloc] init];

	var propertyKeys = [aDictionary keyEnumerator];
	var aKey;
	while((aKey = [propertyKeys nextObject]))		
	{		
		var aObject = [aDictionary objectForKey:aKey];
		if(aObject != nil)
		{			
			if([self isPropertyOfTypeAttribute:aKey])
			{
				var aClass = [self attributeClassValue:aKey];	
				
				if(aClass.name == "CPDate")
				{								
					[result setObject:[CPDate dateWithTimeIntervalSince1970:aObject] forKey:aKey];
				}
				else
				{
					[result setObject:aObject forKey:aKey];	
				}
			}
			else
			{
				if([self isPropertyOfTypeToManyRelationship:aKey])
				{
					var toManySet = [[CPMutableSet alloc] init];
					var aObjectEnum = [aObject objectEnumerator];
					var aObjectIDDictionary;
					
					while((aObjectIDDictionary = [aObjectEnum nextObject]))
					{						
						var aObjectID = [CPManagedObjectID deserializeFromDictionary:aObjectIDDictionary withContext:[self context]];	
						[toManySet addObject:aObjectID];
					}
					
					[result setObject:toManySet forKey:aKey];
				}
				else if([self isPropertyOfTypeToOneRelationship:aKey])
				{
					var aObjectID = [CPManagedObjectID deserializeFromDictionary:aObject withContext:[self context]];											
					[result setObject:aObjectID forKey:aKey];
				}
			}
		}
	}
	
	return result;
}

- (CPDictionary) serializeProperties:(CPDictionary) aDictionary
{
	var result = [[CPMutableDictionary alloc] init];
	
	var keyEnum = [aDictionary keyEnumerator];
	var aKey;
	
	while(aKey = [keyEnum nextObject])
	{
		var aObject = [aDictionary objectForKey:aKey];
		if(aObject != null && aObject != nil && aObject != CPNull)
		{
			if([aObject isKindOfClass:[CPSet class]])
			{
				aObject = [aObject allObjects];
			}
			
			if([aObject isKindOfClass:[CPArray class]])
			{
				var toManyArray = [[CPMutableArray alloc] init];
				
				var objArrayEnum = [aObject objectEnumerator];
				var aObj;
				
				while(aObj = [objArrayEnum nextObject])
				{
					if([aObj isKindOfClass:[CPManagedObjectID class]])
					{
						var aDict = [[CPMutableDictionary alloc] init];

						if([aObj globalID] != nil)
							[aDict setObject:[aObj globalID] forKey:CPDglobalID];

						[aDict setObject:[aObj localID] forKey:CPDlocalID];	
						[aDict setObject:[aObj isTemporary] forKey:CPDisTemporaryID];		

						[aDict setObject:[[aObj entity] name] forKey:CPEntityDescriptionName];

						[toManyArray addObject:aDict];
					}					
				}
				
				[result setObject:toManyArray forKey:aKey];
			}
			else if([aObject isKindOfClass:[CPManagedObjectID class]])
			{
				var aObjID = [[CPMutableDictionary alloc] init];
				
				if([aObject globalID] != nil)
					[aObjID setObject:[aObject globalID] forKey:CPDglobalID];
				 
				[aObjID setObject:[aObject localID] forKey:CPDlocalID];	
				[aObjID setObject:[aObject isTemporary] forKey:CPDisTemporaryID];		
				
				[aObjID setObject:[[aObject entity] name] forKey:CPEntityDescriptionName];
				 
				[result setObject:aObjID forKey:aKey];
				
			}
			else
			{
				if([aObject isKindOfClass:[CPDate class]])
				{
					[result setObject:(aObject.getTime() / 1000.0) forKey:aKey];
				}
				else if([aObject isKindOfClass:[CPNumber class]])
				{
					if(!isNaN(aObject))
					{
						[result setObject:aObject forKey:aKey];
					}
				}
				else
				{
					[result setObject:aObject forKey:aKey];
				}
			}
		}
	}
	
	return result;
}

@end