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
	CPDUndefinedAttributeType, 		//NSUndefinedAttributeType
	CPDIntegerAttributeType, 		//NSInteger16AttributeType
	CPDIntegerAttributeType, 		//NSInteger32AttributeType
	CPDIntegerAttributeType, 		//NSInteger64AttributeType
	CPDDecimalAttributeType, 		//NSDecimalAttributeType
	CPDDoubleAttributeType, 		//NSDoubleAttributeType
	CPDFloatAttributeType, 			//NSFloatAttributeType
	CPDStringAttributeType, 		//NSStringAttributeType
	CPDBooleanAttributeType, 		//NSBooleanAttributeType
	CPDDateAttributeType, 			//NSDateAttributeType
	CPDBinaryDataAttributeType, 	//NSBinaryDataAttributeType
	CPDTransformableAttributeType	//NSTransformableAttributeType
];

@implementation NSAttributeDescription : CPAttributeDescription
{
    CPString ns_valueTransformerName @accessors(property=valueTransformerName);
	NSEntityDescription ns_entity @accessors(property=entity);
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		[self setTypeValue:[self NS_attributeType:[aCoder decodeIntForKey: @"NSAttributeType"]]];
		[self setIsOptional:[aCoder decodeBoolForKey: @"NSIsOptional"]];
  		[self setClassValue:[[aCoder decodeObjectForKey: @"NSAttributeValueClassName"] stringByReplacingOccurrencesOfString:@"NS" withString:@"CP"]];
		[self setDefaultValue:[aCoder decodeObjectForKey: @"NSDefaultValue"]];
		[self setName:[aCoder decodeObjectForKey: @"NSPropertyName"]];

		ns_valueTransformerName = [aCoder decodeObjectForKey: @"NSValueTransformerName"];
		ns_entity = [aCoder decodeObjectForKey: @"NSEntity"];	//is set in NSEntityDescription		
	}
	
	return self;
}

- (int)NS_attributeType:(int) aTypeValue
{
	var result = 0;
	var i = 0;
	while(i < xcprototypes.length)
	{
		if(aTypeValue == xcprototypes[i])
		{
			result = xcprototypes_cp[i];
			break;
		}
		i++;
	}
	return result;
	
}

- (Class)classForKeyedArchiver
{
    return [NSAttributeDescription class];
}

@end