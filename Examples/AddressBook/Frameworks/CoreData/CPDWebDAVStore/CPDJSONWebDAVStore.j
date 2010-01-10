//
//  CPDJSONWebDAVStore.j
//
//  Created by Raphael Bartolome on 10.01.10.
//

@import <Foundation/Foundation.j>
@import <CoreData/CPWebDAVRequest.j>

@implementation CPDJSONWebDAVStore : CPDStore
{
	CPWebDAVRequest _davManager;
}


- (CPString)baseURL
{
	if(_configuration != nil)
	{
		return [_configuration objectForKey:"baseURL"];
	}
}


- (CPString)storeID
{
	if(_configuration != nil)
	{
		return [_configuration objectForKey:"filePath"];
	}
}


- (void)setConfiguration:(CPDictionary)configuration
{
	_configuration = configuration;
}

- (CPDictionary)configuration
{
	return _configuration;
}

- (CPWebDAVRequest)davManager
{
	if(_davManager == nil)
	{
		_davManager = [CPWebDAVRequest requestWithBaseURL:[self baseURL]];
	}
	
	return _davManager;
}

- (void) writeObjects:(CPSet) objects error:({CPError}) error
{
	CPLog.debug("writeObjects");
	[objects makeObjectsPerformSelector:@selector(_mergeChangedDataWithAllData)];
	var dataString = [objects toCDJSON];	
	[[self davManager] writeFileWithStringContent:dataString toPath:[self storeID]];
}


- (CPSet) readObjects:(CPDictionary) properties error:({CPError}) error
{
	CPLog.debug("readObjects");
	var resultSet = nil;
	
	var data = [[self davManager] contentOfFileAtPath:[self storeID]];
	if([data length] > 0)
	{
		var resultFromFile = [data string];
		resultSet = [self convertJSONToObject:[resultFromFile objectFromJSON]];
	}
	else
	{
		CPLog.error("no file or content found");
	}
	
	return resultSet;
}

- (CPSet) convertJSONToObject:(id)jsonObject
{
	var result = [[CPMutableSet alloc] init];

	if(jsonObject)
	{
		for (var i=0; i < jsonObject.length; i++) 
		{
			var newObject = [[CPDObject alloc] initUnqualifiedWithCDJSONObject:jsonObject[i] store:self];
			[result addObject:newObject];
        }
    }

	return result;
}

@end