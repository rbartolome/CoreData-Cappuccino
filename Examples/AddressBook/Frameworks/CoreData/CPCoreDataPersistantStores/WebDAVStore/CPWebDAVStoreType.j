//
//  CPWebDAVStoreType.j
//
//  Created by Raphael Bartolome on 10.01.10.
//

@import <Foundation/Foundation.j>
@import <CoreData/CoreData.j>

CPWebDAVStoreConfigurationKeyBaseURL = "CPWebDAVStoreBaseURL";
CPWebDAVStoreConfigurationKeyFilePath = "CPWebDAVStoreFilePath";
CPWebDAVStoreConfigurationKeyFileFormat = "CPWebDAVStoreFileFormat";


@implementation CPWebDAVStoreType : CPPersistantStoreType
{
}

+ (CPString)type
{
	return "CPWebDAVStore";
}

+ (Class)storeClass
{
	return [CPWebDAVStore class];
}

@end