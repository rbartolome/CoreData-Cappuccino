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
	if(self = [super init])
	{
		[self initializeContext];
	}
	
	return self;
}


/*
 ************************
 * Context initialization
 ************************
 */
- (void) initializeContext
{
	model = [CPDObjectModel objectModelWithModelNamed:@"AddressBook.xcdatamodel" bundle:nil];
	context = [[CPDObjectContext alloc] initWithObjectModel: model 
												  storeType: [CPDJSONWebDAVStoreType class] 
										 storeConfiguration: [ABContextController webDAVConfig]];
	
	[context setAutoSaveChanges:YES];
}

/*
 *************************************************************************
 * WebDAV configuration
 * This will generate a addressbook.cpdjson file in the webdav root folder
 *************************************************************************
 */
+ (CPDictionary) webDAVConfig
{
	var result = [[CPMutableDictionary alloc] init];
	
	[result setObject:@"http://localhost:8080" forKey:@"baseURL"];
	[result setObject:@"/addressbook.cpdjson" forKey:@"filePath"];
	
	return result
}


/*
 *************************************
 *	CoreData Context accessor methods
 *************************************
 */
- (CPDObject) addNewAddress
{	
	var aAddress = [[self context] createAndInsertObjectByEntityNamed:@"Address"];				
	return aAddress;
}

- (void) deleteAddress:(CPDObject) aAddress
{
	[[self context] deleteObject:aAddress];
}

- (CPArray) addresses
{
	var result = [[[self context] objectsRegisteredWithEntityNamed:"Address"] allObjects];
	return result;
}



@end