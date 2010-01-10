//
//  CPDObjectModel+EOModel.j
//
//  Created by Raphael Bartolome on 23.11.09.
//

@import <Foundation/Foundation.j>


var woprototypes = [
    "amount", 
    "blob", 
    "boolean", 
    "charFlag", 
    "cryptoString", 
    "date", 
    "dateTime", 
    "doubleNumber", 
    "flag", 
    "globalID", 
    "intBoolean", 
    "intNumber", 
    "ipAddress", 
    "javaEnum", 
    "longNumber", 
    "longText", 
    "mutableArray", 
    "mutableDictionary", 
    "osType", 
    "shortString", 
    "type", 
    "varchar10", 
    "varchar100", 
    "varchar1000", 
    "varchar16", 
    "varchar255", 
    "varchar50", 
    "varcharLarge",
	"id"
];

var woprototypes_cp = [
    "CPNumber", 
    "CPData", 
    "BOOL", 
    "CPString", 
    "CPString", 
    "CPDate", 
    "CPDate", 
    "CPNumber", 
    "CPNumber", 
    "CPString", 
    "NSNumer", 
    "NSNumber", 
    "CPString", 
    "CPString", 
    "CPNumber", 
    "CPString", 
    "CPData", 
    "CPData", 
    "CPString", 
    "CPString", 
    "CPString", 
    "CPString", 
    "CPString", 
    "CPString", 
    "CPString", 
    "CPString", 
    "CPString", 
    "CPString",
	"CPNumber"
];


@implementation CPDObjectModel (EOModel)

- (void) parseEOModel:(CPString) aModelName
{
	var indexFile = aModelName + "/" + "index.eomodeld"; 
	var dict = [self dictionaryForPropertyListFile:indexFile];	
	var entitiesFromModel = [dict objectForKey:@"entities"];
	
	if([self createPrototypesForEntitiesFromEOModel:entitiesFromModel])
	{		
		var entitiesEnum = [_entities objectEnumerator];
		var entity;
		while((entity = [entitiesEnum nextObject]))
		{			
			var aEntityDescriptionFile = aModelName + "/" + [entity name] + ".plist";	
			var entityDescDictionary = [self dictionaryForPropertyListFile:aEntityDescriptionFile];
			[self validateEntity:[entity name] withDescription:entityDescDictionary];
		}
	}
}

- (void) createPrototypesForEntitiesFromEOModel:(CPArray) entitiesFromModel
{
	var result = NO;
	var i = 0;
	if(entitiesFromModel != nil && [entitiesFromModel count] > 0)
	{
		for(i = 0; i<[entitiesFromModel count]; i++)
		{
			var entityDict = [entitiesFromModel objectAtIndex:i];
			if(entityDict != nil && [entityDict isKindOfClass:[CPDictionary class]])
			{
				var name = [entityDict objectForKey:@"name"];
				var aEntity = [[CPDEntity alloc] init];
				[aEntity setName:name];
				[self addEntity:aEntity];
			}
		}	
		result = YES;
	}
	return result;
}

- (void) validateEntity:(CPString)aName withDescription:(CPDictionary) aDict
{
	var entity = [self entityWithName:aName];		
	[entity setExternalName:[aDict objectForKey:@"externalName"]];
	
	//validate classProperties with attributes array
	var attributes = [aDict objectForKey:@"attributes"];
	var classProperties = [aDict objectForKey:@"classProperties"];
	var relationships = [aDict objectForKey:@"relationships"];
	
	var classPropertiesE = [classProperties objectEnumerator];
	var classProperty;
	while((classProperty = [classPropertiesE nextObject]))
	{
		//handle attributes array
		var attributesE = [attributes objectEnumerator];
		var attribute;
		while((attribute = [attributesE nextObject]))
		{
			var attributeName = [attribute objectForKey:@"name"];
			if([classProperty isEqualToString:attributeName])
			{
				var attributeType;
				var allowsNull = [attribute objectForKey:@"allowsNull"];
				var prototypeName = [attribute objectForKey:@"prototypeName"];
				var valueClassName = [attribute objectForKey:@"valueClassName"];
				if(prototypeName == null)
				{
					if(valueClassName != null)
					{
						//@TASK we need to modify this because this could be a problem for NSDate because NSCalendarDate
						//isn't a supported class by capp currently
						valueClassName = [valueClassName stringByReplacingOccurrencesOfString:@"NS" withString:@"CP"];
					}
					else
					{
						attributeType = [self attibuteTypeForWOPrototype:prototypeName];	
					}
				}
				else
				{
					attributeType = [self attibuteTypeForWOPrototype:prototypeName];
				}

				[entity addAttributeWithName:attributeName type:attributeType allowsNull:allowsNull];
			}
		}
		
		//handle relationships array
		var relatioshipsE = [relationships objectEnumerator];
		var relationship;
		while((relationship = [relatioshipsE nextObject]))
		{
			var relationshipName = [relationship objectForKey:@"name"];
			if([classProperty isEqualToString:relationshipName])
			{
				var destination = [relationship objectForKey:@"destination"];
				var isToMany = [relationship objectForKey:@"isToMany"];
				var isMandatory = [relationship objectForKey:@"isMandatory"];
				var deleteRuleWO = [relationship objectForKey:@"deleteRule"];
				var deleteRule = [self deleteRuleForWODescription:deleteRuleWO];
				var destinationEntity = [self entityWithName:destination];
				
				[entity addRelationshipWithName:relationshipName 
										toMany:isToMany 
										mandatory:isMandatory 
										deleteRule:deleteRule 
										destination:destinationEntity];				
			}
		}
	}
	
}

- (int) deleteRuleForWODescription:(CPString) aDescription
{
	var result = CPDRelationshipDeleteRuleNullify;
	if(aDescription != nil)
	{
		if([aDescription isEqualToString:@"EODeleteRuleCascade"])
			result = CPDRelationshipDeleteRuleCascade;
		else if([aDescription isEqualToString:@"EODeleteRuleDeny"])
			result = CPDRelationshipDeleteRuleDeny;
		else if([aDescription isEqualToString:@"EODeleteRuleNullify"])
			result = CPDRelationshipDeleteRuleNullify;
		else if([aDescription isEqualToString:@"EODeleteRuleNoAction"])
			result = CPDRelationshipDeleteRuleNoAction;
	}

	return result;
}

- (CPString) attibuteTypeForWOPrototype:(CPString) aPrototype
{
	var result = "CPString";
	
	var i = 0;
	while(i < woprototypes.length)
	{
		if([aPrototype isEqualToString:[woprototypes[i]]])
		{
			result = woprototypes_cp[i];
			break;
		}
		i++;
	}
	
	return result;
}
- (CPDictionary) dictionaryForPropertyListFile:(CPString) aFile
{
	var data = [CPURLConnection sendSynchronousRequest:[CPURLRequest requestWithURL:aFile] returningResponse:nil error:nil];
	var dict = [CPPropertyListReader_Vintage dictionaryForString:[data string]];
//	var dict = [CPPropertyListReader_Binary propertyListFromData:data];
	
	return dict;
}
@end