//
//  SmartNotificationDelegate
//  appez
//
//  Created by Transility on 01/08/12.
//
//

#import <Foundation/Foundation.h>

@protocol SmartNotificationDelegate <NSObject>
@optional
-(void)showPopOverViewController;
-(void)hidePopOverViewController;
-(void)sendDataToMaster:(NSString*)data;
-(void)sendDataToDetail:(NSString*)data;
-(void)sendActionInfo:(NSString*)actionName;
-(void)didResponseDataReceived:(NSString*)imageResponse;
-(void)didResponseDataReceivedInBytes:(NSData*)imageResponse;
/** Notifies SmartServiceListener about unsuccessful completion of HTTP operation
 *
 * @param exceptionData : Exception type
 *
 */

-(void)didResponseErrorReceived:(int)exceptionData WithMessage:(NSString*)exceptionMessage;

@end
