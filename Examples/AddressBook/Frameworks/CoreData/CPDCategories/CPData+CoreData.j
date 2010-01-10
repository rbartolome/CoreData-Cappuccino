//
//  CPData+CoreData.j
//
//  Created by Raphael Bartolome on 02.12.09.
//

@import <Foundation/Foundation.j>


@implementation CPData (CoreData)

+ (id)objectWithCDJSONObject:(id)aValue
{
	var aData = aData = [CPData dataWithString:[aValue decodeBase64]];
	return aData;
}

- (CPString)toCDJSON 
{
	var result = [[self string] encodeBase64];
	return [result toCDJSON];
}

- (CPString)base64EncodedString 
{
	var result = [[self string] encodeBase64];
	return result;
}

+ (CPData) dataWithContentsOfFile:(CPString) aPath
{
	var aData = [CPURLConnection sendSynchronousRequest:[CPURLRequest requestWithURL:aPath] returningResponse:nil error:nil];
	return aData;
}

@end