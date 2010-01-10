//
//  CPDEntity.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPDEntity : CPObject
{
	CPString _name @accessors(property=name);
	CPString _externalName @accessors(property=externalName);
	CPMutableSet _properties @accessors(property=properties);
}

- (CPDObject)createObject;
- (void)addRelationshipWithName:(CPString)name toMany:(BOOL)toMany mandatory:(BOOL)isMandatory deleteRule:(int) aDeleteRule destination:(CPDEntity)destinationEntity;
- (void)addAttributeWithName:(CPString)name type:(CPString)type allowsNull:(BOOL)allowsNull;
- (void)addProperty:(CPDProperty)property;
- (CPDictionary)attributesByName;
- (CPDictionary)relationshipsByName;
- (CPDictionary)propertiesByName;
- (CPArray)propertyNames;
- (CPArray)notNullAttributes;
- (CPArray)mandatoryRelationships;
- (BOOL) isEqualTo:(CPDEntity)aEntity;
- (CPString)stringRepresentation;

@end