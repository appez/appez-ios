//
//  SmartUIUtility.m
//  appez
//
//  Created by Transility on 2/29/12.
//

#import "SmartUIUtility.h"
#import "AppUtils.h"
#import "SmartMapViewController.h"
#import "SmartDirectionViewController.h"
#import "AppStartupManager.h"
#import "MenuInfoBean.h"
#import "SmartNotificationDelegate.h"
#import "SmartConstants.h"
#import "CoEvents.h"
#import "SmartViewController.h"
#import "SmartSignatureViewController.h"

static SmartUIUtility *sharedInstance;

@interface SmartUIUtility(PrivateMethod)
-(void)showMapViewOnMainThread:(NSString*)mapData;

@end

@implementation SmartUIUtility
@synthesize viewController;
@synthesize delegate;
@synthesize signVc;
@synthesize actionSheet=_actionSheet;

/**
 Getting new instance of the SmartUIUtility
 */
+(SmartUIUtility*)sharedInstance
{
    @synchronized(sharedInstance)
    {

        if(sharedInstance==nil)
        {
            sharedInstance=[[SmartUIUtility alloc] init];
        }
        return sharedInstance;
    }
    
    return nil;
}

+(void)tear
{
    if(sharedInstance!=nil)
    {
      //[sharedInstance release];
        sharedInstance=nil;  
    }
    
}

/**
 Method to show the pop up view of a particular size(height, width) on any other view
 */
-(void)showPopOverFromRect:(CGRect)rect WithView:(UIView*)popUpView 
{
    [self hidePopOver];
    
    UIViewController *pViewController=self.viewController;//[[[UIViewController alloc] init] autorelease];
    pViewController.view=popUpView;
    pViewController.contentSizeForViewInPopover=CGSizeMake(320,260);
    popOverController = [[UIPopoverController alloc] initWithContentViewController:pViewController];
    popOverController.delegate=self;
    [popOverController presentPopoverFromRect:CGRectMake(260,-260,320,260)
                                                             inView:((UIViewController*)delegate).view
                                           permittedArrowDirections:UIPopoverArrowDirectionAny
                                                           animated:YES];
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

- (void)popoverControllerDidDismissPopover:(id)popoverController
{
    [AppUtils showDebugLog:@"pop over did dismiss"];
}

/**
* Method to hide the popUp view
 */
-(void)hidePopOver
{
    if(popOverController!=nil)
    {
        [popOverController dismissPopoverAnimated:YES];
        popOverController=nil;
    }
}


//-------------------------------------------------------------------------------------------------------------------
/**
Method to show the Activity indicator view with the custom message provided by the framework user in api call.
*/
-(void)showActivityViewWithMessage:(NSString*)msgStr 
{
    [self hideActivityView];
    [AppUtils showDebugLog:@"inside show activity"];
    loadingView =(LoadingView*) [[[AppUtils getBundlePath] loadNibNamed:[AppUtils getXibWithName:@"LoadingView"] owner:nil options:nil]objectAtIndex:0];
    loadingView.alpha=0.8;
    
    if(delegate){
        UIViewController *controller=(UIViewController*)delegate;
        loadingView.frame=controller.view.frame;
     
        [((UIViewController*)delegate).view addSubview:loadingView];
    }
    if([AppUtils isDeviceiPad] == TRUE )
    {
        [delegate setActivityViewOrientaion];  //TODO
    }
    
    loadingView.waitLabel.text = msgStr;
    [loadingView startAnimation];
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents] == FALSE)
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
}
//-------------------------------------------------------------------------------------------------------------------
/**
 Method to hide the activity view
 */
-(void)hideActivityView
{
    if(loadingView && [loadingView respondsToSelector:@selector(stopAnimation)])
    {
        [loadingView stopAnimation];
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents] == TRUE)
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
}
//-------------------------------------------------------------------------------------------------------------------
/**
 Method to show the progress indicator at the navigation bar whenever user of the framework requires it to be shown.
 */
-(void)showIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=TRUE;
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents] == FALSE)
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}
//-------------------------------------------------------------------------------------------------------------------

/**
 Method to hide the indicator
 */
-(void)hideIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=FALSE;
    
    if([[UIApplication sharedApplication] isIgnoringInteractionEvents] == TRUE)
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

}
//-------------------------------------------------------------------------------------------------------------------
-(void)setActivityMessage:(NSString*)msgStr
{
    loadingView.waitLabel.text = msgStr;
}
-(void)adjustLayoutOnOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(loadingView!=nil)
        [loadingView adjustLayoutOnOrientation:interfaceOrientation];
}

