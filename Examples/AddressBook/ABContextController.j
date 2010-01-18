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
	CPDObjectContext context @accessors(property=context);
	CPDObjectModel model @accessors(property=model);
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
		model = [CPDObjectModel objectModelWithModelNamed:@"AddressBook.xcdatamodel" bundle:nil];
		//model = [CPDObjectModel objectModelWithModelNamed:@"AddressBook.eomodeld" bundle:nil];
		
		//init the context with your configuration dictionary
		context = [[CPDObjectContext alloc] initWithObjectModel: model 
												  storeType: [CPDWebDAVStoreType class] 
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
 *  for key 'CPDWebDAVStoreConfigurationKeyFileFormat' with:
 *
 *	- CPDSerializationJSONFormat
 *	- CPDSerializationXMLFormat
 *	- CPDSerialization280NPLISTFormat
 *************************************************************************
 */
+ (CPDictionary) webDAVConfig
{
	var result = [[CPMutableDictionary alloc] init];
	
	[result setObject:@"http://localhost:8080" forKey:CPDWebDAVStoreConfigurationKeyBaseURL];
	[result setObject:@"addressbook.json" forKey:CPDWebDAVStoreConfigurationKeyFilePath];
	[result setObject:CPDSerializationJSONFormat forKey:CPDWebDAVStoreConfigurationKeyFileFormat];
	
	return result
}



@end