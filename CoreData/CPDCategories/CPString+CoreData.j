//
//  CPString+CoreData.j
//
//  Created by Raphael Bartolome on 26.10.09.
//

@import <Foundation/CPObject.j>


@implementation CPString (CoreData)

- (CPString)toCDJSON 
{
	return @"\""+[self string]+"\"";
}

// Returns a base64 encoded string
- (CPString)encodeBase64
{
    return base64_encode_string(self);
}
 
// Returns a string decoded from its base64 representation.
- (CPString)decodeBase64
{
    return base64_decode_to_string(self);
}


+ (CPString) stringWithContentsOfFile:(CPString) aPath
{
	var aData = [CPURLConnection sendSynchronousRequest:[CPURLRequest requestWithURL:aPath] returningResponse:nil error:nil];
	return [CPString stringWithString:[aData string]];
}

@end