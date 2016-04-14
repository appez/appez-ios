//
//  SmartServiceDelegate.h
//  appez
//
//  Created by Transility on 2/27/12.
//

/**
 * SmartServiceDelegate: Defines an protocol for listening to appez framework
 * service completion events.
 * */

#import <Foundation/Foundation.h>

@class SmartEvent;

@protocol SmartServiceDelegate <NSObject>
@optional
/**
 * Specifies action to be taken when service(s),either HTTP or UI service,
 * is completed successfully
 * 
 * @param smartEvent
 *            : SmartEvent object containing service completion info
 * */
-(void)didCompleteServiceWithSuccess:(SmartEvent*)smartEvent;

/**
 * Specifies action to be taken when service(s),either HTTP or UI service,
 * is completed with erro
 * 
 * @param smartEvent
 *            : SmartEvent object containing service completion info
 * */
-(void)didCompleteServiceWithError:(SmartEvent*)smartEvent;


-(void)shutDown;

@end
