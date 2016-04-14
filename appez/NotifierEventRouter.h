//
//  NotifierEventRouter.h
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import <Foundation/Foundation.h>
#import "NotifierConstants.h"
#import "NotifierEventDelegate.h"
#import "SmartNotifier.h"

@interface NotifierEventRouter : NSObject
{
@private id<NotifierEventDelegate> notifierEventDelegate;
}
-(SmartNotifier*)getNotifier:(int)notifierType;
-(instancetype)initWithNotifierEventDelegate:(id<NotifierEventDelegate>)notifierEvDelegate;
@end
