//
//  WXCloudConnection.m
//  Test
//
//  Created by Greg Pasquariello on 8/28/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//

#import "WXCloudConnection.h"

static NSUInteger _activeConnections = 0;

#define K	1024
#define M	1024 * K

@implementation WXCloudConnection

@synthesize url;
@synthesize connection;
@synthesize	saveToFile;
@synthesize data;
@synthesize target;
@synthesize selector;
@synthesize error;
@synthesize userData;
@synthesize downloadFolder;
@synthesize downloadFilename;
@synthesize statusCode;
@dynamic downloadPath;

- (id) init {
	if ((self = [super init]) != nil) {
		url					= nil;
		connection			= nil;
		saveToFile			= NO;
		data				= nil;
		target				= nil;
		selector			= nil;
		error				= nil;
		userData			= nil;
		downloadFolder		= nil;
		downloadFilename	= nil;
		statusCode			= 0;
		
		NSArray *folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		if ([folders count] < 1) {
			NSLog(@"WXCloudConnection Cannot locate a cache directory.");
		}
		
		self.downloadFolder = [folders objectAtIndex: 0];
		
		BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath: self.downloadFolder withIntermediateDirectories: YES attributes: nil error: nil];
		if (result == NO) {
			NSLog(@"WXCloudConnection Error creating download folder %@.", self.downloadFolder);
		}
		
		++_activeConnections;
	}
	
	return self;
}

- (void) get {	
	//
	// This retains the thing for the duration of the download.  The corresponding release is in 
	// didFailWithError or didFinishLoading.
	//
//	[self retain];
	
	error = nil;
	
	NSURLRequest *request = [NSURLRequest requestWithURL: self.url];

	connection = [NSURLConnection connectionWithRequest: request delegate: self];
}

- (void) post {	
	//
	// This retains the thing for the duration of the download.  The corresponding release is in 
	// didFailWithError or didFinishLoading.
	//
//	[self retain];
	
	error = nil;
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:self.url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
	//NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: self.url];

	[request setHTTPMethod: @"POST"];
   // [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody: self.data];
	connection = [NSURLConnection connectionWithRequest: request delegate: self];
}

+ (NSUInteger) activeConnections {
	return _activeConnections;
}

+ (WXCloudConnection *) getURL:(NSURL *) url target:(id) target selector:(SEL) selector userData:(id) userData {
	WXCloudConnection *cnx = [[WXCloudConnection alloc] init];
	
	cnx.url = url;
	cnx.target = target;
	cnx.selector = selector;
	cnx.userData = userData;

	[cnx get];
	
	return cnx;
}

+ (WXCloudConnection *) getLink:(NSString *) link target:(id) target selector:(SEL) selector userData:(id) userData {
	return [WXCloudConnection getURL: [NSURL URLWithString: link] target: target selector: selector userData: userData];
}
+ (WXCloudConnection *) downloadURL:(NSURL *) url target:(id) target selector:(SEL) selector userData:(id) userData {
	WXCloudConnection *cnx = [[WXCloudConnection alloc] init];
	
	cnx.url = url;
	cnx.target = target;
	cnx.selector = selector;
	cnx.userData = userData;
	cnx.saveToFile = YES;

	[cnx get];
	
	return cnx;
}

+ (WXCloudConnection *) downloadLink:(NSString *) link target:(id) target selector:(SEL) selector userData:(id) userData {
	return [WXCloudConnection downloadURL: [NSURL URLWithString: link] target: target selector: selector userData: userData];
}
			
+ (WXCloudConnection *) postData:(NSData *) data toURL:(NSURL *) url target:(id) target selector:(SEL) selector userData:(id) userData {
	WXCloudConnection *cnx = [[WXCloudConnection alloc] init];
	
	cnx.url = url;
	cnx.data = [NSMutableData dataWithData: data];
	cnx.target = target;
	cnx.selector = selector;
	cnx.userData = userData;

	[cnx post];
	
	return cnx;
}

+ (WXCloudConnection *) postData:(NSData *) data toLink:(NSString *)link target:(id) target selector:(SEL) selector userData:(id) userData {
	return [WXCloudConnection postData: data toURL: [NSURL URLWithString: link] target: target selector: selector userData: userData];
}


- (NSString *) dataAsUTF8String {
	NSString *string = nil;
	
	if (saveToFile == NO) {
		string = [[NSString alloc] initWithData: self.data encoding:NSUTF8StringEncoding];
	}
	
	return string;
}

- (NSString *) tempFileName {
	NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    NSString *name = [NSString stringWithFormat:@"temp%f", interval];

	return name;
}

- (NSString *) downloadPath {
	NSString *path = [NSString pathWithComponents: [NSArray arrayWithObjects: self.downloadFolder, self.downloadFilename, nil]];
	return path;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {	
	if ([response respondsToSelector:@selector(statusCode)]) {
		self.statusCode = [response statusCode];
	}

	if (saveToFile == NO) {
		self.data = [NSMutableData dataWithCapacity: 10 * K];
	} else {
		self.downloadFilename = [self tempFileName];
		NSString *path = [self downloadPath];

		BOOL result = [[NSFileManager defaultManager] createFileAtPath: path contents:nil attributes:nil];
		if (result == NO) {
			NSLog(@"WXCloudConnection Error creating file.");
		}

		NSLog(@"WXCloudConnection Downloading to %@", [self downloadPath]);
	}
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
	if (saveToFile == NO) {
		@synchronized(self.data) {
			[self.data appendData: d];
		}
	}
	else {
		NSString *path = [self downloadPath];
		
		NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath: path];
		if (!handle) {
			NSLog(@"WXCloudConnection no file handle allocated for %@", path);
		}
		else {
			[handle seekToEndOfFile];
			[handle writeData: d];
			[handle closeFile];
//			NSLog(@"WXCloudConnection wrote %d bytes", [d length]);

		}
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if (self.target && self.selector) {
		[self.target performSelector: self.selector withObject: self];
	}
	
//	[self release]; // see start, for matching retain.
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)e {	
	NSLog(@"WXCloudConnection Error fetching data.  %@", [e localizedDescription]);
	
	
	if (self.target && self.selector) {
		[self.target performSelector: self.selector withObject: self];
	}
	
}

@end
