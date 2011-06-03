//
//  CPEntityDescription.j
//
//  Created by Raphael Bartolome on 15.10.09.
//

@import <Foundation/Foundation.j>
@import "CPPropertyDescription.j"
@import "CPAttributeDescription.j"
@import "CPRelationshipDescription.j"
@import "CPManagedObject.j"

@implementation CPEntityDescription : CPObject
{
	CPManagedObjectModel _model @accessors(property=model);
	CPString _name @accessors(property=name);
	CPString _externalName @accessors(property=externalName);
	CPMutableSet _properties @accessors(property=properties);
}

- (id)init
{
	if(self = [super init])
	{
		_properties = [[CPMutableSet alloc] init];
	}
	
	return self;
}

+ (CPManagedObject)insertNewObjectForEntityForName:(CPString)aEntityName inManagedObjectContext:(CPManagedObjectContext) aContext
{
	var result = [aContext insertNewObjectForEntityForName:aEntityName];
	
	return result;
}

- (CPManagedObject)createObject
{
	var newObject;
	var objectClassWithName = CPClassFromString(_name);
	var objectClassWithExternaName = CPClassFromString(_externalName);

	if(objectClassWithExternaName != nil)
	{
		newObject = [[objectClassWithExternaName alloc] initWithEntity:self]
	}
	else if(objectClassWithName != nil)
	{
		newObject = [[objectClassWithName alloc] initWithEntity:self];
	}
	else
	{
		newObject = [[CPManagedObject alloc] initWithEntity:self];
	}
	
	return newObject;
}

- (void)addRelationshipWithName:(CPString)name toMany:(BOOL)toMany optional:(BOOL)isOptional deleteRule:(int) aDeleteRule destination:(CPString)destinationEntityName
{
	var tmp = [[CPRelationshipDescription alloc] init];
	[tmp setName:name];
	[tmp setEntity:self];
	[tmp setIsToMany:toMany];
	[tmp setIsOptional:isOptional];
	[tmp setDeleteRule:aDeleteRule];
	[tmp setDestinationEntityName:destinationEntityName];
	
	[self addProperty:tmp];
}

- (void)addAttributeWithName:(CPString)name classValue:(CPString)aClassValue typeValue:(int)aAttributeType optional:(BOOL)isOptional
{
	var tmp = [[CPAttributeDescription alloc] init];
	[tmp setName:name];
	[tmp setEntity:self];
	[tmp setTypeValue:aAttributeType];
	[tmp setClassValue:aClassValue];
	[tmp setIsOptional:isOptional];
	
	[self addProperty:[tmp copy]];
}

- (void)addProperty:(CPPropertyDescription)property
{
	[_properties addObject:property];
}

- (CPDictionary)attributesByName
{
	return [self _filteredPropertiesOfClass: [CPAttributeDescription class]];
}

- (CPDictionary)relationshipsByName
{
	return [self _filteredPropertiesOfClass: [CPRelationshipDescription class]];
}


- (CPDictionary)propertiesByName
{
	return [self _filteredPropertiesOfClass: Nil];
}

- (CPArray)propertyNames
{
	return [[self _filteredPropertiesOfClass: Nil] allKeys];
}

- (CPArray)mandatoryAttributes
{
	var result = [[CPMutableArray alloc] init];
	var allAttributes = [self attributesByName];
	
	var allKeys = [allAttributes allKeys];
	var i = 0;
	
	for(i=0;i<[allKeys count];i++)
	{
		var aKey = [allKeys objectAtIndex:i];
		var attribute = [allAttributes objectForKey:aKey];
	
		if(attribute != nil && ![attribute isOptional])
		{
			[result addObject:aKey];
		}
	}
	
	return result
}

- (CPArray)mandatoryRelationships
{
	var result = [[CPMutableArray alloc] init];
	var allRC = [self relationshipsByName];
	
	var allKeys = [allRC allKeys];
	var i = 0;
	
	for(i=0;i<[allKeys count];i++)
	{
		var aKey = [allKeys objectAtIndex:i];
		var property = [allRC objectForKey:aKey];
	
		if(property != nil && ![property isOptional])
		{
			[result addObject:aKey];
		}
	}
	
	return result
}


- (CPDictionary) _filteredPropertiesOfClass: (Class) aClass
{
	var dict;
	var e;
	var property;

	dict = [[CPMutableDictionary alloc] init];
	e = [_properties objectEnumerator];
	while ((property = [e nextObject]) != nil)
    {
      if (aClass == Nil || [property isKindOfClass: aClass])
        {
			[dict setObject: property forKey: [property name]];
        }
    }

	return dict;
}


- (BOOL)acceptValue:(id) aValue forProperty:(CPString) aKey
{
	var result = NO;
	var theProperty = [[self propertiesByName] objectForKey:aKey]
	result = [theProperty acceptValue:aValue];
	return result;
}


- (BOOL) isEqual:(CPEntityDescription)aEntity
{
	if([[aEntity name] isEqualToString:_name])
	{
		return YES;
	}
	
	return NO;
}


- (CPString)stringRepresentation
{
	var result = "\n";
	result = result + "\n";
	result = result + "-CPEntityDescription-";
	result = result + "\n***********";
	result = result + "\n";
	result = result + "name:" + [self name] + ";";
	result = result + "\n";
	result = result + "externalName:" + [self externalName] + ";";
	
	var propertiesE = [_properties objectEnumerator];
	var aProperty;
	
	while((aProperty = [propertiesE nextObject]))
	{
		result = result + "\n";
		result = result + [aProperty stringRepresentation];
	}

	return result;
}

@end