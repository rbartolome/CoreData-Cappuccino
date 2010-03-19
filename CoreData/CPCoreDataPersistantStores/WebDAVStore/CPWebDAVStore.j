//
//  CPWebDAVStore.j
//
//  Created by Raphael Bartolome on 10.01.10.
//

@import <Foundation/Foundation.j>
@import <CoreData/CoreData.j>
@import <CoreData/CPWebDAVRequest.j>


@implementation CPWebDAVStore : CPPersistantStore
{
	CPWebDAVRequest _davManager;
}


- (CPString)baseURL
{
	if(_configuration != nil)
	{
		var result = [_configuration objectForKey:CPWebDAVStoreConfigurationKeyBaseURL];
		var lastCharacter = [result characterAtIndex:[result length]-1];
		
		if(![lastCharacter isEqualToString:@"/"])
		{
			result = result + @"/";
		}
		
		return result;
	}
}


- (CPString)storeID
{
	if(_configuration != nil)
	{
		var result = [_configuration objectForKey:CPWebDAVStoreConfigurationKeyFilePath];
		var firstCharacter = [result characterAtIndex:0];
		
		if([firstCharacter isEqualToString:@"/"])
		{
			result = [result substringFromIndex:1];
		}
		
		return result;
	}
}

- (CPString)format
{
	if(_configuration != nil)
	{
		return [_configuration objectForKey:CPWebDAVStoreConfigurationKeyFileFormat];
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


- (void) saveAll:(CPSet) objects error:({CPError}) error
{
	if([[self format] isEqualToString:CPCoreDataSerializationXMLFormat])
	{
		[[self davManager] writeFileWithStringContent:[objects serializeToXML:YES containsChangedProperties:YES] toPath:[self storeID]];
	}
	else if([[self format] isEqualToString:CPCoreDataSerialization280NPLISTFormat])
	{
		[[self davManager] writeFileWithStringContent:[[objects serializeTo280NPLIST:YES containsChangedProperties:YES] rawString] toPath:[self storeID]];
	}
	else if([[self format] isEqualToString:CPCoreDataSerializationJSONFormat])
	{
		[[self davManager] writeFileWithStringContent:[objects serializeToJSON:YES containsChangedProperties:YES] toPath:[self storeID]];		
	}	
	else if([[self format] isEqualToString:CPCoreDataSerializationDictionaryFormat])
	{
		CPLog.error("*** Dictionary Format is unimplemented for WebDAV ***");
	}
}


- (CPSet)loadAll:(CPDictionary) properties inManagedObjectContext:(CPManagedObjectContext) aContext error:({CPError}) error
{
	var resultSet = nil;
	
	var data = [[self davManager] contentOfFileAtPath:[self storeID]];
	if([data length] > 0)
	{
		if([[self format] isEqualToString:CPCoreDataSerializationXMLFormat])
		{
			resultSet = [CPSet deserializeFromXML:data withContext:aContext];
			error = nil;
		}
		else if([[self format] isEqualToString:CPCoreDataSerialization280NPLISTFormat])
		{
			resultSet = [CPSet deserializeFrom280NPLIST:data withContext:aContext];
			error = nil;
		}
		else if([[self format] isEqualToString:CPCoreDataSerializationJSONFormat])
		{
			var jsonArray = JSON.parse([data rawString]); 		
			resultSet = [CPSet deserializeFromJSON:jsonArray withContext:aContext];
		}
		else if([[self format] isEqualToString:CPCoreDataSerializationDictionaryFormat])
		{
			CPLog.error("*** Unimplemented Format ***");
		}
	}
	else
	{
		CPLog.error("*** File not found or content not readable ***");
	}
	
	return resultSet;
}


@end