//
//  CPDEntity.j
//
//  Created by Raphael Bartolome on 15.10.09.
//

@import <Foundation/Foundation.j>
@import "CPDProperty.j"
@import "CPDAttribute.j"
@import "CPDRelationship.j"
@import "CPDObject.j"

@implementation CPDEntity : CPObject
{
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


- (CPDObject)createObject
{
	var newObject;
	var objectClassWithName = CPClassFromString(_name);
	var objectClassWithExternaName = CPClassFromString(_externalName);
	
	if(objectClassWithName != nil)
	{
		newObject = [[objectClassWithName alloc] initWithEntity:self];
	}
	else if(objectClassWithExternaName != nil)
	{
		newObject = [[objectClassWithExternaName alloc] initWithEntity:self]
	}
	else
	{
		newObject = [[CPDObject alloc] initWithEntity:self];
	}
	
	return newObject;
}

- (void)addRelationshipWithName:(CPString)name toMany:(BOOL)toMany mandatory:(BOOL)isMandatory deleteRule:(int) aDeleteRule destination:(CPDEntity)destinationEntity
{
	var tmp = [[CPDRelationship alloc] init];
	[tmp setName:name];
	[tmp setIsToMany:toMany];
	[tmp setIsMandatory:isMandatory];
	[tmp setDeleteRule:aDeleteRule];
	[tmp setDestination:destinationEntity];
	
	[self addProperty:tmp];
}

- (void)addAttributeWithName:(CPString)name type:(CPString)type allowsNull:(BOOL)allowsNull
{
	var tmp = [[CPDAttribute alloc] init];
	[tmp setName:name];
	[tmp setType:type];
	[tmp setAllowsNull:allowsNull];
	
	[self addProperty:[tmp copy]];
}

- (void)addProperty:(CPDProperty)property
{
	[_properties addObject:property];
}


- (CPDictionary)attributesByName
{
	return [self _filteredPropertiesOfClass: [CPDAttribute class]];
}

- (CPDictionary)relationshipsByName
{
	return [self _filteredPropertiesOfClass: [CPDRelationship class]];
}


- (CPDictionary)propertiesByName
{
	return [self _filteredPropertiesOfClass: Nil];
}

- (CPArray)propertyNames
{
	return [[self _filteredPropertiesOfClass: Nil] allKeys];
}

- (CPArray)notNullAttributes
{
	var result = [[CPMutableArray alloc] init];
	var allAttributes = [self attributesByName];
	
	var allKeys = [allAttributes allKeys];
	var i = 0;
	
	for(i=0;i<[allKeys count];i++)
	{
		var aKey = [allKeys objectAtIndex:i];
		var attribute = [allAttributes objectForKey:aKey];
	
		if(attribute != nil && ![attribute allowsNull])
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
	
		if(property != nil && [property isMandatory])
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

- (BOOL) isEqualTo:(CPDEntity)aEntity
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
	result = result + "-CPDEntity-";
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