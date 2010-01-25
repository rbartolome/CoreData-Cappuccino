//
//  CPWebDAVRequest.h
//
//  Created by Raphael Bartolome on 04.12.09.
//

@import <Foundation/Foundation.j>

@interface CPWebDAVRequest : CPObject
{
}

+ (id)requestWithBaseURL:(CPString)baseURL

- (void) writeFileWithStringContent:(CPString)aString toPath:(CPString)aPath;
- (void) writeFileWithDataContent:(CPData)aData toPath:(CPString)aPath;
- (void) deleteFileAtPath:(CPString)aPath;
- (void) createDirectoryAtPath:(CPString)aPath;
- (CPArray) contentsOfDirectoryAtPath:(CPString)aPath;
- (CPData) contentOfFileAtPath:(CPString)aPath;


@end