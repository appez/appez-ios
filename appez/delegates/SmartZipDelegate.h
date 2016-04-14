//
//  SmartZipDelegate.h
//  appez
//
//  Created by Transility on 5/25/14.
//
//


/**
 * SmartZipDelegate : This protocol helps listen to the successful/erroneous completion of file
 * archiving(zipping) operation.
 *
 * */

#import <Foundation/Foundation.h>

@protocol SmartZipDelegate <NSObject>

/**
 * Called when the operation is completed successfully
 *
 * @param opCompData
 *            : Zip operation completion response.
 *
 *
 * */
-(void)didCompleteZipOperationWithSuccess:(NSString*)opCompData;

/**
 * Called when the zip operation could not complete successfully
 *
 * @param errorMessage
 *
 * */
-(void)didCompleteZipOperationWithError:(NSString*)errorMessage;

@end
