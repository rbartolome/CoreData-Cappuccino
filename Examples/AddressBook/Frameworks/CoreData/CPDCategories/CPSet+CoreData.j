//
//  CPSet+CoreData.j
//
//  Created by Raphael Bartolome on 19.10.09.
//

@import <Foundation/CPObject.j>


@implementation CPSet (CoreData)


- (CPString)toCDJSON
{
	var resultString = "[";
	
	var objects = [self allObjects];

	var i = 0;
	for(i=0;i<[objects count];i++)
	{
		if(i > 0)
			resultString = resultString + ",";
			
		var obj = [objects objectAtIndex:i];
		
		if([obj respondsToSelector:@selector(toCDJSON)])
		{
			resultString = resultString + [obj toCDJSON];
		}
	}
	
	resultString = resultString + "]";
    return resultString;
}

@end