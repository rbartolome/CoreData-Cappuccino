//
//  CPManagedObjectModel.h
//
//  Created by Raphael Bartolome on 25.11.09.
//

@interface CPManagedObjectModel : CPObject
{
	CPMutableSet _entities @accessors(property=entities);
}

+ (id)modelWithModelNamed:(CPString) aModelName bundle:(CPBundle)aBundle;
+ (id) mergedModelFromBundles: (CPArray) bundles; //Unimplemented 
+ (id) modelByMergingModels: (CPArray) models; //Unimplemented
- (void)addEntity:(CPEntityDescription) entity;
- (CPEntityDescription)entityWithName:(CPString)name;
- (CPString)stringRepresentation;

@end