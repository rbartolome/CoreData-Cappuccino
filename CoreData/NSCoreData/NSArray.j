//
//  NSArray.j
//
//  Created by Raphael Bartolome on 06.01.10.
//
 
@import <Foundation/CPObject.j>
@import <Foundation/CPArray.j>

@implementation NSArray : CPArray
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [aCoder decodeObjectForKey:@"NS.objects"];
}

@end

@implementation NSMutableArray : NSArray
{
}

@end
