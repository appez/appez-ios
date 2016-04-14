//
//  StorePreferences.h
//  appez
//
//  Created by Transility on 5/11/12.
//
/**
 * This class will store shared preferences values in key value format.
 **/

#import <Foundation/Foundation.h>

@interface StorePreferences : NSObject
{
    NSMutableDictionary *sharedDictionary;
    NSUserDefaults *userDefaults;
    NSString *sharedPreferenceName;
}

-(instancetype)initWithDomainName:(NSString*)domainName;
- (BOOL)setObject:(id)value forKey:(NSString *)defaultName;
- (BOOL)setInteger:(int)value forKey:(NSString *)defaultName;
- (BOOL)setFloat:(float)value forKey:(NSString *)defaultName;
- (BOOL)setDouble:(double)value forKey:(NSString *)defaultName;
- (BOOL)setBool:(BOOL)value forKey:(NSString *)defaultName;
- (NSString *)stringForKey:(NSString *)defaultName;
- (float)floatForKey:(NSString *)defaultName;
- (double)doubleForKey:(NSString *)defaultName;
- (BOOL)boolForKey:(NSString *)defaultName;
-(instancetype)objectForKey:(NSString*)defaultName;
-(NSDictionary*)allPreferences;
-(BOOL)removeObjectForKey:(NSString*)key;
@end
