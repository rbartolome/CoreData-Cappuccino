//
//  NSDictionary.j
//
//  Created by Raphael Bartolome on 06.01.10.
//


@import <Foundation/CPObject.j>
@import <Foundation/CPDictionary.j>

@implementation NSDictionary : CPObject
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [CPDictionary dictionaryWithObjects:[aCoder decodeObjectForKey:@"NS.objects"] forKeys:[aCoder decodeObjectForKey:@"NS.keys"]];
}

@end

@implementation NSMutableDictionary : NSDictionary
{
}
@end
