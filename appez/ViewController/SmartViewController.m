//
//  SmartViewController.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "SmartViewController.h"
#import "SmartUIUtility.h"
#import "SmartAppDelegate.h"
#import "ExceptionTypes.h"
#import "MobiletException.h"
#import "SmartConstants.h"
#import "CoEvents.h"
#import "AppUtils.h"
#import "SmartTableView.h"
#import "NotifierMessageConstants.h"
#import "NotifierEventProcessor.h"
#import "NotifierEvent.h"
#import "NotifierConstants.h"
@interface SmartViewController(PrivateMethods)
-(void)notifyCoEvent:(SmartEvent*)smartEvent;
-(NSString*)notifyToJavaScript:(NSString*)javaScriptCallback WithArgument:(NSString*)jsNameToCallArgument;
-(NSString*)processJavaScriptCallback:(SmartEvent*)smartEvent;
-(void)toggleSplashScreen;
-(UIImage*)defaultImage;
-(void)notifyPageInit;
-(void)animationPlay:(NSString*)eventData WithType:(UIViewAnimationTransition)animation;
-(void)animationResumeWithType:(UIViewAnimationTransition)animation;
-(void)setActivityViewOrientaion;

@end

@implementation SmartViewController
@synthesize smartViewPrimary;
@synthesize splashImageView;
@synthesize htmlUri;
@synthesize smartConnector;
@synthesize orientation;
@synthesize menuInformation;
#pragma
#pragma UIView Methods
#pragma 
//-------------------------------------------------------------------------------------------------------------------------

-(instancetype)initWithExtendedSplashAndPageURI:(NSString *)uri
{
    NSString *xibName=[AppUtils getXibWithName:@"SmartViewController"];
    self = [super initWithNibName:xibName bundle:[AppUtils getBundlePath]];
    if (self)
    {
        self.htmlUri = uri;
        showSplash=TRUE;
        //To be called from client app [self initAppConfigInformation];
    
    }
    return self;
}

-(instancetype)initWithPageURI:(NSString *)uri
{
    NSString *xibName=[AppUtils getXibWithName:@"SmartViewController"];
    self = [super initWithNibName:xibName bundle:[NSBundle mainBundle]];
    if (self)
    {
        self.htmlUri = uri;
       //To be called from client app [self initAppConfigInformation];
    }
    return self;
}

/*Appliation level delegate methods*/

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    //Delegate method that will be called when the application will go in background.Write code here if needed for the case application goes in background.
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    [self notifyPageInit];
}

//-------------------------------------------------------------------------------------------------------------------------
//- (void)dealloc
//{
//    [htmlUri release];
//    if(smartConnector)
//    {
//        [smartConnector release];
//        smartConnector=nil;
//    }
//    
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
//     
//    FREE_NSOBJ(menuInformation);
//    [super dealloc];
//}
//-------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
//-------------------------------------------------------------------------------------------------------------------------#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppUtils showDebugLog:@"willAPperar"];
    if([AppUtils getSystemVersion]>=7.0)
    self.title=@" ";
    [[SmartUIUtility sharedInstance] setDelegate:self];

    if(self.navigationController)
        self.navigationController.navigationBarHidden=TRUE;
    
//    NSString *topBarbgColor=[AppStartupManager getTopbarStylingInfoBean].topbarBgColor;
//    if(topBarbgColor!=nil){
//        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, -20)];
//        statusBarView.backgroundColor = [AppUtils colorFromHexString:topBarbgColor];
//        [self.view addSubview:statusBarView];
//        [statusBarView release];
//    }
}

