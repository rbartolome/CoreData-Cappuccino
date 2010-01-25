//
//  NSManagedObjectModel.j
//
//  Created by Raphael Bartolome on 06.01.10.
//


@implementation NSManagedObjectModel : CPManagedObjectModel
{
	CPMutableDictionary ns_entities;
	CPSet ns_versionIdentifier;
	id ns_fetchRequestTemplates;
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		ns_entities = [aCoder decodeObjectForKey:@"NSEntities"];
		ns_versionIdentifier = [aCoder decodeObjectForKey:@"NSVersionIdentifiers"];	
		ns_fetchRequestTemplates = [aCoder decodeObjectForKey:@"NSFetchRequestTemplate"];

		[self NS_transformEntities];
	}
	
	return self;
}

- (void)NS_transformEntities
{	
	var keyEnumerator = [ns_entities keyEnumerator];
	var aName;
	while(aName = [keyEnumerator nextObject])
	{
		var aNSEntity = [ns_entities objectForKey:aName];	
		[self addEntity:aNSEntity];
	}
	
	[[self entities] makeObjectsPerformSelector:@selector(NS_loadEntityDescription)];	
}


- (Class)classForKeyedArchiver
{
    return [NSManagedObjectModel class];
}

@end