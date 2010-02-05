//
//  CPManagedObject.j
//
//  Created by Raphael Bartolome on 07.10.09.
//

@import <Foundation/Foundation.j>
@import "CPEntityDescription.j"
@import "CPManagedObjectContext.j"
@import "CPManagedObjectID.j"

/*
**** HEADER ****
@private
- (void)willChangeValueForKey:(CPString)aKey;
- (void)didChangeValueForKey:(CPString)aKey;

- (BOOL)_solveRelationshipsWithDeleteRules;
- (void)_updateWithObject:(CPManagedObject) aObject;
- (void)_resetChangedDataForProperties;
- (void)_applyToContext:(CPManagedObjectContext) context;

- (CPArray)_properties;

- (BOOL)_containsKey:(CPString) aKey;
- (void)_resetObjectDataForProperties;

*/
CPManagedObjectUnexpectedValueTypeForProperty = "CPManagedObjectUnexpectedValueTypeForProperty";

@implementation CPManagedObject : CPObject
{
	CPEntityDescription _entity @accessors(property=entity);
	CPManagedObjectContext _context @accessors(property=context);
	CPPersistantStore _store @accessors(property=store);
	
	CPManagedObjectID _objectID @accessors(property=objectID);
	BOOL _isUpdated @accessors(getter=isUpdated, setter=setUpdated:);
	BOOL _isDeleted @accessors(getter=isDeleted, setter=setDeleted:);
	BOOL _isFault @accessors(getter=isFault, setter=setFault:);
	
	CPMutableDictionary _data @accessors(getter=data);
	CPMutableDictionary _changedData @accessors(getter=changedData);
}


- (void)dealloc
{
	[super dealloc];
}


- (id)initWithEntity:(CPEntityDescription)entity
{
	if(self = [super init])
	{
		_propertiesData = [[CPMutableDictionary alloc] init];
		_changedData = [[CPMutableDictionary alloc] init];
		_entity = entity;
		_objectID = [[CPManagedObjectID alloc] initWithEntity:_entity globalID:nil isTemporary:YES];
		_context = nil;
		_isFault = NO;
		_isDeleted = NO;
		_isUpdated = NO;
		[self _resetObjectDataForProperties];
	}
	
	return self;
}

- (id)initWithEntity:(CPEntityDescription)entity inManagedObjectContext:(CPManagedObjectContext)aContext
{
	if(self = [super init])
	{
		_propertiesData = [[CPMutableDictionary alloc] init];
		_changedData = [[CPMutableDictionary alloc] init];
		_entity = entity;
		_objectID = [[CPManagedObjectID alloc] initWithEntity:_entity globalID:nil isTemporary:YES];
		_context = aContext;
		_isFault = NO;
		_isDeleted = NO;
		_isUpdated = NO;
		[self _resetObjectDataForProperties];
		[_context insertObject:self];
	}
	
	return self;
}
			

/*
 *	KVC/KVO methods
 */
- (id)valueForKey:(CPString)aKey
{
	var result;

	if([self _containsKey:aKey])
	{
		result = [self storedValueForKey:aKey];
	}
	else
	{
		result = [super valueForKey:aKey];
	}
	

	return result;
}