-(void)notifyPageInit
{
    NSString *notificationMethod = JS_NOTIFICATION_FROM_NATIVE;
    NSString *notificationArgument =[NSString stringWithFormat:@"%d",NATIVE_EVENT_PAGE_INIT_NOTIFICATION];
    NSString *notifyJavaScript=[self notifyToJavaScript:notificationMethod WithArgument:notificationArgument];
   //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:notifyJavaScript waitUntilDone:YES];
    if ([NSThread isMainThread])
    {
        [self executeJavaScript:notifyJavaScript];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self executeJavaScript:notifyJavaScript];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    [smartViewPrimary setDelegate:self];
    [self configureBackButton];
    self.orientation=UIInterfaceOrientationPortrait;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(orientationChanged:)
     
                                                 name:UIDeviceOrientationDidChangeNotification
     
                                               object:nil];
    //Register the view controller for the application lifecycle events for going in background and coming to foreground.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[self.smartViewPrimary.subviews objectAtIndex:0] setScrollEnabled:YES];  //to stop scrolling completely
    [[self.smartViewPrimary.subviews objectAtIndex:0] setBounces:NO]; //to stop bouncing
    
    smartConnector = [[MobiletManager alloc] initSmartConnectorWithDelegate:self];
    
    smartViewCurrent=self.smartViewPrimary;
    
    [self toggleSplashScreen];
    
    if (![self.htmlUri isEqualToString:@""])
    {
        self.htmlUri=[[AppUtils getAbsolutePathForFile:self.htmlUri] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",self.htmlUri);
        [self loadWebContainerView];
    }
    else
    {
        [AppUtils showDebugLog:@"No Url entered to show on the web page."];
    }
}

//Code to manage status bar style
- (UIStatusBarStyle)preferredStatusBarStyle
{
    NSString *topBarTextColor=[AppStartupManager getTopbarStylingInfoBean].topbarTextColor;
    if([topBarTextColor isEqualToString:@"#FFFFFF"])
    {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

//Setting the orientation of the activity view
-(void)setActivityViewOrientaion
{
    [[SmartUIUtility sharedInstance] adjustLayoutOnOrientation:self.orientation];
}

-(void)configureBackButton
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init] ;
    if([AppUtils getSystemVersion]>=7.0)
       barButtonItem.title=@"";
    else
        barButtonItem.title=@"Back";
    
    self.navigationItem.backBarButtonItem = barButtonItem;
    //[barButtonItem release];
}

-(void)toggleSplashScreen
{
    if(showSplash)
    {
        showSplash=FALSE;
        smartViewCurrent.hidden=true;
        splashImageView.hidden=FALSE;
        if(splashImageView.image==nil)
            splashImageView.image=[self defaultImage];
    }
    else
    {
        NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        if ([[vComp objectAtIndex:0] intValue] >= 7) {
            CGRect viewBounds = self.view.bounds;
            CGFloat topBarOffset =20.0;
            viewBounds.origin.y = -topBarOffset;
            self.view.bounds = viewBounds;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

        splashImageView.hidden=TRUE;
        smartViewCurrent.hidden=FALSE;
    }
}
-(UIImage*)defaultImage
{
    UIImage *image=nil;
    
    if([AppUtils isDeviceiPad] == TRUE)
    {
        //The change is made to check current device orientation because current one is supported in both ios7 and ios8.Commented was only givin true result on ios7 not on ios8.
        //if(UIInterfaceOrientationIsLandscape(self.orientation))
        if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            image=[UIImage imageNamed:DEFAULT_BACKGROUND_LANDSCAPE];
        }
        else //if(UIInterfaceOrientationIsPortrait(self.orientation))
        {
            image=[UIImage imageNamed:DEFAULT_BACKGROUND_PORTRAIT];
        }
    }
    else
    {
        if([AppUtils isDeviceiPhone5])
        {
            image=[UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE5G];
        }
        else
        {
            image=[UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE];
        }
    }

    if(image!=nil)
        return image;
    else
    {
        image=[UIImage imageNamed:DEFAULT_appez_IMAGE];
        return image;
    }
}

- (void)viewDidUnload
{
    [self setSplashImageView:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
}

//This method is called when the device orientation is changed
- (void)orientationChanged:(NSNotification *)notification

{
    NSString *topBarbgColor=[AppStartupManager getTopbarStylingInfoBean].topbarBgColor;
    if(topBarbgColor!=nil){
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, -20)];
        statusBarView.backgroundColor = [AppUtils colorFromHexString:topBarbgColor];
        [self.view addSubview:statusBarView];
       // [statusBarView release];
    }
    
    self.orientation=[[UIApplication sharedApplication] statusBarOrientation];
    
    self.splashImageView.image=[self defaultImage];
    
}

- (BOOL)shouldAutorotate
{
    return TRUE;
}
//Used to set all the orientations that must be supported by the device

