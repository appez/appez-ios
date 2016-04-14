//
//  NetworkStateUtility.m
//  appez
//
//  Created by Transility on 07/01/15.
//
//

#import "NetworkStateUtility.h"
#import "NotifierConstants.h"
#import "ExceptionTypes.h"
#import "AppUtils.h"
#import "NotifierMessageConstants.h"
#import "SmartUIUtility.h"


@implementation NetworkStateUtility

-(id)initWithNetworkStateDelegate:(id<NotifierNetworkStateDelegate>)nwStateDelegate
{
    self = [super init];
    if (self)
    {
        notifierNetworkStateDelegate=nwStateDelegate;
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        //netStatus= [reach currentReachabilityStatus];
    }
    return self;
}

-(void)registerWithNotifierEvent:(NotifierEvent *)notifierEvent
{
    //OS specific code to register for network status change updates
    dispatch_queue_t mainQueue=dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
    });
    
    @try {
        currentNotifierEvent=notifierEvent;
        NSLog(@"NetworkStateUtility-->register");
        [notifierNetworkStateDelegate didCompleteNetworkStateRegistrationWithSuccess:[self prepareResponseFromCurrentEventSuccesWithEvent:currentNotifierEvent andResponse:[[NSDictionary alloc]init]]];
    }
    @catch (NSException *exception) {
        [notifierNetworkStateDelegate didCompleteNetworkStateRegistrationWithError:[self prepareResponseFromCurrentEventErrorWithEvent:currentNotifierEvent andError:[exception description]]];
    }
}

-(void)unregister:(NotifierEvent *)notifierEvent
{
    @try {
        currentNotifierEvent=notifierEvent;
        [reachability stopNotifier];
        [notifierNetworkStateDelegate didCompleteNetworkStateRegistrationWithSuccess:[self prepareResponseFromCurrentEventSuccesWithEvent:currentNotifierEvent andResponse:[[NSDictionary alloc]init]]];
    }
    @catch (NSException *exception) {
        [notifierNetworkStateDelegate didCompleteNetworkStateRegistrationWithError:[self prepareResponseFromCurrentEventErrorWithEvent:currentNotifierEvent andError:[exception description]]];
    }
}

/*
 *This will be called whenever network status of device changes.
 */
- (void)reachabilityChanged:(NSNotification *)note
{
    BOOL isWifiConnected = FALSE;
    BOOL isMobileDataConnected = FALSE;
        @try {
        
            NetworkStatus deviceNetStatus = [reachability currentReachabilityStatus];
            
            switch (deviceNetStatus) {
           
                case ReachableViaWiFi:
                {
                    isWifiConnected=TRUE;

                }
                break;
                case ReachableViaWWAN:
            
                {
                    isMobileDataConnected=TRUE;
                }
                break;
                case NotReachable:
                {
                    //Currently do nothing here
                }
                break;
        }
        
        if(notifierNetworkStateDelegate!=nil)
        {
            NSMutableDictionary *networkState=[[NSMutableDictionary alloc]init];
            [networkState setValue:[NSNumber numberWithBool:isWifiConnected] forKey:NOTIFIER_RESP_NWSTATE_WIFI_CONNECTED];
            [networkState setValue:[NSNumber numberWithBool:isMobileDataConnected] forKey:NOTIFIER_RESP_NWSTATE_CELLULAR_CONNECTED];
            [networkState setValue:[NSNumber numberWithBool:isWifiConnected||isMobileDataConnected] forKey:NOTIFIER_RESP_NWSTATE_CONNECTED];
            [notifierNetworkStateDelegate didReceiveNetworkStateEventWithSuccess:[self prepareSuccessNotifierEvent:networkState]];
        }
    }
    @catch (NSException *exception) {
        if(notifierNetworkStateDelegate!=nil)
            [notifierNetworkStateDelegate didReceiveNetworkStateEventWithError:[self prepareErrorNotifierEvent:[exception description]]];
    }
}

-(NotifierEvent*)prepareResponseFromCurrentEventSuccesWithEvent:(NotifierEvent*)notifierEvent andResponse:(NSDictionary*)notifierResponse
{
    if (notifierEvent!=nil) {
        notifierEvent.isOperationSuccess=TRUE;
        notifierEvent.responseData=notifierResponse;
        notifierEvent.errorType=0;
        notifierEvent.errorMessage=@"{}";
    }
    
    return notifierEvent;
}

-(NotifierEvent*)prepareResponseFromCurrentEventErrorWithEvent:(NotifierEvent*)notifierEvent andError:(NSString*)notifierError
{
    if(notifierEvent!=nil)
    {
        notifierEvent.isOperationSuccess=FALSE;
        notifierEvent.responseData=[AppUtils getDictionaryFromJson:@"{}"];
        notifierEvent.errorType=[NOTIFIER_REQUEST_ERROR intValue];
        notifierEvent.errorMessage=notifierError;
    }
    
    return notifierEvent;
}

-(NotifierEvent*)prepareSuccessNotifierEvent:(NSDictionary*)notifierResponse {
   
    NotifierEvent *notifierEvent = [[NotifierEvent alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
    NSDate *date = [NSDate date];
    notifierEvent.transactionId=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    notifierEvent.type=NETWORK_STATE_NOTIFIER;
    notifierEvent.isOperationSuccess=TRUE;
    notifierEvent.responseData=notifierResponse;
    notifierEvent.errorType=0;
    notifierEvent.errorMessage=@"";
    return notifierEvent;
}

-(NotifierEvent*)prepareErrorNotifierEvent:(NSString*)notifierError {
    NotifierEvent *notifierEvent = [[NotifierEvent alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH:mm"];
    NSDate *date = [NSDate date];
    notifierEvent.transactionId=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    notifierEvent.type=NETWORK_STATE_NOTIFIER;
    notifierEvent.isOperationSuccess=FALSE;
    notifierEvent.responseData=[AppUtils getDictionaryFromJson:@"{}"];
    notifierEvent.errorType=[NOTIFIER_REQUEST_ERROR intValue];
    notifierEvent.errorMessage=notifierError;
    return notifierEvent;
}


@end