#pragma 
#pragma mark- Date Picker
#pragma 
-(void)showDatePickerWithDelegate:(id)aDelegate
{
   [self hideDatePicker];
    
   
    datePicker = (SmartDatePickerView*) [[[AppUtils getBundlePath]  loadNibNamed:[AppUtils getXibWithName:@"SmartDatePickerView"] owner:nil options:nil]objectAtIndex:0];
    datePicker.delegate = aDelegate;
    if([AppUtils getSystemVersion]>=7.0)
    datePicker.toolBar.barStyle=UIBarStyleDefault;
    UIWindow *window=[((UIViewController*)delegate).view window];

    //TODO : uncomment this code to support popoverview controller on ipad
        if([AppUtils isDeviceiPad])
        {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            
            if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation]))
            {
                if([AppUtils getSystemVersion]<8.0)
                     datePicker.center=CGPointMake(screenRect.size.height/2,screenRect.size.width/2);
                else
                    datePicker.center=CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
            }
            else
                datePicker.center=CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    
            
            NSLog(@"width %f height %f",screenRect.size.width,screenRect.size.height);
            [((UIViewController*)delegate).view addSubview:datePicker];
        }
        else
        {
            datePicker.frame=CGRectMake(0,window.frame.size.height,datePicker.frame.size.width,datePicker.frame.size.height);
            [window addSubview:datePicker];
            [UIView beginAnimations:nil context:nil];
            datePicker.frame=CGRectMake(0,datePicker.frame.origin.y-datePicker.frame.size.height,datePicker.frame.size.width,datePicker.frame.size.height);
            [UIView setAnimationDuration:1.0];
            [UIView commitAnimations];
    }
}
-(void)hideDatePicker
{
    if (datePicker){
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0];
        
        UIWindow *window=[((UIViewController*)delegate).view window];
        
        [UIView commitAnimations];
        
        datePicker.frame=CGRectMake(0,window.frame.size.height,datePicker.frame.size.width,datePicker.frame.size.height);
        
        
        [datePicker removeFromSuperview];
        datePicker = nil;

    }
}

-(void)showCustomDatePickerWithDelegate:(id)aDelegate
{
    [self hideCustomDatePicker];
    customDatePicker = (SmartCustomDatePickerView*) [[[AppUtils getBundlePath]  loadNibNamed:[AppUtils getXibWithName:@"SmartCustomDatePickerView"] owner:nil options:nil]objectAtIndex:0];
    customDatePicker.delegate = aDelegate;
    CGRect pickerFrame=customDatePicker.datePicker.frame;
    
        customDatePicker.datePicker.frame=CGRectMake(pickerFrame.origin.x,pickerFrame.origin.y,pickerFrame.size.width,90);
        
        UIWindow *window=[((UIViewController*)delegate).view window];
        
        customDatePicker.frame=CGRectMake(0,window.frame.size.height,customDatePicker.frame.size.width,customDatePicker.frame.size.height);
    
        [window addSubview:customDatePicker];
        
        [UIView beginAnimations:nil context:nil];
        
        customDatePicker.frame=CGRectMake(0,customDatePicker.frame.origin.y-customDatePicker.frame.size.height,customDatePicker.frame.size.width,customDatePicker.frame.size.height);
        
        [UIView setAnimationDuration:1.0];
        [UIView commitAnimations];

}
-(void)hideCustomDatePicker
{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0];
        
        UIWindow *window=[((UIViewController*)delegate).view window];
        
        [UIView commitAnimations];
        
        customDatePicker.frame=CGRectMake(0,window.frame.size.height,customDatePicker.frame.size.width,customDatePicker.frame.size.height);
        
        [customDatePicker removeFromSuperview];
        customDatePicker = nil;
}