- (NSUInteger)supportedInterfaceOrientations
{
    if([AppUtils isDeviceiPad] == TRUE)
    {
        [self defaultImage];
        [[SmartUIUtility sharedInstance] adjustLayoutOnOrientation:self.orientation];
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        [self defaultImage];
        self.orientation=UIInterfaceOrientationPortrait;
        return (UIInterfaceOrientationMaskPortrait);
    }
    
    return (UIInterfaceOrientationMaskPortrait);
}


//-------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     self.orientation = interfaceOrientation;
    
    //Return YES for supported orientations
    if([AppUtils isDeviceiPad] == TRUE)
    {
        [self defaultImage];
        [[SmartUIUtility sharedInstance] adjustLayoutOnOrientation:interfaceOrientation];
        return TRUE;
    }
    else
    {
       [self defaultImage];
      return (interfaceOrientation == UIInterfaceOrientationPortrait); 
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//-------------------------------------------------------------------------------------------------------------------------
-(void)loadWebContainerView
{
    self.htmlUri=[self.htmlUri stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    [AppUtils showDebugLog:[NSString stringWithFormat:@"show web view with url->%@",self.htmlUri]];
    NSURL *url=[NSURL URLWithString:self.htmlUri];
    NSURLRequest *loadUrlRequest=[NSURLRequest requestWithURL:url];
    
    //The below line causes some random crashes on ios8 ipad3 device on launching during loading html resources like js files and other assets.Seems like a issue on iOS8 which may be temporarly avoided by disabling the animation at application level and hopefully will be resolved in the next release of iOS
    [self.smartViewPrimary loadRequest:loadUrlRequest];
}
//-------------------------------------------------------------------------------------------------------------------------

#pragma 
#pragma Delegate Methods
#pragma

/** Sends error notification to Java Script in case of SmartEvent processing with error
 * 
 *  @param smartEvent : SmartEvent being processed
 */
-(void)didFinishProcessingWithError:(SmartEvent*)smartEvent
{
    NSString *jsCallbackMethod = [smartEvent getJavaScriptNameToCall];
    NSString *jsCallBackArg=[smartEvent getJavaScriptNameToCallArg];
    
    NSString *notifyJavaScript=[self notifyToJavaScript:jsCallbackMethod WithArgument:jsCallBackArg];
    //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:notifyJavaScript waitUntilDone:YES];
    if ([NSThread isMainThread])
    {
        [self executeJavaScript:notifyJavaScript];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self executeJavaScript:notifyJavaScript];
        });
    }
}
//-------------------------------------------------------------------------------------------------------------------------


/** Sends success notification to Java Script in case of SmartEvent processing with success
 *
 *  @param smartEvent : SmartEvent being processed
 */
-(void)didFinishProcessingWithOptions:(SmartEvent*)smartEvent
{
    NSString *notifyJavaScript=[self processJavaScriptCallback:smartEvent];
    //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:notifyJavaScript waitUntilDone:YES];
    if ([NSThread isMainThread])
    {
        [self executeJavaScript:notifyJavaScript];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self executeJavaScript:notifyJavaScript];
        });
    }
}

