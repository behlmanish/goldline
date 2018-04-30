//
//  WXCloudFile.m
//  WXCloudKit
//
//  Created by Greg Pasquariello on 12/1/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//

#import "WXCloudFile.h"


@implementation WXCloudFile

@synthesize delegate;
@synthesize url;
@synthesize path;
@synthesize cnx;

+(WXCloudFile *) getURL:(NSURL *)url path:(NSString *)path delegate:(id) delegate {
	WXCloudFile *f = [[WXCloudFile alloc] initWithURL:url path:path delegate:delegate];
	[f refresh];
	return f;
}

+(WXCloudFile *) getLink:(NSString *)link path:(NSString *)path delegate:(id) delegate {
	WXCloudFile *f = [[WXCloudFile alloc] initWithLink:link path:path delegate:delegate];
	[f refresh];
	return f;
}


-(id) initWithURL:(NSURL *)u path:(NSString *)p delegate:(id) d {
	if ((self = [super init]) != nil) {
		self.url		= u;
		self.path		= p;
		self.delegate	= d;
		self.cnx		= nil;
	}
	return self;
}

-(id) initWithLink:(NSString *)link path:(NSString *)p delegate:(id) d {	
	if ((self = [super init]) != nil) {
		NSURL *u = [NSURL URLWithString: link];

		self.url		= u;
		self.path		= p;
		self.delegate	= d;
		self.cnx		= nil;
	}
	return self;
}

-(void) refresh {
	self.cnx = [WXCloudConnection downloadURL: self.url target: self selector: @selector(getComplete:) userData: nil];
}

-(void) remove {
	if (self.path) {
		[[NSFileManager defaultManager] removeItemAtPath: path error: nil];
	}
}

-(void) getComplete:(WXCloudConnection *) c {
	if (c.statusCode == 200) {
		NSString *src = [c downloadPath];
		NSString *target = self.path;
	
		[[NSFileManager defaultManager] removeItemAtPath: target error: nil];
	
		NSError *error = nil;
		[[NSFileManager defaultManager] moveItemAtPath: src toPath: target error: &error];
		
		[self.delegate cloudFileComplete: self error: error];
	}
	else {
		NSError *error = [[NSError alloc] initWithDomain: @"An HTTP error occurred." code: c.statusCode userInfo: nil];
		[self.delegate cloudFileComplete: self error: error];
	}
	
	self.cnx = nil;
}

@end
