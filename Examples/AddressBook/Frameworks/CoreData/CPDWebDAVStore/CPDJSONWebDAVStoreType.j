//
//  CPDJSONWebDAVStoreType.j
//
//  Created by Raphael Bartolome on 10.01.10.
//

@import <Foundation/Foundation.j>
@import <CoreData/CoreData.j>


@implementation CPDJSONWebDAVStoreType : CPDStoreType
{
}

+ (CPString)type
{
	return "CPDJSONWebDAVStore";
}

+ (Class)storeClass
{
	return [CPDJSONWebDAVStore class];
}

@end