-(void)customizeMultiSelectionViewForIos7
{
    multiSelector.backgroundColor=[UIColor clearColor];
    [multiSelector.okButton.imageView removeFromSuperview];
    [multiSelector.cancelButton.imageView removeFromSuperview];
    [multiSelector.okButton setTitle:@"OK" forState:UIControlStateNormal];
    [multiSelector.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    if(![AppUtils isDeviceiPad])
    {
        multiSelector.okButton.frame=CGRectMake(10.0, 355.0, 135.0,55.0);
        multiSelector.cancelButton.frame=CGRectMake(140.0, 355.0, 135.0,55.0);
    }
    else
    {
        //multiSelector.okButton.frame=CGRectMake(215.0, 604.0, 135.0, 55.0);
       // multiSelector.cancelButton.frame=CGRectMake(360.0, 604.0, 135.0,55.0);
    }
    [multiSelector.okButton setTitleColor:multiSelector.smartList.tintColor forState:UIControlStateNormal];
    [multiSelector.cancelButton setTitleColor:multiSelector.smartList.tintColor forState:UIControlStateNormal];
    multiSelector.frameImage.image= [UIImage imageWithContentsOfFile:[[AppUtils getBundlePath].bundlePath stringByAppendingPathComponent:@"customframe7.png"]];
}

-(void)customizeSingleSelectionViewForIos7
{
    [messagePicker.okButton.imageView removeFromSuperview];
    [messagePicker.cancelButton.imageView removeFromSuperview];
    [messagePicker.okButton setTitle:@"OK" forState:UIControlStateNormal];
    [messagePicker.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    if(![AppUtils isDeviceiPad])
    {
        messagePicker.okButton.frame=CGRectMake(10.0, 355.0, 135.0,55.0);
        messagePicker.cancelButton.frame=CGRectMake(140.0, 355.0, 135.0,55.0);
    }
    else
    {
        //multiSelector.okButton.frame=CGRectMake(215.0, 604.0, 135.0, 55.0);
        //multiSelector.cancelButton.frame=CGRectMake(360.0, 604.0, 135.0,55.0);
    }
    
    [messagePicker.okButton setTitleColor:messagePicker.tintColor forState:UIControlStateNormal];
    [messagePicker.cancelButton setTitleColor:messagePicker.tintColor forState:UIControlStateNormal];
}


-(void)showMultiSelectionListWithDelegate:(id)aDelegate WithMessage:(NSString *)messageList
{
    NSString *bgImageName=NULL;
    multiSelector= (SmartMultiSelectionListView*) [[[AppUtils getBundlePath]  loadNibNamed:[AppUtils getXibWithName:@"SmartMultiSelectionListView"] owner:nil options:nil]objectAtIndex:0];
    NSString *resourcePath=[AppUtils getBundlePath].bundlePath;

    if([AppUtils getSystemVersion]>=7.0)
    {
        bgImageName=[NSString stringWithFormat:@"pickerbackground7.png"];
        [self customizeMultiSelectionViewForIos7];
    }
    else
    {
        bgImageName=[NSString stringWithFormat:@"pickerbackground.png"];
        multiSelector.frameImage.image=[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"customframe.png"]];
    }
    NSString *imagePath=[resourcePath stringByAppendingPathComponent:bgImageName];
    multiSelector.backgroundColor=[UIColor clearColor];
    multiSelector.backgroundImage.image=[UIImage imageWithContentsOfFile:imagePath];
    multiSelector.delegate=aDelegate;
    multiSelector.message=messageList;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation]))
    {
        if([AppUtils getSystemVersion]<8.0)
            multiSelector.center=CGPointMake(screenRect.size.height/2,screenRect.size.width/2);
        else
            multiSelector.center=CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    }
    else
        multiSelector.center=CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    
    //multiSelector.center=CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    [multiSelector processSelectionListItems:multiSelector.message];
    if(delegate)
    [((UIViewController*)delegate).view addSubview:multiSelector];
}
#pragma
#pragma mark- Action Sheet
#pragma
-(void)showSmartMessagePickerWithDelegate:(id)aDelegate WithMessage:(NSString*)messageList
{
    NSString *bgImageName=NULL;
    [self hideSmartMessagePicker];
    messagePicker = (SmartMessagePickerView*) [[[AppUtils getBundlePath]  loadNibNamed:[AppUtils getXibWithName:@"SmartMessagePickerView"] owner:nil options:nil]objectAtIndex:0];
    NSString *resourcePath=[AppUtils getBundlePath].bundlePath;
    
    if([AppUtils getSystemVersion]>=7.0)
    {
        bgImageName=[NSString stringWithFormat:@"pickerbackground7.png"];
        [self customizeSingleSelectionViewForIos7];
    }
    else
        bgImageName=[NSString stringWithFormat:@"pickerbackground.png"];
    
    NSString *imagePath=[resourcePath stringByAppendingPathComponent:bgImageName];
    messagePicker.backgroundImage.image=[UIImage imageWithContentsOfFile:imagePath];
    messagePicker.delegate = aDelegate;
    messagePicker.message=messageList;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication]statusBarOrientation]))
    {
        if([AppUtils getSystemVersion]<8.0)
            messagePicker.center=CGPointMake(screenRect.size.height/2,screenRect.size.width/2);
        else
            messagePicker.center=CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    }
    else
        messagePicker.center=CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    
    //messagePicker.center=CGPointMake(screenRect.size.width/2,screenRect.size.height/2);
    [messagePicker processSelectionListItemInfo:messagePicker.message];
    if(delegate)
        [((UIViewController*)delegate).view addSubview:messagePicker];
}

