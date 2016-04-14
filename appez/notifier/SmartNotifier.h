//
//  SmartNotifier.h
//  appez
//
//  Created by Transility on 9/15/14.
//
//

#import <Foundation/Foundation.h>
#import "NotifierEvent.h"
#import "NotifierEventDelegate.h"

@interface SmartNotifier : NSObject
{
    
}
-(void)registerDelegate:(NotifierEvent*)notifierEvent;
-(void)unregisterDelegate:(NotifierEvent*)notifierEvent;
@end
