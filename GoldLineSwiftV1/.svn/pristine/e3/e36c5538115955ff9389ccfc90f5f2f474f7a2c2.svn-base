//
//  WXSimpleCloudService.h
//  kababble
//
//  Created by Greg Pasquariello on 4/2/11.
//  Copyright 2011 WanderWorx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXSimpleCloudService : NSObject
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, readonly) NSMutableData *data;
@property (nonatomic, readonly) NSURLConnection *connection;
@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSString *user;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSError *error;

-(void) start;
-(void) cancel;

-(WXSimpleCloudService *) initWithRequest:(NSURLRequest *) r target:(id)t selector:(SEL) s;
+(WXSimpleCloudService *) serviceWithRequest:(NSURLRequest *) req target:(id)t selector:(SEL) s;

@end
