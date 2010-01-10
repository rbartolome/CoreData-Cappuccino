//
//  CPDAttribute.j
//
//  Created by Raphael Bartolome on 15.10.09.
//

@import <Foundation/Foundation.j>
@import "CPDProperty.j"

@implementation CPDAttribute : CPDProperty
{
	CPString _type @accessors(property=type);
	BOOL _allowsNull @accessors(property=allowsNull);
}

- (Class) classType
{
	var result = [CPObject class];
	var classType = CPClassFromString(_type);
	
	if(classType != nil)
	{
		result = classType;
	}
	
	return result
}


- (CPString)stringRepresentation
{
	var result = "\n";
	result = result + "\n";
	result = result + "-CPDAttribute-";
	
	result = result + "\n";
	result = result + "name:" + [self name] + ";";
	result = result + "\n";
	result = result + "type:" + [self type] + ";";
	result = result + "\n";
	result = result + "allowsNull:" + [self allowsNull] + ";";

	return result;
}

@end