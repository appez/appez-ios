//
//  NetworkStateNotifier.m
//  appez
//
//  Created by Transility on 07/01/15.
//
//

#import "NetworkStateNotifier.h"
#import "NetworkStateUtility.h"
#import "NotifierConstants.h"
#import "Reachability.h"
#import "NotifierMessageConstants.h"
@implementation NetworkStateNotifier
@synthesize nwStateUtility;

-(id)initNetworkStateNotifierWithNotifierEventDelegate:(id<NotifierEventDelegate>)notifierEvDelegate
{
    if(self=[super init]){
        
        notifierEventDelegate=notifierEvDelegate;
    }
    return self;
}

-(void)registerDelegate:(NotifierEvent*)notifierEvent
{
    BOOL isWifiConnected=NO;
    BOOL isMobileDataConnected=NO;
    NSLog(@"NetworkStateNotifier-->registerDelegate");
    nwStateUtility=[[NetworkStateUtility alloc]initWithNetworkStateDelegate:self];
    [nwStateUtility registerWithNotifierEvent:notifierEvent];
    Reachability *reachability=[Reachability reachabilityForInternetConnection];
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

    
    NSMutableDictionary *networkState=[[NSMutableDictionary alloc]init];
    [networkState setValue:[NSNumber numberWithBool:isWifiConnected] forKey:NOTIFIER_RESP_NWSTATE_WIFI_CONNECTED];
    [networkState setValue:[NSNumber numberWithBool:isMobileDataConnected] forKey:NOTIFIER_RESP_NWSTATE_CELLULAR_CONNECTED];
    [networkState setValue:[NSNumber numberWithBool:isWifiConnected||isMobileDataConnected] forKey:NOTIFIER_RESP_NWSTATE_CONNECTED];
    NotifierEvent *notifierEventSuccess=[nwStateUtility prepareSuccessNotifierEvent:networkState];
    [self didReceiveNetworkStateEventWithSuccess:notifierEventSuccess];
}

-(void)unregisterDelegate:(NotifierEvent*)notifierEvent
{
    nwStateUtility=[[NetworkStateUtility alloc]initWithNetworkStateDelegate:self];
    [nwStateUtility unregister:notifierEvent];
}

-(void)didReceiveNetworkStateEventWithSuccess:(NotifierEvent *)notifierEvent
{
    [notifierEventDelegate didReceiveNotifierEventSuccess:notifierEvent];
}

-(void)didReceiveNetworkStateEventWithError:(NotifierEvent *)notifierEvent
{
    [notifierEventDelegate didReceiveNotifierEventError:notifierEvent];
}

-(void)didCompleteNetworkStateRegistrationWithSuccess:(NotifierEvent *)notifierEvent
{
    [notifierEventDelegate didCompleteNotifierRegistrationSuccess:notifierEvent];
}

-(void)didCompleteNetworkStateRegistrationWithError:(NotifierEvent *)notifierEvent
{
    [notifierEventDelegate didCompleteNotifierRegistrationError:notifierEvent];
}

@end
