//
//  CPDWOStoreType.j
//
//  Created by Raphael Bartolome on 09.10.09.
//

@import <Foundation/Foundation.j>
@import <CoreData/CoreData.j>


@implementation CPDWOStoreType : CPPersistantStoreType
{
}

+ (CPString)type
{
	return "CPDWOStore";
}

+ (Class)storeClass
{
	return [CPDWOStore class];
}

@end