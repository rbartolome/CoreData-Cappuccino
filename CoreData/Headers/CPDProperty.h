//
//  CPDProperty.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

CPDPropertyKey = "CPDPropertyKey";

@interface CPDProperty : CPObject
{
	CPString _name @accessors(property=name);
	BOOL _isOptional @accessors(property=isOptional);
	CPDEntity _entity @accessors(property=entity);
}

@end