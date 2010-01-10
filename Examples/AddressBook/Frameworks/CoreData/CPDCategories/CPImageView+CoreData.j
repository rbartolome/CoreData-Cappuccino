//
//  CPImageView+CoreData.j
//
//  Created by Raphael Bartolome on 02.12.09.
//

@import <Foundation/Foundation.j>

@implementation CPImageView (CoreData)

- (void)setBase64Image:(CPImage) aImage
{
	[self setImage:aImage];
	_DOMImageElement.src = aImage._image.src;
}

@end