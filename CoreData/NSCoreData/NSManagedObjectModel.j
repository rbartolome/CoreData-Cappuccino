//
//  NSManagedObjectModel.j
//
//  Created by Raphael Bartolome on 06.01.10.
//


@implementation NSManagedObjectModel : CPObject
{
	CPMutableDictionary _entities @accessors(property=entities);
	CPSet _versionIdentifier;
	id _fetchRequestTemplates;
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		_entities = [aCoder decodeObjectForKey:@"NSEntities"];
		_versionIdentifier = [aCoder decodeObjectForKey:@"NSVersionIdentifiers"];	
		_fetchRequestTemplates = [aCoder decodeObjectForKey:@"NSFetchRequestTemplates"];
	}
	
	return self;
}

- (Class)classForKeyedArchiver
{
    return [NSManagedObjectModel class];
}

@end