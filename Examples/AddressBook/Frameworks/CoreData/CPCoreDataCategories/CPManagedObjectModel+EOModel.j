//
//  CPManagedObjectModel+EOModel.j
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

@implementation CPManagedObjectModel (EOModel)

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
	
	[self setNameFromFilePath: aModelName];
}

- (BOOL) createPrototypesForEntitiesFromEOModel:(CPArray) entitiesFromModel
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
				var aEntity = [[CPEntityDescription alloc] init];
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
				var attributeClassValue;
				var valueType = [attribute objectForKey:@"valueType"];
				var isOptional = [attribute objectForKey:@"allowsNull"];
				var prototypeName = [attribute objectForKey:@"prototypeName"];
				var valueClassName = [attribute objectForKey:@"valueClassName"];
				var className = [attribute objectForKey:@"className"];
				
				if(prototypeName == null)
				{
					if(className != null)
					{
						attributeClassValue = [className stringByReplacingOccurrencesOfString:@"NS" withString:@"CP"];	
					}
					else if(valueClassName != null)
					{
						//@TASK we need to modify this because this could be a problem for NSDate because NSCalendarDate
						//isn't a supported class by capp currently
						attributeClassValue = [valueClassName stringByReplacingOccurrencesOfString:@"NS" withString:@"CP"];
						
						if([attributeClassValue isEqualToString:@"CPCalendarDate"])
							attributeClassValue = @"CPDate";
					}
				}
				else
				{
					attributeClassValue = [self attibuteTypeForWOPrototype:prototypeName];
				}
					
				[entity addAttributeWithName:attributeName classValue:attributeClassValue typeValue:[self valueTypeForEOValue:valueType] optional:isOptional];
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
				var isOptional = ![relationship objectForKey:@"isMandatory"];
				var deleteRuleWO = [relationship objectForKey:@"deleteRule"];
				var deleteRule = [self deleteRuleForWODescription:deleteRuleWO];
				
				[entity addRelationshipWithName:relationshipName 
										toMany:isToMany 
										optional:isOptional 
										deleteRule:deleteRule 
										destination:destination];				
			}
		}
	}
	
}

- (int) valueTypeForEOValue:(CPString) aEOValueType
{
	var result = CPDUndefinedAttributeType;
	if(aEOValueType != null)
	{	
		if([aEOValueType isEqualToString:@"b"])
			result = CPDBinaryDataAttributeType;
		else if([aEOValueType isEqualToString:@"s"])
			result = CPDIntegerAttributeType;
		else if([aEOValueType isEqualToString:@"i"])
			result = CPDIntegerAttributeType;
		else if([aEOValueType isEqualToString:@"l"])
			result = CPDIntegerAttributeType;
		else if([aEOValueType isEqualToString:@"f"])
			result = CPDFloatAttributeType;
		else if([aEOValueType isEqualToString:@"d"])
			result = CPDDoubleAttributeType;
		else if([aEOValueType isEqualToString:@"B"])
			result = CPDDecimalAttributeType;
		else if([aEOValueType isEqualToString:@"c"])
			result = CPDBooleanAttributeType;
	}
	
	return result;
}

- (int) deleteRuleForWODescription:(CPString) aDescription
{
	var result = CPRelationshipDescriptionDeleteRuleNullify;
	if(aDescription != nil)
	{
		if([aDescription isEqualToString:@"EODeleteRuleCascade"])
			result = CPRelationshipDescriptionDeleteRuleCascade;
		else if([aDescription isEqualToString:@"EODeleteRuleDeny"])
			result = CPRelationshipDescriptionDeleteRuleDeny;
		else if([aDescription isEqualToString:@"EODeleteRuleNullify"])
			result = CPRelationshipDescriptionDeleteRuleNullify;
		else if([aDescription isEqualToString:@"EODeleteRuleNoAction"])
			result = CPRelationshipDescriptionDeleteRuleNoAction;
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
	var data = [CPURLConnection sendSynchronousRequest:[CPURLRequest requestWithURL:aFile] returningResponse:nil];
	var dict = [CPPropertyListReader_Vintage dictionaryForString:[data rawString]];
//	var dict = [CPPropertyListReader_Binary propertyListFromData:data];
	
	return dict;
}
@end