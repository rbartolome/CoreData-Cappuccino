//
//  CPDate+CoreData.j
//
//  Created by Raphael Bartolome on 20.10.09.
//

@import <Foundation/Foundation.j>


@implementation CPDate (CoreData)

+ (id)objectWithCDJSONObject:(id)aValue
{
	var aDate = aDate = [CPDate dateWithTimeIntervalSince1970:aValue];	
	return aDate;
}

- (CPString)toCDJSON 
{
	var result = [self timeIntervalSince1970];
	return [result toCDJSON];
}

@end