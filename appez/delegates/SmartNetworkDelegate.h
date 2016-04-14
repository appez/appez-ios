//
//  SmartNetworkDelegate.h
//  appez
//
//  Created by Transility on 17/08/12.
//
//

/**
 * SmartNetworkDelegate : Defines a protocol for listening to network events.
 * This includes listening to successful or erroneous completion of the HTTP
 * calls. Based on the user preference, the response can be provided in either
 * string format or dumped in the DAT file
 * */

#import <Foundation/Foundation.h>

@protocol SmartNetworkDelegate <NSObject>
@optional
/** Updates SmartEventResponse and thereby SmartEvent based on the HTTP operation performed in NetworkService.
 * Also notifies SmartServiceListener about successful completion of HTTP operation
 *
 * @param fileName : Name of the file where the HTTP response data has been dumped
 * @param responseData : HTTP response data
 *
 */
-(void)didCompleteHttpOperationWithSuccess:(NSString*)responseData;

/** Notifies SmartServiceListener about unsuccessful completion of HTTP operation
 *
 * @param exceptionData : Exception type
 * @param exceptionMessage: Message describing the exception
 */

-(void)didCompleteHttpOperationWithError:(int)exceptionType WithMessage:(NSString*)exceptionMessage;
@end
