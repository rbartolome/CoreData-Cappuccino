//
//  CPFetchRequest.j
//
//  Created by Raphael Bartolome on 11.11.09.
//

@import <Foundation/CPObject.j>

//TODO implement
@implementation CPFetchRequest : CPObject
{
 	CPEntityDescription _entity @accessors(property=entity);
	int _fetchLimit @accessors(property=fetchLimit);
  	CPPredicate _predicate @accessors(property=predicate);
	CPArray _sortDescriptors @accessors(property=sortDescriptors);
}

- (id)initWithEntity:(CPEntityDescription)aEntity 
		   predicate:(CPPredicate)aPredicate 
	 sortDescriptors:(CPArray)sortDescriptors  
		  fetchLimit:(int) aFetchLimit
{
	if(self = [super init])
	{
		_entity = aEntity;
		_predicate = aPredicate;
		sortDescriptors = sortDescriptors;
		fetchLimit = aFetchLimit;
	}
	
	return self;
}

- (id)initWithEntity:(CPEntityDescription)aEntity 
		   predicate:(CPPredicate)aPredicate 
{
	if(self = [super init])
	{
		_entity = aEntity;
		_predicate = aPredicate;
		sortDescriptors = nil;
		fetchLimit = 0;
	}
	
	return self;
}
@end