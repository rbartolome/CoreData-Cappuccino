//
//  ABContextController.j
//  AddressBook
//
//  Created by Raphael Bartolome on 30.12.09.
//

@import <Foundation/Foundation.j>
@import <CoreData/CoreData.j>

@implementation ABContextController : CPObject
{
	CPManagedObjectContext context @accessors(property=context);
}


- (id)init
{
	self = [self initWithContext];
	return self;
}


/*
 ************************
 * Context initialization
 ************************
 */
- (id) initWithContext
{
	if(self = [super init])
	{
		//load your coredata model file
		var model = [CPManagedObjectModel modelWithModelNamed:@"AddressBook.xcdatamodel" bundle:nil];
		//var model = [CPManagedObjectModel modelWithModelNamed:@"AddressBook.eomodeld" bundle:nil];
		
//		var coordinator = [[CPPersistentStoreCoordinator alloc] initWithManagedObjectModel: model 
//																			storeType: [CPWebDAVStoreType class] 
//																   storeConfiguration: [ABContextController webDAVConfig]];

// 		uncomment this and comment the above line to use the html5 store
		var coordinator = [[CPPersistentStoreCoordinator alloc] initWithManagedObjectModel: model 
																			storeType: [CPHTML5StoreType class] 
																   storeConfiguration: [ABContextController html5Config]];
																   																   
		//init the context with the coordinator
		context = [[CPManagedObjectContext alloc] initWithPersistantStoreCoordinator: coordinator];
		[context setAutoSaveChanges:YES];		
	}
	
	return self;
}


/*
 *************************************************************************
 * HTML5 configuration
 * This will generate a HTML5 offline store by name
 *
 * The base RLOfflineDataStore.j is written by Randy Luecke the creator of http://www.timetableapp.com/
 * github : http://github.com/Me1000/RLOfflineDataStore
 *************************************************************************
 */
+ (CPDictionary) html5Config
{
	var result = [[CPMutableDictionary alloc] init];
	
	[result setObject:"AddressBook" forKey:CPHTML5StoreName];
	
	return result;
}

/*
 *************************************************************************
 * WebDAV configuration
 * This will generate a addressbook.cpdjson file in the webdav root folder
 *
 *	Try different formats by replace the object 
 *  for key 'CPWebDAVStoreConfigurationKeyFileFormat' with:
 *
 *	- CPCoreDataSerializationJSONFormat
 *	- CPCoreDataSerializationXMLFormat
 *	- CPCoreDataSerialization280NPLISTFormat
 *************************************************************************
 */
+ (CPDictionary) webDAVConfig
{
	var result = [[CPMutableDictionary alloc] init];
	
	[result setObject:@"http://localhost:8080" forKey:CPWebDAVStoreConfigurationKeyBaseURL];
	[result setObject:@"addressbook.json" forKey:CPWebDAVStoreConfigurationKeyFilePath];
	[result setObject:CPCoreDataSerializationJSONFormat forKey:CPWebDAVStoreConfigurationKeyFileFormat];
	
	return result
}



@end