-(NSString*)processJavaScriptCallback:(SmartEvent*)smartEvent
{
    NSString *jsCallbackMethod =[NSMutableString stringWithFormat:@"%@",[smartEvent getJavaScriptNameToCall] ];
    NSString *jsCallbackArg=[NSMutableString stringWithFormat:@"%@",[smartEvent getJavaScriptNameToCallArg]] ;
    jsCallbackArg=[jsCallbackArg stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *processdString= [self notifyToJavaScript:jsCallbackMethod WithArgument:jsCallbackArg];
    return processdString;
}

//-------------------------------------------------------------------------------------------------------------------------

-(void)didReceiveContextNotification:(SmartEvent*)smartEvent
{
    int notificationCode =smartEvent.smartEventRequest.serviceOperationId;

    if([smartEvent.jsNameToCallArg length]>0)
    {
        smartEvent.jsNameToCallArg=[NSString stringWithFormat:@"%d",CO_EVENT_SUCCESSFUL];
        NSString *notifyJavaScript=[self processJavaScriptCallback:smartEvent];
        [self executeJavaScript:notifyJavaScript];
    }
    
    NSString *eventDataString=[AppUtils getJsonFromDictionary:smartEvent.smartEventRequest.serviceRequestData];
    
    switch(notificationCode)
    {
        case CONTEXT_WEBVIEW_HIDE:
            break;
            
        case CONTEXT_WEBVIEW_SHOW:
            if (splashImageView != nil) 
            {
                [self toggleSplashScreen];
            }
            break;
        case ANIMATION_FLIP_PLAY:
            [self animationPlay:eventDataString WithType:UIViewAnimationTransitionFlipFromLeft];
            break;
        case ANIMATION_FLIP_RESUME:
            [self animationResumeWithType:UIViewAnimationTransitionFlipFromRight];
            break;
        case ANIMATION_CURL_PLAY:
            [self animationPlay:eventDataString WithType:UIViewAnimationTransitionCurlUp];
            break;
        case ANIMATION_CURL_RESUME:
            [self animationResumeWithType:UIViewAnimationTransitionCurlDown];
            break;
        default:
            break;
    }
}
//----------------------------------------------------------------------------------------------------------------------
#pragma
#pragma mark- JavaSCript Communication methods
//----------------------------------------------------------------------------------------------------------------------

-(void)executeJavaScript:(NSString*)javaScript
{
    [smartViewCurrent stringByEvaluatingJavaScriptFromString:javaScript];
}
/**
 * Calls JavaScript function with or without arguments as per the requirement
 *
 * @param javaScriptCallback
 *            : Javascript method need to be called
 * @param jsNameToCallArgument
 *            : Javascript argument value
 *
 
 * */
-(NSString*)notifyToJavaScript:(NSString*)javaScriptCallback WithArgument:(NSString*)jsNameToCallArgument
{
    NSMutableString *javaScript =[NSMutableString string];
    
    BOOL isJSCallback = (javaScriptCallback != NULL && [javaScriptCallback length] > 0);
    BOOL isJSArgument = (jsNameToCallArgument != NULL && [jsNameToCallArgument length] > 0);
    if(isJSCallback)
    {
        [javaScript appendString:@"javascript:"];
        [javaScript appendString:javaScriptCallback];
        
        if (jsNameToCallArgument != nil && [jsNameToCallArgument length] > 0)
        {
            jsNameToCallArgument = [jsNameToCallArgument stringByReplacingOccurrencesOfString:SEPARATOR_NEW_LINE withString:@""];
            
            //TODO Need to discuss as to how to handle \" in the response string
            //and with which character(s),it needs to be replaced
            
            jsNameToCallArgument = [jsNameToCallArgument stringByReplacingOccurrencesOfString:ESCAPE_SEQUENCE_BACKSLASH_DOUBLEQUOTES withString:@""];
            
            // For checking the occurrence of ' in the given string and
            // removing it
            for (int i = 0; i < [jsNameToCallArgument length]; i++)
            {
                if ([jsNameToCallArgument characterAtIndex:i] == '\'')
                {
                    if (i != 0 && i !=([jsNameToCallArgument length] - 1))
                    {
                        
                        jsNameToCallArgument =[NSString stringWithFormat:@"%@%@%@",[jsNameToCallArgument substringWithRange:NSMakeRange(0, i)],ENCODE_SINGLE_QUOTE_UTF8,[jsNameToCallArgument substringWithRange:NSMakeRange(i+1,([jsNameToCallArgument length]-i-1))]];
                    }
                }
            }
            [javaScript appendString:@"("];
            [javaScript appendString:jsNameToCallArgument];
            [javaScript appendString:@")"];
        }
        else if (!isJSArgument && !([javaScriptCallback rangeOfString:@"("].length==0) && !([javaScriptCallback rangeOfString:@")"].length==0))
        {
            [javaScript appendString:@"()"];
        }
    }
  
    return [NSString stringWithString:javaScript];
}


#pragma
#pragma mark- App Register methods

/**
 * Initialise Smart connector here with reference of outer activity to
 * receive SmartAppListener notifications
 */
-(void)registerAppDelegate:(id<SmartAppDelegate>)appdelegate {
    
    id<SmartAppDelegate> smartAppDelegate = nil;
    if (appdelegate != nil && smartConnector != nil)
    {
        if ([appdelegate conformsToProtocol:@protocol(SmartAppDelegate)])
        {
            smartAppDelegate = appdelegate;
        }
        else
        {
            @throw [MobiletException MobiletExceptionWithType:SMART_APP_LISTENER_NOT_FOUND_EXCEPTION Message:nil];
        }
        [smartConnector registerAppDelegate:smartAppDelegate];
    }
}

//-------------------------------------------------------------------------------------------------------------------------
/** Initiates processing of SmartEvent received from the JavaScript 
 * 
 * @param smartMessage : SmartEvent message
 */
#pragma 
#pragma mark- UIWebViewDelegate methods
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(([request.URL.scheme isEqualToString:kURLSchemeIMR]) ||  ([request.URL.scheme isEqualToString:kURLSchemeIMRLOG])){
        [self processEventThread:request];
       // [NSThread detachNewThreadSelector:@selector(processEventThread:) toTarget:self withObject:request];
        return NO;
    }
    
    return YES;
}

