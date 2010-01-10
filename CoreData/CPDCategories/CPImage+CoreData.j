//
//  CPData+CoreData.j
//
//  Created by Raphael Bartolome on 02.12.09.
//

@import <Foundation/Foundation.j>

@implementation CPImage (CoreData)

- (CPData) data 
{
	var result = [CPData dataWithContentsOfFile:_image.src];
	CPLog.debug(_image.src);
	return result;
}

+ (CPImage) imageWithBase64String:(CPString) content
{
	var aImage = [[CPImage alloc] init];
	aImage._loadStatus = CPImageLoadStatusCompleted;
	aImage._image = new Image();	
	aImage._image.src = "data:image/png;base64," + content;
		
	return aImage;
}

@end