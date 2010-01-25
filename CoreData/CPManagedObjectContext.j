//
//  CPManagedObjectContext.j
//
//  Created by Raphael Bartolome on 07.10.09.
//

@import <Foundation/Foundation.j>
@import "CPManagedObject.j"
@import "CPManagedObjectID.j"
@import "CPManagedObjectModel.j"
@import "CPPersistantStore.j"

/* 

***** HEADER *****
@private
- (CPManagedObject) _fetchObjectWithID:(CPManagedObjectID) aObjectID
- (CPSet)_fetchObjectsWithEntityNamed:(CPString)aEntityName;
- (CPSet)_fetchObjectsWithEntityNamed:(CPString)aEntityName qualifier:(CPString)aQualifier fetchLimit:(int)aFetchLimit:
- (CPManagedObject) _insertedObjectWithID:(CPManagedObjectID) aObjectID;
- (CPManagedObject) _updatedObjectWithID:(CPManagedObjectID) aObjectID;
- (CPManagedObject) _deletedObjectWithID:(CPManagedObjectID) aObjectID;
- (BOOL) reset;
- (void) _objectDidChange:(CPManagedObject) aObject;
- (CPManagedObject) _registerObject:(CPManagedObject) object;
- (void) _unregisterObject:(CPManagedObject) object;
- (void) _deleteObject: ({CPManagedObject}) aObject saveAfterDeletion:(BOOL) saveAfterDeletion;

*/

// Notifications.
CPManagedObjectContextObjectsDidChangeNotification = "CPManagedObjectContextObjectsDidChangeNotification";
CPManagedObjectContextDidSaveNotification = "CPManagedObjectContextDidSaveNotification";
CPManagedObjectContextDidLoadObjectsNotification = "CPManagedObjectContextDidLoadObjectsNotification";
CPManagedObjectContextDidSaveChangedObjectsNotification = "CPManagedObjectContextDidSaveChangedObjectsNotification";
CPManagedObjectContextDidSaveAllObjectsNotification = "CPManagedObjectContextDidSaveAllObjectsNotification";

CPDInsertedObjectsKey = "CPDInsertedObjectsKey";
CPDUpdatedObjectsKey = "CPDUpdatedObjectsKey";
CPDDeletedObjectsKey = "CPDDeletedObjectsKey";


@implementation CPManagedObjectContext : CPObject
{
	BOOL _autoSaveChanges;
	CPPersistentStoreCoordinator _storeCoordinator @accessors(property=storeCoordinator);
	
	CPMutableSet _registeredObjects;
	CPMutableSet _insertedObjectIDs;
	CPMutableSet _updatedObjectIDs;
	CPMutableSet _deletedObjects;
}

- (id) init
{
	if ((self = [super init]))
	{
		_autoSaveChanges = false;
		_registeredObjects = [CPMutableSet new];
		_insertedObjectIDs = [CPMutableSet new];
		_updatedObjectIDs = [CPMutableSet new];
		_deletedObjects = [CPMutableSet new];
	}
	
	return self;
}