-(void)processEventThread:(NSURLRequest *)request
{
    //Dispatched new thread using GCD on Concurrent queue.
   // NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    dispatch_queue_t concurrentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
     
    NSString *absoluteUrl = request.URL.absoluteString;
    SmartEvent *smEvent=NULL;
    
    //Check now if the parameters contain smart event or notifier event
    if([request.URL.scheme isEqualToString:kURLSchemeIMR])
    {
        NSString *requestString=[absoluteUrl stringByReplacingOccurrencesOfString:@"imr://" withString:@""];
        requestString=[requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *requestObject= [AppUtils getDictionaryFromJson:requestString];

        if([requestObject.allKeys containsObject:MMI_MESSAGE_PROP_TRANSACTION_REQUEST])
        {
            smEvent = [[SmartEvent alloc] initWithMessage:requestString];
            [smartConnector processSmartEvent:smEvent];
        }
        //Check now if the parameters contain smart event or notifier event
        else if([requestObject.allKeys containsObject:NOTIFIER_PROP_TRANSACTION_REQUEST])
        {
            //It means the request is the notifier request
            NotifierEventProcessor *notifierEventProcessor=[[NotifierEventProcessor alloc]initWithNotifierEventDelegate:self];
            NotifierEvent *notifierEvent=[[NotifierEvent alloc]initWithMessage:requestString];
            [notifierEventProcessor processNotifierRegistrationReq:notifierEvent];
        }
        else
        {
            //Do nothing here
        }
    }
    else if([request.URL.scheme isEqualToString:kURLSchemeIMRLOG])
    {
        NSString *eventString=[[absoluteUrl stringByReplacingOccurrencesOfString:@"imrlog://" withString:@""] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [AppUtils showDebugLog:[NSString stringWithFormat:@"Log Javascript -------------> %@" , eventString]];
    }
    else
    {
        //do nothing here
    }
   });
   // [pool drain];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self toggleSplashScreen];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [AppUtils showDebugLog:[NSString stringWithFormat:@"web view did fail loading request"]];
    NSLog(@"Error :%@",error);
}
//--------------------------------------------------------------------------------------------------------------
#pragma 
#pragma mark - Animation Methods
#pragma
-(void)animationPlay:(NSString*)eventData WithType:(UIViewAnimationTransition)animation
{
    
    smartViewSecondary=[[UIWebView alloc] initWithFrame:[AppUtils getScreenFrame]];
    
    [[smartViewSecondary.subviews objectAtIndex:0] setScrollEnabled:YES];  //to stop scrolling completely
    [[smartViewSecondary.subviews objectAtIndex:0] setBounces:NO]; //to stop bouncing
    smartViewSecondary.delegate=self;
    smartViewCurrent=smartViewSecondary;
    showSplash=FALSE;
    [self toggleSplashScreen];
    [self.view bringSubviewToFront:splashImageView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:animation
                           forView:[self view]
                             cache:YES];
    [self.view addSubview:smartViewSecondary];
    
    //[smartViewSecondary release];
    self.htmlUri=[AppUtils getAbsolutePathForHtml:eventData];
    [self loadWebContainerView];
    
    [UIView commitAnimations];
    //change main URl check once that it can't affect when we back to original html
    
}
-(void)animationResumeWithType:(UIViewAnimationTransition)animation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:animation
                           forView:[self view]
                             cache:YES];
    [smartViewSecondary removeFromSuperview];
    smartViewSecondary=nil;
    smartViewCurrent=smartViewPrimary;
    [UIView commitAnimations];
}
-(void)showOptionMenu:(NSString*)optionsForScreen
{
    [[SmartUIUtility sharedInstance] showAction:optionsForScreen];
}
//--------------------------------------------------------------------------------------------------------------
#pragma
#pragma mark - Dynamic SmartNotificationDelegate Methods
#pragma
-(void)sendActionInfo:(NSString*)actionName
{
    NSString *notifyJavaScript=[self notifyToJavaScript:JS_NOTIFICATION_FROM_NATIVE WithArgument:[NSString stringWithFormat:@"'%@'",actionName]];
    //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:notifyJavaScript waitUntilDone:YES];
    if ([NSThread isMainThread])
    {
        [self executeJavaScript:notifyJavaScript];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self executeJavaScript:notifyJavaScript];
        });
    }
}

