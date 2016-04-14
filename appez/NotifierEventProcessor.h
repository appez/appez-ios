//
//  NotifierEventProcessor.h
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import <Foundation/Foundation.h>
#import "NotifierMessageConstants.h"
#import "NotifierEventDelegate.h"
#import "SmartNotifierDelegate.h"
#import "NotifierEvent.h"

@interface NotifierEventProcessor : NSObject<NotifierEventDelegate>
{
  @private id<SmartNotifierDelegate> smartNotifierDelegate;
}
-(void)processNotifierRegistrationReq:(NotifierEvent*)notifierEvent;
-(instancetype)initWithNotifierEventDelegate:(id<SmartNotifierDelegate>)smNotifierDelegate;
@end
