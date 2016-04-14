//
//  PushNotiicationUtility.h
//  appez
//
//  Created by Transility on 25/09/14.
//
//

#import <Foundation/Foundation.h>
#import "NotifierPushMessageDelegate.h"
#import "SmartNetworkDelegate.h"
#import "NetworkService.h"
#import "NotifierEvent.h"
#import "NotifierMessageConstants.h"

@interface PushNotificationUtility : NSObject<SmartNetworkDelegate>
{
    id <NotifierPushMessageDelegate> notifierPushMessageDelegate;
    NotifierEvent *currentNotifierEvent;
    int currentEvent;
}
@property(nonatomic,retain)NSString *pushServerUrl;
-(instancetype)initWithNotifierPushMessageDelegate:(id<NotifierPushMessageDelegate>)notifierPNMessageDelegate;
-(void)registerPush:(NotifierEvent*)notifierEvent;
-(void)unregisterPush:(NotifierEvent*)notifierEvent;
@end
