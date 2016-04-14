//
//  SmartSplitViewController.m
//  SmartSplitView
//
//  Created by Transility on 7/18/12.
//

#import "SmartSplitViewController.h"
#import "AppEvents.h"
#import "SmartConstants.h"
#import "AppUtils.h"
#import "MobiletException.h"
#import "ExceptionTypes.h"
#import "SmartUIUtility.h"
#import "SmartView.h"

@interface SmartSplitViewController()
-(void)sendDataToMaster:(NSString*)data;
-(void)sendDataToDetail:(NSString*)data;
-(void)showPopOverViewController;
@end

@implementation SmartSplitViewController
@synthesize showPopOver;
@synthesize popOverContentSize;
@synthesize popOverPosition;


-(instancetype)initWithExtendedSplashMasterPageUri:(NSString*)masterPage WithDetailPageUri:(NSString*)detailPage
{
    if(![AppUtils isDeviceiPad])
        @throw [MobiletException MobiletExceptionWithType:DEVICE_SUPPORT_EXCEPTION Message:nil];
    
    if(masterPage==nil || detailPage==nil)
        @throw [MobiletException MobiletExceptionWithType:INVALID_PAGE_URI_EXCEPTION Message:nil];
    
    self = [super initWithNibName:@"SmartSplitViewController" bundle:[NSBundle mainBundle]];
    if (self)
    {
        masterUri =masterPage;
        detailUri =detailPage;
        showSplash=TRUE;
        self.popOverContentSize=POPOVER_CONTENT_SIZE;
        self.popOverPosition=POPOVER_POSITION;
        self.showPopOver=TRUE;
    }
    return self;
    
}
-(instancetype)initWithMasterPageUri:(NSString*)masterPage WithDetailPageUri:(NSString*)detailPage
{
    if(masterPage==nil || detailPage==nil)
        @throw [MobiletException MobiletExceptionWithType:INVALID_PAGE_URI_EXCEPTION Message:nil];
    
    self = [super initWithNibName:@"SmartSplitViewController" bundle:[NSBundle mainBundle]];
    if (self)
    {
        masterUri =masterPage;
        detailUri =detailPage;
        showSplash=FALSE;
        self.popOverContentSize=POPOVER_CONTENT_SIZE;
        self.popOverPosition=POPOVER_POSITION;
        self.showPopOver=TRUE;
    }
    return self;

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SmartUIUtility sharedInstance] setDelegate:self];

    // Do any additional setup after loading the view from its nib.
    masterSmartView=(SmartView*)[[[AppUtils getBundlePath] loadNibNamed:@"MasterSmartView" owner:self options:nil] objectAtIndex:0];
    detailSmartView=(SmartView*)[[[AppUtils getBundlePath] loadNibNamed:@"DetailSmartView" owner:self options:nil] objectAtIndex:0];
    
    [self.view addSubview:masterSmartView];
    [self.view addSubview:detailSmartView];
    
    [masterSmartView initializeSmartView:showSplash];
    [detailSmartView initializeSmartView:showSplash];
    
    masterSmartView.delegate=self;
    detailSmartView.delegate=self;
    
    [masterSmartView registerAppDelegate:self];
    [detailSmartView registerAppDelegate:self];
    
    [masterSmartView loadWebContainerViewWithUri:[AppUtils getAbsolutePathForHtml:masterUri]];
    [detailSmartView loadWebContainerViewWithUri:[AppUtils getAbsolutePathForHtml:detailUri]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    }

