//
//  NSEntityDescription.j
//
//  Created by Raphael Bartolome on 06.01.10.
//

@implementation NSEntityDescription : CPEntityDescription
{
    NSManagedObjectModel ns_model;
    CPDictionary ns_properties;
    CPDictionary ns_subentities;
    NSEntityDescription ns_superentity;
    CPDictionary ns_userInfo;
    id ns_versionHashModifier;
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{		
		[self setName:[aCoder decodeObjectForKey: @"NSEntityName"]];
		[self setExternalName:[aCoder decodeObjectForKey: @"NSClassNameForEntity"]];
		ns_model = [aCoder decodeObjectForKey: @"NSManagedObjectModel"];	//will set on addEntity in CPManagedObjectModel
		ns_properties = [aCoder decodeObjectForKey: @"NSProperties"];
		ns_subentities = [aCoder decodeObjectForKey: @"NSSubentities"];
		ns_superentity = [aCoder decodeObjectForKey: @"NSSuperentity"];
		ns_userInfo = [aCoder decodeObjectForKey: @"NSUserInfo"];
		ns_versionHashModifier = [aCoder decodeObjectForKey: @"NSVersionHashModifier"];	
	}
	
	return self;
}

- (void)NS_loadEntityDescription
{
	var keyEnumerator = [ns_properties keyEnumerator];
	var aPropertyName;
	while(aPropertyName = [keyEnumerator nextObject])
	{
		var aProperty = [ns_properties objectForKey:aPropertyName];
		[aProperty setEntity:self];
		[self addProperty:aProperty];
	}
}

- (Class)classForKeyedArchiver
{
    return [NSEntityDescription class];
}

@end