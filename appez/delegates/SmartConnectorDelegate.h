//
//  SmartConnectDelegate.h
//  appez
//
//  Created by Transility on 2/27/12.
//

/**
 * SmartConnectorDelegate : Defines an interface for listening to completion
 * status of the SmartEvent initiated by the web layer.
 *
 * */

#import <Foundation/Foundation.h>

@class SmartEvent;

@protocol SmartConnectorDelegate <NSObject>

@optional
/**
 * Specifies action to be taken on successful processing of SmartEvent
 * 
 * @param smartEvent
 *            : SmartEvent being processed
 */
-(void)didFinishProcessingWithOptions:(SmartEvent*)smartEvent;

/**
 * Specifies action to be taken on unsuccessful processing of SmartEvent
 * 
 * @param smartEvent
 *            : SmartEvent being processed
 */
-(void)didFinishProcessingWithError:(SmartEvent*)smartEvent;



-(void)shutDown;


-(void)didReceiveContextNotification:(SmartEvent*)smartEvent;
@end
