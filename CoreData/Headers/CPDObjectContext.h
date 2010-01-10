//
//  CPDObjectContext.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

CPDObjectContextObjectsDidChangeNotification = "CPDObjectContextObjectsDidChangeNotification";
CPDObjectContextDidSaveNotification = "CPDObjectContextDidSaveNotification"; //TODO currently unused
CPDObjectContextDidReadObjectsNotification = "CPDObjectContextDidReadObjectsNotification";
CPDObjectContextDidWriteObjectsNotification = "CPDObjectContextDidWriteObjectsNotification";

CPDInsertedObjectsKey = "CPDInsertedObjectsKey";
CPDUpdatedObjectsKey = "CPDUpdatedObjectsKey";
CPDDeletedObjectsKey = "CPDDeletedObjectsKey";

@interface CPDObjectContext : CPObject
{
	CPDObjectModel _model @accessors(property=model);
	CPDStore _store @accessors(property=store);
}

- (id) initWithObjectModel:(CPDObjectModel)model
				 storeType:(CPDStoreType) aStoreType
		storeConfiguration:(id) aConfiguration;

- (BOOL) autoSaveChanges;
- (void) setAutoSaveChanges:(BOOL)aState;

- (void)writeObjects;
- (void)readObjects;

- (CPDObject)createAndInsertObjectByEntityNamed:(CPString) entity;

- (void) insertObject:({CPDObject}) aObject;
- (void) deleteObject:({CPDObject}) aObject;
- (void) deleteObjectWithID: ({CPDObjectID}) aObjectId;

- (CPUndoManager) undoManager
- (void) setUndoManager: (CPUndoManager) aManager

//TODO implement UndoManager methods
- (void) undo;
- (void) redo;
- (void) reset;
- (void) rollback;

- (BOOL) save;
- (BOOL) hasChanges;

- (CPSet) registeredObjects;
- (CPSet) insertedObjects;
- (CPSet) deletedObjects;
- (CPSet) updatedObjects;

- (CPDObject) updateObject:(CPDObject) aObject mergeChanges:(BOOL) mergeChanges;
- (CPDObject) updateObjectWithID:(CPDObjectID) aObjectID mergeChanges:(BOOL) mergeChanges
- (CPSet) executeFetchRequest:(CPDFetchRequest)aRequest;	//TODO implement this method and CPDFetchRequest

- (CPSet) objectsRegisteredWithEntityNamed:(String) aEntityName;
- (CPDObject) objectRegisteredForID:(CPDObjectID) aObjectID;

@end