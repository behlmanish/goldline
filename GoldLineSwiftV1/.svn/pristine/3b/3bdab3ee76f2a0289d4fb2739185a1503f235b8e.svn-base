//
//  WXCloudFile.h
//  WXCloudKit
//
//  Created by Greg Pasquariello on 12/1/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//
//	This is a utility class used to fetch a file from a cloud server and 
//	dump it to a specified place.  Calls the delegate when done.
//

#import <Foundation/Foundation.h>
#import "WXCloudConnection.h"

@class WXCloudFile;

@protocol WXCloudFileDelegate
- (void) cloudFileComplete:(WXCloudFile *)cloudFile error:(NSError *)error;
@end

@interface WXCloudFile : NSObject {
	id<WXCloudFileDelegate>	delegate;
	NSURL					*url;
	NSString				*path;
	WXCloudConnection		*cnx;
}

@property (nonatomic, retain) id<WXCloudFileDelegate> delegate;
@property (nonatomic, retain) NSURL	*url;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) WXCloudConnection *cnx;

-(id) initWithURL:(NSURL *)url path:(NSString *)path delegate:(id) delegate;
-(id) initWithLink:(NSString *)link path:(NSString *)path delegate:(id) delegate;

-(void) refresh;
-(void) remove;

+(WXCloudFile *) getURL:(NSURL *)url path:(NSString *)path delegate:(id) d;
+(WXCloudFile *) getLink:(NSString *)link path:(NSString *)path delegate:(id) d;


@end
