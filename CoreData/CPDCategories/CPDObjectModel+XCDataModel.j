//
//  CPDObjectModel+XCDataModel.j
//
//  Created by Raphael Bartolome on 23.11.09.
//

@import <Foundation/Foundation.j>


@implementation CPDObjectModel (XCDataModel)

+ (void) parseCoreDataModel:(CPString) aModelName
{
	if(![aModelName hasPrefix:@"cxcdatamodel"])
	{
		var modelNameComponents = [aModelName componentsSeparatedByString:@"."];
		aModelName = [modelNameComponents objectAtIndex:0] + ".cxcdatamodel";	
	}
	
	var data = [CPURLConnection sendSynchronousRequest:
						[CPURLRequest requestWithURL:aModelName] returningResponse:nil error:nil];
	var plistContents = [data string].replace(/\<key\>\s*CF\$UID\s*\<\/key\>/g, "<key>CP$UID</key>");
	var unarchiver = [[CPKeyedUnarchiver alloc] initForReadingWithData:[CPData dataWithString:plistContents]]; 
	
	var managedObjectModel = [unarchiver decodeObjectForKey: @"root"];
	[managedObjectModel setNameFromFilePath: aModelName];	

	return managedObjectModel;
}

@end