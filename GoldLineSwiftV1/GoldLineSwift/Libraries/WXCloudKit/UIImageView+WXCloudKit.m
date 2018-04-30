//
//  UIImageView+WXCloudKit.m
//  WXCloudKit
//
//  Created by Greg Pasquariello on 9/20/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//

#import "WXCloudKit.h"

@implementation UIImageView (WXCloudKit)

/**
 Get an image from the cloud and update the view.
 **/
-(void)imageFromCloudURL:(NSURL *) url {
	return [self imageFromCloudURL: url cacheToDataSet: nil];
}

/**
 Get an image from the cloud and save it to the URL key in the specified domain.  If no
 domain is specified, no caching will occur.
**/
 
-(void)imageFromCloudURL:(NSURL *) url cacheToDataSet:(WXDataSet *) dataSet {
	NSDictionary *userData = nil;
	
	if (dataSet) {
		userData = [NSDictionary dictionaryWithObjectsAndKeys: url, @"URL", dataSet, @"dataSet", nil];
	}
	
	[WXCloudConnection getURL: url target: self selector:@selector(imageComplete:) userData: userData];
}

-(void)imageComplete:(WXCloudConnection *) c {
	self.image = [UIImage imageWithData: c.data];
	
	if (self.image == nil) {
		NSLog(@"Image load failed: %@ %@", c.url, [c dataAsUTF8String]);
	}
	else {
		NSLog(@"Image loaded from: %@", c.url);
	}

	WXDataSet *dataSet = [c.userData objectForKey: @"dataSet"];
	if (dataSet) {
		NSURL *url = [c.userData objectForKey: @"URL"];
		[dataSet setImage: self.image forKey: [url dataSetKey]];
		
		//
		// Not clear whether resizing should be automatic or not.  For now, not.
		//
		//self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.image.size.width, self.image.size.height);
	}
}

@end
