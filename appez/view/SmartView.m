//
//  SmartView.m
//  SmartSplitView
//
//  Created by Transility on 7/19/12.
//

#import "SmartView.h"
#import "MobiletManager.h"
#import "MobiletException.h"
#import "ExceptionTypes.h"
#import "SmartConstants.h"
#import "CoEvents.h"

@interface SmartView(PrivateMethods)
-(NSString*)notifyToJavaScript:(NSString*)javaScriptCallback WithArgument:(NSString*)jsNameToCallArgument;
-(NSString*)processJavaScriptCallback:(SmartEvent*)smartEvent;
-(void)toggleSplashScreen;
-(UIImage*)defaultImage;
@end

@implementation SmartView
@synthesize webView;
@synthesize smartConnector;
@synthesize anSmartEvent;
@synthesize delegate;
@synthesize splashImageView;
@synthesize dividerImage;
#pragma 
#pragma mark -  WebView Interaction Methods
#pragma 
-(void)initializeSmartView:(BOOL)showSplashImage
{
    [[self.webView.subviews objectAtIndex:0] setScrollEnabled:YES];  //to stop scrolling completely
    [[self.webView.subviews objectAtIndex:0] setBounces:NO]; //to stop bouncing
    
    smartConnector = [[MobiletManager alloc] initSmartConnectorWithDelegate:self];
    
    //anSmartEvent = [[SmartEvent alloc] init];
    anSmartEvent=nil;
    
    showSplash=showSplashImage;
    [self toggleSplashScreen];
}

/**
 *This method when called determines which view to show ,whether the splash image, or the web
 *view
 */
-(void)toggleSplashScreen
{
    if(showSplash)
    {
        showSplash=FALSE;
        webView.hidden=true;
        splashImageView.hidden=FALSE;
        if(splashImageView.image==nil)
            splashImageView.image=[self defaultImage];
    }
    else
    {
        splashImageView.hidden=TRUE;
        webView.hidden=FALSE;
    }
}
/**
 *This method determines which image to show when the splash view is in front
 */
-(UIImage*)defaultImage
{
    UIImage *image=nil;
    image=[UIImage imageNamed:DEFAULT_BACKGROUND_IMAGE];
    if(image!=nil)
        return image;
    else
    {
        image=[UIImage imageNamed:DEFAULT_appez_IMAGE];
        return image;
    }
}

//-------------------------------------------------------------------------------------------------------------------------
/**
 *This method will determine which data to show on the html page if it is on front provided an 
 *htmlfile as a url
 */
-(void)loadWebContainerViewWithUri:(NSString*)htmlFile
{
    [ AppUtils showDebugLog:[NSString stringWithFormat:@"smartview->loadWebContainerViewWithUri %@",[NSURL URLWithString:htmlFile].absoluteString]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlFile]]];
}
//-------------------------------------------------------------------------------------------------------------------------

-(NSString*)executeJavaScript:(NSString*)javaScript
{
    return [webView stringByEvaluatingJavaScriptFromString:javaScript];
}
//-------------------------------------------------------------------------------------------------------------------------
#pragma 
#pragma mark - WebView Delegate Methods
#pragma 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(([request.URL.scheme isEqualToString:kURLSchemeIMR]) || ([request.URL.scheme isEqualToString:kURLSchemeIMRFILE]))
        [self processEventThread:request];
    
    return TRUE;
}
-(void)processEventThread:(NSURLRequest *)request
{
    dispatch_queue_t concurrentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        
    NSString * absoluteUrl = request.URL.absoluteString;
    [AppUtils showDebugLog:[NSString stringWithFormat:@"absoluteUrl is=%@",absoluteUrl]];
    
    if([request.URL.scheme isEqualToString:kURLSchemeIMR])
    {
            NSString *eventString=[absoluteUrl stringByReplacingOccurrencesOfString:@"imr://" withString:@""];
            anSmartEvent = [[SmartEvent alloc] initWithMessage:eventString];
            [smartConnector processSmartEvent:self.anSmartEvent ];
    }
    });
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self toggleSplashScreen];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [AppUtils showDebugLog:[NSString stringWithFormat:@"Error %@",[error description]]];
}
//-------------------------------------------------------------------------------------------------------------------------

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

    return  [NSString stringWithString:javaScript];
}
/** Sends error notification to Java Script in case of SmartEvent processing with error
 * 
 *  @param smartEvent : SmartEvent being processed
 */
