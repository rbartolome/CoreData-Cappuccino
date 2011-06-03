//
//  CPManagedObjectID.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPManagedObjectID : CPObject
{
	CPEntityDescription _entity @accessors(property=entity);
	CPManagedObjectContext _context @accessors(property=context);
	id _globalID @accessors(property=globalID);
	id _localID @accessors(setter=setLocalID:);
	BOOL _isTemporary @accessors(property=isTemporary);
}

- (id)initWithEntity:(CPEntityDescription) entity globalID:(id)globalID isTemporary:(BOOL)isTemporary;
- (CPEntityDescription) entity;
- (CPString)entityName;
- (id)localID;
- (BOOL)validatedLocalID;
- (BOOL)validatedGlobalID;
- (BOOL) isEqualToLocalID: (CPManagedObjectID) otherID;
- (BOOL) isEqualToGlobalID: (CPManagedObjectID) otherID;
- (void)updateWithObjectID:(CPManagedObjectID)newObjectID;

@end