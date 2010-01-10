//
//  CPDObject+CoreData.j
//
//  Created by Raphael Bartolome on 19.10.09.
//

@import <Foundation/CPObject.j>


@implementation CPDObject (CoreData)

- (id)initUnqualifiedWithCDJSONObject:(id)jsonObject store:(CPDStore)aStore
{
	var unqObjectID = [[CPDObjectID alloc] initUnqualifiedWithCDJSONObject: jsonObject.objectID store:aStore];
	
	if(self = [super init])
	{

		_objectID = unqObjectID;
		_propertiesData = [[CPMutableDictionary alloc] init];
		_changedData = [[CPMutableDictionary alloc] init];
		_entity = [unqObjectID entity];
		_context = nil;

		_isUpdated = jsonObject.updated;
		_isDeleted = jsonObject.deleted;
		_isFault = jsonObject.fault;
		
		[self _resetObjectDataForProperties];
		
		var propertiesFromJSON = [CPDictionary dictionaryWithJSObject:jsonObject.properties];
		
		var dataKeys = [_data keyEnumerator];
		var aKey;
		while((aKey = [dataKeys nextObject]))		
		{
			var aObject = [propertiesFromJSON objectForKey:aKey];
			if(aObject!= nil)
			{
				if([self isPropertyFromTypeAttribute:aKey])
				{
					var aClass = [self attributeClassType:aKey];
					
					var convertedObject = aObject
					if(aClass != nil)
					{
						if([aClass respondsToSelector:@selector(objectWithCDJSONObject:)])
						{
							var validatedObject = [aClass objectWithCDJSONObject:aObject];
							if(validatedObject != nil)
							{
								convertedObject = validatedObject;
							}
						}
					}
									
					[_data setObject:convertedObject forKey:aKey];	
				}
				else
				{
					if([self isPropertyFromTypeToManyRelationship:aKey])
					{
						CPLog.trace("tomany: " + aKey);
						var toManySet = [[CPMutableSet alloc] init];
						var aObjectEnum = [aObject objectEnumerator];
						var aObjectPossibleID;
						while((aObjectPossibleID = [aObjectEnum nextObject]))
						{
							var aObjID = [[CPDObjectID alloc] initUnqualifiedWithCDJSONObject:aObjectPossibleID store:aStore];
							[toManySet addObject:aObjID];
						}
						
						[_data setObject:toManySet forKey:aKey];
					}
					else if([self isPropertyFromTypeToOneRelationship:aKey])
					{
						var aObjID = [[CPDObjectID alloc] initUnqualifiedWithCDJSONObject: aObject store:aStore];
						[_data setObject:aObjID forKey:aKey];	
					}
				}
			}
		}
		
	}
	
	return self;
}


- (CPString)toCDJSON 
{
	var result = "{";
	
	result = result + [@"objectID" toCDJSON] + " : "  + [[self objectID] toCDJSON] + ",";
	result = result + [@"isUpdated" toCDJSON] + " : " + [[self isUpdated] toCDJSON] + ",";
	result = result + [@"isDeleted" toCDJSON] + " : " + [[self isDeleted] toCDJSON] + ",";
	result = result + [@"isFault" toCDJSON] + " : " + [[self isFault] toCDJSON] + ",";
	result = result + [@"properties" toCDJSON] + " : "  + [[self _changedPropertiesData] toCDJSON];
	
	result = result + "}";

    return result;
}

@end