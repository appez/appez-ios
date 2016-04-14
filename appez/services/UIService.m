//
//  UIService.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "UIService.h"
#import "WebEvents.h"
#import "SmartUIUtility.h"
#import "ExceptionTypes.h"
#import "AppUtils.h"

@interface UIService(PrivateMethods)
-(void)hideProgressDialog;
-(void)updateProcessDialogMessage:(NSString*)updatedMessage;
-(void)startLoading:(NSString*)mStrStatusMessage;
-(void)createDialogWithType:(int)type WithMessage:(NSString*)message;
-(void)notifyUiResponseWithValue:(NSString*)value;
@end

@implementation UIService

-(instancetype)initWithDelegate:(id<SmartServiceDelegate>)delegate
{
    self = [super init];
    if (self) {
        
        smartServiceDelegate=delegate;
        mAlertView=[[AlertView alloc] initWithAlertViewDelegate:self];

    }
    return self;
}


/*Creates the response to be generated corresponding to each case of Ui Service Type and does completion with success
*/

-(void)notifyUiResponseWithValue:(NSString*)value
{
    @try {
        NSMutableDictionary *activityIndicatorResponse=[[NSMutableDictionary alloc]init] ;
        [activityIndicatorResponse setValue:value forKey:MMI_RESPONSE_PROP_USER_SELECTION];
        NSString *uiResponse=[AppUtils getJsonFromDictionary:activityIndicatorResponse];
        [self didCompleteUiOperationWithSuccess:uiResponse];
        
    }@catch (NSException *e) {
        [self didCompleteUiOperationWithError:[UNKNOWN_EXCEPTION intValue]  andMessage:nil];
    }
}

/**
 * Performs UI action based on SmartEvent action type
 * 
 * @param smartEvent
 *            : SmartEvent specifying action type for the UI action
 */
-(void)performAction:(SmartEvent *)smartevent
{
    @try {
       
        NSDictionary *messageDictionary=smartevent.smartEventRequest.serviceRequestData;
        NSString *message=[messageDictionary valueForKey:MMI_REQUEST_PROP_MESSAGE];
        switch (smartevent.smartEventRequest.serviceOperationId)
        {
        case WEB_SHOW_ACTIVITY_INDICATOR: 
            {
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    [self startLoading:message];
                    currentEvent=smartevent;
                    [self notifyUiResponseWithValue:@"null"];
                });
            }
            break;
            
        case WEB_HIDE_ACTIVITY_INDICATOR: 
        
            {
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    [self hideProgressDialog];
                    currentEvent=smartevent;
                    [self notifyUiResponseWithValue:@"null"];
                });
            }
            
            break;
            
        case WEB_UPDATE_LOADING_MESSAGE:
                
            {
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    [self updateProcessDialogMessage:message];
                    currentEvent=smartevent;
                     [self notifyUiResponseWithValue:@"null"];
                });
            }
                break;
            
        case WEB_SHOW_MESSAGE:
           
            {
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    [self createDialogWithType:ALERTVIEW_MESSAGE_OK WithMessage:message];
                    currentEvent = smartevent;
                });
            }
            break;
            
        case WEB_SHOW_MESSAGE_YESNO:
            {
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    [self createDialogWithType:ALERTVIEW_MESSAGE_YESNO WithMessage:message];
                    currentEvent = smartevent;
                });
            }
                break;
            
        case WEB_SHOW_DATE_PICKER:
            {
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    [[SmartUIUtility sharedInstance] showDatePickerWithDelegate:self];
                    currentEvent = smartevent;
                });
            }
            break;
        
        case WEB_SHOW_INDICATOR:
            {
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    [[SmartUIUtility sharedInstance] showIndicator];
                    [self notifyUiResponseWithValue:@"null"];
                });
            }
            break;
            
            
        case WEB_HIDE_INDICATOR:
        
           [[SmartUIUtility sharedInstance] hideIndicator];
           [self notifyUiResponseWithValue:@"null"];
            break;
            
        case WEB_SHOW_DIALOG_MULTIPLE_CHOICE_LIST_CHECKBOXES:
            {
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_sync(mainQueue, ^{
                    [[SmartUIUtility sharedInstance] showMultiSelectionListWithDelegate:self WithMessage:message];
                    currentEvent = smartevent;
                });
            }
            break;
        case WEB_SHOW_DIALOG_SINGLE_CHOICE_LIST_RADIO_BTN:
        case WEB_SHOW_DIALOG_SINGLE_CHOICE_LIST:
            if(message==nil){
            message=UNABLE_TO_PROCESS_MESSAGE;
            }
                dispatch_queue_t mainQueue=dispatch_get_main_queue();
                dispatch_sync(mainQueue, ^{
                    [[SmartUIUtility sharedInstance] showSmartMessagePickerWithDelegate:self WithMessage:message];
                    currentEvent = smartevent;
                });
            break;
        }

    }@catch (NSException *e) {
        [AppUtils showDebugLog:[NSString stringWithFormat:@"exception in UI is %@",[e description]]];
        [self didCompleteUiOperationWithError:UNKNOWN_EXCEPTION.intValue andMessage:nil];
    }
}

