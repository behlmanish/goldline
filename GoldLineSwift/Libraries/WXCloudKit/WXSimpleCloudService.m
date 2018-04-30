//
//  WXSimpleCloudService.m
//  kababble
//
//  Created by Greg Pasquariello on 4/2/11.
//  Copyright 2011 WanderWorx. All rights reserved.
//

#import "WXSimpleCloudService.h"
#import "Reachability.h"

@implementation WXSimpleCloudService
@synthesize request = _request;
@synthesize target = _target;
@synthesize selector = _selector;
@synthesize error = _error;
@synthesize data;
@synthesize connection;
@synthesize user;
@synthesize password;

#pragma mark - Convenience method
+ (WXSimpleCloudService *)serviceWithRequest:(NSURLRequest *)request target:(id)target selector:(SEL)selector {
	WXSimpleCloudService *cloudService = [[WXSimpleCloudService alloc] initWithRequest:request target:target selector:selector];
    [cloudService start];
    return cloudService;
}


#pragma mark - Object lifecycle
- (WXSimpleCloudService *)initWithRequest:(NSURLRequest *)request target:(id)target selector:(SEL)selector {
	if (self = [super init]) {
		self.request = request;
		self.target = target;
		self.selector = selector;
    }
	return self;
}


- (void) dealloc {
	self.request = nil;
	self.target = nil;
	self.selector = nil;
	self.error = nil;

//	[data release];
//	[connection release];
//	[user release];
//	[password release];
//
//	[super dealloc];
}


#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)incomingData {
    [self.data appendData:incomingData];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	self.error = nil;

	if (self.target && [self.target respondsToSelector:self.selector]) {
		[self.target performSelector:self.selector withObject:self];
	}
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)newError {
    self.error = newError;
    if (self.target && [self.target respondsToSelector: self.selector]) {
        [self.target performSelector:self.selector withObject:self];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.user password:self.password persistence:NSURLCredentialPersistenceNone];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }
    else {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
}


#pragma mark - Cloud Service logic
- (void)start {
    //
    // If it's not reachable, call back to the delegate without even trying.
    //
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject: @"Internet is unavailable" forKey: NSLocalizedDescriptionKey];
        self.error = [[NSError alloc] initWithDomain:@"Reachability" code:-1 userInfo:userInfo];
        
        if (self.target && [self.target respondsToSelector: self.selector]) {
            [self.target performSelector: self.selector withObject: self];
        }
    }
    else {
        data = [NSMutableData dataWithCapacity: 1024];
        connection = [NSURLConnection connectionWithRequest: self.request delegate: self];
        [connection start];
    }
}

- (void)cancel {
    [connection cancel];
}

@end
