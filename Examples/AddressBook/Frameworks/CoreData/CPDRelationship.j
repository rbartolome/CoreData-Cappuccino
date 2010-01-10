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
	CPDEntity _destination @accessors(property=destination);
	BOOL _toMany @accessors(property=isToMany);
	BOOL _mandatory @accessors(property=isMandatory);
	
	int _deleteRule @accessors(property=deleteRule);
}

- (Class)destinationClassType
{
	var result = [CPDObject class];
	var classType = CPClassFromString([_destination name]);
	
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
	result = result + "-CPDRelationship-";

	result = result + "\n";
	result = result + "name:" + [self name] + ";";
	result = result + "\n";
	result = result + "destination:" + [[self destination] name] + ";";
	result = result + "\n";
	result = result + "isToMany:" + [self isToMany] + ";";
	result = result + "\n";
	result = result + "mandatory:" + [self isMandatory] + ";";
	result = result + "\n";
	result = result + "deleteRule:" + [self deleteRule] + ";";
	return result;
}

@end