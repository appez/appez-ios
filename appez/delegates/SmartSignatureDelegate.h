//
//  SmartSignatureDelegate.h
//  appez
//
//  Created by Transility on 29/11/14.
//
//

#import <Foundation/Foundation.h>

@protocol SmartSignatureDelegate <NSObject>

-(void)didCaptureUserSignatureWithSuccess:(NSString*)responseData;

-(void)didCaptureUserSignatureWithError:(int)exceptionType withMessage:(NSString*)exceptionMessage;

@end
