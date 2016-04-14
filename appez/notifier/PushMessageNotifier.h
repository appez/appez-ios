//
//  PushMessageNotifier.h
//  appez
//
//  Created by Transility on 9/15/14.
//
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SmartNotifier.h"
#import "NotifierPushMessageDelegate.h"
#import "NotifierEventDelegate.h"
#import "NotifierEvent.h"
#import "PushNotificationUtility.h"

@interface PushMessageNotifier:SmartNotifier<NotifierPushMessageDelegate,UIApplicationDelegate>
{
@private id<NotifierEventDelegate> notifierEventDelegate;
@private NotifierEvent *currentEvent;
}
@property(strong) PushNotificationUtility *pnUtility;
-(instancetype)initWithNotifierEventDelegate:(id<NotifierEventDelegate>)notifierEvDelegate;

@end