- (id) initWithPersistantStoreCoordinator:(CPPersistentStoreCoordinator)aStoreCoordinator
{
	if ((self = [super init]))
	{
		_autoSaveChanges = false;
		_registeredObjects = [CPMutableSet new];
		_insertedObjectIDs = [CPMutableSet new];
		_updatedObjectIDs = [CPMutableSet new];
		_deletedObjects = [CPMutableSet new];
		
		_storeCoordinator = aStoreCoordinator;
		[self loadAll];
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (CPManagedObjectModel)model
{
	return [_storeCoordinator managedObjectModel];
}

- (CPPersistantStore)store
{
	return [_storeCoordinator persistantStore];
}

- (BOOL) autoSaveChanges
{
	return _autoSaveChanges;
}

- (void) setAutoSaveChanges:(BOOL)aState
{
	_autoSaveChanges = aState;
}

  
- (CPManagedObject) updateObject:(CPManagedObject) aObject mergeChanges:(BOOL) mergeChanges
{
	//TODO currently mergeChanges ignored
	var result = [self _fetchObjectWithID: [aObject objectID]];
	return result;
}


- (CPManagedObject) updateObjectWithID:(CPManagedObjectID) aObjectID mergeChanges:(BOOL) mergeChanges
{
	//TODO currently mergeChanges ignored
	var result = [self _fetchObjectWithID: aObjectID];
	return result;
}


- (CPSet) executeFetchRequest:(CPFetchRequest)aRequest
{
	//TODO use the _fetchObjectsWithEntityNamed:(CPString)aEntityName  fetchProperties:(CPDictionary)properties qualifier:(CPString)aQualifier fetchLimit:(int)aFetchLimit 
	//method
}   

- (CPSet) objectsForEntityNamed:(String) aEntityName
{	
	var e;
	var object;
	var resultSet = [[CPMutableSet alloc] init];
	
	e = [_registeredObjects objectEnumerator];
	while ((object = [e nextObject]) != nil)
	{
		if(object != nil && object != nil)
		{
			if ([[[object entity] name] isEqualToString: aEntityName] == YES)
			{
				[resultSet addObject:object];
			}
		}
	}

	if([resultSet count] == 0)
	{
		//let us try it remote
		resultSet = [self _fetchObjectsWithEntityNamed:aEntityName];
	}
	
	return resultSet;
}

- (void) reset
{
	var result = YES;

	[_registeredObjects makeObjectsPerformSelector:@selector(_resetChangedDataForProperties)];
		
	[_updatedObjectIDs removeAllObjects];
	[_insertedObjectIDs removeAllObjects];
	[_deletedObjects removeAllObjects];
	// 			
	// CPLog.debug(@"updatedObjectIDs " + [_updatedObjectIDs count] + ", insertedObjects " + [_insertedObjectIDs count]);
	// CPLog.debug(@"registeredObjects " + [_registeredObjects count] + ", deletedObjects " + [_deletedObjects count]);
	// 
	return result;
}


- (void) rollback
{ 
}


/*
 *	Store request methods
 */
- (CPSet)_fetchObjectsWithEntityNamed:(CPString)aEntityName
{	
	return [self _fetchObjectsWithEntityNamed:aEntityName fetchProperties:nil qualifier:nil fetchLimit:0];
}


- (CPSet)_fetchObjectsWithEntityNamed:(CPString)aEntityName  fetchProperties:(CPDictionary)properties qualifier:(CPString)aQualifier fetchLimit:(int)aFetchLimit
{
	var result = [[CPMutableSet alloc] init];
		
	var localQualifierModification = aQualifier;
	if(aQualifier == nil)
	{
		localQualifierModification = "*";
	}
	
	var newProperitesDict = properties;
	if(properties == nil)
	{
		var localEntity = [[self model] entityWithName:aEntityName];
		var localProperties = [CPSet setWithArray: [localEntity propertyNames]]; 
		
		newProperitesDict = [[CPMutableDictionary alloc] init];
		[newProperitesDict setObject:localProperties forKey:aEntityName];
	}
	
	var error = nil;	
	var resultSet = [[self store] fetchObjectsWithEntityNamed:aEntityName
										  fetchProperties:newProperitesDict
										   fetchQualifier:localQualifierModification
											   fetchLimit:aFetchLimit
								   inManagedObjectContext:self
														error:error];
					  
	if(resultSet != nil && [resultSet count] > 0 && error == nil)
	{
		var objectEnum = [resultSet objectEnumerator];
		var objectFromResponse;
		while((objectFromResponse = [objectEnum nextObject]))
		{
			[result addObject:[self _registerObject:objectFromResponse]];
		}
	}
	
	return result;	
}

- (BOOL)saveAll
{
	var result = YES;
	var error = nil;
	
	[[self store] saveAll:[self registeredObjects] error:error];
	
	[[CPNotificationCenter defaultCenter]
						postNotificationName: CPManagedObjectContextDidSaveAllObjectsNotification
									  object: self
									userInfo: nil];
	return result;
}


- (BOOL) loadAll
{
	var error = nil;
	var result = YES;
	var resultSet = nil;
	var propertiesDictionary = [[CPMutableDictionary alloc] init];
	
	var allEntities = [[[self model] entities] objectEnumerator];
	var aEntity;
	
	while((aEntity = [allEntities nextObject]))
	{
		var propertiesFromEntity = [CPSet setWithArray: [aEntity propertyNames]]; 
		[propertiesDictionary setObject:propertiesFromEntity forKey:[aEntity name]];
	}

	resultSet = [[self store] loadAll:propertiesDictionary inManagedObjectContext:self error:error];
	if(resultSet != nil && [resultSet count] > 0 && error == nil)
	{		
		var resultEnumerator = [[resultSet allObjects] objectEnumerator];
		var objectFromResponse;
				
		while(objectFromResponse = [resultEnumerator nextObject])
		{
			[self _registerObject:objectFromResponse];	
		}
	}
	
	[self hasChanges];
	[[CPNotificationCenter defaultCenter] postNotificationName:CPManagedObjectContextDidLoadObjectsNotification 
														object: self 
													  userInfo: nil];
	return result;
}

			   
- (BOOL)saveChanges
{
	var result = NO;
	if([self hasChanges])
	{
		var error = nil;	
		var updatedObjects = [self updatedObjects];
		var insertedObjects = [self insertedObjects];
		var deletedObjects = [self deletedObjects];
		
		[self _validateUpdatedObject:updatedObjects insertedObjects:insertedObjects];
		
		if([updatedObjects count] > 0 || [insertedObjects count] > 0 || [deletedObjects count] > 0)
		{
			var resultSet = [[self store] saveObjectsUpdated:updatedObjects
												inserted:insertedObjects
												 deleted:deletedObjects
												   error:error];
					  
			if(resultSet != nil && [resultSet count] > 0 && error == nil)
			{
				var objectsEnum = [resultSet objectEnumerator];
				var objectFromResponse;
				while((objectFromResponse = [objectsEnum nextObject]))
				{
					var registeredObject = [self objectRegisteredForID:[objectFromResponse objectID]];
				
					if(registeredObject != nil)
					{
						[[registeredObject objectID] setGlobalID: [[objectFromResponse objectID] globalID]];
						[[registeredObject objectID] setIsTemporary: [[objectFromResponse objectID] isTemporary]];
					}
				}
			
				result = [self reset];
			}

			[[CPNotificationCenter defaultCenter]
				postNotificationName: CPManagedObjectContextDidSaveNotification
							  object: self
							userInfo: nil];
							
			[[CPNotificationCenter defaultCenter]
								postNotificationName: CPManagedObjectContextDidSaveChangedObjectsNotification
											  object: self
											userInfo: nil];
											
		
		}
	}
	
	return result;
}


- (void) _validateUpdatedObject:({CPSet}) updated insertedObjects:({CPSet}) inserted
{
	var unionSet = [[CPMutableSet alloc] init];
	[unionSet unionSet:updated];
	[unionSet unionSet:inserted];
	
	var enumerator = [unionSet objectEnumerator];
	var aObject;
	
	while((aObject = [enumerator nextObject]))
	{
		if(![aObject validateForUpdate])
		{
			[updated removeObject:aObject];
			[inserted removeObject:aObject];
			
			var objectEnum = [unionSet objectEnumerator];
			var object;
			while((object = [objectEnum nextObject]))
			{
				if([object _containsObject:[aObject objectID]])
				{
					[updated removeObject:object];
					[inserted removeObject:object];
				}
			}
		}
	}
}

/*
 *	Check if the context has changes
 */
- (BOOL) hasChanges
{
	CPLog.debug(@"updatedObjectIDs " + [_updatedObjectIDs count] + ", insertedObjects " + [_insertedObjectIDs count]);
	CPLog.debug(@"registeredObjects " + [_registeredObjects count] + ", deletedObjects " + [_deletedObjects count]);

	return ([_updatedObjectIDs count] > 0) ||
			([_insertedObjectIDs count] > 0) ||
			([_deletedObjects count] > 0);
}

/*
 *	request registered,inserted, updated and deleted objects by object id
 */
- (CPManagedObject) objectRegisteredForID: (CPManagedObjectID) aObjectID
{
	var e;
	var object = nil;
	
	if(aObjectID != nil)
	{			
		if([aObjectID validatedLocalID] || [aObjectID validatedGlobalID])
		{		
			e = [_registeredObjects objectEnumerator];
			while ((object = [e nextObject]) != nil)
			{		
				if ([[object objectID] isEqualToLocalID: aObjectID] == YES)
				{
					return object;
				}
				else if ([[object objectID] isEqualToGlobalID: aObjectID] == YES)
				{
					return object;
				}
			}
		}
	}
	return object;
}


- (CPManagedObject) _fetchObjectWithID:(CPManagedObjectID) aObjectID
{	
	var objectFromResponse = nil;
	if(aObjectID != nil)
	{
		if([self _deletedObjectWithID:aObjectID] == nil && [aObjectID validatedGlobalID])
		{
			var setWithObjIDs = [[CPMutableSet alloc] init];
			[setWithObjIDs addObject:aObjectID];

			var newPropertiesDict = [[CPMutableDictionary alloc] init];
			var localEntity = [[self model] entityWithName:[[aObjectID entity] name]];
			var localProperties = [CPSet setWithArray: [localEntity propertyNames]]; 
			[newPropertiesDict setObject:localProperties forKey:[[aObjectID entity] name]];

		
			var error = nil;
			var resultSet = [[self store] fetchObjectsWithID:setWithObjIDs fetchProperties:newPropertiesDict error:error];
			if(resultSet != nil && [resultSet count] > 0 && error == nil)
			{
				var objectEnum = [resultSet objectEnumerator];
				var objectFromResponse;
			
				while((objectFromResponse = [objectEnum nextObject]))
				{
					[[objectFromResponse objectID] setLocalID: [aObjectID localID]];
					objectFromResponse = [self _registerObject:objectFromResponse];
					aObjectID = [objectFromResponse objectID];
//					CPLog.trace("_fetchObjectWithID: " + [[objectFromResponse objectID] localID]);
					return objectFromResponse;
				}
			}
		}
	}
	
	return objectFromResponse;
}


- (CPManagedObject) _insertedObjectWithID: (CPManagedObjectID) aObjectID
{
	var e;
	var object;

	e = [_insertedObjectIDs objectEnumerator];
	while ((object = [e nextObject]) != nil)
	{
		if ([object isEqualToLocalID: aObjectID] == YES)
		{
			return [self objectRegisteredForID: aObjectID];
		}
	}

	return nil;
}

- (CPManagedObject) _updatedObjectWithID: (CPManagedObjectID) aObjectID
{
	var e;
	var object;

	e = [_updatedObjectIDs objectEnumerator];
	while ((object = [e nextObject]) != nil)
	{
		if ([object isEqualToLocalID: aObjectID] == YES)
		{
			return [self objectRegisteredForID: aObjectID];
		}
	}

	return nil;
}


- (CPManagedObject) _deletedObjectWithID: (CPManagedObjectID) aObjectID
{
	var e;
	var object;

	e = [_deletedObjects objectEnumerator];
	while ((object = [e nextObject]) != nil)
	{
		if ([[object objectID] isEqualToLocalID: aObjectID] == YES)
		{
			return object;
		}
		else if ([[object objectID] isEqualToGlobalID: aObjectID] == YES)
		{
			return object;
		}
	}

	return nil;
}

/*
 *	Create new object from entity
 */
- (CPManagedObject) insertNewObjectForEntityForName:(CPString) entity
{
	var result_object;	
	var tmpentity = [[self model] entityWithName:entity];
	if(tmpentity != nil)
	{
		result_object = [tmpentity createObject];

		if(result_object != nil)
		{
			[self insertObject:result_object];
		}
	}
		
	return result_object
}

/*
 *	Insert and delete registered objects
 */
- (void) insertObject: ({CPManagedObject}) aObject
{		
	if([aObject objectID] == nil)
	{
		[aObject setObjectID:[[CPManagedObjectID alloc] initWithEntity:[aObject entity] globalID:nil isTemporary:YES]];
	}
	if ([self _deletedObjectWithID: [aObject objectID]] != nil)
    {
		[self _registerObject: aObject];
		[_deletedObjects removeObject: aObject];
		[_insertedObjectIDs addObject: [aObject objectID]];

    }
	else if ([self _deletedObjectWithID: [aObject objectID]] == nil)
    {
		[self _registerObject: aObject];
		[_insertedObjectIDs addObject: [aObject objectID]];
    }
	else
    {
      return;
	}

	[aObject _applyToContext: self];
	
	var userInfo = [CPDictionary dictionaryWithObject: [CPSet setWithObject: aObject]
											   forKey: CPDInsertedObjectsKey];
	[[CPNotificationCenter defaultCenter]
		postNotificationName: CPManagedObjectContextObjectsDidChangeNotification
					  object: self
					userInfo: userInfo];
}


- (void) deleteObject: ({CPManagedObject}) aObject
{
	[self _deleteObject:aObject saveAfterDeletion:YES];
}


- (void) _deleteObject: ({CPManagedObject}) aObject saveAfterDeletion:(BOOL) saveAfterDeletion
{
	if ([self objectRegisteredForID: [aObject objectID]] != nil)
	{		
		if([aObject _solveRelationshipsWithDeleteRules] == YES)
		{
			var needToSave = NO;
			//if delete rule is Deny the result is false
			[aObject setDeleted: YES];
			
			if([[aObject objectID] validatedGlobalID])
			{
				[_deletedObjects addObject: aObject];
				needToSave = YES;
			}
			
			[_insertedObjectIDs removeObject: [aObject objectID]];
			[self _unregisterObject: aObject];
			
			var userInfo = [CPDictionary dictionaryWithObject: [CPSet setWithObject: aObject]
													   forKey: CPDDeletedObjectsKey];
			
			[[CPNotificationCenter defaultCenter]
						postNotificationName: CPManagedObjectContextObjectsDidChangeNotification
									  object: self
									userInfo: userInfo];
									
			if(saveAfterDeletion && [self autoSaveChanges] && needToSave)
				[self saveChanges];
		}
	}
	else
	{
		[aObject setDeleted: YES];
		[_deletedObjects addObject: aObject];
	}	
}

- (void) deleteObjectWithID: (CPManagedObjectID) aObjectId
{
	var aObject = [self objectRegisteredForID: objectID];
	if (aObject != nil)
	{
		[self deleteObject:aObject];
	}
}

/*
 *	Object changes notifications
 */
- (void)_objectDidChange:(CPManagedObject)aObject
{	
	if ([self objectRegisteredForID: [aObject objectID]] != nil)
	{
		if ([self _insertedObjectWithID: [aObject objectID]] == nil)
		{
			[[self objectRegisteredForID: [aObject objectID]] setUpdated:YES];
			[_updatedObjectIDs addObject: [aObject objectID]];			
		}
		
		var userInfo = [CPDictionary dictionaryWithObject: [CPSet setWithObject: aObject]
												   forKey: CPDUpdatedObjectsKey];
		[[CPNotificationCenter defaultCenter]
			postNotificationName: CPManagedObjectContextObjectsDidChangeNotification
						  object: self
						userInfo: userInfo];
						
		CPLog.debug(@"updatedObjectIDs " + [_updatedObjectIDs count] + ", insertedObjects " + [_insertedObjectIDs count]);
		CPLog.debug(@"registeredObjects " + [_registeredObjects count] + ", deletedObjects " + [_deletedObjects count]);
	}
}


/*
 *	Register and Unregister object
 */
- (CPManagedObject) _registerObject: (CPManagedObject) aObject
{
//	CPLog.trace("localID: " + [[aObject objectID] localID]);
	var regObject = [self objectRegisteredForID:[aObject objectID]];
	if(regObject != nil)
	{
		//update regobject with object
		[regObject _updateWithObject: aObject];
		[regObject _applyToContext:self];
		aObject = regObject;
		var userInfo = [CPDictionary dictionaryWithObject: [CPSet setWithObject: regObject]
											   forKey: CPDUpdatedObjectsKey];
		[[CPNotificationCenter defaultCenter]
						postNotificationName: CPManagedObjectContextObjectsDidChangeNotification
									  object: self
									userInfo: userInfo];
	}
	else
	{
		if(![[aObject objectID] validatedLocalID])
		{
			[aObject setEntity:[[aObject objectID] entity]];
			[[aObject objectID] setLocalID:[CPManagedObjectID createLocalID]];
			[aObject _applyToContext:self];
			
			[_registeredObjects addObject: aObject];	
		}
		else
		{
			[_registeredObjects addObject: aObject];
		}
		[aObject _applyToContext:self];
//		CPLog.trace("aobject:localID: " + [[aObject objectID] localID]);
		return aObject;
	}	
	
	[regObject _applyToContext:self];
//	CPLog.trace("reg:localID: " + [[regObject objectID] localID]);
	return regObject;
}


- (void) _unregisterObject: (CPManagedObject) object
{
	if ([_registeredObjects containsObject: object] == YES)
	{
		[_registeredObjects removeObject: object];
	}
}



/*
 *	All inserted object ids
 */
- (CPSet) insertedObjectIDs
{
	return _insertedObjectIDs;
}

/*
 *	All updated object ids
 */
- (CPSet) updatedObjectIDs
{
	return _updatedObjectIDs;
}



/*
 *	All inserted objects
 */
- (CPSet) insertedObjects
{
	var result = [[CPMutableSet alloc] init];
	
	var objectsEnum = [_insertedObjectIDs objectEnumerator];
	var objID;
	while((objID = [objectsEnum nextObject]))
	{
		[result addObject:[self objectRegisteredForID:objID]];
	}
	
	return result;
}


/*
 *	All updated objects
 */
- (CPSet) updatedObjects
{
	var result = [[CPMutableSet alloc] init];

	var objectsEnum = [_updatedObjectIDs objectEnumerator];
	var objID;
	while((objID = [objectsEnum nextObject]))
	{
		[result addObject:[self objectRegisteredForID:objID]];
	}
	
	return result;
}



/*
 *	All deleted objects
 */
- (CPSet) deletedObjects
{
	return _deletedObjects;
}


/*
 *	All registrated object ids
 */
- (CPSet) registeredObjectIDs
{
	var result = [[CPMutableSet alloc] init];

	var objectsEnum = [_registeredObjects objectEnumerator];
	var obj;
	while((obj = [objectsEnum objectEnumerator]))
	{
		[result addObject:[obj objectID]];
	}
	
	return result;
}

/*
 * All registrated objects
 */
- (CPSet) registeredObjects
{
 return _registeredObjects
}



@end