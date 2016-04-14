//  SmartViewController.h
//  appez
//  Created by Transility on 2/27/12.


/**
 * SmartViewActivity:
 * Renders HTML page on screen using webView and responsible for handling
 * JavaScript(JS) notification using iOS WebView Delegate. Also
 * responsible for sending response callback notifications back to the Html & responsive JS.
 */

#import <UIKit/UIKit.h>
#import "SmartConnectorDelegate.h"
#import "MobiletManager.h"

#import "AppUtils.h"
#import "AppStartupManager.h"
#import "SmartNotificationDelegate.h"
#import "SmartNotifierDelegate.h"

@interface SmartViewController : UIViewController<SmartConnectorDelegate,SmartNotificationDelegate,UIWebViewDelegate,SmartNotifierDelegate,UIApplicationDelegate>
{
    @private UIWebView               *smartViewPrimary;
    @private UIWebView               *smartViewSecondary;
    @private UIWebView               *smartViewCurrent;
    @private NSString                *htmlUri;
    @private MobiletManager          *smartConnector;
    BOOL                             showSplash;
    NSString                         *menuInformation;
    @private NSDictionary            *appConfigInformation;
    @private NSArray                 *appMenuInformation;
    @private NSDictionary            *appTopbarInformation;
}
@property(nonatomic,retain) NSDictionary            *configInfo;
@property(nonatomic,retain) NSString            *menuInformation;
@property(nonatomic,retain) MobiletManager      *smartConnector;
@property(nonatomic,copy) NSString              *htmlUri;
@property(nonatomic,retain) IBOutlet UIWebView   *smartViewPrimary;
@property (assign, nonatomic) IBOutlet UIImageView *splashImageView;
@property (nonatomic,readwrite) UIInterfaceOrientation orientation;
@property (nonatomic,retain)UIActionSheet *containedActionSheet;

-(instancetype)initWithExtendedSplashAndPageURI:(NSString*)uri;
-(instancetype)initWithPageURI:(NSString*)uri;
-(void)loadWebContainerView;
-(void)executeJavaScript:(NSString*)javaScript;  
-(void)registerAppDelegate:(id<SmartAppDelegate>)appdelegate;
-(void)showOptionMenu:(NSString*)optionsForScreen;
-(void)initAppConfigInformation;
@end