//-(void)initMAHandler:(NSDictionary *)appConfiguration
//{
//    if ([appConfiguration.allKeys containsObject:MA_INFO] && [appConfiguration.allKeys containsObject:CHECK_FOR_APP_CONFIG_INFO])
//    {
//        [[ManageabilityHandler sharedInstance] procesManageabiltyInfo:[appConfiguration objectForKey:MA_INFO] appConfiguration:[appConfiguration objectForKey:CHECK_FOR_APP_CONFIG_INFO]];
//      
//    }
//}
-(void)initAppConfigInformation
{
    //To be set from client app self.configInfo=[AppUtils getAppConfigFileProps:@"assets/www/app/appez.conf"];
    
    if(self.configInfo!=NULL)
    {
        appConfigInformation=self.configInfo;
        //appConfigInformation=[AppUtils getDictionaryFromJson:self.configInfo];
        
        // Set the application menu information provided in the
        // 'appez.conf' file
        if ([appConfigInformation.allKeys containsObject:appez_CONF_PROP_MENU_INFO]) {
            
            NSDictionary *appMenuInfoObj=[AppUtils getDictionaryFromJson:[appConfigInformation valueForKey:appez_CONF_PROP_MENU_INFO]];
            appMenuInformation=(NSArray*)appMenuInfoObj;
        }
        else
        {
            appMenuInformation=[[NSArray alloc]init];
        }
        
        if ([appConfigInformation.allKeys containsObject:appez_CONF_PROP_TOPBAR_INFO]) {
            appTopbarInformation = [AppUtils getDictionaryFromJson:[appConfigInformation valueForKey:appez_CONF_PROP_TOPBAR_INFO]];
        } else {
            appTopbarInformation = [[NSDictionary alloc]init];
        }
        // Process the application menu information provided by the user
        // in the 'appez.conf' file
        [AppStartupManager processTopbarStylingInformation:appTopbarInformation];
        [AppStartupManager processMenuCreationInfo:appMenuInformation];
    }
}

-(void)didReceiveNotifierEvent:(NotifierEvent*)notifierEvent
{
    if(appConfigInformation!=nil)
    {
        NSString *jsListener=[self getNotifierListener:notifierEvent.type];
        NSString *jsListenerArg=[notifierEvent getJavascriptNameToCallArg];
        NSString *urlToLoad = [NSString stringWithFormat:@"javascript:%@(%@);",jsListener,jsListenerArg];
        //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:urlToLoad waitUntilDone:YES];
        if ([NSThread isMainThread])
        {
            [self executeJavaScript:urlToLoad];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self executeJavaScript:urlToLoad];
            });
        }
    }
}

-(NSString*)getNotifierListener:(int)notifierType
{
    NSString *listener=nil;
    @try {
        switch (notifierType) {
            case PUSH_MESSAGE_NOTIFIER:
                listener=[appConfigInformation valueForKey:appez_CONF_PROP_PUSH_NOTIFIER_LISTENER_FUNCTION];
                break;
            case NETWORK_STATE_NOTIFIER:
                listener=[appConfigInformation valueForKey:appez_CONF_PROP_NWSTATE_NOTIFIER_LISTENER];
            
            default:
                break;
        }
    }
    @catch (NSException *exception) {
        //TODO need to handle this exception
        NSLog(@"Exception :%@",[exception description]);

    }
    return listener;
}


