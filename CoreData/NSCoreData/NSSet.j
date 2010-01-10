//
//  NSSet.j
//
//  Created by Raphael Bartolome on 06.01.10.
//
 
@import <Foundation/CPObject.j>
@import <Foundation/CPSet.j>


@implementation NSSet : CPSet
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [[CPSet alloc] initWithArray:[aCoder decodeObjectForKey:@"NS.objects"]];
}

@end

@implementation NSMutableSet : NSSet
{
}
@end
