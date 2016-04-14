//
//  NotifierEventProcessor.m
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import "NotifierEventProcessor.h"
#import "NotifierEventRouter.h"

@implementation NotifierEventProcessor

-(instancetype)initWithNotifierEventDelegate:(id<SmartNotifierDelegate>)smNotifierDelegate
{
    self=[super init];
    if(self!=nil)
    {
        smartNotifierDelegate=smNotifierDelegate;
    }
    return self;
}

-(void)processNotifierRegistrationReq:(NotifierEvent*)notifierEvent
{
    NotifierEventRouter *notifierEventRouter=[[NotifierEventRouter alloc]initWithNotifierEventDelegate:self];
    int notifierType = 0;
    int notifierActionType=0;
    
    if(notifierEvent!=nil)
    {
        notifierType=notifierEvent.type;
        notifierActionType=notifierEvent.actionType;
    }
    
    SmartNotifier *smartNotifier=[notifierEventRouter getNotifier:notifierType];
    
    if (smartNotifier!=nil) {
        if (notifierActionType==NOTIFIER_ACTION_REGISTER) {
            
            [smartNotifier registerDelegate:notifierEvent];
        }
        else if (notifierActionType==NOTIFIER_ACTION_UNREGISTER)
        {
            [smartNotifier unregisterDelegate:notifierEvent];
        }
        else
        {
            //Do nothing here
        }
    }
}

-(void)didReceiveNotifierEventSuccess:(NotifierEvent *)notifierEvent
{
    [smartNotifierDelegate didReceiveNotifierEventSuccess:notifierEvent];
}

-(void)didReceiveNotifierEventError:(NotifierEvent *)notifierEvent
{
    [smartNotifierDelegate didReceiveNotifierRegistrationEventError:notifierEvent];
}

-(void)didCompleteNotifierRegistrationSuccess:(NotifierEvent *)notifierEvent
{
    [smartNotifierDelegate didReceiveNotifierRegistrationEventSuccess:notifierEvent];
}

-(void)didCompleteNotifierRegistrationError:(NotifierEvent *)notifierEvent
{
    [smartNotifierDelegate didReceiveNotifierRegistrationEventError:notifierEvent];
}

@end
