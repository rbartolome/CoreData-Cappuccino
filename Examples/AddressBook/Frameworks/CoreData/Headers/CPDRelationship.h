//
//  CPDRelationship.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPDRelationship : CPDProperty
{
	CPDEntity _destination @accessors(property=destination);
	BOOL _toMany @accessors(property=isToMany);
	BOOL _mandatory @accessors(property=isMandatory);
	int _deleteRule @accessors(property=deleteRule);
}

- (Class)destinationClassType;
- (CPString)stringRepresentation;

@end