- (id)storedValueForKey:(CPString)aKey
{
	[self willAccessValueForKey:aKey];
	if([self isPropertyOfTypeAttribute:aKey])
	{
		[self didAccessValueForKey:aKey];
		return [_data objectForKey:aKey];
	}
	else if([self isPropertyOfTypeRelationship:aKey])
	{
		var value = [_data objectForKey:aKey];
		var values = nil;
		
		if(value != nil)
		{
			if([value isKindOfClass:[CPSet class]])
			{
				values = value;
			}
			else if([value isKindOfClass:[CPArray class]])
			{
				//WATCH only for savety remove later
				CPLog.fatal("isKindOfClass Array **fail**");
				values = [CPMutableSet setWithArray: value];
			}
		}
		
		if(values != nil)
		{
			//return a qualified object set instead of a objectid array
			var resultSet  = [[CPSet alloc] init];
			var valuesEnumerator = [values objectEnumerator];
			var aValue;
			var i = 0;
			while((aValue = [valuesEnumerator nextObject]))
			{
				if(aValue != nil)
				{					
					var regObject = [_context objectRegisteredForID: aValue];
					if(regObject == nil)
					{
						//if the regObject is nil we remove it
						regObject = [_context updateObjectWithID:aValue mergeChanges:YES];
//						CPLog.trace("_ID: " + [[regObject objectID] localID]);
						if(regObject != nil)
						{
							[values removeObject:aValue];
							[values addObject:[regObject objectID]];
//							[_data setObject:values forKey:aKey];
//							[_changedData setObject:value forKey:aKey];
							[self _setChangedObject:values forKey:aKey];
						}
						else
						{
							[values removeObject:aValue];
//							[_data setObject:values forKey:aKey];
//							[_changedData setObject:value forKey:aKey];
							[self _setChangedObject:values forKey:aKey];
						}
					}
					
					if(regObject != nil)
						[resultSet addObject: regObject];
				}
			}
			[self didAccessValueForKey:aKey];
			return resultSet;
		}
		else if([_data objectForKey:aKey] != nil)
		{
			var regObject = [_context objectRegisteredForID: [_data objectForKey:aKey]];
			
			if(regObject == nil && [_data objectForKey:aKey] != nil)
			{
				regObject = [_context updateObjectWithID:[_data objectForKey:aKey] mergeChanges:YES];
				
//				CPLog.trace("ID: " + [[regObject objectID] localID]);
				//if the regObject is nil we remove it
				if(regObject != nil)
				{
//					[_data setObject:[regObject objectID] forKey:aKey];
//					[_changedData setObject:[regObject objectID] forKey:aKey];
					[self _setChangedObject:[regObject objectID] forKey:aKey];
				}
				else
				{
//					[_data setObject:nil forKey:aKey];
//					[_changedData setObject:nil forKey:aKey];
					[self _setChangedObject:nil forKey:aKey];
				}
			}
			[self didAccessValueForKey:aKey];
			return regObject;
		}
	}
	[self didAccessValueForKey:aKey];
	return nil;
}




- (id)valueForKeyPath:(CPString)aKeyPath
{
	return [super valueForKeyPath:aKeyPath];
}

- (id)storedValueForKeyPath:(CPString)aKeyPath
{
	return [super valueForKeyPath:aKeyPath];
}




- (void)setValue:(id)aValue forKey:(CPString)aKey
{
	if([self _containsKey:aKey])
	{
		[self takeStoredValue:aValue forKey:aKey];
	}
	else
	{
		[super setValue:aValue forKey:aKey];
	}
}

- (void)takeStoredValue:(id)value forKey:(CPString)aKey
{
	if([self isPropertyOfTypeRelationship: aKey])
	{		
		var values;
		if([value isKindOfClass:[CPSet class]])
		{
			values = [value allObjects];
		}
		else if([value isKindOfClass:[CPArray class]])
		{
			values = value;
		}
		
		if(values != nil && [values count] > 0)
		{
			[self addObjects:values toBothSideOfRelationship:aKey];
		}	
		else
		{
			[self addObject:value toBothSideOfRelationship:aKey];
		}	
	}
	else if([self isPropertyOfTypeAttribute: aKey])
	{
		[self willChangeValueForKey:aKey];
		
		if(value == nil || [[self entity] acceptValue:value forProperty:aKey])
		{
			[self _setChangedObject:value forKey:aKey];
			[self didChangeValueForKey:aKey];
		}
		else
		{
			[self _unexpectedValueTypeError:aKey expectedType:[[self attributeClassValue:aKey] className] receivedType:[value className]];
		}
	}
}


- (void)setValue:(id)aValue forKeyPath:(CPString)aKeyPath
{
	[self takeStoredValue:aValue forKeyPath:aKeyPath];
}

- (void)takeStoredValue:(id)aValue forKeyPath:(CPString)aKeyPath
{
	[super setValue:aValue forKeyPath:aKeyPath];
}


- (void)addObjects:(CPArray)objectArray toBothSideOfRelationship:(CPString)propertyName
{
	if(objectArray != nil && [objectArray count] > 0)
	{
		var i = 0;
		
		for(i=0;i<[objectArray count];i++)
		{
			var object = [objectArray objectAtIndex:i];
			
			[self addObject:object toBothSideOfRelationship:propertyName];
		}		
	}
}

