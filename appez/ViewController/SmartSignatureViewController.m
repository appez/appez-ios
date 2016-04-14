//
//  SmartSignatureViewController.m
//  appez
//
//  Created by Transility on 29/11/14.
//
//

#import "SmartSignatureViewController.h"
#import "SmartUIUtility.h"
#import "GTMBase64.h"
#import "ExceptionTypes.h"
#import "AppStartupManager.h"


@interface SmartSignatureViewController ()

@end
@implementation SmartSignatureViewController
@synthesize drawableView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"SmartSignatureViewController->init");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(orientationChanged:)
     
                                                 name:UIDeviceOrientationDidChangeNotification
     
                                               object:nil];
    
    if(drawableView == nil) {
        CGRect rect = CGRectMake(0, 0, self.signatureView.frame.size.width,self.signatureView.frame.size.height);
        drawableView = [[DrawingView alloc] initWithFrame:rect];
    } else {
        [drawableView clearsContextBeforeDrawing];
    }

    if(self.signatureView!=nil){
    [self.signatureView addSubview:drawableView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.navigationController)
    {
        self.navigationController.navigationBarHidden=FALSE;
        self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
    }    
    
    [self processSignRequestData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
        self.view.center = CGPointMake(super.view.frame.size.height / 2,super.view.frame.size.width / 2);
}

-(void)processSignRequestData
{
    @try {
        NSDictionary *signRequestData = [AppUtils getDictionaryFromJson:self.signingParameters];
        if ([signRequestData.allKeys containsObject:MMI_REQUEST_PROP_SIGN_PENCOLOR]) {
            signPenColor = [signRequestData valueForKey:MMI_REQUEST_PROP_SIGN_PENCOLOR];
        } else {
            signPenColor = @"#000000";
        }
        
        [drawableView setPenColor:signPenColor];
       
        if ([signRequestData.allKeys containsObject:MMI_REQUEST_PROP_SIGN_IMG_SAVEFORMAT]) {
            signImageFormat = [signRequestData valueForKey:MMI_REQUEST_PROP_SIGN_IMG_SAVEFORMAT];
        } else {
            signImageFormat = IMAGE_FORMAT_TO_SAVE_PNG;
        }
        
    } @catch (NSException *exception) {
        // TODO handle this exception
        NSLog(@"Exception :%@",[exception description]);

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///Added 3dec
- (UIImage *) getScreenShot {
    if(drawableView != nil && !drawableView.hidden) {
        UIGraphicsBeginImageContext(drawableView.frame.size);
    } else {
        CGSize size = CGSizeMake(self.dataContextView.frame.size.width, self.dataContextView.frame.size.height);
        UIGraphicsBeginImageContext(size);
    }
    [self.signatureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    return screenshot;
}

- (void)viewDidUnload {
    
    [self setSignatureView:nil];
    [self setSignatureContainerView:nil];
    [super viewDidUnload];
}
- (IBAction)clearCanvas:(id)sender {
    [drawableView clear];
}

- (IBAction)cancel:(id)sender {
    
    [self.view removeFromSuperview];
     self.view=nil;
    [self prepareErrorData];
}

- (IBAction)saveImage:(id)sender {
   
    NSLog(@"save image button action before calling screenshot");
    UIImage *img=[self getScreenShot];
    NSLog(@"save image button action after calling screenshot");
    NSData *imageData = nil;
    NSString* docsPath = [NSTemporaryDirectory()stringByStandardizingPath];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString* filePath;
    int i=1;
    do{
        filePath = [NSString stringWithFormat:@"%@/%d.%@", docsPath,i++,signImageFormat];
    } while ([fileMgr fileExistsAtPath:filePath]);
    
    if([signImageFormat isEqualToString:IMAGE_FORMAT_TO_SAVE_JPEG])
    {
        imageData=UIImageJPEGRepresentation(img, 0.9);
    }
    else if ([signImageFormat isEqualToString:IMAGE_FORMAT_TO_SAVE_PNG])
    {
        imageData = UIImagePNGRepresentation(img);
    }
    
    //Dismiss the view 
    [self.view removeFromSuperview];
    self.view=nil;
    
    NSString *stringImage=nil;
    if ([imageData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        stringImage = [imageData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        stringImage = [imageData base64Encoding];                              // pre iOS7
    }
    
    
    if(self.shouldSaveSignature){
    
    if([imageData writeToFile:filePath atomically:YES])
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didCaptureUserSignatureWithSuccess:)])
        {
            [self prepareSuccessData:filePath];
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didCaptureUserSignatureWithError:withMessage:)])
        {
            [self prepareErrorData];
        }
    }
    }
    else
    {
        [self prepareSuccessData:stringImage];
    }
}

-(void)prepareSuccessData:(NSString*)signImage
{
    self.drawableView=nil;
    NSMutableDictionary *imageResponse=[[NSMutableDictionary alloc]init] ;
    
    if(self.shouldSaveSignature)
       [imageResponse setValue:signImage forKey:MMI_RESPONSE_PROP_SIGN_IMAGE_URL];
    else
        [imageResponse setValue:signImage forKey:MMI_RESPONSE_PROP_SIGN_IMAGE_DATA];
    [imageResponse setValue:signImageFormat forKey:MMI_RESPONSE_PROP_SIGN_IMAGE_TYPE];
    NSString *imageData=[AppUtils getJsonFromDictionary:imageResponse];
    NSLog(@"prepare success Data before capture");
    [self.delegate didCaptureUserSignatureWithSuccess:imageData];
     NSLog(@"prepare success Data after capture");
}

-(void)prepareErrorData
{
    drawableView=nil;
    [self.delegate didCaptureUserSignatureWithError:USER_SIGN_CAPTURE_ERROR.intValue withMessage:USER_SIGN_CAPTURE_ERROR_MESSAGE];
}

////Device rotation related operations
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation==UIInterfaceOrientationLandscapeRight) ;
}

- (BOOL)shouldAutorotate
{
    return TRUE;
}
//Used to set all the orientations that must be supported by the device

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
 }

//-------------------------------------------------------------------------------------------------------------------------

- (void)orientationChanged:(NSNotification *)notification
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.view.center=CGPointMake(screenWidth/2,screenHeight/2);
}

@end
