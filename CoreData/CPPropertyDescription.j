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
	BOOL _isOptional;
	CPEntityDescription _entity @accessors(property=entity);
}

- (BOOL)isOptional
{
	return _isOptional;
}

- (void)setIsOptional:(BOOL)isOptional
{
	if(isOptional == null)
	{
		_isOptional = false;
	}
	else
	{
		_isOptional = isOptional;
	}
}
@end