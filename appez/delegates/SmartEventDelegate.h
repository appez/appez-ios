//
//  SmartEventDelegate.h
//  appez
//
//  Created by Transility on 2/27/12.
//

#import <Foundation/Foundation.h>
@class SmartEvent;

@protocol SmartEventDelegate <NSObject>

@optional
/**
 * Specifies action to be taken on successful completion of action. Also
 * processes SmartEvent on the basis of event type contained in it
 * 
 * @param smartEvent
 *            : SmartEvent containing event type
 */
-(void) didCompleteActionWithSuccess:(SmartEvent*)smartEvent;

/**
 * Specifies action to be taken on unsuccessful completion of action. Also
 * processes SmartEvent on the basis of event type contained in it
 * 
 * @param smartEvent
 *            : SmartEvent containing event type
 */
-(void)didCompleteActionWithError:(SmartEvent*)smartEvent;


-(void)shutDown;

@end
