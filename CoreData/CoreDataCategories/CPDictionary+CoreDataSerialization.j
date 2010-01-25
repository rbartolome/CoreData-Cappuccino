//
//  CPDictionary+CoreDataSerialization.j
//
//  Created by Raphael Bartolome on 14.01.10.
//

@import <Foundation/Foundation.j>


@implementation CPDictionary (CoreDataSerialization)

+(id)dictionaryWithJSObject:(id)object recursively:(BOOL)recursively
{
	var updatedObject = object;
	for(var key in object)
	{
		if(key === "_buckets")
		{
			updatedObject = object[key];
			break;
		}
	}

	var dictionary = [[self alloc] init];

	for (var key in updatedObject)
	{
		var value = updatedObject[key];

		if (recursively && value.constructor === Object)
			value = [CPDictionary dictionaryWithJSObject:value recursively:YES];
		
		if([value isKindOfClass:[CPArray class]])
		{
			for(var i = 0; i < [value count]; i++)
			{
				var arrayObject = [value objectAtIndex:i];
				if (arrayObject.constructor === Object)
					arrayObject = [CPDictionary dictionaryWithJSObject:arrayObject recursively:YES];
					
				[value replaceObjectAtIndex:i withObject:arrayObject];
			}
		}

		[dictionary setObject:value forKey:key];
	}
	
	return dictionary;
}


- (JSObject)toJSObject
{
	var result = [CPMutableDictionary new];
	
	var contentEnum = [self keyEnumerator];
	var aKey;
	
	while(aKey = [contentEnum nextObject])
	{
		var aObject = [self objectForKey:aKey];
		
		if([aObject isKindOfClass:[CPDictionary class]] 
			|| [aObject isKindOfClass:[CPArray class]] 
			|| [aObject isKindOfClass:[CPSet class]])
		{
			[result setObject:[aObject toJSObject] forKey:aKey];
		}
		else
		{
			[result setObject:aObject forKey:aKey];
		}
	}
	return result._buckets;
}

@end