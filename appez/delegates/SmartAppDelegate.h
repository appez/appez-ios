//
//  SmartAppDelegate.h
//  appez
//
//  Created by Transility on 2/27/12.
//

/**
 * SmartAppDelegate : Defines protocol for listening to JavaScript
 * notifications meant for the application.
 * */
#import <Foundation/Foundation.h>

@protocol SmartAppDelegate <NSObject>

@optional
/**
 * Specifies action to be taken on receiving Smart notification containing
 * event data and notification
 * 
 * @param eventData
 *            : Event data
 * @param notification
 *            : Notification from Javascript
 * 
 */
-(void)didReceiveSmartNotification:(NSString*)eventData WithNotification:(NSString*) notification;

/**
 * Specifies action to be taken on receiving Smart notification containing
 * event data, notification and data message
 * 
 * @param eventData
 *            : Event data
 * @param notification
 *            : Notification from Javascript
 * @param dataMessage
 *            : Data message containing file name that holds response from
 *            HTTp operation
 * 
 */
//void onReceiveSmartNotification(String eventData, String notification, String dataMessage);
-(void)didReceiveDataNotification:(NSString*)notification  WithFileUrl:(NSString*)fromFile;

/**
 * Specifies action to be taken on receiving Smart notification containing
 * event data and notification
 * 
 * @param eventData
 *            : Event data
 * @param notification
 *            : Notification from Javascript
 * @param responseData
 *            : Response of HTTP action
 * 
 */
//void onReceiveSmartNotification(String eventData, String notification, byte[] responseData);
-(void)didReceiveDataNotification:(NSString*)notification WithData:(NSData*)responseData;

@end
