//
//  NSData+Utilities.m
//  WXAppKit
//
//  Created by Greg Pasquariello on 1/30/10.
//  Copyright 2010 WanderWorx, LLC. All rights reserved.
//

#import "NSData+WXUtilities.h"


@implementation NSData (WXUtilities) 

- (NSString *) UTF8String {
    return [[NSString alloc] initWithBytes: self.bytes length: self.length encoding: NSUTF8StringEncoding];
}

@end
