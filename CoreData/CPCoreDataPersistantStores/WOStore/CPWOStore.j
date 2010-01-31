//
//  CPWOStore.j
//
//  Created by Raphael Bartolome on 07.10.09.
//

@import <Foundation/Foundation.j>

/*
 * configuration keys:
 *	sessionID
 *	persistantStore
 *	customConnectionURL
 */
@implementation CPWOStore : CPPersistantStore
{
}



/*
 * Connection URL
 */
- (CPString)sessionID
{
	if(_configuration != nil)
	{
		return [_configuration objectForKey:"sessionID"];
	}
	
	return nil;
}

/*
 * Connection URL
 */
- (CPString)connectionURL
{
	if(_configuration != nil)
	{
		return [_configuration objectForKey:"customConnectionURL"];
	}
	
	return nil;
}

/*
 * Custom method to set configuration from application arguments
 */
- (void)setConfiguration:(CPString)configuration
{
	_configuration = [CPDictionary dictionary];
	var args = configuration.replace(@"#", "").split(@",").slice(0);
	var i = 0;
	while(i < args.length)
	{
		
		var key = args[i];
		var value = args[i+1];
		
		if(key != nil && value != nil && value != "NULL")
		{
			[_configuration setObject:value forKey:key];
		}
		i = i + 2;
	}		
}

/*
 *	Override storeID
 */

- (CPString)storeID
{
	if(_configuration != nil)
	{
		return [_configuration objectForKey:"persistantStore"];
	}
	
	return nil;
}



/*
 *	write all objects before store will close
 */
- (void) saveAll:(CPSet) object error:({CPError}) error
{
	CPLog.debug(@"saveAll");
}


/*
 *	Request prefetched objects from store
 */
- (CPSet)loadAll:(CPDictionary) properties inManagedObjectContext:(CPManagedObjectContext) aContext error:({CPError}) error
{
	CPLog.debug(@"readDefaultObjects");

	var resultSet = [[CPMutableSet alloc] init];
	var request = @"{";
	request = request + [@"session" toCDJSON] + " : " + [[self sessionID] toCDJSON] + ",";
	request = request + [@"persistantStore" toCDJSON] + " : " + [[self storeID] toCDJSON] + ",";
	request = request + [@"fetchProperties" toCDJSON] + " : " + [properties toCDJSON] + ",";
	request = request + [@"method" toCDJSON] + " : " + [@"readDefaultObjects" toCDJSON];
	request = request + @"}";


	var result = [self _sendRequest:request];	
			
	if(result == nil)
	{
		CPLog.error(@"readDefaultObjects error description: " + [error localizedDescription]);
	}
	else
	{
		resultSet = [self convertJSONToObject:[result objectFromJSON]]; 
	}
	
	return resultSet;
}




/*
 * Save objects, updated, inserted and deleted the result must be of type CPManagedObject
 *
 */
