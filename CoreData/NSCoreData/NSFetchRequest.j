//
//  NSFetchRequest.j
//
//  Created by Raphael Bartolome on 06.01.10.
//


@implementation NSFetchRequest : CPFetchRequest
{
}

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		CPLog.info("NSFetchRequest" + [aCoder._plistObject allKeys]);		
	}
	
	return self;
}


- (Class)classForKeyedArchiver
{
    return [NSFetchRequest class];
}

@end