//
//  ApplicationSession.h
//  appez
//
//  Created by Transility on 2/27/12.
//

/**
 * SessionData : Application class that helps in maintaining the state of
 * objects throughout the application's session. Since this class is singleton
 * and retains its state throughout the application, it is ideal for holding the
 * objects.
 * */

#import <Foundation/Foundation.h>

@interface SessionData : NSObject
{
    NSMutableDictionary *session;
    BOOL isLoggedIn;
}
+(SessionData*)sharedInstance;
+(void)tear;
-(void)addSessionObject:(id)object withKey:(NSString*)key;
-(instancetype)getSessionObject:(NSString*)key;
-(void)deleteSessionObject:(NSString*)key;
-(BOOL)containsKey:(NSString*)key;
-(void)destroySession;
@end
