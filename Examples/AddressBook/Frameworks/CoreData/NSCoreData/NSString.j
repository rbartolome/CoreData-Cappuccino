//
//  NSString.j
//
//  Created by Raphael Bartolome on 06.01.10.
//

@import <Foundation/CPObject.j>
@import <Foundation/CPString.j>

@implementation NSString : CPString
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
    return [aCoder decodeObjectForKey:@"NS.string"];
}

@end

@implementation NSMutableString : NSString
{
}

@end
