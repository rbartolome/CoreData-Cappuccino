//
//  CPPropertyDescription.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

CPPropertyDescriptionKey = "CPPropertyDescriptionKey";

@interface CPPropertyDescription : CPObject
{
	CPString _name @accessors(property=name);
	BOOL _isOptional @accessors(property=isOptional);
	CPEntityDescription _entity @accessors(property=entity);
}

@end