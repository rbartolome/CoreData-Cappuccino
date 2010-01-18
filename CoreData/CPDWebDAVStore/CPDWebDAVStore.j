//
//  CPDWebDAVStore.j
//
//  Created by Raphael Bartolome on 10.01.10.
//

@import <Foundation/Foundation.j>
@import <CoreData/CoreData.j>
@import <CoreData/CPWebDAVRequest.j>


@implementation CPDWebDAVStore : CPDStore
{
	CPWebDAVRequest _davManager;
}


- (CPString)baseURL
{
	if(_configuration != nil)
	{
		var result = [_configuration objectForKey:CPDWebDAVStoreConfigurationKeyBaseURL];
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
		var result = [_configuration objectForKey:CPDWebDAVStoreConfigurationKeyFilePath];
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
		return [_configuration objectForKey:CPDWebDAVStoreConfigurationKeyFileFormat];
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
	CPLog.error("write all to path: " + [self storeID]);
	if([[self format] isEqualToString:CPDSerializationXMLFormat])
	{
		[[self davManager] writeFileWithStringContent:[objects serializeToXML:YES] toPath:[self storeID]];
	}
	else if([[self format] isEqualToString:CPDSerialization280NPLISTFormat])
	{
		[[self davManager] writeFileWithStringContent:[objects serializeTo280NPLIST:YES] toPath:[self storeID]];
	}
	else if([[self format] isEqualToString:CPDSerializationJSONFormat])
	{
		[[self davManager] writeFileWithStringContent:[objects serializeToJSON:YES] toPath:[self storeID]];		
	}	
	else if([[self format] isEqualToString:CPDSerializationDictionaryFormat])
	{
		CPLog.error("*** Dictionary Format is unimplemented for WebDAV ***");
	}
}


- (CPSet)load:(CPDictionary) properties error:({CPError}) error
{
	var resultSet = nil;
	
	var data = [[self davManager] contentOfFileAtPath:[self storeID]];
	if([data length] > 0)
	{
		if([[self format] isEqualToString:CPDSerializationXMLFormat])
		{
			resultSet = [CPSet deserializeFromXML:data withContext:[self context]];
			error = nil;
		}
		else if([[self format] isEqualToString:CPDSerialization280NPLISTFormat])
		{
			resultSet = [CPSet deserializeFrom280NPLIST:data withContext:[self context]];
			error = nil;
		}
		else if([[self format] isEqualToString:CPDSerializationJSONFormat])
		{
			var jsonArray = JSON.parse([data description]); 		
			resultSet = [CPSet deserializeFromJSON:jsonArray withContext:[self context]];
		}
		else if([[self format] isEqualToString:CPDSerializationDictionaryFormat])
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