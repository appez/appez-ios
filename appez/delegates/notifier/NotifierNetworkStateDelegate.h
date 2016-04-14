//
//  NotifierNetworkStateDelegate.h
//  appez
//
//  Created by Transility on 07/01/15.
//
//

#import <Foundation/Foundation.h>
#import "NotifierEvent.h"

@protocol NotifierNetworkStateDelegate <NSObject>

/**
 * This method is called on successful receiving of network status
 *
 * @param notifierEvent
 *
 * */
-(void)didReceiveNetworkStateEventWithSuccess:(NotifierEvent*)notifierEvent;

/**
 * This method is called if there's an error in receiving a network status
 *
 * @param notifierEvent
 *
 * */
-(void)didReceiveNetworkStateEventWithError:(NotifierEvent*)notifierEvent;

/**
 * This method is called on successful registration of device for network
 * notification
 *
 * @param notifierEvent
 *
 * */
-(void)didCompleteNetworkStateRegistrationWithSuccess:(NotifierEvent*)notifierEvent;

/**
 * This method is called if there's error registering device with network notification
 *
 * @param notifierEvent
 *
 * */
-(void)didCompleteNetworkStateRegistrationWithError:(NotifierEvent*)notifierEvent;

@end
