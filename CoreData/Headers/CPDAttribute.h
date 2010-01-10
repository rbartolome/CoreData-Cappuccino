//
//  CPDAttribute.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPDAttribute : CPDProperty
{
	CPString _type @accessors(property=type);
	BOOL _allowsNull @accessors(property=allowsNull);
}

- (Class) classType;
- (CPString)stringRepresentation;

@end