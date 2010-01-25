//
//  CPPersistentStoreCoordinator.j
//
//  Created by Raphael Bartolome on 25.01.10.
//

@import <Foundation/Foundation.j>

@implementation CPPersistentStoreCoordinator : CPObject
{
	CPManagedObjectModel _model @accessors(property=managedObjectModel);
	CPDictionary _persistentStores @accessors(property=persistentStores);
	CPPersistantStore _persistantStore @accessors(property=persistantStore);
	CPUndoManager _undoManager;
}

- (id) initWithManagedObjectModel: (NSManagedObjectModel *) aModel
{
	if ((self = [super init]))
	{
		_model = model
		_undoManager = [CPUndoManager new];
		_persistentStores = [CPDictionary new];
	}
	
	return self;	
}


- (id) initWithManagedObjectModel:(CPManagedObjectModel)model
				 		storeType:(CPPersistantStoreType) aStoreType
			   storeConfiguration:(id) aConfiguration
{
	if ((self = [super init]))
	{
		_model = model
		_undoManager = [CPUndoManager new];
		[self addPersistentStoreWithType:aStoreType configuration:aConfiguration];		
	}
	
	return self;
}


// Managing the persistent stores.
- (id) addPersistentStoreWithType: (CPPersistantStoreType) aStoreType
                    configuration: (id) aConfiguration
{
	var storeClass = [aStoreType storeClass];
	var store = [[storeClass alloc] init];
	[store setConfiguration: aConfiguration];
	[store setStoreCoordinator:self];
	_persistantStore = store;
}

- (BOOL) removePersistentStore: (id) aPersistentStore
                         error: (NSError **) errorPointer
{
	//Unimplemented
}

- (id) migratePersistentStore: (id) aPersistentStore
                        toURL: (NSURL *) aURL
                      options: (NSDictionary *) options
                     withType: (NSString *) newStoreType
                        error: (NSError **) errorPointer
{
	//Unimplemented
}


- (CPUndoManager) undoManager
{
  return _undoManager;
}

- (void) setUndoManager: (CPUndoManager) aManager
{
	_undoManager = aManager;
}


- (void) undo
{
	[_undoManager undo];
}

- (void) redo
{
	[_undoManager redo];
}

@end