- (void)addObject:(id)object toBothSideOfRelationship:(CPString)propertyName
{	
	var tmpObjectID;
	
	if([object isKindOfClass: [CPManagedObject class]])
	{
		tmpObjectID = [object objectID];
	}
	else if([object isKindOfClass: [CPManagedObjectID class]])
	{
		tmpObjectID = object;
	}
	
	if(tmpObjectID != nil && [self isPropertyOfTypeRelationship: propertyName])
	{		

		[self willChangeValueForKey:propertyName];
		
		//Add local
		var localRelationship = [[_entity relationshipsByName] objectForKey: propertyName];
		var propertyObject = [_data objectForKey:propertyName];

		if([localRelationship isToMany])
		{
			if(propertyObject == nil)
			{
				propertyObject = [[CPMutableSet alloc] init];
			}
			else
			{
				[propertyObject addObject: tmpObjectID];	
			}
			
			// if([propertyObject containsObject:tmpObjectID])
			// 	return;
			// 	
			// [propertyObject addObject: tmpObjectID];
			// 
			// var changedPropertySet = nil;
			// if(![_changedData objectForKey:propertyName])
			// 	changedPropertySet = [_changedData objectForKey:propertyName];
			// else
			// 	changedPropertySet = [[CPMutableSet alloc] init];
			// 
			// [changedPropertySet addObject:tmpObjectID];
			// [_changedData setObject:changedPropertySet forKey:propertyName];			
			
			[self _setChangedObject:propertyObject forKey:propertyName];
			
		}
		else
		{
			if(propertyObject == tmpObjectID)
				return;
			
			propertyObject = tmpObjectID;
			
//			[_changedData setObject:propertyObject forKey:propertyName];
			[self _setChangedObject:propertyObject forKey:propertyName];
		}

		CPLog.debug(@"addObject:toBothSideOfRelationship: " + [localRelationship name]);

//		[_data setObject:propertyObject forKey:propertyName];
//		[_changedData setObject:propertyObject forKey:propertyName];
		
		//Add otherside
		var localRelationshipDestinationName  = [localRelationship destinationEntityName];
		var foreignRelationship = [self realtionshipWithDestination:[localRelationship destination]];
		
//		CPLog.info([[self objectID] stringRepresentation]);
		var myObjectID = [[_context objectRegisteredForID:[self objectID]] objectID];

		
		if(myObjectID != nil)
		{
			if(![foreignRelationship isToMany])
			{
				[[_context objectRegisteredForID:tmpObjectID] addObject:myObjectID toBothSideOfRelationship:[foreignRelationship name]];
			}
			else
			{
				[[_context objectRegisteredForID:tmpObjectID] addObject:myObjectID toBothSideOfRelationship:[foreignRelationship name]];
			}
		}
	
		//Take care that the new object is under control
		if([_context objectRegisteredForID:tmpObjectID] == nil)
		{
			[_context insertObject:tmpObjectID];
		}			
		
		[self didChangeValueForKey:propertyName];
	}
}


- (void)removeObjects:(CPArray)objectArray fromBothSideOfRelationship:(CPString)propertyName
{
	//TODO implement
}

- (void)removeObject:(id)object fromBothSideOfRelationship:(CPString)propertyName
{
	//TODO implement
}

- (CPArray)toManyRelationshipsKey
{
	var result = [[CPMutableArray alloc] init];
	var relationshipDict = [entity relationshipsByName];
	var allKeys = [relationshipDict allKeys];
	var i = 0;
	
	for(i=0;i<[allKeys count]; i++)
	{
		var key = [allKeys objectAtIndex:i];
		var tmpRel = [relationshipDict objectForKey: key];
		
		if([[tmpRel destination] isToMany] == YES)
		{
			[result addObject:tmpRel];
		}
	}
}

- (CPArray)toOneRelationshipsKey
{
	var result = [[CPMutableArray alloc] init];
	var relationshipDict = [entity relationshipsByName];
	var allKeys = [relationshipDict allKeys];
	var i = 0;
	
	for(i=0;i<[allKeys count]; i++)
	{
		var key = [allKeys objectAtIndex:i];
		var tmpRel = [relationshipDict objectForKey: key];
		
		if([[tmpRel destination] isToMany] == NO)
		{
			[result addObject:tmpRel];
		}
	}
}


/*
 *	Detect changes and notify the context
 */
- (void)willChangeValueForKey:(CPString)aKey
{
	[super willChangeValueForKey:aKey];
}

- (void)didChangeValueForKey:(CPString)aKey
{
	[super didChangeValueForKey:aKey];
	[_context _objectDidChange:self];

	if([_context autoSaveChanges])
	{
		[_context saveChanges];
	}
}


