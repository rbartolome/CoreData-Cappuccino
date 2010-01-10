//
//  CPDObjectID.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPDObjectID : CPObject
{
	CPDEntity _entity @accessors(property=entity);
	CPDStore _store @accessors(property=store);
	id _globalID @accessors(property=globalID);
	id _localID @accessors(setter=setLocalID:);
	BOOL _isTemporary @accessors(property=isTemporary);
}

- (id)initWithEntity:(CPDEntity) entity globalID:(id)globalID isTemporary:(BOOL)isTemporary;
- (CPDStore) store;
- (CPDEntity) entity;
- (CPString)entityName;
- (id)localID;
- (BOOL)validatedLocalID;
- (BOOL)validatedGlobalID;
- (BOOL) isEqualToLocalID: (CPDObjectID) otherID;
- (BOOL) isEqualToGlobalID: (CPDObjectID) otherID;
- (void)updateWithObjectID:(CPDObjectID)newObjectID;

@end