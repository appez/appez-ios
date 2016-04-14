//
//  SmartUnzipDelegate.h
//  appez
//
//  Created by Transility on 4/15/14.
//
//

/**
 * This delegate helps listen to the successful/erroneous completion of generic
 * events. This delegate can be used for listening events that are neither of
 * network, camera etc.
 *
 * */

#import <Foundation/Foundation.h>

@protocol SmartUnzipDelegate <NSObject>

/**
* Called when the operation is completed successfully
*
* @param opCompData
*            : No fixed format for sending the completion response. This
*            can be based on the type of event.*
* */
-(void)didCompleteUnZipOperationWithSuccess:(NSString*)opCompData;

/**
* Called when the operation could not complete successfully
*
* @param errorMessage
* */
-(void)didCompleteUnZipOperationWithError:(NSString*)errorMessage;


@end