/*
 *	Detect changes and notify the context
 */
- (void)willAccessValueForKey:(CPString)aKey
{
}

- (void)didAccessValueForKey:(CPString)aKey
{
}

- (void)_unexpectedValueTypeError:(CPString) aKey expectedType:(CPString) expectedType receivedType:(CPString) receivedType
{	
	CPLog.error("*** CPManagedObject Exception: expect value of type '" + expectedType + "', but received '" + receivedType + "' for property '" + aKey + "' ***");
}


/*
 * If the relationship is not empty or nil and the delete rule is CPRelationshipDescriptionDeleteRuleDeny
 * this method returns false otherwise it can be solve the relationship
 */
- (BOOL)_solveRelationshipsWithDeleteRules
{	
	var result = YES;
	var e = [[_entity relationshipsByName] keyEnumerator];
	var property;

	while ((property = [e nextObject]) != nil)
	{
		var valueForProperty = [self valueForKey:property];
		var relationshipObject = [[_entity relationshipsByName] objectForKey:property];
		if([relationshipObject deleteRule] == CPRelationshipDescriptionDeleteRuleNullify)
		{
			CPLog.debug(@"The deletion rule for relationship '" + property + "' is CPRelationshipDescriptionDeleteRuleNullify.");
			if([self isPropertyOfTypeToManyRelationship:property])
			{
				if(valueForProperty != nil && [valueForProperty count] > 0)
				{
					var valueForPropertyEnum = [valueForProperty objectEnumerator];
					var objectFromValueForProperty;
					while((objectFromValueForProperty = [valueForPropertyEnum nextObject]) != nil)
					{
						[objectFromValueForProperty _deleteReferencesForObject:self];
					}
				}
			}
			else
			{
				if(valueForProperty != nil)
				{
					[valueForProperty _deleteReferencesForObject:self];
				}
			}
		}
		else if([relationshipObject deleteRule] == CPRelationshipDescriptionDeleteRuleCascade)
		{
			CPLog.debug(@"The deletion rule for relationship '" + property + "' is CPRelationshipDescriptionDeleteRuleCascade.");
			if([self isPropertyOfTypeToManyRelationship:property])
			{
				if(valueForProperty != nil && [valueForProperty count] > 0)
				{
					var valueForPropertyEnum = [valueForProperty objectEnumerator];
					var objectFromValueForProperty;
					while((objectFromValueForProperty = [valueForPropertyEnum nextObject]) != nil)
					{
						[objectFromValueForProperty _deleteReferencesForObject:self];
						[_context _deleteObject:objectFromValueForProperty saveAfterDeletion:NO];
					}
				}
			}
			else
			{
				if(valueForProperty != nil)
				{
					[valueForProperty _deleteReferencesForObject:self];
					[_context _deleteObject:valueForProperty saveAfterDeletion:NO];
				}
			}
		}
		else if([relationshipObject deleteRule] == CPRelationshipDescriptionDeleteRuleDeny)
		{
			CPLog.debug(@"The deletion rule for relationship '" + property + "' is CPRelationshipDescriptionDeleteRuleDeny.");
			if([self isPropertyOfTypeToManyRelationship:property])
			{
				if(valueForProperty != nil && [valueForProperty count] > 0)
				{
					var valueForPropertyEnum = [valueForProperty objectEnumerator];
					var objectFromValueForProperty;
					while((objectFromValueForProperty = [valueForPropertyEnum nextObject]) != nil)
					{
						[objectFromValueForProperty _deleteReferencesForObject:self];
					}

					result = NO;
					break;
				}
			}
			else
			{
				if(valueForProperty != nil)
				{
					[valueForProperty _deleteReferencesForObject:self];
					result = NO;
					break;
				}
			}
		}
		else if([relationshipObject deleteRule] == CPRelationshipDescriptionDeleteRuleNoAction)
		{
			//don´t care about the deletion
			CPLog.debug(@"The deletion rule for relationship '" + property + "' is CPRelationshipDescriptionDeleteRuleNoAction.");	
			[valueForProperty _deleteReferencesForObject:self];
		}
	}
	
//	CPLog.trace("_solveRelationshipsWithDeleteRules");
	
	return result;
}

