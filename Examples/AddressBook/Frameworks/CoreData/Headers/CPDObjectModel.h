//
//  CPDObjectModel.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPDObjectModel : CPObject
{
	CPMutableSet _entities @accessors(property=entities);
}

+ (id)objectModelWithModelNamed:(CPString) aModelName bundle:(CPBundle)aBundle;
- (void)addEntity:(CPDEntity) entity;
- (CPDEntity)entityWithName:(CPString)name;
- (CPString)stringRepresentation;

@end