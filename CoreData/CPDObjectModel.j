//
//  CPDObjectModel.j
//
//  Created by Raphael Bartolome on 15.10.09.
//


@import <Foundation/CPObject.j>

@import "CPDProperty.j"
@import "CPDAttribute.j"
@import "CPDRelationship.j"
@import "CPDEntity.j"
@import "CPPropertyListReader_Vintage.j"
@import "CPPropertyListReader_Binary.j"

var EOMODEL_SUFFIX = "eomodeld";
var COREDATAMODEL_SUFFIX = "xcdatamodel";
var CPDCOREDATAMODEL_SUFFIX = "cpxcdatamodel";

@implementation CPDObjectModel : CPObject
{
	CPMutableSet _entities @accessors(property=entities);
}

- (id)init
{
	if(self = [super init])
	{
		_entities = [[CPMutableSet alloc] init];
	}
	
	return self;
}

+ (id)objectModelWithModelNamed:(CPString) aModelName bundle:(CPBundle)aBundle
{
	var objectModel = [[CPDObjectModel alloc] init];
	var modelURL = [aBundle || [CPBundle mainBundle] pathForResource:aModelName];
	if(modelURL != nil)
	{
		//check what kind of model we have
		if([aModelName hasSuffix:EOMODEL_SUFFIX])
		{
			[objectModel parseEOModel:modelURL];
		}
		else if([aModelName hasSuffix:COREDATAMODEL_SUFFIX] 
					|| [aModelName hasSuffix:CPDCOREDATAMODEL_SUFFIX])
		{
			[objectModel parseCoreDataModel:modelURL];
		}
	}

	return objectModel;
}

- (void)addEntity:(CPDEntity) entity
{
	[_entities addObject:entity];
}


- (CPDEntity)entityWithName:(CPString)name
{
	var result;
	var entity;
	var e = [_entities objectEnumerator];

	while ((entity = [e nextObject]) != nil)
    {
		if([[entity name] isEqualToString:name])
		{
			result = entity;
		}
    }
	
	return result;
}


- (CPString)stringRepresentation
{
	var result = "CPObjectModel";
	
	var entitiesE = [_entities objectEnumerator];
	var aEntity;
	
	while((aEntity = [entitiesE nextObject]))
	{
		result = result + "\n";
		result = result + [aEntity stringRepresentation];
	}

	return result;
}
@end