- (void)_deleteReferencesForObject:(CPManagedObject) aObject
{
	var e = [[_entity relationshipsByName] keyEnumerator];
	var property;
	
	while ((property = [e nextObject]) != nil)
	{
		var valueForProperty = [self valueForKey:property];
		if(valueForProperty != nil)
		{
			if([self isPropertyOfTypeToManyRelationship:property])
			{
				var valueForPropertyEnum = [valueForProperty objectEnumerator];
				var objectFromValueForProperty;
				while((objectFromValueForProperty = [valueForPropertyEnum nextObject]) != nil)
				{
					if ([[objectFromValueForProperty objectID] isEqualToLocalID: [aObject objectID]] == YES)
					{
						[valueForProperty removeObject:[objectFromValueForProperty objectID]];
						
						var changedPropertySet = nil;
						if(![_data objectForKey:property])
							changedPropertySet = [_data objectForKey:property];
	
						if(changedPropertySet != nil || [changedPropertySet count] > 0)
						{
							[changedPropertySet removeObject:[objectFromValueForProperty objectID]];
//							[_changedData setObject:changedPropertySet forKey:property];
							[self _setChangedObject:changedPropertySet forKey:property];
						}						
					}
				}
			}
			else
			{
				if ([[valueForProperty objectID] isEqualToLocalID: [aObject objectID]] == YES)
				{
					[self _setChangedObject:nil forKey:property];
					// [_data setObject:nil forKey:property];
					// [_changedData setObject:nil forKey:property];
				}	
			}
		}
	}
}

- (void)_updateWithObject:(CPManagedObject) aObject
{
	[_objectID updateWithObjectID: [aObject objectID]];
	
	var data = [[aObject data] allKeys];	
	var i = 0;
	for(i = 0;i<[data count];i++)
	{
		var aKey = [data objectAtIndex:i];
		var aValue = [[aObject data] objectForKey:aKey];
		[_data setObject:aValue forKey:aKey];
	}
}

- (BOOL)validateForDelete
{
	return [self _validateForChanges];
}

- (BOOL)validateForInsert
{
	return [self _validateForChanges];
}

- (BOOL)validateForUpdate
{
	return [self _validateForChanges];
}

- (BOOL)_validateForChanges
{
	var result = YES;
	
	var mandatoryAttributes = [_entity mandatoryAttributes];
	var mandatoryRelationships = [_entity mandatoryRelationships];
	var relationships = [_entity relationshipsByName];
	
	var i = 0;
	for(i=0;i<[[_data allKeys] count];i++)
	{
		var property = [[_data allKeys] objectAtIndex:i];
		
//		CPLog.debug("Validate property: " + property);
		if([mandatoryAttributes containsObject:property])
		{
			if([_data objectForKey:property] == nil && ![_changedData objectForKey:property])
			{
//				CPLog.debug(@"Object is not complete because property '" + property + "' is missing");
				return NO;
			}
		}
		else
		{
//			CPLog.trace("property: " + property + " is not a not null property");
		}
		
		if([relationships objectForKey:property])
		{
//			CPLog.trace("relation: " + property + " is a relation");
			if([mandatoryRelationships containsObject:property])
			{
				if([_data objectForKey:property] == nil && ![_changedData objectForKey:property])
				{
//					CPLog.debug(@"Object is not complete because property '" + property + "' is missing");
					return NO;
				}
			}
			
			var aRelationship = [relationships objectForKey:property];
			if([aRelationship isToMany])
			{
				var valueE = [[self valueForKey:property] objectEnumerator];
				var aObj;
				
				while((aObj = [valueE nextObject]))
				{
					if(![aObj _validateForChanges])
					{
//						CPLog.debug(@"Object is not complete because object with " + [[aObj objectID] localID] + " in toMany Relation '" + property + "' is not valid");
						return NO;
					}
				}
			}
		}	
		else
		{
//			CPLog.debug("relation: " + property + " is not a relation");
		}
	}
	
	return result;
}

- (BOOL)_containsObject:(CPManagedObjectID) aObjectID
{
	var result = NO;
	var i = 0;
	for(i=0;i<[[_data allKeys] count];i++)
	{
		var property = [[_data allKeys] objectAtIndex:i];
		var valueForProperty = [_data objectForKey:property];
		if([self isPropertyOfTypeToOneRelationship:property])
		{
			if(valueForProperty != nil && [valueForProperty isEqualToLocalID:aObjectID])
				return YES;
		}
		else if([self isPropertyOfTypeToManyRelationship:property])
		{
			if(valueForProperty != nil && [valueForProperty containsObject:aObjectID])
				return YES;
		}
	}
	return result;
}

