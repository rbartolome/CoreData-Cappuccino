//
//  CPDAttribute.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPDAttribute : CPDProperty
{
	int _typeValue @accessors(property=typeValue);
	id _defaultValue @accessors(property= defaultValue);
}

- (Class) classValue;
- (CPString) classValueName;
- (CPString) typeName;
- (BOOL)acceptValue:(id) aValue;

- (CPString)stringRepresentation;

@end