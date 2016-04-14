//
//  NotifierEventRouter.m
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import "NotifierEventRouter.h"
#import "PushMessageNotifier.h"
#import "NetworkStateNotifier.h"

@implementation NotifierEventRouter

-(instancetype)initWithNotifierEventDelegate:(id<NotifierEventDelegate>)notifierEvDelegate
{
    self=[super init];
    if(self)
        notifierEventDelegate=notifierEvDelegate;
    return self;
}

-(SmartNotifier*)getNotifier:(int)notifierType{
    SmartNotifier *smartNotifier=NULL;
    switch (notifierType) {
        
        case PUSH_MESSAGE_NOTIFIER:
            smartNotifier=[[PushMessageNotifier alloc]initWithNotifierEventDelegate:notifierEventDelegate] ;
            break;
        
        case NETWORK_STATE_NOTIFIER:
            smartNotifier=[[NetworkStateNotifier alloc] initNetworkStateNotifierWithNotifierEventDelegate:notifierEventDelegate];
            break;
        default:
        break;
    }
    return smartNotifier;
}

@end
