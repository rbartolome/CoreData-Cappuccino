//
//  CPDProperty.j
//
//  Created by Raphael Bartolome on 15.10.09.
//

@import <Foundation/CPObject.j>

CPDPropertyKey = "CPDPropertyKey";

@implementation CPDProperty : CPObject
{
	CPString _name @accessors(property=name);
	BOOL _isOptional @accessors(property=isOptional);
	CPDEntity _entity @accessors(property=entity);
}

@end