//
//  CPMemoryStore.j
//
//  Created by Raphael Bartolome on 11.01.10.
//

@import <Foundation/Foundation.j>


@implementation CPMemoryStore : CPPersistantStore
{
	CPString _storeID;
	CPURL _URL;
	CPMutableDictionary _configuration;
	CPMutableDictionary _metadata;

	CPManagedObjectModel _model @accessors(property=model);
}


- (id)initWithStoreID:(CPString)aStoreID configuration:(CPDictionary)configuration
{
	self = [super init];
	
	if(self != nil)
	{
		_storeID = aStoreID;
		_configuration = configuration
	}
	
	return self;
}

- (id)initWithStoreID:(CPString)aStoreID url:(CPURL)url
{
	self = [super init];
	
	if(self != nil)
	{
		_storeID = aStoreID;
		_configuration = nil;
		_URL = url;
	}
	
	return self;
}

- (CPURL)URL
{
	return _URL;
}

- (void)setURL:(CPURL)url
{
	_URL = url;
}

- (CPString)storeID
{
  return _storeID;
}


- (void)setConfiguration:(CPDictionary)configuration
{
	_configuration = configuration;
}

- (CPDictionary)configuration
{
	return _configuration;
}


- (void)setMetadata:(CPDictionary)metadata
{
	_metadata = metadata;
}

- (CPDictionary)metadata
{
	return _metadata;
}


/*
 *	The CPManagedObjectContext calls this method before it closed
 */
- (void) saveAll:(CPSet) objects error:({CPError}) error
{
}

/*
 *	The CPManagedObjectContext call this method through the instantiation
 *	and update and registrate the objects from reponse
 *	@return a set of CPManagedObjects with cheap relationship
 */
- (CPSet)loadAll:(CPDictionary) properties inManagedObjectContext:(CPManagedObjectContext) aContext error:({CPError}) error
{
	return [CPSet new];
}

/*
 *	Save objects, updated, inserted and deleted
 *	@return a set of CPManagedObjects with cheap relationship
 */
- (CPSet) saveObjectsUpdated:(CPSet) updatedObjects
			       inserted:(CPSet) insertedObjects
				    deleted:(CPSet) deletedObjects
					  error:({CPError}) error
{
	return [CPSet new];
}


/*
 *	Fetch objects with request
 *	@return a set of CPManagedObjects with cheap relationship
 */
- (CPSet) executeFetchRequest:(CPFetchRequest) aFetchRequest
	   inManagedObjectContext:(CPManagedObjectContext) aContext
					  	error:({CPError}) error
{
	return [CPSet new];
}


@end