//
//  ApplicationSession.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "SessionData.h"
#import "AppUtils.h"

static SessionData *sharedInstance;

@implementation SessionData

+(SessionData*)sharedInstance
{
    if(sharedInstance==nil)
    {
        sharedInstance=[[SessionData alloc] init];
    }
    return sharedInstance;
}

+(void)tear
{
    if(sharedInstance!=nil)
    {
        sharedInstance=nil;  
    }
}

-(void)addSessionObject:(id)object withKey:(NSString*)key
{
    if(session==nil)
        session=[[NSMutableDictionary alloc]init];
    [session setValue:object forKey:key];
}

-(instancetype)getSessionObject:(NSString*)key
{
    if(session==nil)
        session=[[NSMutableDictionary alloc]init];
    return [session objectForKey:key];
}

-(void)deleteSessionObject:(NSString*)key
{
    [session removeObjectForKey:key];
}

-(BOOL)containsKey:(NSString*)key
{
   NSArray *allKeys=session.allKeys;
    for (NSString *akey in allKeys) 
    {
        if([akey isEqualToString:key])
            return TRUE;
       
    }
    return FALSE;
}

-(void)destroySession
{
    [session removeAllObjects];
}

@end
