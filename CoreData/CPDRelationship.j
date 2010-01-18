//
//  CPDRelationship.j
//
//  Created by Raphael Bartolome on 15.10.09.
//

@import <Foundation/CPObject.j>
@import "CPDProperty.j"
@import "CPDObject.j"


CPDRelationshipDeleteRuleNullify = 0;
CPDRelationshipDeleteRuleCascade = 1;
CPDRelationshipDeleteRuleDeny = 2;
CPDRelationshipDeleteRuleNoAction = 3;


@implementation CPDRelationship : CPDProperty
{
	CPDString _inversePropertyName @accessors(property=inversePropertyName);
	CPDString _destinationEntityName @accessors(property=destinationEntityName);
	BOOL _toMany @accessors(property=isToMany);
	int _deleteRule @accessors(property=deleteRule);
}

- (Class)destinationClassType
{
	var result = [CPDObject class];
	var classType = CPClassFromString(_destinationEntityName);
	
	if(classType != nil)
	{
		result = classType;
	}
	
	return result
}

- (BOOL)acceptValue:(id) aValue
{
	var result = NO;
	var theProperty = [[self propertiesByName] objectForKey:aKey]
	result = [theProperty acceptValue:aValue];
	return result;
}

- (CPDEntity)destination
{
	return [[[self entity] model] entityWithName:_destinationEntityName];
}

- (CPString)stringRepresentation
{
	var result = "\n";
	result = result + "\n";
	result = result + "-CPDRelationship-";

	result = result + "\n";
	result = result + "name:" + [self name] + ";";
	result = result + "\n";
	result = result + "destination:" + [self destinationEntityName] + ";";
	result = result + "\n";
	result = result + "isToMany:" + [self isToMany] + ";";
	result = result + "\n";
	result = result + "optional:" + [self isOptional] + ";";
	result = result + "\n";
	result = result + "deleteRule:" + [self deleteRule] + ";";
	return result;
}

@end