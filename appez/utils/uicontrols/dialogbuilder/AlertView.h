//
//  AlertView.h
//  appez
//
//  Created by Transility on 2/29/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AlertViewDelegate.h"

@interface AlertView : NSObject
{
    @private UIAlertView            *mAlertView;
	@private id<AlertViewDelegate>  mAlertViewDelegate;
    int alertViewType;
    NSString *titleMessage;
    NSString *descriptionMessage;
}

-(instancetype)initWithAlertViewDelegate:(id<AlertViewDelegate>)delegate;

/**
 * Creates dialog corresponding to the ID and the message specified
 * 
 * @param id
 *            : Specifies the ID required to create dialog
 * @param mStrStatusMessage
 *            : Message to be shown on dialog
 * 
 * */
-(void)showAlertViewWithType:(int)type WithMessage:(NSString*)mStrStatusMessage;

/**
 * Dismisses dialog
 * 
 */
-(void)hideDialog;

/**
 * Updates the text on the dialog with the text provided
 * 
 * @param message
 *            : Message which will replace existing message on the dialog
 * */
-(void)updateDialogText:(NSString*)message;
@end
