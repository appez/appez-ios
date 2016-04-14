//
//  NetworkStateNotifier.h
//  appez
//
//  Created by Transility on 07/01/15.
//
//

#import <Foundation/Foundation.h>
#import "NotifierEventDelegate.h"
#import "NotifierNetworkStateDelegate.h"
#import "SmartNotifier.h"
#import "NetworkStateUtility.h"

@interface NetworkStateNotifier : SmartNotifier<NotifierNetworkStateDelegate>
{
    @private id<NotifierEventDelegate> notifierEventDelegate;
}
@property(strong)NetworkStateUtility *nwStateUtility;
-(id)initNetworkStateNotifierWithNotifierEventDelegate:(id<NotifierEventDelegate>)notifierEvDelegate;

@end
