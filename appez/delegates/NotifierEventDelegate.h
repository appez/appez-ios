//
//  NotifierEventDelegate.h
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import <Foundation/Foundation.h>
#import "NotifierEvent.h"

@protocol NotifierEventDelegate <NSObject>
-(void)didReceiveNotifierEventSuccess:(NotifierEvent*)notifierEvent;
-(void)didReceiveNotifierEventError:(NotifierEvent*)notifierEvent;
-(void)didCompleteNotifierRegistrationSuccess:(NotifierEvent*)notifierEvent;
-(void)didCompleteNotifierRegistrationError:(NotifierEvent*)notifierEvent;
@end
