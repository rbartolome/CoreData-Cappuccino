//
//  CPManagedObjectID+CoreDataSerialization.j
//
//  Created by Raphael Bartolome on 15.01.10.
//

@import <Foundation/CPObject.j>


@implementation CPManagedObjectID (CoreDataSerialization)

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
		aObjectID = [[CPManagedObjectID alloc] init];
		[aObjectID setGlobalID:[aDictionary objectForKey:CPDglobalID]];
		[aObjectID setLocalID:[aDictionary objectForKey:CPDlocalID]];
		[aObjectID setIsTemporary:[aDictionary objectForKey:CPDisTemporaryID]];
		[aObjectID setContext:aContext];
		[aObjectID setEntity:[[[aObjectID context] model] entityWithName:[aDictionary objectForKey:CPEntityDescriptionName]]];
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
	[result setObject:[[self entity] name] forKey:CPEntityDescriptionName];

	return result;
}


@end