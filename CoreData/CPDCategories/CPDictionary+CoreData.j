//
//  CPDictionary+CoreData.j
//
//  Created by Raphael Bartolome on 16.09.09.
//

@import <Foundation/Foundation.j>

@implementation CPDictionary (CoreData)


- (CPString)toCDJSON
{

	var resultString = "{";
	
	var keys = [self allKeys];
	
	for(i=0;i<[keys count];i++)
	{
		var aKey = [keys objectAtIndex:i];
		var obj = [self objectForKey:aKey];
		
		if(i > 0)
			resultString = resultString + ",";
			
		resultString = resultString +[aKey toCDJSON]+" : ";
		if([obj respondsToSelector:@selector(toCDJSON)])
		{
			resultString = resultString + [obj toCDJSON];
		}
		else
		{
			resultString = resultString + obj;
		}
	}
	
	resultString = resultString + "}";
    return resultString;
}

@end