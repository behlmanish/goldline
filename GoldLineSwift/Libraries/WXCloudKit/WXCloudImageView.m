//
//  WXCloudImageView.m
//  WXAppKit
//
//  Created by Greg Pasquariello on 5/21/10.
//  Copyright 2010 WanderWorx, LLC. All rights reserved.
//

#import "WXCloudImageView.h"
#import "WXCloudConnection.h"
#import "WXDataSet.h"

#define CLOUD_IMAGE_DOMAIN	@"CloudImages"


@implementation WXCloudImageView

@synthesize key;
@synthesize url;
@synthesize activityIndicatorView;

- (void) imageLoadComplete:(WXCloudConnection *) c {
	[self.activityIndicatorView stopAnimating];
	
	WXDataSet *dataSet = [[WXDataSet alloc] initWithDomain: CLOUD_IMAGE_DOMAIN];
	[dataSet copyFileAtPath: c.downloadPath toKey: self.key];
	
	UIImage *image = [dataSet imageForKey: self.key];
	WXCloudImageView *imageView = (WXCloudImageView *) c.userData;
	
	imageView.image = image;

}

/**
 Set the view's image. If the image has already been downloaded, and it is newer than maxAge,
 just set the image. Otherwise, download it.
 **/
- (void) imageForKey:(NSString *) k url:(NSURL *) u maxAge:(NSTimeInterval) maxAge {
//	key = [k retain];
//	url = [u retain];
	
	[self.activityIndicatorView startAnimating];

	WXDataSet *dataSet = [[WXDataSet alloc] initWithDomain: CLOUD_IMAGE_DOMAIN];
	
	NSTimeInterval age = [dataSet ageForKey: key];

	if (age == 0 || age >= maxAge) {
		[WXCloudConnection downloadURL: self.url target: self selector: @selector(imageLoadComplete:) userData: self];
	}
	else {
		self.image = [dataSet imageForKey: self.key];
	}
}

-(void) dealloc {
//	[key release];
//	[url release];
//	[super dealloc];
}
	

@end
