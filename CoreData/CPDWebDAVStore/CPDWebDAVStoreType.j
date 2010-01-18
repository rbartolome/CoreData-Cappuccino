//
//  CPDWebDAVStoreType.j
//
//  Created by Raphael Bartolome on 10.01.10.
//

@import <Foundation/Foundation.j>
@import <CoreData/CoreData.j>

CPDWebDAVStoreConfigurationKeyBaseURL = "CPDWebDAVStoreBaseURL";
CPDWebDAVStoreConfigurationKeyFilePath = "CPDWebDAVStoreFilePath";
CPDWebDAVStoreConfigurationKeyFileFormat = "CPDWebDAVStoreFileFormat";


@implementation CPDWebDAVStoreType : CPDStoreType
{
}

+ (CPString)type
{
	return "CPDWebDAVStore";
}

+ (Class)storeClass
{
	return [CPDWebDAVStore class];
}

@end