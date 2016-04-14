//
//  AlertView.m
//  appez
//
//  Created by Transility on 2/29/12.
//

#import "AlertView.h"
#import "AlertViewDelegate.h"
#import "SmartConstants.h"
#import "SmartUIUtility.h"

@implementation AlertView

- (instancetype)initWithAlertViewDelegate:(id<AlertViewDelegate>)delegate{
    self = [super init];
    if (self) {
        mAlertViewDelegate=delegate;
    }
    return self;
}

-(void)showAlertViewWithType:(int)type WithMessage:(NSString*)mStrStatusMessage
{
    UIViewController *alertController=nil;//iOS 8+
    if(NSClassFromString(@"UIAlertController"))             //iOS 8+
    {
         alertController=[UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        NSLog(@"------UIAlertController available------");
    }
    alertViewType=type;
    switch (type)
    {
        case ALERTVIEW_MESSAGE_YESNO:
        
            [self parseStatusMessage:mStrStatusMessage];
            if(alertController!=nil) //iOS 8+
            {
                NSLog(@"------UIAlertController is presented ------");

                UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"im_no",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self alertActionPressedWithIndexZero:YES];
                }];
                UIAlertAction *yesAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"im_yes",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self alertActionPressedWithIndexZero:NO];

                }];
                [(UIAlertController*)alertController setTitle:titleMessage];
                [(UIAlertController*)alertController setMessage:descriptionMessage];
                [(UIAlertController*)alertController addAction:cancelAction];
                [(UIAlertController*)alertController addAction:yesAction];

                [(UIViewController*)[SmartUIUtility sharedInstance].delegate presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                mAlertView=[[UIAlertView alloc] initWithTitle:titleMessage message:descriptionMessage delegate:self cancelButtonTitle:NSLocalizedString(@"im_no",nil) otherButtonTitles:NSLocalizedString(@"im_yes",nil), nil];
                [mAlertView show];
            }
           
        break;
            
        case ALERTVIEW_MESSAGE_OK:
        
            [self parseStatusMessage:mStrStatusMessage];
            if(alertController!=nil) //iOS 8+
            {
                NSLog(@"------UIAlertController is presented ------");
                UIAlertAction *okAction=[UIAlertAction actionWithTitle:NSLocalizedString(@"im_ok",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self alertActionPressedWithIndexZero:YES];
                    
                }];
                [(UIAlertController*)alertController setTitle:titleMessage];
                [(UIAlertController*)alertController setMessage:descriptionMessage];
                [(UIAlertController*)alertController addAction:okAction];
                [(UIViewController*)[SmartUIUtility sharedInstance].delegate presentViewController:alertController animated:YES completion:nil];

            }
            else
            {
            mAlertView=[[UIAlertView alloc] initWithTitle:titleMessage message:descriptionMessage delegate:self cancelButtonTitle:NSLocalizedString(@"im_ok",nil) otherButtonTitles:nil, nil];
            [mAlertView show];
            }
            //[mAlertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        break;
            
        case ALERTVIEW_LOADING:

            [[SmartUIUtility sharedInstance] showActivityViewWithMessage:mStrStatusMessage];
        break;
    }
}
-(void)parseStatusMessage:(NSString*)mStrStatusMessage
{
    NSArray *statusMessageArray=[mStrStatusMessage componentsSeparatedByString:@"~"];
    if(statusMessageArray.count>1)
    {
        titleMessage=[statusMessageArray objectAtIndex:0];
        descriptionMessage=[statusMessageArray objectAtIndex:1];
    }
    else 
    {
        titleMessage=NSLocalizedString(@"im_title_information", nil);
        descriptionMessage=mStrStatusMessage;
    }
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==0) //Press No Button
    {
        switch (alertViewType)
        {
            case ALERTVIEW_MESSAGE_YESNO:
            
                if(mAlertViewDelegate && [mAlertViewDelegate respondsToSelector:@selector(processUsersSelection:)])
                    [mAlertViewDelegate processUsersSelection:USER_SELECTION_NO];
            break;
            
            case ALERTVIEW_MESSAGE_OK:
        
                if(mAlertViewDelegate && [mAlertViewDelegate respondsToSelector:@selector(processUsersSelection:)])
                    [mAlertViewDelegate processUsersSelection:USER_SELECTION_OK];
            break;

           case ALERTVIEW_LOADING:
            break;
        }

    }
    else  //Press Yes Button
    {
        switch (alertViewType)
        {
                
            case ALERTVIEW_MESSAGE_YESNO:
            {
                if(mAlertViewDelegate && [mAlertViewDelegate respondsToSelector:@selector(processUsersSelection:)])
                    [mAlertViewDelegate processUsersSelection:USER_SELECTION_YES];
            }
            break;
                            
            case ALERTVIEW_LOADING:
            break;
        }
        
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];

}
//iOS 8+
-(void)alertActionPressedWithIndexZero:(BOOL)isButtonPressed
{
    
    if(isButtonPressed) //Press No Button
    {
        switch (alertViewType)
        {
            case ALERTVIEW_MESSAGE_YESNO:
                
                if(mAlertViewDelegate && [mAlertViewDelegate respondsToSelector:@selector(processUsersSelection:)])
                    [mAlertViewDelegate processUsersSelection:USER_SELECTION_NO];
                break;
                
            case ALERTVIEW_MESSAGE_OK:
                
                if(mAlertViewDelegate && [mAlertViewDelegate respondsToSelector:@selector(processUsersSelection:)])
                    [mAlertViewDelegate processUsersSelection:USER_SELECTION_OK];
                break;
                
            case ALERTVIEW_LOADING:
                break;
        }
        
    }
    else  //Press Yes Button
    {
        switch (alertViewType)
        {
                
            case ALERTVIEW_MESSAGE_YESNO:
            {
                if(mAlertViewDelegate && [mAlertViewDelegate respondsToSelector:@selector(processUsersSelection:)])
                    [mAlertViewDelegate processUsersSelection:USER_SELECTION_YES];
            }
                break;
                
            case ALERTVIEW_LOADING:
                break;
        }
        
    }

}
// Called when a button is clicked in UIAlertController. The view will be automatically dismissed after this call returns

/**
 * Dismisses dialog
 * 
 */
-(void)hideDialog
{
    [[SmartUIUtility sharedInstance] hideActivityView];
}

/**
 * Updates the text on the dialog with the text provided
 * 
 * @param message
 *            : Message which will replace existing message on the dialog
 * */
-(void)updateDialogText:(NSString*)message
{
    [[SmartUIUtility sharedInstance] setActivityMessage:message];
}



@end
