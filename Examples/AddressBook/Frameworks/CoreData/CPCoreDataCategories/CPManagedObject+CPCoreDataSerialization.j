//
//  CPManagedObject+CPCoreDataSerialization.j
//
//  Created by Raphael Bartolome on 14.01.10.
//

@import <Foundation/Foundation.j>

//global keys for serialization formats
CPCoreDataSerializationXMLFormat = "CPCoreDataSerializationXMLFormat";
CPCoreDataSerializationJSONFormat = "CPCoreDataSerializationJSONFormat";
CPCoreDataSerialization280NPLISTFormat = "CPCoreDataSerialization280NPLISTFormat";
CPCoreDataSerializationDictionaryFormat = "CPCoreDataSerializationDictionaryFormat";


//private keys for serialization
CPManagedObjectIDKey = "CPManagedObjectID";
CPglobalID = "CPglobalID";
CPlocalID = "CPlocalID";
CPisTemporaryID = "CPisTemporaryID";
CPEntityDescriptionName = "CPEntityDescriptionName";
CPmodelName = "CPmodelName";
CPisUpdated = "CPisUpdated";
CPisDeleted = "CPisDeleted";
CPisFault = "CPisFault";
CPallProperties = "CPallProperties";
CPchangedProperties = "CPchangedProperties";


@implementation CPManagedObject (CPCoreDataSerialization)


/*
 * ************
 *	XML format
 * ************
 */
+ (id)deserializeFromXML:(CPData) data withContext:(CPManagedObjectContext) aContext
{
	var propertyListFromData = [CPPropertyListSerialization propertyListFromData:data
															format:CPPropertyListXMLFormat_v1_0];
	
	return [CPManagedObject deserializeFromDictionary:propertyListFromData withContext:aContext];
}


- (CPData)serializeToXML:(BOOL) containsAllProperties containsChangedProperties:(BOOL)containsChangedProperties
{
	var result = [CPPropertyListSerialization dataFromPropertyList:
				[self serializeToDictionary:containsAllProperties containsChangedProperties:containsChangedProperties] 
															format:CPPropertyListXMLFormat_v1_0];
									
	return result;
}


/*
 * *****************
 *	280NPLIST format
 * *****************
 */
+ (id)deserializeFrom280NPLIST:(CPData) data withContext:(CPManagedObjectContext) aContext
{
	var propertyListFromData = [CPPropertyListSerialization propertyListFromData:data
															format:CPPropertyList280NorthFormat_v1_0];
	
	return [CPManagedObject deserializeFromDictionary:propertyListFromData withContext:aContext];
}


- (CPData)serializeTo280NPLIST:(BOOL) containsAllProperties containsChangedProperties:(BOOL)containsChangedProperties
{
	var result = [CPPropertyListSerialization dataFromPropertyList:
					[self serializeToDictionary:containsAllProperties containsChangedProperties:containsChangedProperties] 
															format:CPPropertyList280NorthFormat_v1_0];
									
	return result;
}


/*
 * ************
 *	JSON format
 * ************
 */
+ (id)deserializeFromJSON:(id) jsonObject withContext:(CPManagedObjectContext) aContext
{
	var aDictionary = [CPDictionary dictionaryWithJSObject:jsonObject recursively:YES];
	var aObject = [CPManagedObject deserializeFromDictionary:aDictionary withContext:aContext];
	
	return aObject;
}


- (id)serializeToJSON:(BOOL) containsAllProperties containsChangedProperties:(BOOL)containsChangedProperties
{
	var result =  [CPString JSONFromObject:[self serializeToDictionary:containsAllProperties containsChangedProperties:containsChangedProperties]];
	return result;
}


/*
 * ******************
 *	Dictionary format
 * ******************
 */
+ (id)deserializeFromDictionary:(CPDictionary) aDictionary withContext:(CPManagedObjectContext) aContext
{
	var aCPManagedObject = nil;
	
	if(aDictionary != nil)
	{
		var aModelName = [aDictionary objectForKey:CPmodelName];
		var aModel = nil;
		if([[aContext model] isModelAllowedForMergeByName: aModelName])
		{		
			var aEntityName = [aDictionary objectForKey:CPEntityDescriptionName];
			var aEntity = [[aContext model] entityWithName:aEntityName];

			var allProperties = [aDictionary objectForKey:CPallProperties];
			var changedProperties = [aDictionary objectForKey:CPchangedProperties];

			var objIsDeleted = [aDictionary objectForKey:CPisDeleted];
			var objIsUpdated = [aDictionary objectForKey:CPisUpdated];
			var objIsFault = [aDictionary objectForKey:CPisFault];

			//deserialize the ObjectID
			var aObjectID = [CPManagedObjectID deserializeFromDictionary: [aDictionary objectForKey:CPManagedObjectIDKey] withContext:aContext];
		
			//deserialize the CPManagedObject representation
			aCPManagedObject = [aEntity createObject];
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


- (CPDictionary)serializeToDictionary:(BOOL) containsAllProperties containsChangedProperties:(BOOL)containsChangedProperties
{
	var result = [[CPMutableDictionary alloc] init];
		
	[result setObject:[[self objectID] serializeToDictionary] forKey:CPManagedObjectIDKey];
	[result setObject:[[self entity] name] forKey:CPEntityDescriptionName];
	[result setObject:[self isFault] forKey:CPisFault];
	[result setObject:[self isUpdated] forKey:CPisUpdated];
	[result setObject:[self isDeleted] forKey:CPisDeleted];
	
	[result setObject:[[[self entity] model] name] forKey:CPmodelName];
	
	if(containsAllProperties)
		[result setObject:[self serializeProperties:[self data]] forKey:CPallProperties];
	
	if(containsChangedProperties)
		[result setObject:[self serializeProperties:[self changedData]] forKey:CPchangedProperties];
	 	
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
					var aObjectIDDictionary;
					
					for(var j = 0; j < [aObject count]; j++)
					//@TODO_ENUM while((aObjectIDDictionary = [aObjectEnum nextObject]))
					{				
						aObjectIDDictionary = [aObject objectAtIndex:j];
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
							[aDict setObject:[aObj globalID] forKey:CPglobalID];

						[aDict setObject:[aObj localID] forKey:CPlocalID];	
						[aDict setObject:[aObj isTemporary] forKey:CPisTemporaryID];		

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
					[aObjID setObject:[aObject globalID] forKey:CPglobalID];
				 
				[aObjID setObject:[aObject localID] forKey:CPlocalID];	
				[aObjID setObject:[aObject isTemporary] forKey:CPisTemporaryID];		
				
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