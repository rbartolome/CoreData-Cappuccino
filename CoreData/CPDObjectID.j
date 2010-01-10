//
//  CPDObjectID.j
//
//  Created by Raphael Bartolome on 07.10.09.
//

@import <Foundation/Foundation.j>


@implementation CPDObjectID : CPObject
{
	CPDEntity _entity @accessors(property=entity);
	CPDStore _store @accessors(property=store);
	id _globalID @accessors(property=globalID);
	id _localID @accessors(setter=setLocalID:);
	
	BOOL _isTemporary @accessors(property=isTemporary);
}

+ (id)createLocalID
{
	return [CPString UUID]
}

- (id)initWithEntity:(CPDEntity) entity globalID:(id)globalID isTemporary:(BOOL)isTemporary
{
	if(self = [super init])
	{
		_entity = entity;
		if(isTemporary == YES && globalID == nil)
		{
			_isTemporary = isTemporary;
			_globalID = globalID;
			_localID = [CPDObjectID createLocalID];
		}
		else
		{
			_globalID = globalID;
			_localID = [CPDObjectID createLocalID];
			_isTemporary = isTemporary;
		}
	}
	
	return self;
}


- (CPDStore) store
{
	return _store;
}

- (CPDEntity) entity
{
	return _entity;
}

- (id)localID
{
	if(_localID == nil)
		_localID = [CPDObjectID createLocalID];
		
	return _localID;
}

- (BOOL)validatedLocalID
{
	if(_localID != nil && [_localID length] > 0)
		return YES;
		
	return NO;
}

- (BOOL)validatedGlobalID
{
	if(_globalID != nil && [_globalID length] > 0)
		return YES;
		
	return NO;
}

- (BOOL) isEqualToLocalID: (CPDObjectID) otherID
{
	if(otherID == nil || [otherID localID] == nil || ![[self localID] isEqual:[otherID localID]])
	{
      return NO;
    }
	
	return YES;
}

- (BOOL) isEqualToGlobalID: (CPDObjectID) otherID
{
	if(otherID == nil || [otherID globalID] == nil || ![[self globalID] isEqual:[otherID globalID]])
	{
      return NO;
    }
	
	return YES;
}

//TODO check if this method is necessary
- (BOOL) isEqualTo: (CPDObjectID) otherID
{
	if(![[self globalID] isEqual:[otherID globalID]] &&
		[self isEqualToLocalID: otherID])
	{
      return NO;
    }
	
	return YES;
}

- (void)updateWithObjectID:(CPDObjectID)newObjectID
{
	_globalID = [newObjectID globalID];
	_isTemporary = [newObjectID isTemporary];
	
	if([self localID] == nil || [[self localID] length] <= 0)
	{
		[self setLocalID: [self createLocalID]];
	}
}

- (CPString)entityName
{
	return [_entity name];
}


- (CPNumber)_isTemporaryNumber
{
	return [CPNumber numberWithBool:_isTemporary];
}


- (CPString)stringRepresentation
{
	var result = "\n";
	result = result + "\n";
	result = result + "-CPDObjectID-";
	result = result + "\n***********";
	result = result + "\n";
	result = result + "localID:" + [self localID] + ";";
	result = result + "\n";
	result = result + "globalID:" + [self globalID] + ";";

	return result;
}

@end