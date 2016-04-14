//
//  NetworkStateUtility.h
//  appez
//
//  Created by Transility on 07/01/15.
//
//

/**
 * Responsible for listening for change in the network state of the device.
 * Communicates the information to the corresponding
 *  NotifierNetworkStateDelegate
 *
 */

#import <Foundation/Foundation.h>
#import "NotifierNetworkStateDelegate.h"
#import "Reachability.h"

@interface NetworkStateUtility : NSObject
{
    id<NotifierNetworkStateDelegate> notifierNetworkStateDelegate;
    NotifierEvent *currentNotifierEvent;
    Reachability *reachability;
}
-(id)initWithNetworkStateDelegate:(id<NotifierNetworkStateDelegate>)nwStateDelegate;
-(void)registerWithNotifierEvent:(NotifierEvent*)notifierEvent;
-(void)unregister:(NotifierEvent*)notifierEvent;
-(NotifierEvent*)prepareSuccessNotifierEvent:(NSDictionary*)notifierResponse;

@end