- (CPSet) saveObjectsUpdated:(CPSet) updatedObjects
			       inserted:(CPSet) insertedObjects
				    deleted:(CPSet) deletedObjects
					  error:({CPError}) error
{
	CPLog.debug(@"saveObjects");
	
	var allObjects = [[CPMutableSet alloc] init];
	
	[allObjects unionSet:insertedObjects];
	[allObjects unionSet:updatedObjects];
	[allObjects unionSet:deletedObjects];

	var resultSet = [[CPMutableSet alloc] init];
	var request = @"{";
	request = request + [@"session" toCDJSON] + " : " + [[self sessionID] toCDJSON] + ",";
	request = request + [@"persistantStore" toCDJSON] + " : " + [[self storeID] toCDJSON] + ",";
	request = request + [@"method" toCDJSON] + " : " + [@"saveObjects" toCDJSON] + ",";
	request = request + [@"objects" toCDJSON] + " : " + [allObjects toCDJSON];
	request = request + @"}";

	var result = [self _sendRequest:request];	
	
	
	if(result == nil)
	{
		CPLog.error(@"saveObjects error description: " + [error localizedDescription]);
	}
	else
	{
		resultSet = [self convertJSONToObject:[result objectFromJSON]]; 
	}
	
	return resultSet;
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

/*
 * the following methods are @deprecated
 */

/*
 *	Fetch properties from objects with id
 */
- (CPSet) fetchObjectsWithEntityNamed:(CPString) aName
						fetchProperties:(CPDictionary) properties
						 fetchQualifier:(CPString) aQualifier
							 fetchLimit:(int) aFetchLimit
				 inManagedObjectContext:(CPManagedObjectContext) aContext
								  error:({CPError}) error
{
	CPLog.debug(@"fetchObjectsWithEntityNamed:fetchQualifier:fetchLimit");
	
	var resultSet = [[CPMutableSet alloc] init];
	
	var request = @"{";
	request = request + [@"session" toCDJSON] + " : " + [[self sessionID] toCDJSON] + ",";
	request = request + [@"persistantStore" toCDJSON] + " : " + [[self storeID] toCDJSON] + ",";
	request = request + [@"method" toCDJSON] + " : " + [@"fetchObjectsWithEntityNamed" toCDJSON] + ",";
	request = request + [@"entityNamed" toCDJSON] + " : " + [aName toCDJSON] + ",";
	request = request + [@"qualifier" toCDJSON] + " : " + [aQualifier toCDJSON] + ",";
	request = request + [@"fetchLimit" toCDJSON] + " : " + aFetchLimit + ",";
	request = request + [@"fetchProperties" toCDJSON] + " : " + [properties toCDJSON];
	request = request + @"}";

	var result = [self _sendRequest:request];	
	
	
	if(result == nil)
	{
		CPLog.error(@"fetchObjectsWithEntityNamed error description: " + [error localizedDescription]);
	}
	else
	{
		resultSet = [self convertJSONToObject:[result objectFromJSON]]; 
	}
	
	return resultSet;
}

/*
 *	Fetch properties from objects with id
 */
- (CPSet) fetchObjectsWithID:(CPSet) objectIDs
			   fetchProperties:(CPDictionary) properties
		inManagedObjectContext:(CPManagedObjectContext) aContext
						 error:({CPError}) error
{
	CPLog.debug(@"fetchObjectsWithID:fetchProperties");
		
	var resultSet = [[CPMutableSet alloc] init];
	
	var request = @"{";
	request = request + [@"session" toCDJSON] + " : " + [[self sessionID] toCDJSON] + ",";
	request = request + [@"persistantStore" toCDJSON] + " : " + [[self storeID] toCDJSON] + ",";
	request = request + [@"method" toCDJSON] + " : " + [@"fetchObjectsWithID" toCDJSON] + ",";
	request = request + [@"objectIDs" toCDJSON] + " : " + [objectIDs toCDJSON] + ",";
	request = request + [@"fetchProperties" toCDJSON] + " : " + [properties toCDJSON];
	request = request + @"}";

	var result = [self _sendRequest:request];	
	
	if(result == nil)
	{
		CPLog.error(@"fetchObjectsWithID error description: " + [error localizedDescription]);
	}
	else
	{
		resultSet = [self convertJSONToObject:[result objectFromJSON]]; 
	}
	
	return resultSet;
}

/*
 *	custom convert json objects
 */
- (CPSet) convertJSONToObject:(id)jsonObject
{
	var result = [[CPMutableSet alloc] init];

	if(jsonObject)
	{
		for (var i=0; i < jsonObject.length; i++) 
		{
			var newObject = [[CPManagedObject alloc] initUnqualifiedWithCDJSONObject:jsonObject[i] store:self];
			[result addObject:newObject];
        }
    }

	return result;
}


/*
 *	custom send request method
 */
- (CPString)_sendRequest:(CPString)aString
{
	CPLog.debug(@"_sendRequest:" + aString);
	var requestURL = [self connectionURL]+[self storeID];
	
	if([self sessionID] != nil)
	{
		requestURL = requestURL + "@" + [self sessionID];
	}
	
	var request = [CPURLRequest requestWithURL:requestURL];
	[request setHTTPMethod: "POST"]; 
	[request setHTTPBody:[aString string]]
	[request setValue:"application/json" forHTTPHeaderField:@"Content-Type"];
	var data = [CPURLConnection sendSynchronousRequest: request returningResponse:nil error:nil]; 
	var resultString = [data description]; 
	

	CPLog.debug(@"_response:" + resultString);
	
	return resultString;
}

@end