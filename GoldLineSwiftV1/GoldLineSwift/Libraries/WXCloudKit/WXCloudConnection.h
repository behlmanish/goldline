//
//  WXCloudConnection.h
//  
//	A cloud connection is a simplified URL grabber that will download and return
//	data in an NSData block or to a file.  It runs in asynchronously and calls the 
//	app when the fetch is complete.
//
//	A WXCloudConnection instance should be used for a single connection only.
//
//  Created by Greg Pasquariello on 8/28/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXCloudConnection : NSObject {
	id				target;
	id				userData;
	SEL				selector;	
	BOOL			saveToFile;
	NSURL			*url;
	NSURLConnection	*connection;
	NSMutableData	*data;
	NSError			*error;
	NSString		*downloadFolder;
	NSString		*downloadFilename;
	NSUInteger		statusCode;
}

@property (nonatomic, retain)	id				target;
@property (nonatomic, retain)	id				userData;
@property (nonatomic, assign)	SEL				selector;
@property (nonatomic, assign)	BOOL			saveToFile;
@property (nonatomic, retain)	NSURL			*url;
@property (nonatomic, readonly) NSURLConnection	*connection;
@property (nonatomic, retain)	NSMutableData	*data;
@property (nonatomic, readonly) NSError			*error;
@property (nonatomic, retain)	NSString		*downloadFolder;
@property (nonatomic, retain)	NSString		*downloadFilename;
@property (nonatomic, readonly)	NSString		*downloadPath;
@property (nonatomic, assign)	NSUInteger		statusCode;

/**
 Returns the number of currently active connections
 **/
+ (NSUInteger) activeConnections;

/**
 Grab the data at the url and hand it to target:selector in the NSData block.  
 The selector is a method that takes one parameter (WXCloudConnection *) like:

	- (void) dataComplete:(WXCloudConnection *)c
 
 The data block is stored in the "data" member of the object.
 **/
+ (WXCloudConnection *) getURL:(NSURL *) url target:(id) target selector:(SEL) selector userData:(id) userData;
+ (WXCloudConnection *) getLink:(NSString *) link target:(id) target selector:(SEL) selector userData:(id) userData;

/**
 Grab the data at the url and save it to a file.  The selector is a method
 that takes one parameter (WXCloudConnection *) like:

	- (void) dataComplete:(WXCloudConnection *)c
 
 The datafile that was used to save the file can be located using the
 downloadPath property.
 
 **/
+ (WXCloudConnection *) downloadURL:(NSURL *) url target:(id) target selector:(SEL) selector userData:(id) userData;
+ (WXCloudConnection *) downloadLink:(NSString *) link target:(id) target selector:(SEL) selector userData:(id) userData;

/**
 Send data up.  If you'd like to send the data in the URL, just add the parameters to the url and pass nil as the 
 data value.
 **/
+ (WXCloudConnection *) postData:(NSData *) data toURL:(NSURL *) url target:(id) target selector:(SEL) selector userData:(id) userData;

- (void) get;
- (void) post;
- (NSString *) dataAsUTF8String;




@end
