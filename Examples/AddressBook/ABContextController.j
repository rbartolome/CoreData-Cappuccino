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
	CPManagedObjectModel model @accessors(property=model);
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
		model = [CPManagedObjectModel modelWithModelNamed:@"AddressBook.xcdatamodel" bundle:nil];
		//model = [CPManagedObjectModel modelWithModelNamed:@"AddressBook.eomodeld" bundle:nil];
		
		//init the context with your configuration dictionary
		context = [[CPManagedObjectContext alloc] initWithManagedObjectModel: model 
												  storeType: [CPWebDAVStoreType class] 
										 storeConfiguration: [ABContextController webDAVConfig]];
		
																			 	
		[context setAutoSaveChanges:YES];
	}
	
	return self;
}

/*
 *************************************************************************
 * WebDAV configuration
 * This will generate a addressbook.cpdjson file in the webdav root folder
 *
 *	Try different formats by replace the object 
 *  for key 'CPWebDAVStoreConfigurationKeyFileFormat' with:
 *
 *	- CoreDataSerializationJSONFormat
 *	- CoreDataSerializationXMLFormat
 *	- CoreDataSerialization280NPLISTFormat
 *************************************************************************
 */
+ (CPDictionary) webDAVConfig
{
	var result = [[CPMutableDictionary alloc] init];
	
	[result setObject:@"http://localhost:8080" forKey:CPWebDAVStoreConfigurationKeyBaseURL];
	[result setObject:@"addressbook.json" forKey:CPWebDAVStoreConfigurationKeyFilePath];
	[result setObject:CoreDataSerializationJSONFormat forKey:CPWebDAVStoreConfigurationKeyFileFormat];
	
	return result
}



@end