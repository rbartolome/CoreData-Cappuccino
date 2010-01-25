//
//  CPPersistantStoreType.j
//
//  Created by Raphael Bartolome on 09.10.09.
//

@import <Foundation/CPObject.j>


/*
 * Override this class to add a custom StoreType
 */
@implementation CPPersistantStoreType : CPObject
{
}

+ (CPString)type
{
	return nil;
}

+ (Class)storeClass
{
	return nil;
}

@end