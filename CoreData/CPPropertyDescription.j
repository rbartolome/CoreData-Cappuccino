//
//  CPPropertyDescription.j
//
//  Created by Raphael Bartolome on 15.10.09.
//

@import <Foundation/CPObject.j>

CPPropertyDescriptionKey = "CPPropertyDescriptionKey";

@implementation CPPropertyDescription : CPObject
{
	CPString _name @accessors(property=name);
	BOOL _isOptional @accessors(property=isOptional);
	CPEntityDescription _entity @accessors(property=entity);
}

@end