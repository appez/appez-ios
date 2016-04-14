//
//  SmartCoActionDelegate.h
//  appez
//
//  Created by Transility on 11/09/12.
//
//

/**
 * SmartCoActionDelegate : Defines a protocol for notifying the result for
 * completion of Co-action. Essentially used by services such as Map service
 * which lie in the co-event category
 *
 * */
#import <Foundation/Foundation.h>

@protocol SmartCoActionDelegate <NSObject>
/**
 * Indicates the successful completion of the co-action along with the data
 * corresponding to the completion
 *
 * @param mapsData
 *            : Data accompanying the completion of the co-event
 * */
@optional
-(void)didCompleteCoActionWithSuccess:(NSString*)mapsData;
/**
 * Indicates the erroneous completion of the co-event action
 *
 * @param exceptionType
 *            : Unique code corresponding to the problem in the co-event
 *
 * @param exceptionMessage
 *            : Message describing the nature of problem with the co-event
 *            execution
 * */
-(void)didCompleteCoActionWithError:(int)exceptionType WithMessage:(NSString*)exceptionMessage;
@end
