//
//  NSFetchedPropertyDescription.j
//
//  Created by Raphael Bartolome on 06.01.10.
//


@implementation NSFetchedPropertyDescription : CPFetchedPropertyDescription
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		CPLog.info("NSFetchedPropertyDescription: " + [aCoder._plistObject allKeys]);		
	}
	
	return self;
}


- (Class)classForKeyedArchiver
{
    return [NSFetchedPropertyDescription class];
}

@end