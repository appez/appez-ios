//
//  NotifierPushMessageDelegate.h
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import <Foundation/Foundation.h>

@protocol NotifierPushMessageDelegate <NSObject>
-(void)didReceivePushMessage:(NSString*)message;
-(void)didReceivePushError:(NSString*)error;
-(void)didReceiveRegistrationToken:(NSString*)tokenInfo;
-(void)didReceiveRegistrationError:(NSString *)error;
@end
