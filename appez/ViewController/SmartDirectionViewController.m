//
//  SmartDirectionViewController.m
//  appez
//
//  Created by Transility on 17/08/12.
//
//

#import "SmartDirectionViewController.h"
//#import "SBJsonWriter.h"
#import "SmartUIUtility.h"
//#import "NSString+SBJSON.h"
#import "SmartConstants.h"
#import "AppStartupManager.h"

#define REQUEST_FORMAT @"URI|%@^HTTPVERB|%@^REQUESTBODY|%@^HEADER|%@"
#define GOOGLE_MAP_API @"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true"
 
@interface SmartDirectionViewController ()
-(NSString*)getRequest;
-(void)prepareHtml;

@property(nonatomic,readwrite) BOOL showImage;
@end

@implementation SmartDirectionViewController
@synthesize currentLocation;
@synthesize selectedLocation;
@synthesize mWebView;
@synthesize mImageView;
@synthesize showImage;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"SmartDirectionViewController->init");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.mWebView.subviews objectAtIndex:0] setScrollEnabled:YES];  //to stop scrolling completely
    [[self.mWebView.subviews objectAtIndex:0] setBounces:NO]; //to stop bouncing
    self.orientation=UIInterfaceOrientationPortrait;
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(orientationChanged:)
     
                                                 name:UIDeviceOrientationDidChangeNotification
     
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=@"Route Directions";
    [SmartUIUtility sharedInstance].delegate=self;
    [[SmartUIUtility sharedInstance] showActivityViewWithMessage:@"Loading Data...."];
    
    //Execute the request in separate thread(non-main thread)
    dispatch_queue_t dispatchQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^{
        [self createView];
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)createView
{
    [[SmartUIUtility sharedInstance] showActivityViewWithMessage:@"Loading Data...."];
    if(self.currentLocation.latitude && self.selectedLocation.latitude)
    {
        NetworkService *service=[[NetworkService alloc] initWithDelegate:self] ;
        [service performSyncRequest:[self getRequest] WithFlag:NO];
    }
}

/**
 *Creates the request to get directions from current to the selected location from google api
 */
-(NSString*)getRequest
{
    NSMutableDictionary *directionReqObj=[[NSMutableDictionary alloc]init];
    NSString *urlString=[NSString stringWithFormat:GOOGLE_MAP_API,currentLocation.latitude,currentLocation.longitude,selectedLocation.latitude,selectedLocation.longitude];
    
    [directionReqObj setValue:HTTP_REQUEST_VERB_GET forKey:MMI_REQUEST_PROP_REQ_METHOD];
    [directionReqObj setValue:urlString forKey:MMI_REQUEST_PROP_REQ_URL];
 
    NSString *requestFormat=[AppUtils getJsonFromDictionary:directionReqObj];
                             
    return requestFormat;
}

//Setting the orientation of the activity view
-(void)setActivityViewOrientaion
{
    [[SmartUIUtility sharedInstance] adjustLayoutOnOrientation:[[UIApplication sharedApplication]statusBarOrientation]];
}

- (void)viewDidUnload
{
    [self setMWebView:nil];
    [self setMImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.orientation = interfaceOrientation;
    
    //Return YES for supported orientations
    if([AppUtils isDeviceiPad] == TRUE)
    {
        [[SmartUIUtility sharedInstance] adjustLayoutOnOrientation:interfaceOrientation];
        return TRUE;
    }
    else
    {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark- Smart Network Delegate

/** Updates SmartEventResponse and thereby SmartEvent based on the HTTP operation performed in NetworkService.
 * Also notifies SmartServiceListener about successful completion of HTTP operation
 *
 * @param fileName : Name of the file where the HTTP response data has been dumped
 * @param responseData : HTTP response data
 *
 */
-(void)didCompleteHttpOperationWithSuccess:(NSString*)responseData
{
    NSDictionary *jsonObject=[AppUtils getDictionaryFromJson:responseData];
     NSArray *routesArray=[jsonObject valueForKey:@"routes"];

    directionArray=[NSMutableArray array];

    if(routesArray.count>0)
    {
        NSArray *legsArray=[[routesArray objectAtIndex:0] valueForKey:@"legs"];
        NSArray *stepsArray=[[legsArray objectAtIndex:0] valueForKey:@"steps"];
        for (NSDictionary *dict in stepsArray)
        {
            [directionArray addObject:[dict valueForKey:@"html_instructions"]];
        }
        //[directionArray retain];
    }
    //Run on main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        if(directionArray.count>0)
        {
            [self prepareHtml];
        }
        [[SmartUIUtility sharedInstance] hideActivityView];

    });
   
}
/** Notifies SmartServiceListener about unsuccessful completion of HTTP operation
 *
 * @param exceptionData : Exception type
 *
 */
-(void)didCompleteHttpOperationWithError:(int)exceptionData WithMessage:(NSString *)exceptionMessage
{
    [[SmartUIUtility sharedInstance] hideActivityView];
}

-(void)prepareHtml
{
    NSMutableString *htmlString=[NSMutableString string];
    [htmlString appendString:@"<!doctype html> <html> <head> <meta charset=\"UTF-8\"/> </head><body style='margin:0px; padding:0px; font-family:'Droid Sans', 'Helvetica'; font-size:14px; line-height:16px;'><div><ul style='display: block; list-style-type: none; -webkit-margin-before: 0em; -webkit-margin-after: 0em; -webkit-margin-start: 0px; -webkit-margin-end: 0px; -webkit-padding-start: 0px;'>"];
    
    for(int i=0 ; i<directionArray.count ; i++)
    {
        [htmlString appendString:@"<li style='border-bottom:#999 thin solid; padding:10px 0px 10px 10px;'>"];
        [htmlString appendFormat:@"%@",[directionArray objectAtIndex:i]];
        [htmlString appendString:@"</li>"];
        
    }
    
    [htmlString appendString:@"</ul></div></body></html>"];
    
    
   [htmlString appendString:@"</div></ul></body></hrml>"];
    
    [self.mWebView loadHTMLString:htmlString baseURL:nil];
     
}

#pragma 
#pragma mark - WebView Delegate Methods
#pragma 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[SmartUIUtility sharedInstance] hideActivityView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}



- (NSUInteger)supportedInterfaceOrientations
{
    if([AppUtils isDeviceiPad] == TRUE)
    {
        [[SmartUIUtility sharedInstance] adjustLayoutOnOrientation:self.orientation];
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        self.orientation=UIInterfaceOrientationPortrait;
        return (UIInterfaceOrientationMaskPortrait);
    }
    
    return (UIInterfaceOrientationMaskPortrait);
}

- (void)orientationChanged:(NSNotification *)notification

{
    NSString *topBarbgColor=[AppStartupManager getTopbarStylingInfoBean].topbarBgColor;
    if(topBarbgColor!=nil){
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, -20)];
        statusBarView.backgroundColor = [AppUtils colorFromHexString:topBarbgColor];
        [self.view addSubview:statusBarView];
    }
    
    self.orientation=[[UIApplication sharedApplication] statusBarOrientation];
}

- (BOOL)shouldAutorotate
{
    return TRUE;
}

@end
