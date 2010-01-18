//
//  CPDObject.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

CPDObjectUnexpectedValueTypeForProperty = "CPDObjectUnexpectedValueTypeForProperty";

@interface CPDObject : CPObject
{
	CPDEntity _entity @accessors(property=entity);
	CPDObjectContext _context @accessors(property=context);

	CPDObjectID _objectID @accessors(property=objectID);
	BOOL _isUpdated @accessors(getter=isUpdated, setter=setUpdated:);
	BOOL _isDeleted @accessors(getter=isDeleted, setter=setDeleted:);
	BOOL _isFault @accessors(getter=isFault, setter=setFault:);
	
	CPMutableDictionary _data @accessors(property=data);
	CPMutableDictionary _changedData @accessors(property=changedData);
}

- (id)initWithEntity:(CPDEntity)entity;
- (id)initWithEntityNamed:(CPDEntity)entity insertIntoManagedObjectContext:(CPDObjectContext)aContext;

- (id)valueForKey:(CPString)aKey;
- (id)valueForKeyPath:(CPString)aKey;
- (id)storedValueForKey:(CPString)aKey;
- (id)storedValueForKeyPath:(CPString) key;

- (void)setValue:(id)aValue forKey:(CPString)aKey;
- (void)takeStoredValue:(id)value forKey:(CPString)aKey;
- (void)setValue:(id)aValue forKeyPath:(CPString)aKeyPath;
- (void)takeStoredValue:(id)value forKeyPath:(CPString)key;

- (void)addObjects:(CPArray)objectArray toBothSideOfRelationship:(CPString)propertyName;
- (void)addObject:(id)object toBothSideOfRelationship:(CPString)propertyName;

- (BOOL)isDeleted;
- (BOOL)isUpdated;
- (BOOL)isFault;
- (CPDObjectContext)context;
- (CPDEntity)entity;

- (CPArray)toManyRelationshipsKey;
- (CPArray)toOneRelationshipsKey;

- (BOOL)validateForDelete;
- (BOOL)validateForInsert;
- (BOOL)validateForUpdate;

- (void)willChangeValueForKey:(CPString)aKey;
- (void)didChangeValueForKey:(CPString)aKey;


- (BOOL)isPropertyOfTypeAttribute:(CPString)aKey;
- (BOOL)isPropertyOfTypeRelationship:(CPString)aKey;
- (BOOL)isPropertyOfTypeToManyRelationship:(CPString)aKey;
- (BOOL)isPropertyOfTypeToOneRelationship:(CPString)aKey;
- (BOOL)isPropertyOfTypeAttribute:(CPString)aKey;

- (Class)attributeClassValue:(CPString) key;
- (Class)relationshipDestinationClassType:(CPString) key;
- (CPDRelationship)realtionshipWithDestination:(CPDEntity)aEntity;
@end