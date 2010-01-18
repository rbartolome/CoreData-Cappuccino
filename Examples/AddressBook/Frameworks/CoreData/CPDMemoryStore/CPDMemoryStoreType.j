//
//  CPDMemoryStoreType.j
//
//  Created by Raphael Bartolome on 11.01.10.
//

@import <Foundation/CPObject.j>


@implementation CPDMemoryStoreType : CPDStoreType
{
}

+ (CPString)type
{
	return "CPDMemoryStore";
}

+ (Class)storeClass
{
	return [CPDMemoryStore class];
}

@end