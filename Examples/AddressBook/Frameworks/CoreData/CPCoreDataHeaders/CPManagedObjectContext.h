//
//  CPManagedObjectContext.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

// Notifications.
CPManagedObjectContextObjectsDidChangeNotification = "CPManagedObjectContextObjectsDidChangeNotification";
CPManagedObjectContextDidSaveNotification = "CPManagedObjectContextDidSaveNotification";
CPManagedObjectContextDidLoadObjectsNotification = "CPManagedObjectContextDidLoadObjectsNotification";
CPManagedObjectContextDidSaveChangedObjectsNotification = "CPManagedObjectContextDidSaveChangedObjectsNotification";
CPManagedObjectContextDidSaveAllObjectsNotification = "CPManagedObjectContextDidSaveAllObjectsNotification";

CPDInsertedObjectsKey = "CPDInsertedObjectsKey";
CPDUpdatedObjectsKey = "CPDUpdatedObjectsKey";
CPDDeletedObjectsKey = "CPDDeletedObjectsKey";

@interface CPManagedObjectContext : CPObject
{
	CPManagedObjectModel _model @accessors(property=model);
	CPPersistantStore _store @accessors(property=store);
	CPPersistentStoreCoordinator _storeCoordinator @accessors(property=storeCoordinator);
}

- (id) initWithManagedObjectModel:(CPManagedObjectModel)model
				 storeType:(CPPersistantStoreType) aStoreType
		storeConfiguration:(id) aConfiguration;

- (BOOL) autoSaveChanges;
- (void) setAutoSaveChanges:(BOOL)aState;

- (BOOL)saveChanges
- (void)saveAll;
- (BOOL)load;

- (CPManagedObject)insertNewObjectForEntityForName:(CPString) entity;

- (void) insertObject:({CPManagedObject}) aObject;
- (void) deleteObject:({CPManagedObject}) aObject;
- (void) deleteObjectWithID: ({CPManagedObjectID}) aObjectId;

- (CPUndoManager) undoManager
- (void) setUndoManager: (CPUndoManager) aManager

//TODO implement UndoManager methods
- (void) undo;
- (void) redo;
- (void) reset;
- (void) rollback;

- (BOOL)saveAll;
- (BOOL)hasChanges;

- (CPSet) registeredObjects;
- (CPSet) insertedObjects;
- (CPSet) deletedObjects;
- (CPSet) updatedObjects;

- (CPManagedObject) updateObject:(CPManagedObject) aObject mergeChanges:(BOOL) mergeChanges;
- (CPManagedObject) updateObjectWithID:(CPManagedObjectID) aObjectID mergeChanges:(BOOL) mergeChanges
- (CPSet) executeFetchRequest:(CPFetchRequest)aFetchRequest;	//TODO implement this method and CPFetchRequest

- (CPSet) objectsForEntityNamed:(String) aEntityName;
- (CPManagedObject) objectRegisteredForID:(CPManagedObjectID) aObjectID;

@end