-(void)hideProgressDialog
{
    [mAlertView hideDialog];
}

-(void)updateProcessDialogMessage:(NSString*)updatedMessage
{
    [mAlertView updateDialogText:updatedMessage];
}

-(void)startLoading:(NSString*)mStrStatusMessage
{
    [mAlertView  showAlertViewWithType:ALERTVIEW_LOADING WithMessage:mStrStatusMessage];
}

-(void)createDialogWithType:(int)type WithMessage:(NSString*)message
{
    [mAlertView showAlertViewWithType:type WithMessage:message];
}

/**
 * Specifies action to be performed on the basis of user selection on native
 * components
 * 
 * @param userSelection
 *            : Value of user selection
 */
-(void)processUsersSelection:(NSString*)userSelection 
{
    [self notifyUiResponseWithValue:userSelection];
}
/**
 * Specifies action to be performed on the basis of user selection on native
 * components
 * 
 * @param date
 *            : Value of Date Picker selection
 */

-(void)processUsersSelectedDate:(NSString *)date
{
    @try {
         [[SmartUIUtility sharedInstance] hideDatePicker];

        [self notifyUiResponseWithValue:date];
       
    }@catch (NSException *e) {
    
        [self didCompleteUiOperationWithError:UNKNOWN_EXCEPTION.intValue andMessage:nil];
}
}

-(void)processUsersCustomSelectedDate:(NSString*)date
{
    @try {
        [[SmartUIUtility sharedInstance] hideCustomDatePicker];

        [self notifyUiResponseWithValue:date];

    }@catch (NSException *e) {
             [self didCompleteUiOperationWithError:UNKNOWN_EXCEPTION.intValue andMessage:nil];
        }
}

/**
 * Specifies action to be performed on the basis of user selection on native
 * components
 *
 * @param index
 *            : Value of user selection
 */
-(void)processUsersSelectedIndex:(NSString*)index
{
    @try {
        
         [[SmartUIUtility sharedInstance] hideSmartMessagePicker];
         [self notifyUiResponseWithValue:index];
        
    }@catch (NSException *e) {
        [self didCompleteUiOperationWithError:UNKNOWN_EXCEPTION.intValue andMessage:nil];
    }
}

-(void)didCompleteUiOperationWithError:(int)exceptionType andMessage:(NSString *)exceptionMessage
{
    SmartEventResponse *smEventResponse=[AppUtils createErrorResponseWithExceptionType:exceptionType andExceptionMessage:exceptionMessage];
    currentEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:currentEvent];
}
-(void)didCompleteUiOperationWithSuccess:(NSString *)jsonResponse

{
    SmartEventResponse *smEventResponse=[AppUtils createSuccessResponseWithserviceResponse:jsonResponse];
    currentEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:currentEvent];
}

@end
