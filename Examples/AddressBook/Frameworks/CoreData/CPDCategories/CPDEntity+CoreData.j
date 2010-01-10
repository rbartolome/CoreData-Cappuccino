//
//  CPDEntity+CoreData.j
//
//  Created by Raphael Bartolome on 19.10.09.
//

@import <Foundation/Foundation.j>


@implementation CPDEntity (CoreData)

- (CPString)toCDJSON 
{
    var result = "{"+ [@"name" toCDJSON] + " : " + [_name toCDJSON] + "}";
	return result;
}

@end