-(void)hideSmartMessagePicker
{
    if(messagePicker)
    {        
        [messagePicker removeFromSuperview];
         messagePicker = nil;
    }
}

-(void)hideMultiSelector
{
    if(multiSelector)
    {
        [multiSelector removeFromSuperview];
        multiSelector=nil;
    }
}

#pragma
#pragma mark- MapView
#pragma

-(void)showMapView:(NSString*)mapData WithDelegate:(id<SmartCoActionDelegate>)smartDelegate WithAnimation:(BOOL)animation WithDirection:(BOOL)direction
{
    NSMutableArray *mapArray=[NSMutableArray array];
    [mapArray addObject:mapData];
    [mapArray addObject:smartDelegate];
    [mapArray addObject:[NSNumber numberWithBool:animation]];
    [mapArray addObject:[NSNumber numberWithBool:direction]];
    if ([NSThread isMainThread])
    {
        [self showMapViewOnMainThread:mapArray];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMapViewOnMainThread:mapArray];
        });
    }
}

-(void)showMapViewOnMainThread:(NSMutableArray*)mapData
{
    SmartMapViewController *mapVC=[[SmartMapViewController alloc] initWithNibName:[AppUtils getXibWithName:@"SmartMapViewController"] bundle:[AppUtils getBundlePath]] ;
    mapVC.mapData=[NSString stringWithFormat:@"%@",[mapData objectAtIndex:0]] ;
    mapVC.delegate=[mapData objectAtIndex:1];
    [mapVC configureBackButton];
    mapVC.title=@"Map";
    if([[mapData objectAtIndex:2] boolValue]==TRUE)
    {
       mapVC.showAnimation=TRUE;
       [((UIViewController*)delegate).navigationController pushViewController:mapVC animated:YES];
       
       if( [[[AppUtils getDictionaryFromJson:mapVC.mapData] valueForKey:MMI_REQUEST_PROP_ANIMATION_TYPE] intValue]==ANIMATION_CURL_PLAY)
           [AppUtils curlUpAnimationForView:((UIViewController*)delegate).navigationController.view];
       else if(( [[[AppUtils getDictionaryFromJson:mapVC.mapData] valueForKey:MMI_REQUEST_PROP_ANIMATION_TYPE] intValue]==ANIMATION_FLIP_PLAY))
           [AppUtils flipFromLeftAnimationForView:((UIViewController*)delegate).navigationController.view];
       else
           [AppUtils showDebugLog:@"Show Map view, invalid case of animation"];
   }
    else
    {
       if([[mapData objectAtIndex:3] boolValue]==TRUE)
           mapVC.showAccessoryButton=TRUE;
       else
           mapVC.showAccessoryButton=FALSE;
       [((UIViewController*)delegate).navigationController pushViewController:mapVC animated:TRUE];
   }
    
    [[SmartUIUtility sharedInstance] hideActivityView];
    [[SmartUIUtility sharedInstance] hideIndicator];
}

-(void)showDirectionViewWithLocation:(CLLocationCoordinate2D)currentCoordinate WithLocation:(CLLocationCoordinate2D)selectedCoordinate
{
    SmartDirectionViewController *directionVC=[[SmartDirectionViewController alloc] initWithNibName:[AppUtils getXibWithName:@"SmartDirectionViewController"] bundle:[AppUtils getBundlePath]] ;
    directionVC.currentLocation=currentCoordinate;
    directionVC.selectedLocation=selectedCoordinate;
    [((UIViewController*)delegate).navigationController pushViewController:directionVC animated:TRUE];
   

}

#pragma
#pragma mark- Action Sheet
#pragma

