//
//  NSRelationshipDescription.j
//
//  Created by Raphael Bartolome on 06.01.10.
//


@implementation NSRelationshipDescription : CPObject
{
	int _deleteRule @accessors(property=className);
    NSEntityDescription _destinationEntity @accessors(property=destinationEntity);
    NSRelationshipDescription _inverseRelationship @accessors(property=inverseRelationship);
    BOOL _optional @accessors(property=optional);
    int _maxCount @accessors(property=maxCount);
    int _minCount @accessors(property=minCount);
    CPString _destinationEntityName @accessors(property=destinationEntityName);
   	CPString _inverseRelationshipName @accessors(property=inverseRelationshipName);
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		_deleteRule = [aCoder decodeIntForKey: @"NSDeleteRule"];
		_destinationEntity = [aCoder decodeObjectForKey: @"NSDestinationEntity"];
		_entity = [aCoder decodeObjectForKey: @"NSEntity"];
		_inverseRelationship = [aCoder decodeObjectForKey: @"NSInverseRelationship"];
		_optional = [aCoder decodeBoolForKey: @"NSIsOptional"];
		_maxCount = [aCoder decodeIntForKey: @"NSMaxCount"];
		_minCount = [aCoder decodeIntForKey: @"NSMinCount"];
		_propertyName = [[aCoder decodeObjectForKey: @"NSPropertyName"] retain];

		_destinationEntityName = [aCoder decodeObjectForKey: @"_NSDestinationEntityName"];
		_inverseRelationshipName = [aCoder decodeObjectForKey: @"_NSInverseRelationshipName"];
	}
	
	return self;
}

- (BOOL) isToMany 
{    
	if(_maxCount > 1)
	{
		return YES;
	}
    else
	{
		return NO;
	}
}

- (int) deleteRule
{
	var result = CPDRelationshipDeleteRuleNullify;
	if(_deleteRule == 3)
		result = CPDRelationshipDeleteRuleDeny;
	else if(_deleteRule == 2)
		result = CPDRelationshipDeleteRuleCascade;
	else if(_deleteRule == 1)
		result = CPDRelationshipDeleteRuleNullify;
	else if(_deleteRule == 0)
		result = CPDRelationshipDeleteRuleNoAction;

	return result;
}

- (Class)classForKeyedArchiver
{
    return [NSRelationshipDescription class];
}

@end