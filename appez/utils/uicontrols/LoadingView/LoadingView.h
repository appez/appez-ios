/**
 *This is the utility to show custom view on the window of the device whenver there is a 
 *loading data related task going on like fetching data from server, during the time a loading
 *view is shown with transparent black view and an indicator with the user provided message
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoadingView : UIView {
	UIActivityIndicatorView *activityIndicator;
	UILabel					*waitLabel;
}

@property(nonatomic,retain)	IBOutlet UIActivityIndicatorView    *activityIndicator;
@property(nonatomic,retain) IBOutlet UILabel                    *waitLabel;
@property(nonatomic,retain) IBOutlet UIView                     *activityBackView;
- (void) adjustLayoutOnOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void) startAnimation;
- (void) stopAnimation;
-(BOOL)isActivityAnimating;
@end
