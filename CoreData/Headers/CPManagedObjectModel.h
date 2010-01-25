//
//  CPManagedObjectModel.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPManagedObjectModel : CPObject
{
	CPMutableSet _entities @accessors(property=entities);
}

+ (id)objectModelWithModelNamed:(CPString) aModelName bundle:(CPBundle)aBundle;
- (void)addEntity:(CPEntityDescription) entity;
- (CPEntityDescription)entityWithName:(CPString)name;
- (CPString)stringRepresentation;

@end