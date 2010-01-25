//
//  CPMemoryStoreType.j
//
//  Created by Raphael Bartolome on 11.01.10.
//

@import <Foundation/CPObject.j>


@implementation CPMemoryStoreType : CPPersistantStoreType
{
}

+ (CPString)type
{
	return "CPMemoryStore";
}

+ (Class)storeClass
{
	return [CPMemoryStore class];
}

@end