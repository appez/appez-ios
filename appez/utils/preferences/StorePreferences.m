//
//  StorePreferences.m
//  appez
//
//  Created by Transility on 5/11/12.
//

#import "StorePreferences.h"

@interface StorePreferences(PrivateMethods)
-(BOOL)IsDomainAvailable:(NSString*)domainName;
@end


@implementation StorePreferences

/*
 * Set the preference name
 */
-(instancetype)initWithDomainName:(NSString*)domainName
{
    self=[super init];
    if([self IsDomainAvailable:domainName])
    {
        sharedPreferenceName=domainName;
        userDefaults=[[NSUserDefaults alloc] init];
        [userDefaults addSuiteNamed:domainName];
        sharedDictionary=[NSMutableDictionary dictionaryWithDictionary:[userDefaults persistentDomainForName:domainName]];
        [userDefaults synchronize];
    }
    else
    {
        sharedPreferenceName=domainName;
        userDefaults=[[NSUserDefaults alloc] init];
        sharedDictionary=[NSMutableDictionary dictionaryWithDictionary:[userDefaults persistentDomainForName:domainName]];
        [userDefaults synchronize];
    }
    
    return self;
}

-(BOOL)IsDomainAvailable:(NSString*)domainName
{
    NSArray *domainNames=[[NSUserDefaults standardUserDefaults] persistentDomainNames];
    for (NSString *name in domainNames)
    {
            if([domainName isEqualToString:name])
            {
                return TRUE;
            }
    }
    return FALSE;
}


/*
 * Store object values
 */
- (BOOL)setObject:(id)value forKey:(NSString *)defaultName
{
    [sharedDictionary setObject:value forKey:defaultName];
    [userDefaults setPersistentDomain:sharedDictionary forName:sharedPreferenceName];
    return [userDefaults synchronize];
    
}
/*
 * Store int values
 */
- (BOOL)setInteger:(int)value forKey:(NSString *)defaultName
{
    [sharedDictionary setObject:[NSNumber numberWithInt:value] forKey:defaultName];
     [userDefaults setPersistentDomain:sharedDictionary forName:sharedPreferenceName];
    return [userDefaults synchronize];
}
/*
 * Store float values
 */
- (BOOL)setFloat:(float)value forKey:(NSString *)defaultName
{
    [sharedDictionary setObject:[NSNumber numberWithFloat:value] forKey:defaultName];    
     [userDefaults setPersistentDomain:sharedDictionary forName:sharedPreferenceName];
    return [userDefaults synchronize];
}
/*
 * Store double values
 */
- (BOOL)setDouble:(double)value forKey:(NSString *)defaultName
{
    [sharedDictionary setObject:[NSNumber numberWithDouble:value] forKey:defaultName];
     [userDefaults setPersistentDomain:sharedDictionary forName:sharedPreferenceName];
    return [userDefaults synchronize];
}
/*
 * Store bool values
 */
- (BOOL)setBool:(BOOL)value forKey:(NSString *)defaultName
{
    [sharedDictionary setObject:[NSNumber numberWithBool:value] forKey:defaultName];
     [userDefaults setPersistentDomain:sharedDictionary forName:sharedPreferenceName];
    return [userDefaults synchronize];
}

/*
 * Retrieve String value
 */
- (NSString *)stringForKey:(NSString *)defaultName
{
    NSString *value=[sharedDictionary valueForKey:defaultName];
    if(value==nil)
        return @"null";
    else
        return value;
    
}
/*
 * Retrieve float value
 */
- (float)floatForKey:(NSString *)defaultName
{
    return [[sharedDictionary valueForKey:defaultName] floatValue];
}
/*
 * Retrieve double value
 */
- (double)doubleForKey:(NSString *)defaultName
{
    return [[sharedDictionary valueForKey:defaultName] doubleValue];
}
/*
 * Retrieve boolean value
 */
- (BOOL)boolForKey:(NSString *)defaultName
{
    return [[sharedDictionary valueForKey:defaultName] boolValue];
}

/*
 * Retrieve object value
 */

-(id)objectForKey:(NSString*)defaultName
{
    id value=[sharedDictionary valueForKey:defaultName];
    if(value==nil)
        return (id)@"null";
    else
        return value;
    

}

/**
 * Retrieving all the entries from the SharedPreferences
 */
-(NSDictionary*)allPreferences
{
    return sharedDictionary;
}

/*
 * Remove entry from the SharedPreferences
 */
-(BOOL)removeObjectForKey:(NSString*)key
{
    [sharedDictionary removeObjectForKey:key];
    [userDefaults setPersistentDomain:sharedDictionary forName:sharedPreferenceName];
    return [userDefaults synchronize];
}

@end
