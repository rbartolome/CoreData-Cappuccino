//
//  CPDObjectID+CPDSerialization.j
//
//  Created by Raphael Bartolome on 15.01.10.
//

@import <Foundation/CPObject.j>


@implementation CPDObjectID (CPDSerialization)

/*
 * ******************
 *	Dictionary format
 * ******************
 */
+ (id)deserializeFromDictionary:(CPDictionary) aDictionary withContext:(CPDContext) aContext
{
	var aObjectID = nil;
	
	if(aDictionary != nil)
	{
		//deserialize ObjectID
		aObjectID = [[CPDObjectID alloc] init];
		CPLog.debug("DEBUG-1");
		[aObjectID setGlobalID:[aDictionary objectForKey:CPDglobalID]];
		CPLog.debug("DEBUG-2");
		[aObjectID setLocalID:[aDictionary objectForKey:CPDlocalID]];
		[aObjectID setIsTemporary:[aDictionary objectForKey:CPDisTemporaryID]];
		[aObjectID setContext:aContext];
		[aObjectID setEntity:[[[aObjectID context] model] entityWithName:[aDictionary objectForKey:CPDentityName]]];
	}

	return aObjectID;
}

- (CPDictionary)serializeToDictionary
{
	var result = [[CPMutableDictionary alloc] init];

	if([self globalID] != nil)
		[result setObject:[self globalID] forKey:CPDglobalID];
	
	[result setObject:[self localID] forKey:CPDlocalID];	
	[result setObject:[self isTemporary] forKey:CPDisTemporaryID];	
	[result setObject:[[self entity] name] forKey:CPDentityName];

	return result;
}


@end