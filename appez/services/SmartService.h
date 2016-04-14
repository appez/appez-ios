//  SmartService.h
//  appez
//  Created by Transility on 2/27/12.

/**
 * SmartService.java: 
 * Base class of the services. All individual service classes are derived
 * from SmartService. It exposes interface called SmartServiceListner to share
 * processing results of service with intended client
 */

#import <Foundation/Foundation.h>
#import "SmartEvent.h"

@interface SmartService : NSObject

{
    
}

-(void)shutDown;
    
/**
 * Specifies action to be taken for the current service type
 * 
 * @param smartEvent : SmartEvent containing parameters required for performing
 *            action in current service type
 */
-(void)performAction:(SmartEvent*)smartevent;

@end
