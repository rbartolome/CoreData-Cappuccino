//
//  CPArray+CPCoreDataSerialization.j
//
//  Created by Raphael Bartolome on 14.01.10.
//

@import <Foundation/Foundation.j>


@implementation CPArray (CPCoreDataSerialization)


- (JSObject)toJSObject
{
	var result = [CPMutableArray new];
	
	var contentEnum = [self objectEnumerator];
	var aObject;
	
	while(aObject = [contentEnum nextObject])
	{
		if([aObject isKindOfClass:[CPDictionary class]] 
			|| [aObject isKindOfClass:[CPArray class]] 
			|| [aObject isKindOfClass:[CPSet class]])
		{
			[result addObject:[aObject toJSObject]];
		}
		else
		{
			[result addObject:aObject];
		}
	}
	return result;
}


@end