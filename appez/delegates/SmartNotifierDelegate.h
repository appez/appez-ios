//
//  SmartNotifierDelegate.h
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import <Foundation/Foundation.h>
#import "NotifierEvent.h"

@protocol SmartNotifierDelegate <NSObject>
-(void)didReceiveNotifierEventSuccess:(NotifierEvent*)notifierEvent;
-(void)didReceiveNotifierEventError:(NotifierEvent*)notifierEvent;
-(void)didReceiveNotifierRegistrationEventSuccess:(NotifierEvent*)notifierEvent;
-(void)didReceiveNotifierRegistrationEventError:(NotifierEvent*)notifierEvent;
@end
