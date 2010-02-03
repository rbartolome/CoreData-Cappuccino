//
//  CPHTML5Store.j
//
//  Created by Raphael Bartolome on 07.10.09.
//
// The base RLOfflineDataStore.j is written by Randy Luecke the creator of http://www.timetableapp.com/
// github : http://github.com/Me1000/RLOfflineDataStore
//

@import <Foundation/Foundation.j>

@import "RLOfflineDataStore.j"

@implementation CPHTML5Store : CPPersistantStore
{
	id dataStorage;
}


/*
 * Connection URL
 */
- (CPString)storeName
{
	if(_configuration != nil)
	{
		return [_configuration objectForKey:"CPHTML5StoreName"];
	}
	
	return nil;
}

- (id)dataStorage
{
	if(!dataStorage)
		 dataStorage = [[RLOfflineDataStore alloc] initWithName:[self storeName] delegate:self];
		
	return dataStorage;
}

/*
 *	write all objects before store will close
 */
- (void) saveAll:(CPSet) objects error:({CPError}) error
{
	CPLog.info("writedata:");
	[[self dataStorage] setValue:[[objects serializeTo280NPLIST:YES containsChangedProperties:YES] string] forKey:@"AllObjects"];
}



- (CPSet)loadAll:(CPDictionary) properties inManagedObjectContext:(CPManagedObjectContext) aContext error:({CPError}) error
{
	var resultValue = [[self dataStorage] storedValueForKey:@"AllObjects"];
	CPLog.info("RESULT:" + resultValue);
	if(resultValue == null)
		return [CPSet new];
		
	return [CPSet deserializeFrom280NPLIST:[CPData dataWithString:resultValue] withContext:aContext];
}


@end