-(void)didReceiveNotifierRegistrationEvent:(NotifierEvent*)notifierEvent
{
    [AppUtils showDebugLog:@"SmartViewControllr->didReceiveNotifierRegistrationEvent"];
    NSString *jsCallbackFunction = @"appez.mmi.getMobiletManager().processNotifierResponse";
    NSString *jsCallbackArg =[notifierEvent getJavascriptNameToCallArg];
    NSString *urlToLoad= [NSString stringWithFormat:@"javascript:%@(%@);",jsCallbackFunction,jsCallbackArg];
    [AppUtils showDebugLog:[NSString stringWithFormat:@"urltoload %@",urlToLoad]];
    //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:urlToLoad waitUntilDone:YES];
    if ([NSThread isMainThread])
    {
        [self executeJavaScript:urlToLoad];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self executeJavaScript:urlToLoad];
        });
    }

}

-(void)didReceiveNotifierEventSuccess:(NotifierEvent *)notifierEvent
{
    if(appConfigInformation!=nil)
    {
        NSString *jsListener=[self getNotifierListener:notifierEvent.type];
        NSString *jsListenerArg=[notifierEvent getJavascriptNameToCallArg];
        NSString *urlToLoad = [NSString stringWithFormat:@"javascript:%@(%@);",jsListener,jsListenerArg];
        //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:urlToLoad waitUntilDone:YES];
        if ([NSThread isMainThread])
        {
            [self executeJavaScript:urlToLoad];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self executeJavaScript:urlToLoad];
            });
        }
    }
    
}

-(void)didReceiveNotifierEventError:(NotifierEvent *)notifierEvent
{
    if (appConfigInformation != NULL) {
        NSString *jsListener = [self getNotifierListener:notifierEvent.type];
        NSString *jsListenerArg = [notifierEvent getJavascriptNameToCallArg];
        NSString *urlToLoad= [NSString stringWithFormat:@"javascript:%@(%@);",jsListener,jsListenerArg];
        //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:urlToLoad waitUntilDone:YES];
        if ([NSThread isMainThread])
        {
            [self executeJavaScript:urlToLoad];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self executeJavaScript:urlToLoad];
            });
        }
    }
}

-(void)didReceiveNotifierRegistrationEventSuccess:(NotifierEvent *)notifierEvent
{
    [AppUtils showDebugLog:@"SmartViewControllr->didReceiveNotifierRegistrationEventSuccess"];
    NSString *jsCallbackFunction = @"appez.mmi.getMobiletManager().processNotifierResponse";
    NSString *jsCallbackArg =[notifierEvent getJavascriptNameToCallArg];
    NSString *urlToLoad= [NSString stringWithFormat:@"javascript:%@(%@);",jsCallbackFunction,jsCallbackArg];
    [AppUtils showDebugLog:[NSString stringWithFormat:@"urltoload %@",urlToLoad]];
    //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:urlToLoad waitUntilDone:YES];
    if ([NSThread isMainThread])
    {
        [self executeJavaScript:urlToLoad];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self executeJavaScript:urlToLoad];
        });
    }

}

-(void)didReceiveNotifierRegistrationEventError:(NotifierEvent *)notifierEvent
{
    NSString *jsCallback = @"appez.mmi.getMobiletManager().processNotifierResponse";
    NSString *jsCallbackArg = [notifierEvent getJavascriptNameToCallArg];
    NSString *urlToLoad= [NSString stringWithFormat:@"javascript:%@(%@);",jsCallback,jsCallbackArg];
    //[self performSelectorOnMainThread:@selector(executeJavaScript:) withObject:urlToLoad waitUntilDone:YES];
    if ([NSThread isMainThread])
    {
        [self executeJavaScript:urlToLoad];
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self executeJavaScript:urlToLoad];
        });
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    //Dismiss action sheet if os version is <8
    [_containedActionSheet dismissWithClickedButtonIndex:0 animated:NO];
    
    //For dismissing action sheet if os version is >=8
    UIAlertController *presentedVC=(UIAlertController*)self.presentedViewController;
    if(presentedVC!=nil && [presentedVC isKindOfClass:[UIAlertController class]])
    {
        if (presentedVC.preferredStyle==UIAlertControllerStyleActionSheet)
            [self.presentedViewController dismissModalViewControllerAnimated:YES];
    }
}

@end
