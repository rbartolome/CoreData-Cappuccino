//
//  CPEntityDescription.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPEntityDescription : CPObject
{
	CPManagedObjectModel _model @accessors(property=model);
	CPString _name @accessors(property=name);
	CPString _externalName @accessors(property=externalName);
	CPMutableSet _properties @accessors(property=properties);
}

- (CPManagedObject)createObject;
- (void)addRelationshipWithName:(CPString)name toMany:(BOOL)toMany optional:(BOOL)isOptional deleteRule:(int) aDeleteRule destination:(CPEntityDescription)destinationEntityName;
- (void)addAttributeWithName:(CPString)name classValue:(CPString)aClassValue typeValue:(int)aAttributeType optional:(BOOL)isOptional;
- (void)addProperty:(CPPropertyDescription)property;
- (CPDictionary)attributesByName;
- (CPDictionary)relationshipsByName;
- (CPDictionary)propertiesByName;
- (CPArray)propertyNames;
- (CPArray)mandatoryAttributes;
- (CPArray)mandatoryRelationships;
- (BOOL)acceptValue:(id) aValue forProperty:(CPString) aKey;
- (BOOL) isEqual:(CPEntityDescription)aEntity;
- (CPString)stringRepresentation;

@end