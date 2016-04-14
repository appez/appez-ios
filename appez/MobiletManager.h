//  MobiletManager.h
//  appez
//  Created by Transility on 2/27/12.

/**
 * SmartConnector:
 * Responsible for checking sanity of event using smartEvent. Also
 * provides valid smart event to SmartEventProcessor for further processing. It
 * implements SmartEventLister to get processing results from
 * SmartEventProcessor. Events could be of two types name as WEB-EVENT and
 * APP-EVENT. Smart Connector exposes sends notification of WEB-EVENT processing
 * to SmartViewActivity using SmartConnectorListener and send APP-EVENT using
 * SmartAppListener
 * 
 */
#import <Foundation/Foundation.h>
#import "SmartEvent.h"
#import "AppUtils.h"
#import "SmartConnectorDelegate.h"
#import "SmartEventDelegate.h"
#import "SmartAppDelegate.h"
#import "SmartEventProcessor.h"
#import "CommMessageConstants.h"
@interface MobiletManager : NSObject<SmartEventDelegate>
{
    @private id<SmartConnectorDelegate> smartConnectorDelegate;
    @private id<SmartAppDelegate>     smartAppDelegate;
    @private SmartEventProcessor        *smartEventProcessor;
}

-(instancetype)initSmartConnectorWithDelegate:(id<SmartConnectorDelegate>)connectordelegate WithAppDelegate:(id<SmartAppDelegate>)appdelegate;
-(instancetype)initSmartConnectorWithDelegate:(id<SmartConnectorDelegate>)connectordelegate;

/**
 * Overloaded version of processSmartEvent, requires SmartEvent as a input.
 * 
 * @param context
 *            : Current application context
 * @param message
 *            : Message to be processed
 * @return boolean : Indicates whether or not the event is valid or not
 */
-(BOOL)processSmartEvent:(SmartEvent*)smartEvent;

/**
 * Sets target to receive SmartAppDelegate Notifications
 * 
 * @param argSmartAppDelegate
 *            : reference of outer activity
 * @return void
 */
-(void)registerAppDelegate:(id<SmartAppDelegate>)argSmartAppDelegate;
@end
