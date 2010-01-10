//
//  CPNumber+CoreData.j
//
//  Created by Raphael Bartolome on 26.10.09.
//

@import <Foundation/Foundation.j>


@implementation CPNumber (CoreData)

- (CPString)toCDJSON 
{
	if (typeof self == "boolean")
	{
		if([self boolValue])
		{
			return @"true";
		}
		else
		{
			return @"false";
		}
	}	
	else
	{
		return self;
	}
	
}

@end