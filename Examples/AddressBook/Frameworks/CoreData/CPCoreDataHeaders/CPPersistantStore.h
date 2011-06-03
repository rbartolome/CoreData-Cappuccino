//
//  CPPersistantStore.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPPersistantStore : CPObject
{
	CPManagedObjectModel [self model] @accessors(property=model);
}

- (id)initWithStoreID:(CPString)aStoreID configuration:(CPDictionary)configuration;
- (id)initWithStoreID:(CPString)aStoreID url:(CPURL)url;

- (CPURL)URL;
- (void)setURL:(CPURL)url;
- (CPString)storeID;


- (void)setConfiguration:(CPDictionary)configuration;
- (CPDictionary)configuration;


- (void)setMetadata:(CPDictionary)metadata;
- (CPDictionary)metadata;


/*
 *	The CPManagedObjectContext calls this method before it closed
 */
- (void) saveAll:(CPSet) object error:({CPError}) error;

/*
 *	The CPManagedObjectContext call this method through the instantiation
 *	and updates/registrates the objects in reponse
 *	@return a set of CPManagedObjects with cheap relationship
 */
- (CPSet)loadAll:(CPDictionary) properties inManagedObjectContext:(CPManagedObjectContext) aContext error:({CPError}) error

/*
 *	Save objects, updated, inserted and deleted
 *	@return a set of CPManagedObjects with cheap relationship
 */
- (CPSet) saveObjectsUpdated:(CPSet) updatedObjects
			       inserted:(CPSet) insertedObjects
				    deleted:(CPSet) deletedObjects
					  error:({CPError}) error;


/*
 *	Fetch objects with predicate
 *	@return a set of CPManagedObjects with cheap relationship
 */
- (CPSet) fetchObjectsWithEntityNamed:(CPString) aName
						fetchProperties:(CPDictionary) properties
						 fetchQualifier:(CPString) aQualifier
							 fetchLimit:(int) aFetchLimit
	  			 inManagedObjectContext:(CPManagedObjectContext) aContext
								  error:({CPError}) error;


/*
 *	Fetch properties from objects with id
 *	@return a set of CPManagedObjects with cheap relationship
 */
- (CPSet) fetchObjectsWithID:(CPSet) objectIDs
			   fetchProperties:(CPDictionary) properties
						 error:({CPError}) error;
@end