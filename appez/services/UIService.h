//
//  UIService.h
//  appez
//
//  Created by Transility on 2/27/12.
//
/**
 * <description> Class UIService which extends SmartService and implements
 * AlertViewDelegate and SmartPickerViewDelegate
 */

#import <Foundation/Foundation.h>
#import "SmartService.h"
#import "AlertView.h"
#import "SmartServiceDelegate.h"
#import "SmartEvent.h"
#import "SmartDatePickerView.h"
#import "CommMessageConstants.h"
#import "SmartConstants.h"

@interface UIService : SmartService <AlertViewDelegate,SmartPickerDelegate>
{
    @private AlertView                 *mAlertView;
	@private id<SmartServiceDelegate> smartServiceDelegate;
    @private SmartEvent                *currentEvent;
    @private SmartDatePickerView      *mDatePicker;
}
-(void)didCompleteUiOperationWithSuccess:(NSString*)jsonResponse;
-(void)didCompleteUiOperationWithError:(int)exceptionType andMessage:exceptionMessage;
-(instancetype)initWithDelegate:(id<SmartServiceDelegate>)delegate;
@end
