//
//  WXDataSet.h
//  
//
//  Created by Greg Pasquariello on 8/28/10.
//  Copyright 2010 Wanderworx, LLC. All rights reserved.
//
//	DataSet implements a simple persistence model for a variety of resource types such
//	that they can be accessed by name.  A little easier-to-use and lighter weight
//	than NSUserDefaults, though there are similarities.
//

#import <UIKit/UIKit.h>
enum  {
    WXDataSetAgeNone	= 0,
    WXDataSetAgeSecond	= 1,
    WXDataSetAgeMinute	= 60,
    WXDataSetAgeHour	= 60 * 60,
    WXDataSetAgeDay		= WXDataSetAgeHour * 24,
    WXDataSetAgeWeek	= WXDataSetAgeDay * 7,
    WXDataSetAgeMonth	= WXDataSetAgeDay * 30,
    WXDataSetAgeYear	= WXDataSetAgeDay * 365
};
typedef double WXDataSetAge;

@interface WXDataSet : NSObject {
	NSString	*domain;
	BOOL		isResourceDataSet;
}

@property (nonatomic, retain) NSString *domain;
@property (nonatomic, assign) BOOL isResourceDataSet;

/**
 Returns a WXDataSet initialized to use resources in the root dataset folder.
 **/
-(id) init;

/**
 Returns a WXDataSet initialize to use resources in the named subfolder of the dataset folder.
 **/
-(id) initWithDomain:(NSString *) d;

/**
 This creates and returns a WXDataSet in the "DataSetDomain" domain.  In other words, it stores
 it's resources in the "DataSetDomain" subfolder of the resources folder.
 
 To create a DataSet that uses the base resources subfolder, create an instance using one of
 the resourceDataSet methods.
 **/
+ (WXDataSet *) defaultDataSet;
+ (WXDataSet *) resourceDataSet;
+ (WXDataSet *) resourceDataSetWithDomain:(NSString *)domain;

/**
 The removeKey method will remove the key from the domain, thereby also removing the data file,
 while the clearDataSet method will remove all keys from the domain.
 **/
- (void) removeKey:(NSString *) key;
- (void) clearDataSet;

/**
 Check to see if the key exists in the domain
 **/
- (BOOL) doesKeyExist:(NSString *)key;
- (NSArray *)allKeys;


/**
 Get the last modification date of the file associated with the 
 specified key/
 **/
- (NSDate *) modificationDateForKey:(NSString *)key;

/**
 This returns the age of the file based on it's last modification date.
 **/
- (NSTimeInterval) ageForKey:(NSString *) key;

- (NSMutableArray *) arrayForKey:(NSString *) key;
- (void) setArray:(NSArray *) array forKey:(NSString *) key;

- (NSMutableDictionary *) dictionaryForKey:(NSString *) key;
- (void) setDictionary:(NSDictionary *) dict forKey:(NSString *) key;

- (UIImage *) imageForKey:(NSString *) key;
- (void) setImage:(UIImage *) image forKey:(NSString *) key;

- (NSMutableData *) dataForKey:(NSString *) key;
- (void) setData: (NSData *) data forKey:(NSString *) key;

- (NSString *) stringForKey:(NSString *) key;
- (void) setString: (NSString *) string forKey:(NSString *) key;

/**
 Return the dataset base path.
 **/
- (NSString *) root;

/**
 This returns the absolute path for the specified key in the
 DataSet's domain.
 **/
- (NSString *) pathForKey:(NSString *) key;
- (NSURL *) fileURLForKey:(NSString *) key;

/**
 This returns the absolute path for domain itself.
 **/
- (NSString *) pathForDomain;

- (NSError *) copyFileAtPath:(NSString *)sourcePath toKey:(NSString *) key;


@end
