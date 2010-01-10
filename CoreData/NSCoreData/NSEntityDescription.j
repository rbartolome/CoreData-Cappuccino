//
//  NSEntityDescription.j
//
//  Created by Raphael Bartolome on 06.01.10.
//


@implementation NSEntityDescription : CPObject
{
    CPString _className @accessors(property=className);
    CPString _name @accessors(property=name);
    NSManagedObjectModel _model @accessors(property=model);
    CPDictionary _properties @accessors(property=properties);
    CPDictionary _subentities @accessors(property=subentities);
    NSEntityDescription _superentity @accessors(property=superentity);
    CPDictionary _userInfo @accessors(property=userInfo);
    id _versionHashModifier;
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{		
		_className = [aCoder decodeObjectForKey: @"NSClassNameForEntity"];
		_name = [aCoder decodeObjectForKey: @"NSEntityName"];
		_model = [aCoder decodeObjectForKey: @"NSManagedObjectModel"];
		_properties = [aCoder decodeObjectForKey: @"NSProperties"];
		_subentities = [aCoder decodeObjectForKey: @"NSSubentities"];
		_superentity = [aCoder decodeObjectForKey: @"NSSuperentity"];
		_userInfo = [aCoder decodeObjectForKey: @"NSUserInfo"];
		_versionHashModifier = [aCoder decodeObjectForKey: @"NSVersionHashModifier"];		
	}
	
	return self;
}

- (Class)classForKeyedArchiver
{
    return [NSEntityDescription class];
}

@end