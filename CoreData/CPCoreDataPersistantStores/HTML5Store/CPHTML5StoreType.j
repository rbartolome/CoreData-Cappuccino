//
//  CPHTML5StoreType.j
//
//  Created by Raphael Bartolome on 09.10.09.
//

@import <Foundation/Foundation.j>
@import <CoreData/CoreData.j>

CPHTML5StoreName = "CPHTML5StoreName";

@implementation CPHTML5StoreType : CPPersistantStoreType
{
}

+ (CPString)type
{
	return "CPHTML5Store";
}

+ (Class)storeClass
{
	return [CPHTML5Store class];
}

@end