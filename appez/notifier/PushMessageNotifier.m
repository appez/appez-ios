//
//  PushMessageNotifier.m
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import "PushMessageNotifier.h"
#import "NotifierEventDelegate.h"
#import "AppUtils.h"
#import "NotifierMessageConstants.h"
#import "ExceptionTypes.h"
#import "NotifierConstants.h"

@implementation PushMessageNotifier
@synthesize pnUtility;

-(instancetype)initWithNotifierEventDelegate:(id<NotifierEventDelegate>)notifierEvDelegate
{
    if(self=[super init]){
        
        notifierEventDelegate=notifierEvDelegate;
    }
    return self;
}

-(void)registerDelegate:(NotifierEvent*)notifierEvent
{
    pnUtility=[[PushNotificationUtility alloc]initWithNotifierPushMessageDelegate:self];
    currentEvent=notifierEvent;
    [pnUtility registerPush:notifierEvent];
}

-(void)unregisterDelegate:(NotifierEvent*)notifierEvent
{
    pnUtility=[[PushNotificationUtility alloc]initWithNotifierPushMessageDelegate:self];
    currentEvent=notifierEvent;
    [pnUtility unregisterPush:notifierEvent];
}

-(NotifierEvent*)prepareResponseFromCurrentEventwith:(NotifierEvent*)notifierEvent operation:(BOOL)isOperationSuccess response:(NSDictionary*)notifierResponse errorType:(int)errorType andErrorMessage:(NSString*)notifierError{
    if (notifierEvent != nil) {
        notifierEvent.isOperationSuccess=isOperationSuccess;
        notifierEvent.responseData=notifierResponse;
        notifierEvent.errorType =errorType;
        notifierEvent.errorMessage=notifierError;
    }
    return notifierEvent;
}

-(NotifierEvent*)prepareNotifierEventResponsewithSuccess:(BOOL)isOperationSuccess actionType:(int)notifierActionType response:(NSDictionary*)notifierResponse errorType:(int)errorType andErrorMessage:(NSString*)notifierError
{
    NotifierEvent *notifierEvent = [[NotifierEvent alloc]init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"yyyy-MM-dd-HH:mm";
    NSDate *date = [NSDate date];
    notifierEvent.transactionId=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    notifierEvent.type=PUSH_MESSAGE_NOTIFIER;
    notifierEvent.isOperationSuccess=isOperationSuccess;
    notifierEvent.responseData=notifierResponse;
    notifierEvent.errorType=errorType;
    notifierEvent.errorMessage=notifierError;
    
    return notifierEvent;
}

-(void)didReceiveRegistrationToken:(NSString *)tokenInfo
{
    [notifierEventDelegate didCompleteNotifierRegistrationSuccess:[self prepareResponseFromCurrentEventwith:currentEvent operation:YES response:[AppUtils getDictionaryFromJson:tokenInfo] errorType:0 andErrorMessage:@""]];
}

-(void)didReceiveRegistrationError:(NSString*)error
{
     [notifierEventDelegate didCompleteNotifierRegistrationError:[self prepareResponseFromCurrentEventwith:currentEvent operation:NO response:[AppUtils getDictionaryFromJson:@"{}"] errorType:NOTIFIER_REQUEST_ERROR.intValue andErrorMessage:error]];
}

-(void)didReceivePushMessage:(NSString *)message
{
    NSDictionary *notifierEventResponse = [AppUtils getDictionaryFromJson:message];
    [notifierEventDelegate didReceiveNotifierEventSuccess:[self prepareNotifierEventResponsewithSuccess:YES actionType:0 response:notifierEventResponse errorType:0 andErrorMessage:@""]];
}

-(void)didReceivePushError:(NSString *)error
{
    //This method will not be called , but in order to keep equal analogy with android and as discussed in code review, this is added
    [notifierEventDelegate didCompleteNotifierRegistrationError:[self prepareResponseFromCurrentEventwith:currentEvent operation:NO response:[AppUtils getDictionaryFromJson:@"{}"] errorType:NOTIFIER_REQUEST_ERROR.intValue andErrorMessage:error]];
}

@end