-(void)didFinishProcessingWithError:(SmartEvent*)smartEvent
{
    NSString *jsCallbackMethod=[smartEvent getJavaScriptNameToCall];
    NSString *jsCallbackArg=[smartEvent getJavaScriptNameToCallArg];
    NSString *notifyJavaScript=[self notifyToJavaScript:jsCallbackMethod WithArgument:jsCallbackArg];
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

-(void)didReceiveContextNotification:(SmartEvent*)smartEvent 
{
    
    int notificationCode=smartEvent.smartEventRequest.serviceOperationId;
    
    
    if([[smartEvent getJavaScriptNameToCallArg] length]>0)
    {
        NSString *jsCallbackMethod=[smartEvent getJavaScriptNameToCall];
        NSString *jsCallbackArg=[smartEvent getJavaScriptNameToCallArg];
        NSString *notifyJavaScript=[self notifyToJavaScript:jsCallbackMethod WithArgument:jsCallbackArg];
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
       
        case CONTEXT_POPOVER_SHOW:
        {
            [AppUtils showDebugLog:@"CONTEXT_POPOVER_SHOW"];
            if (delegate && [delegate conformsToProtocol:@protocol(SmartNotificationDelegate)])
            {
                 [delegate showPopOverViewController];
            }
        }
        break;
        case CONTEXT_POPOVER_HIDE:
        {
            [AppUtils showDebugLog:@"CONTEXT_POPOVER_HIDE"];
            if (delegate && [delegate conformsToProtocol:@protocol(SmartNotificationDelegate)])
            {
                [delegate hidePopOverViewController];
            }
        }
        break;
            
        case CONTEXT_NOTIFICATION_DETAIL:
        {
            [AppUtils showDebugLog:@"CONTEXT_NOTIFICATION_DETAIL"];
            
            if (delegate && [delegate conformsToProtocol:@protocol(SmartNotificationDelegate)])
            {
               [delegate sendDataToMaster:smartEvent.serviceRequestData];
            }
            
        }
        break;
        case CONTEXT_NOTIFICATION_MASTER:
        {
            [AppUtils showDebugLog:@"CONTEXT_NOTIFICATION_MASTER"];
            
            if (delegate && [delegate conformsToProtocol:@protocol(SmartNotificationDelegate)])
            {
                 [delegate sendDataToDetail:smartEvent.serviceRequestData];
            }
           
        }
        break;

        default:
            break;
    }
}
//----------------------------------------------------------------------------------------------------------------------
-(NSString*)processJavaScriptCallback:(SmartEvent*)smartEvent
{
    
    NSString *jsCallBackMethod=[smartEvent getJavaScriptNameToCall];
    NSString *jsCallBackArg=[smartEvent getJavaScriptNameToCallArg];
    return  [self notifyToJavaScript:jsCallBackMethod WithArgument:jsCallBackArg];
}


/** Sends success notification to Java Script in case of SmartEvent processing with success
 * 
 *  @param smartEvent : SmartEvent being processed
 */
-(void)didFinishProcessingWithOptions:(SmartEvent*)smartEvent
{
    NSString *notifyJavaScript=[self processJavaScriptCallback:smartEvent];

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

/**
 * Send data callback to JavaScript in event of a data operation (WEB_HTTP_REQUEST)
 * 
 * @param smartEvent
 *            : SmartEvent object containing JavaScript data callback
 */
-(void)executeDataCallback:(SmartEvent*)smartEvent 
{
    NSString *jsCallbackMethod = [smartEvent getJavaScriptNameToCall];
    NSString *jsCallBackArg=[smartEvent getJavaScriptNameToCallArg];
    NSString *notifyJavaScript=[self notifyToJavaScript:jsCallbackMethod WithArgument:jsCallBackArg];
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

/**
 * Initialise Smart connector here with reference of outer activity to
 * receive SmartAppListener notifications
 */
-(void)registerAppDelegate:(id<SmartAppDelegate>)appdelegate {
    
    id<SmartAppDelegate> smartAppDelegate = nil;
    if (appdelegate != nil && smartConnector != nil) 
    {
        [AppUtils showDebugLog:[NSString stringWithFormat:@"[appdelegate conformsToProtocol:@protocol(SmartAppDelegate)]----->%d",[appdelegate conformsToProtocol:@protocol(SmartAppDelegate)]]];
        
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

@end