-(void)showAction:(NSString*)actionData
{
    UIViewController *alertController=nil;//iOS 8+
    NSArray *menuInfoArray=[actionData valueForKey:MENU_INFO_KEY];//[[AppUtils getDictionaryFromJson:actionData]valueForKey:MENU_INFO_KEY];
    //Parsing the title to be shown
    NSString *actionTitle=[actionData valueForKey:MENU_TITLE];
    NSInteger itemsCount=menuInfoArray.count;
    if(itemsCount>0)
    {
       
        if(NSClassFromString(@"UIAlertController"))             //iOS 8+
        {
            NSLog(@"------UIAlertController is presented ------");

            alertController=[UIAlertController alertControllerWithTitle:actionTitle message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelButton=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [(UIAlertController*)alertController addAction:cancelButton];
        }
        else                        //<iOS 8
        {
            _actionSheet=[[UIActionSheet alloc] initWithTitle:actionTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
            ((SmartViewController*)delegate).containedActionSheet=_actionSheet;
            
        }
       
        NSMutableArray *menuInfoBeanCollection=[AppStartupManager getMenuInfoCollection];

        for (int actionIndex=0;actionIndex<itemsCount;actionIndex++) {
           
            NSString *menuId=[[menuInfoArray objectAtIndex:actionIndex] valueForKey:MENUS_CREATION_PROPERTY_ID];
           
            if(menuInfoBeanCollection!=nil && (menuInfoBeanCollection.count>0))
            {
             
                for (int menuCollectionIndex=0;menuCollectionIndex<menuInfoBeanCollection.count;menuCollectionIndex++)
                {
                    if ([menuId isEqualToString:[[menuInfoBeanCollection objectAtIndex:menuCollectionIndex] menuId]])
                    {
                        MenuInfoBean *menuInfoBean=[menuInfoBeanCollection objectAtIndex:menuCollectionIndex];
                        if(alertController!=nil) //iOS 8+
                        {
                            UIAlertAction *actionSheetButton=[UIAlertAction actionWithTitle:menuInfoBean.menuLabel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                id<SmartNotificationDelegate> adelegate=delegate;
                                if (adelegate && [adelegate conformsToProtocol:@protocol(SmartNotificationDelegate)])
                                {
                                    [delegate sendActionInfo:menuInfoBean.menuId];
                                }

                            }];
                            
                            [(UIAlertController*)alertController addAction:actionSheetButton];
                        }
                        else
                        {
                        [_actionSheet addButtonWithTitle:menuInfoBean.menuLabel];
                        }
                            break;
                    }
                }
            }
        }
    if(alertController)
    {
        UIPopoverPresentationController *popover = alertController.popoverPresentationController;
        
        if (popover)
        {
            // Remove arrow from action sheet.
            [alertController.popoverPresentationController setPermittedArrowDirections:0];
            UIViewController *parentViewController=(UIViewController*)delegate;
            UIView *parentView=parentViewController.view;
            //For set action sheet to middle of view.
            CGRect rect=[UIApplication sharedApplication].keyWindow.screen.bounds;
            alertController.popoverPresentationController.sourceView = parentView;
            alertController.popoverPresentationController.sourceRect = rect;
        }
        
        [(UIViewController*)delegate presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        _actionSheet.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [_actionSheet setAutoresizesSubviews:YES];
        dispatch_queue_t mainQueue=dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
                [_actionSheet showInView:((UIViewController*)delegate).view];
            });
    }
    }
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    id<SmartNotificationDelegate> adelegate=delegate;
   
    if(buttonIndex>0)
    {
        NSMutableArray *menuInfoBeanCollection=[AppStartupManager getMenuInfoCollection];
        
        MenuInfoBean *menuInfoBean=[menuInfoBeanCollection objectAtIndex:buttonIndex-1];
        
        if (adelegate && [adelegate conformsToProtocol:@protocol(SmartNotificationDelegate)])
        {
            [delegate sendActionInfo:menuInfoBean.menuId];
        }
    }
}

-(void)showSignatureView:(NSString *)requestData WithImageSaveFlag:(BOOL)shouldSaveSignature andWithDelegate:(id<SmartSignatureDelegate>)signatureDelegate
{
    NSMutableArray *signParamArray=[NSMutableArray array];
    [signParamArray addObject:[NSNumber numberWithBool:shouldSaveSignature]];
    [signParamArray addObject:requestData];
    [signParamArray addObject:signatureDelegate];
   // [self performSelectorOnMainThread:@selector(showSignatureViewOnMainThread:) withObject:signParamArray waitUntilDone:YES];
    
    if ([NSThread isMainThread])
    {
        [self showSignatureViewOnMainThread:signParamArray];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self showSignatureViewOnMainThread:signParamArray];
        });
    }
}

-(void)showSignatureViewOnMainThread:(NSMutableArray*)signatureParams
{
    signVc=[[SmartSignatureViewController alloc]initWithNibName:[AppUtils getXibWithName:@"SmartSignatureViewController"] bundle:[NSBundle mainBundle]];
    signVc.shouldSaveSignature=[[signatureParams objectAtIndex:0] boolValue];
    signVc.signingParameters=[signatureParams objectAtIndex:1];
    signVc.delegate=[signatureParams objectAtIndex:2];
    signVc.title=@"Signature";
    UIViewController *smViewController=(UIViewController*)delegate;
    UIView *currentView=smViewController.view;
    [currentView addSubview:signVc.view];
}


@end
