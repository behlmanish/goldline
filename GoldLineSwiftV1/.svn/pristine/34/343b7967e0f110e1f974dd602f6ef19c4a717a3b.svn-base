//
//  WXDataSet.m
//  Test
//
//  Created by Greg Pasquariello on 8/28/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//

#import "WXDataSet.h"

static WXDataSet *_defaultDataSet;

@implementation WXDataSet

@synthesize domain;
@synthesize isResourceDataSet;

/**
 Returns a WXDataSet initialized to use resources in the root resources folder.
 **/
-(id) init {
	if ((self = [super init]) != nil) {
		self.domain = nil;
		
		NSString *cacheFolder	= [self root];
		NSString *path			= [NSString pathWithComponents: [NSArray arrayWithObjects: cacheFolder, nil]];
		
		NSLog(@"WXDataSet folder is %@", path);
		
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	return self;
}

/**
 Returns a WXDataSet initialize to use resources in the named subfolder of the resources folder.
 **/
-(id) initWithDomain:(NSString *) d {
	if ((self = [super init]) != nil) {
		self.domain = d;
		
		NSString *cacheFolder	= [self root];
		NSString *path			= [NSString pathWithComponents: [NSArray arrayWithObjects: cacheFolder, self.domain, nil]];
		
		NSLog(@"WXDataSet folder is %@", path);
		
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	return self;
}

/**
 This creates and returns a WXDataSet in the "DataSetDomain" domain.  In other words, it stores
 it's resources in the "DataSetDomain" subfolder of the resources folder.
 **/
+ (WXDataSet *) defaultDataSet {
	if (_defaultDataSet == nil) {
		_defaultDataSet = [[WXDataSet alloc] initWithDomain: @""];
	}
	return _defaultDataSet;
}

+ (WXDataSet *) resourceDataSet {
	WXDataSet *dataSet = [[WXDataSet alloc] init];
	dataSet.isResourceDataSet = YES;
	return dataSet;
}

+ (WXDataSet *) resourceDataSetWithDomain:(NSString *) d {
	WXDataSet *dataSet = [[WXDataSet alloc] initWithDomain: d];
	dataSet.isResourceDataSet = YES;
	return dataSet;
}


/**
 Returns the dataSet's folder path. 
 **/
- (NSString *) root {
	NSString *path;
	
	if (isResourceDataSet == YES) {
		path = [[NSBundle mainBundle] resourcePath];
	}
	else {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		path = [paths objectAtIndex:0];
	
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	return path;	
}

- (NSString *)pathForDomain {
	NSString *dataSetFolder	= [self root];
	
	NSString *path;
	
	if (domain == nil) {
		path = [NSString pathWithComponents: [NSArray arrayWithObjects: dataSetFolder, nil]];
	}
	else {
		path = [NSString pathWithComponents: [NSArray arrayWithObjects: dataSetFolder, self.domain, nil]];
	}
	
	return path;
}

- (NSString *)pathForKey:(NSString *) key {
	NSString *basePath	= [self pathForDomain];
	NSString *fileName	= [NSString stringWithFormat: @"%@", key];
	NSString *path		= [NSString pathWithComponents: [NSArray arrayWithObjects: basePath, fileName, nil]];
	
	return path;
}

- (NSURL *) fileURLForKey:(NSString *) key {
	NSURL *url = [NSURL fileURLWithPath: [self pathForKey: key]];
	return url;
}

- (void) removeKey:(NSString *) key {
	NSString *path = [self pathForKey: key];
	[[NSFileManager defaultManager] removeItemAtPath: path error: nil];
}

- (BOOL) doesKeyExist:(NSString *) key {
	NSString *path = [self pathForKey: key];
	return [[NSFileManager defaultManager] fileExistsAtPath: path];
}

- (NSDate *) modificationDateForKey:(NSString *)key {
	NSDate *date	= nil;
	NSString *path	= [self pathForKey: key];
	
	NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath: path error: nil];
	if (attrs) {
		date = [attrs objectForKey: NSFileModificationDate];
	}
	
	return date;
}

- (NSTimeInterval) ageForKey:(NSString *)key {
	NSTimeInterval age = 0.0;
	
	NSDate *currentDate = [NSDate date];
	NSDate *modificationDate = [self modificationDateForKey: key];
	
	if (modificationDate != nil) {
		age = [currentDate timeIntervalSinceDate: modificationDate];
	}
	
	return age;
}


- (NSMutableArray *) arrayForKey:(NSString *)key {
	NSString *path = [self pathForKey: key];	
	return [NSMutableArray arrayWithContentsOfFile: path];
}

- (void) setArray: (NSArray *) array forKey:(NSString *)key {
	NSString *path = [self pathForKey: key];
	
	BOOL result = [array writeToFile: path atomically: YES];
	if (result == NO) {
		NSLog(@"WXDataSet setArray:  write failed");
	}
}



- (NSMutableDictionary *) dictionaryForKey:(NSString *)key {
	NSString *path = [self pathForKey: key];	
	return [NSMutableDictionary dictionaryWithContentsOfFile: path];
}

- (void) setDictionary: (NSDictionary *) dict forKey:(NSString *)key {
	NSString *path = [self pathForKey: key];
	[dict writeToFile: path atomically: YES];
}


- (void) setImage:(UIImage *)image forKey:(NSString *)key {
	NSString *path = [self pathForKey: key];
	NSData *data = UIImagePNGRepresentation(image);
	[data writeToFile: path atomically: YES];
}

- (void) setData:(NSData *) data forKey:(NSString *)key {
	NSString *path = [self pathForKey: key];
	[data writeToFile: path atomically: YES];
}


- (NSArray *)allKeys {
	return [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [self pathForDomain] error: nil];
}

- (void) clearDataSet {
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: [self pathForDomain] error: nil];
	
	for (int i=0; i < [files count]; i++) {
		NSString *name = [files objectAtIndex: i];
		NSString *path = [self pathForKey: name];
		
		NSError *error = nil;
		[[NSFileManager defaultManager] removeItemAtPath: path error: &error];
		
		if (error) {
			NSLog(@"%@", error);
		}
	}
}

- (UIImage *) imageForKey:(NSString *)key {	
	NSData *imageData = [self dataForKey: key];
	return [UIImage imageWithData: imageData];
}

- (NSMutableData *) dataForKey:(NSString *)key {
	NSString *path = [self pathForKey: key];	
	return [NSMutableData dataWithContentsOfFile: path];
}


- (NSString *) stringForKey:(NSString *)key {
	NSString *path = [self pathForKey: key];	
	return [NSString stringWithContentsOfFile: path encoding: NSASCIIStringEncoding error: nil];
}

- (void) setString: (NSString *) string forKey:(NSString *)key {
	NSString *path = [self pathForKey: key];
	[string writeToFile: path atomically: YES encoding: NSASCIIStringEncoding error: nil];
}


- (NSError *) copyFileAtPath:(NSString *)sourcePath toKey:(NSString *) key {
	NSError *error = nil;
	
	NSString *targetPath = [NSString pathWithComponents: [NSArray arrayWithObjects: [self pathForDomain], key, nil]];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath: targetPath] == YES) {
		error = nil;
		[[NSFileManager defaultManager] removeItemAtPath: targetPath error:&error];
		if (error != nil) {
			NSLog(@"WXDataSet Error preparing to copy downloaded file: %@", [error localizedDescription]);
		}
	}
	
	error = nil;
	[[NSFileManager defaultManager] copyItemAtPath: sourcePath toPath: targetPath error: &error];
	if (error != nil) {
		NSLog(@"WXDataSet Error copying downloaded file: %@", [error localizedDescription]);
	}
	else {
		NSLog(@"WXDataSet copied %@ to %@", sourcePath, targetPath);
	}
	
	return error;
}

@end
