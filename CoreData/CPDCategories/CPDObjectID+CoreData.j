//
//  CPDObjectID+CoreData.j
//
//  Created by Raphael Bartolome on 19.10.09.
//

@import <Foundation/CPObject.j>


@implementation CPDObjectID (CoreData)


- (id)initUnqualifiedWithCDJSONObject:(id)jsonObject store:(CPDStore)aStore
{
	if(self = [super init])
	{
		_localID = jsonObject.localID;
		_globalID = jsonObject.globalID;
		_isTemporary = jsonObject.temporary;
		_store = aStore;
		[self setEntity:[[aStore model] entityWithName:jsonObject.entityName]];
	}
	
	return self;
}

- (CPString)toCDJSON 
{
	var result = "{" + [@"globalID" toCDJSON] + " : " + [_globalID toCDJSON] + ",";
	result = result + [@"entityName" toCDJSON] + " : " + [[_entity name] toCDJSON] + ",";
	result = result + [@"localID" toCDJSON] + " : " + [_localID toCDJSON] + ",";
	result = result + [@"isTemporary" toCDJSON] + " : " + [[self _isTemporaryNumber] toCDJSON] + "}";
		
	return result;
}

@end