//
//  NSURL+WXCloudKit.m
//  WXCloudKit
//
//  Created by Greg Pasquariello on 9/11/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//

#import "NSURL+WXCloudKit.h"


@implementation NSURL (WXCloudKit)

- (NSString *) dataSetKey {
	NSString *link = [self absoluteString];
	
	link = [link stringByReplacingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
	link = [link stringByReplacingOccurrencesOfString: @" " withString: @"_"];
	link = [link stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
	link = [link stringByReplacingOccurrencesOfString: @":" withString: @"_"];

	return link;
}

+ (NSString *) dataSetKeyFromLink:(NSString *) s {
	NSURL *url = [NSURL URLWithString: s];
	return [url dataSetKey];
}

@end