- (void)viewDidUnload
{
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
// Notifies when rotation begins, reaches halfway point and ends.
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(showPopOver)
    {
        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            masterSmartView.frame = MasteriPadBoundsInPortriat;
            detailSmartView.frame = DetailiPadBoundsInPortriat;
            //Show Button in case of portrait
            [detailSmartView executeJavaScript:@"javascript:showButton();"];
        }
        else
        {
            masterSmartView.frame = MasteriPadBoundsInLandScape;
            detailSmartView.frame = DetailiPadBoundsInLandScape;
            
            [detailSmartView executeJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",704]];
            [masterSmartView executeJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",318]];
            //Hide Button in case of portrait
            [detailSmartView executeJavaScript:@"javascript:hideButton();"];
            //Reloading a webview on orientation change, webpage looking properly
            //Hide PopOver on Rotation
            [self hidePopOverViewController];
            
        }
    }
    else
    {
        if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            masterSmartView.frame = CGRectMake(0,0,200,1004);
            detailSmartView.frame = CGRectMake(200,0,468,1004);
            
            masterSmartView.webView.frame=CGRectMake(0,0,198,1004);
            masterSmartView.dividerImage.frame=CGRectMake(198,0,2,1004);
            //detailSmartView.webView.frame=CGRectMake(0,0,468,1004);
            
            [detailSmartView executeJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",468]];
            [masterSmartView executeJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",198]];
            // [detailSmartView executeJavaScript:@"javascript:showTabBarItem();"];
        }
        else
        {
            masterSmartView.frame = MasteriPadBoundsInLandScape;
            masterSmartView.webView.frame=CGRectMake(0,0,318,768);
            masterSmartView.dividerImage.frame=CGRectMake(318,0,2,768);
            detailSmartView.frame=DetailiPadBoundsInLandScape;
            //detailSmartView.webView.frame = CGRectMake(0,0,704,768);
            
            
            [detailSmartView executeJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",704]];
            [masterSmartView executeJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",318]];
        }
    }
	return YES;
}

//----------------------------------------------------------------------------------------------------------------------
#pragma 
#pragma mark - Webview Handling Methods
#pragma 

//----------------------------------------------------------------------------------------------------------------------
/** Specifies action to be taken when a notification is received from the JavaScript. 
 * Uses event data and notification received from JavaScript to determine action
 * 
 * @param eventData : Event data that determines specific action for any notification received from JavaScript
 * @param notification : Notification from JavaScript
 */
-(void)didReceiveSmartNotification:(NSString*)eventData WithNotification:(NSString*) notification
{
    switch (notification.intValue)
    {
        case APP_CONTROL_TRANSFER: 
        {
        }
            break;
    }
    
}
-(void)didReceiveDataNotification:(NSString*)notification  WithFileUrl:(NSString*)fromFile
{
    switch (notification.intValue)
    {
        case 0:
        {
            //Place your code here
        }
            break;
    }
}
-(void)didReceiveDataNotification:(NSString*)notification WithData:(NSData*)responseData
{
    switch (notification.intValue)
    {
        case 0:
        {
            //Place your code here
        }
        break;
    }
}

#pragma 
#pragma mark - Delegate
-(void)showPopOverViewController
{
    //code for showing popover controller
    if(popOverController==nil)
    {
        UIViewController *popVC=[[UIViewController alloc] init];
        popVC.view=masterSmartView;
        
        UIPopoverController *popover =  [[UIPopoverController alloc] initWithContentViewController:popVC]; 
        popover.delegate = self;
        
        popover.popoverContentSize =popOverContentSize;
        
        //[popVC release];
        //Adjust Content of webView
        [masterSmartView executeJavaScript:[NSString stringWithFormat:@"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",320]];
        
        popOverController=popover;
           
        [popover presentPopoverFromRect:popOverPosition inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
-(void)hidePopOverViewController
{
    if(popOverController!=nil)
    {
        [popOverController dismissPopoverAnimated:YES];
        popOverController=nil;
        [self.view addSubview:masterSmartView];
        masterSmartView.frame=MasteriPadBoundsInPortriat;
    }

}
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    popOverController=nil;
    [self.view addSubview:masterSmartView];
    masterSmartView.frame=MasteriPadBoundsInPortriat;
    return TRUE;
}

#pragma 
#pragma mark - DATA COMMUNICATION
-(void)sendDataToMaster:(NSString*)data
{
    [AppUtils showDebugLog:[NSString stringWithFormat:@"sendDataToMaster = %@",[NSString stringWithFormat:@"%@('%@')",JS_HANDLE_CONTEXT_MASTER,data]]];
    [self hidePopOverViewController];
    [masterSmartView executeJavaScript:[NSString stringWithFormat:@"%@('%@')",JS_HANDLE_CONTEXT_MASTER,data]];
}
-(void)sendDataToDetail:(NSString*)data
{
   [AppUtils showDebugLog:[NSString stringWithFormat:@"sendDataToDetail = %@",[NSString stringWithFormat:@"%@('%@')",JS_HANDLE_CONTEXT_DETAIL,data]]];
    [self hidePopOverViewController];
   [detailSmartView executeJavaScript:[NSString stringWithFormat:@"%@('%@')",JS_HANDLE_CONTEXT_DETAIL,data]];
  
}

@end
