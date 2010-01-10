//
//  NSAttributeDescription.j
//
//  Created by Raphael Bartolome on 06.01.10.
//

var xcprototypes = [
    0, 		//NSUndefinedAttributeType
    100, 	//NSInteger16AttributeType
    200, 	//NSInteger32AttributeType
    300, 	//NSInteger64AttributeType
    400, 	//NSDecimalAttributeType
    500, 	//NSDoubleAttributeType
    600, 	//NSFloatAttributeType
    700, 	//NSStringAttributeType
    800, 	//NSBooleanAttributeType
    900, 	//NSDateAttributeType
    1000, 	//NSBinaryDataAttributeType
    1800	//NSTransformableAttributeType
];

var xcprototypes_cp = [
    "CPObject", 
    "CPNumber", 
    "CPNumber", 
    "CPNumber", 
    "CPNumber", 
    "CPNumber", 
    "CPNumber", 
    "CPString", 
    "CPNumber", 
    "CPDate", 
    "CPData", 
    "CPObject"
];

@implementation NSAttributeDescription : CPObject
{
	int _attributeType;
    CPString _valueClassName;
    id _defaultValue @accessors(property=defaultValue);
    CPString _valueTransformerName @accessors(property=valueTransformerName);
	NSEntityDescription _entity @accessors(property=entity);
	CPString_propertyName @accessors(property=propertyName);
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
       _attributeType = [aCoder decodeIntForKey: @"NSAttributeType"];
       _valueClassName = [aCoder decodeObjectForKey: @"NSAttributeValueClassName"];
       _defaultValue = [aCoder decodeObjectForKey: @"NSDefaultValue"];
       _entity = [aCoder decodeObjectForKey: @"NSEntity"];
       _propertyName = [aCoder decodeObjectForKey: @"NSPropertyName"];
       _valueTransformerName = [aCoder decodeObjectForKey: @"NSValueTransformerName"];
	}
	
	return self;
}

- (CPString) attributeType
{
	var result = "CPString";

	var i = 0;
	while(i < xcprototypes.length)
	{
		if(_attributeType == xcprototypes[i])
		{
			result = xcprototypes_cp[i];
			break;
		}
		i++;
	}

	return result;
	
}


- (CPString) valueClassName
{
	var mappedClassName = "CPString";
    if (_valueClassName.indexOf("NS") === 0)
    {
        mappedClassName = @"CP" + _valueClassName.substr(2);
        CPLog.warn("Mapping " + aClassName + " to " + mappedClassName);
    }	

	return mappedClassName;
}


- (Class)classForKeyedArchiver
{
    return [NSAttributeDescription class];
}

@end