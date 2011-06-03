//
//  CPAttributeDescription.j
//
//  Created by Raphael Bartolome on 15.10.09.
//

@import <Foundation/Foundation.j>
@import "CPPropertyDescription.j"


CPDUndefinedAttributeType = 0;
CPDIntegerAttributeType = 100;
CPDInteger16AttributeType = 200;
CPDInteger32AttributeType = 300;
CPDInteger64AttributeType = 400;
CPDDecimalAttributeType = 500;
CPDDoubleAttributeType = 600;
CPDFloatAttributeType = 700;
CPDStringAttributeType = 800;
CPDBooleanAttributeType = 900;
CPDDateAttributeType = 1000,
CPDBinaryDataAttributeType = 1100,
CPDTransformableAttributeType = 1200;


@implementation CPAttributeDescription : CPPropertyDescription
{
	CPString _classValue;
	int _typeValue @accessors(property=typeValue);
	id _defaultValue @accessors(property= defaultValue);
}

- (void)setClassValue:(CPString) aClassValue
{
	_classValue = aClassValue;
}

- (Class) classValue
{
	var result = [CPObject class];
	var classType = CPClassFromString(_classValue);
	
	if(classType != nil)
	{
		result = classType;
	}
	
	return result
}

- (CPString) classValueName
{
	return _classValue
}

- (CPString) typeName
{
	var result;
	switch(_typeValue)
	{
		case 0:
			result = "CPDUndefinedAttributeType";break;
		case 100:
			result = "CPDIntegerAttributeType";break;
		case 200:
			result = "CPDInteger16AttributeType";break;
		case 300:
			result = "CPDInteger32AttributeType";break;
		case 400:
			result = "CPDInteger64AttributeType";break;
		case 500:
			result = "CPDDecimalAttributeType";break;
		case 600:
			result = "CPDDoubleAttributeType";break;
		case 700:
			result = "CPDFloatAttributeType";break;
		case 800:
			result = "CPDStringAttributeType";break;
		case 900:
			result = "CPDBooleanAttributeType";break;
		case 1000:
			result = "CPDDateAttributeType";break;
		case 1100:
			result = "CPDBinaryDataAttributeType";break;
		case 1200:
			result = "CPDTransformableAttributeType";break;		
		default:
			result = "CPDUndefinedAttributeType";
	}
	
	return result;
}


- (BOOL)acceptValue:(id) aValue
{
	var result = NO;
	
	if([aValue isKindOfClass:[self classValue]])
	{
		result = YES;
	}
	
	return result;
}

- (CPString)stringRepresentation
{
	var result = "\n";
	result = result + "\n";
	result = result + "-CPAttributeDescription-";
	
	result = result + "\n";
	result = result + "name:" + [self name] + ";";
	result = result + "\n";
	result = result + "type:" + [self typeValue] + ";";
	result = result + "\n";
	result = result + "optional:" + [self isOptional] + ";";

	return result;
}

@end