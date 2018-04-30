//
//  NSURL+Utilities.h
//  WXCloudKit
//
//  Created by Greg Pasquariello on 9/11/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURL (WXCloudKit)

-(NSString *) dataSetKey;
+(NSString *) dataSetKeyFromLink:(NSString *) string;

@end
