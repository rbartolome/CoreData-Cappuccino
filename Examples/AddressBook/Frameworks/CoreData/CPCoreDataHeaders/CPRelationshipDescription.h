//
//  CPRelationshipDescription.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPRelationshipDescription : CPPropertyDescription
{
	CPDString _inversePropertyName @accessors(property=inversePropertyName);
	CPDString _destinationEntityName @accessors(property=destinationEntityName);
	BOOL _toMany @accessors(property=isToMany);
	int _deleteRule @accessors(property=deleteRule);
}

- (Class)destinationClassType;
- (CPEntityDescription)destination;
- (BOOL)acceptValue:(id) aValue;

- (CPString)stringRepresentation;

@end