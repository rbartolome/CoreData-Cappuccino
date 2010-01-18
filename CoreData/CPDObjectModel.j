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
	CPString _name @accessors(property=name);
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
			objectModel = [CPDObjectModel parseCoreDataModel:modelURL];
		}
	}

	CPLog.info("Data Model '" + [objectModel name] + "' loaded");
	
	return objectModel;
}

- (void)setNameFromFilePath:(CPString)aFilePath
{
	var pathComponents = [aFilePath componentsSeparatedByString:@"/"];
	var pathComponentsEnum = [pathComponents objectEnumerator];
	var aPathComponent;
	while(aPathComponent = [pathComponentsEnum nextObject])
	{
		if([CPDObjectModel hasSupportedModelSuffix:aPathComponent])
		{
			var componentSuffix = [aPathComponent componentsSeparatedByString:@"."];
			if([componentSuffix count] > 1)
			{
				[self setName:[componentSuffix objectAtIndex:0]];
				break;
			}
		}
	}
}

+ (BOOL)hasSupportedModelSuffix:(CPString) aModelFile
{
	var result = NO;
	if([aModelFile hasSuffix:EOMODEL_SUFFIX])
	{
		result = YES;
	}
	else if([aModelFile hasSuffix:COREDATAMODEL_SUFFIX])
	{
		result = YES;
	}
	else if([aModelFile hasSuffix:CPDCOREDATAMODEL_SUFFIX])
	{
		result = YES;
	}
	
	return result;
}

- (BOOL)isModelAllowedForMergeByName:(CPString) aModelName
{
	var result = NO;
	if([[self name] isEqualToString:aModelName])
		result = YES;
		
	return result;
}

- (void)addEntity:(CPDEntity) entity
{
	[entity setModel:self];
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

- (CPArray) entitiesByName
{
	var result = [[CPMutableArray alloc] init];
	
	var entitiesE = [_entities objectEnumerator];
	var aEntity;
	
	while((aEntity = [entitiesE nextObject]))
	{
		[result addObject:[aEntity name]];
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