/*
@deprecated
- (void) _mergeChangedDataWithAllData
{
	var aEnum = [_data keyEnumerator];
	var aKey;
	while((aKey = [aEnum nextObject]))
	{
		var aObject = [_data objectForKey:aKey];
		if([_changedData objectForKey:aKey] == CPNull || [_changedData objectForKey:aKey] == nil)
		{
			[_changedData setObject:aObject forKey:aKey];
		}
	}
}
*/
- (void)_setChangedObject:(id) aObject forKey:(CPString) aKey
{	
	[_changedData setObject:aObject forKey:aKey];
	[_data setObject:aObject forKey:aKey];
}

- (void)_resetChangedDataForProperties
{
	_changedData = [[CPMutableDictionary alloc] init];
}


- (void)_applyToContext:(CPManagedObjectContext) context
{
	_context = context;
	
	if(_objectID == nil)
	{
		_objectID = [[CPManagedObjectID alloc] initWithEntity:_entity globalID:nil isTemporary:YES];
		[_objectID setContext:context];
		[_objectID setStore:[context store]];
	}
}


- (CPArray)_properties
{
	return [_entity propertyNames];
}



- (BOOL)_containsKey:(CPString) aKey
{
	return [[_data allKeys] containsObject: aKey];
}


- (void)_setData:(CPDictionary) aDictionary
{
	_data = aDictionary;
	var e = [[_entity properties] objectEnumerator];
	var property;
	
	while ((property = [e nextObject]) != nil)
    {
		var propName = [property name];
		if([_data objectForKey:propName] == nil)
			[_data setObject:nil forKey:propName];
	}
}

- (void)_setChangedData:(CPDictionary) aDictionary
{
	_changedData = aDictionary;
}

- (void)_resetObjectDataForProperties
{
	_data = [[CPMutableDictionary alloc] init];
	var e = [[_entity properties] objectEnumerator];
	var property;
	
	while ((property = [e nextObject]) != nil)
    {
		var propName = [property name];
		[_data setObject:nil forKey:propName];
	}
}

- (BOOL)isPropertyOfTypeAttribute:(CPString)aKey
{
	if([[_entity attributesByName] objectForKey:aKey] != nil)
		return YES;
	
	return NO;
}

- (BOOL)isPropertyOfTypeRelationship:(CPString)aKey
{
	if([[_entity relationshipsByName] objectForKey:aKey] != nil)
		return YES;
	
	return NO;
}

- (BOOL)isPropertyOfTypeToManyRelationship:(CPString)aKey
{
	if([[_entity relationshipsByName] objectForKey:aKey] != nil)
	{
		if([[[_entity relationshipsByName] objectForKey:aKey] isToMany])
		{
			return YES;
		}
	}
	
	return NO;
}

- (BOOL)isPropertyOfTypeToOneRelationship:(CPString)aKey
{
	if([[_entity relationshipsByName] objectForKey:aKey] != nil)
	{
		if(![[[_entity relationshipsByName] objectForKey:aKey] isToMany])
		{
			return YES;
		}
	}
	
	return NO;
}


- (Class)attributeClassValue:(CPString) aKey
{
	var result = nil;
	var att = [[_entity attributesByName] objectForKey:aKey];
	
	if(att != nil)
	{
		result = [att classValue];
	}
	
	return result;
}

- (Class)relationshipDestinationClassType:(CPString) key
{
	var result = nil;
	var att = [[_entity relationshipsByName] objectForKey:aKey];
	
	if(att != nil)
	{
		result = [att destinationClassType];
	}
	
	return result;
}


- (CPRelationshipDescription)realtionshipWithDestination:(CPEntityDescription)aEntity
{
	var relationshipDict = [aEntity relationshipsByName];
	var allKeys = [relationshipDict allKeys];
	var i = 0;
	
	for(i=0;i<[allKeys count]; i++)
	{
		var key = [allKeys objectAtIndex:i];
		var tmpRel = [relationshipDict objectForKey: key];
		
		if([[tmpRel destination] isEqual: _entity])
		{
			return tmpRel;
		}
	}
	
	return nil;
}


- (CPString)stringRepresentation
{
	var result = "CPObject";
	
	result = result + [_objectID stringRepresentation];
	result = result + [_entity stringRepresentation];
	

	return result;
}


@end