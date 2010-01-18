//
//  CPDStore.j
//
//  Created by Raphael Bartolome on 15.09.09.
//

@import <Foundation/Foundation.j>


@implementation CPDStore : CPObject
{
	CPString _storeID;
	CPURL _URL;
	CPMutableDictionary _configuration;
	CPMutableDictionary _metadata;

	CPDObjectContext _context @accessors(property=context);
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
 *	The CPDObjectContext calls this method before it closed
 */
- (void) saveAll:(CPSet) objects error:({CPError}) error
{
}

/*
 *	The CPDObjectContext call this method through the instantiation
 *	and update and registrate the objects from reponse
 *	@return a set of CPDObjects with cheap relationship
 */
- (CPSet) load:(CPDictionary) properties error:({CPError}) error
{
	return [CPSet new];
}

/*
 *	Save objects, updated, inserted and deleted
 *	@return a set of CPDObjects with cheap relationship
 */
- (CPSet) saveObjectsUpdated:(CPSet) updatedObjects
			       inserted:(CPSet) insertedObjects
				    deleted:(CPSet) deletedObjects
					  error:({CPError}) error
{
	return [CPSet new];
}


/*
 *	Fetch objects with predicate
 *	@return a set of CPDObjects with cheap relationship
 */
- (CPSet) fetchObjectsWithEntityNamed:(CPString) aName
						fetchProperties:(CPDictionary) properties
						 fetchQualifier:(CPString) aQualifier
							 fetchLimit:(int) aFetchLimit
								  error:({CPError}) error
{
	return [CPSet new];
}


/*
 *	Fetch properties from objects with id
 *	@return a set of CPDObjects with cheap relationship
 */
- (CPSet) fetchObjectsWithID:(CPSet) objectIDs
			   fetchProperties:(CPDictionary) properties
						 error:({CPError}) error
{
	return [CPSet new];
}



@end