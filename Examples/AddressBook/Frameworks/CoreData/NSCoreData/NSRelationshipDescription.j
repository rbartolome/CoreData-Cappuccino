//
//  NSRelationshipDescription.j
//
//  Created by Raphael Bartolome on 06.01.10.
//


@implementation NSRelationshipDescription : CPDRelationship
{
    NSEntityDescription _destinationEntity;
    CPString _destinationEntityName

    NSRelationshipDescription _inverseRelationship;
   	CPString _inverseRelationshipName;
	
	NSRelationshipDescription ns_entity;
    
	int ns_minCount;
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{	
		[self setDestinationEntityName:[aCoder decodeObjectForKey: @"_NSDestinationEntityName"]];
		[self setInversePropertyName:[aCoder decodeObjectForKey: @"_NSInverseRelationshipName"]];
		[self setName:[aCoder decodeObjectForKey: @"NSPropertyName"]];
		[self setIsOptional:[aCoder decodeBoolForKey: @"NSIsOptional"]];
		[self setIsToMany:[self NS_isToMany:[aCoder decodeIntForKey: @"NSMaxCount"]]];
		[self setDeleteRule:[self NS_deleteRule:[aCoder decodeIntForKey: @"NSDeleteRule"]]];
	}
	
	return self;
}

- (BOOL)NS_isToMany:(int)count
{    
	if(count > 1)
	{
		return YES;
	}
    else
	{
		return NO;
	}
}

- (int) NS_deleteRule:(int) aDeleteRule
{
	var result = CPDRelationshipDeleteRuleNullify;
	if(aDeleteRule == 3)
		result = CPDRelationshipDeleteRuleDeny;
	else if(aDeleteRule == 2)
		result = CPDRelationshipDeleteRuleCascade;
	else if(aDeleteRule == 1)
		result = CPDRelationshipDeleteRuleNullify;
	else if(aDeleteRule == 0)
		result = CPDRelationshipDeleteRuleNoAction;

	return result;
}

- (Class)classForKeyedArchiver
{
    return [NSRelationshipDescription class];
}

@end