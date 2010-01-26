//
//  CPManagedObjectID+CPCoreDataSerialization.j
//
//  Created by Raphael Bartolome on 15.01.10.
//

@import <Foundation/CPObject.j>


@implementation CPManagedObjectID (CPCoreDataSerialization)

/*
 * ******************
 *	Dictionary format
 * ******************
 */
+ (id)deserializeFromDictionary:(CPDictionary) aDictionary withContext:(CPManagedObjectContext) aContext
{
	var aObjectID = nil;
	
	if(aDictionary != nil)
	{
		//deserialize ObjectID
		aObjectID = [[CPManagedObjectID alloc] init];
		[aObjectID setGlobalID:[aDictionary objectForKey:CPglobalID]];
		[aObjectID setLocalID:[aDictionary objectForKey:CPlocalID]];
		[aObjectID setIsTemporary:[aDictionary objectForKey:CPisTemporaryID]];
		[aObjectID setContext:aContext];
		[aObjectID setEntity:[[[aObjectID context] model] entityWithName:[aDictionary objectForKey:CPEntityDescriptionName]]];
	}

	return aObjectID;
}

- (CPDictionary)serializeToDictionary
{
	var result = [[CPMutableDictionary alloc] init];

	if([self globalID] != nil)
		[result setObject:[self globalID] forKey:CPglobalID];
	
	[result setObject:[self localID] forKey:CPlocalID];	
	[result setObject:[self isTemporary] forKey:CPisTemporaryID];	
	[result setObject:[[self entity] name] forKey:CPEntityDescriptionName];

	return result;
}


@end