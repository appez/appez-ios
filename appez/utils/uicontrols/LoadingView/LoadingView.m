#import "LoadingView.h"

#define DeviceiPadBoundsInPortriat                      CGRectMake(0,0,768,1024)
#define DeviceiPadBoundsInLandScape                     CGRectMake(0,0,1024,768)
#define DeviceiPhoneBoundsInPortriat                      CGRectMake(0,0,320,480)
#define DeviceiPhoneBoundsInLandScape                     CGRectMake(0,0,480,320)


@implementation LoadingView
@synthesize activityIndicator;
@synthesize waitLabel;
@synthesize activityBackView;

//Thi method sets the view properties
-(void)awakeFromNib
{
    self.activityBackView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.activityBackView.layer.borderWidth=2.0;
    self.activityBackView.layer.masksToBounds=YES;
    self.activityBackView.layer.cornerRadius=8.0;
}
//-----------------------------------------------------------------------------------------------------------------------
- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        //This is the code for initialization, if we want to initailize some parameters we will do here.For now, it is to be kept blank.
        NSLog(@"LoadingView->init->Instance created");
    }
    return self;
}
//------------------------------------------------------------------------------------------------------------------------
//This method is used to adjust the layout in the corresponding orientation
-(void) adjustLayoutOnOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        self.frame =DeviceiPadBoundsInLandScape ;
    }
    else
    {
        self.frame = DeviceiPadBoundsInPortriat;
    }

}
//------------------------------------------------------------------------------------------------------------------------
//The animation of the activity indicator is made rotating(animated) using this method
-(void) startAnimation
{
	[self.activityIndicator startAnimating];
}
//------------------------------------------------------------------------------------------------------------------------
//Stopping the animation of the activity indicator
-(void) stopAnimation
{
    self.waitLabel.text = nil;
	if([self.activityIndicator isAnimating])
		[self.activityIndicator stopAnimating];
}


//------------------------------------------------------------------------------------------------------------------------
//Method to check if the activity indicator is animating or not
-(BOOL)isActivityAnimating
{
    return [self.activityIndicator isAnimating];
}

@end
