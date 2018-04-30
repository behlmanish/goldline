//
//  WXCloudImageView.h
//  WXAppKit
//
//  Created by Greg Pasquariello on 5/21/10.
//  Copyright 2010 WanderWorx, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXCloudImageView : UIImageView {
	NSURL *url;
	NSString *key;
	UIActivityIndicatorView	*activityIndicatorView;
}

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSString *key;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*activityIndicatorView;

/**
 Initialize the image with view pulled asynchronously from the cloud
 **/

- (void) imageForKey:(NSString *) key url:(NSURL *) url maxAge:(NSTimeInterval) maxAge;


@end
