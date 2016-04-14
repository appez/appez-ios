//
//  SmartView.h
//  SmartSplitView
//
//  Created by Transility on 7/19/12.
//

/**
 This class is responsible for various view related operations
 *
 */
#import <UIKit/UIKit.h>
#import "MobiletManager.h"
#import "SmartAppDelegate.h"
#import "SmartNotificationDelegate.h"


@interface SmartView : UIView <SmartConnectorDelegate>
{
     
    @private MobiletManager          *smartConnector;
    @private SmartEvent              *anSmartEvent;
    @private BOOL                    showSplash;
    //id<SmartNotificationDelegate> delegate;
}
@property(nonatomic,assign)   id<SmartNotificationDelegate> delegate;
@property(nonatomic,retain) MobiletManager      *smartConnector;
@property(nonatomic,retain) SmartEvent          *anSmartEvent;

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (assign, nonatomic) IBOutlet UIImageView *splashImageView;
@property (retain, nonatomic) IBOutlet UIImageView *dividerImage;
-(void)loadWebContainerViewWithUri:(NSString*)htmlFile;
-(NSString*)executeJavaScript:(NSString*)javaScript;
-(void)registerAppDelegate:(id<SmartAppDelegate>)appdelegate;
-(void)toggleSplashScreen;
-(void)initializeSmartView:(BOOL)showSplashImage;
@end
