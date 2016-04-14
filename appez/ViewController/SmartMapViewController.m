//
//  SmartMapViewController.m
//  appez
//
//  Created by Transility on 09/08/12.
//
//

#import "SmartMapViewController.h"
#import "SmartDirectionViewController.h"
#import "AppUtils.h"
#import "SmartConstants.h"
#import <MapKit/MapKit.h>
#import "SmartUIUtility.h"
#import "ExceptionTypes.h"
#import "MobiletException.h"
#import "PunchInformation.h"
#import "CoEvents.h"
#import "AppStartupManager.h"

#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

@interface SmartMapViewController()
@property(nonatomic,readwrite) BOOL isDirectionViewAppear;
- (void)showContentView:(NSMutableArray *) overlapedAnnotations withMKAnnotationView:(MKAnnotationView *) view;
- (void) recenterMap;
- (void) addAnnotations;
-(void)addAccessoryButton:(MKPinAnnotationView*)annView;
-(void)showDirectionVC:(id)sender;
- (double)getCurrentZoomLevel:(MKMapView *) theMapView;
@end


@implementation SmartMapViewController
@synthesize punchLocations;
@synthesize showAccessoryButton;
@synthesize showAnimation;
@synthesize delegate;
@synthesize mapView;
@synthesize isDirectionViewAppear;
@synthesize mapData;
@synthesize punchInformation;
@synthesize animationType;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        return self;
    }
    return nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //Parse Json Data
    NSError *error=nil;
    NSDictionary *mapDataDict=[AppUtils getDictionaryFromJson:mapData];
    if(error)
        @throw [MobiletException MobiletExceptionWithType:JSON_PARSE_EXCEPTION Message:error.description];
    //setting the punch location and punch information
    self.punchLocations=[AppUtils punchLocation:[mapDataDict valueForKey:MMI_REQUEST_PROP_LOCATIONS]];
    self.punchInformation=[AppUtils punchInformation:[mapDataDict valueForKey:PUNCH_INFORMATION]];
    self.animationType=[[mapDataDict valueForKey:MMI_REQUEST_PROP_ANIMATION_TYPE] intValue];
    
    
    self.locationManager=[CLLocationManager new];
    [self.locationManager setDelegate:self];
    // we have to setup the location maanager with permission in later iOS versions
    if ([[self locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[self locationManager] requestWhenInUseAuthorization];
    }
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [[self locationManager] startUpdatingLocation];
    
    
    [self.mapView setDelegate:self];
    //calling the method to add annotations to the locations
    [self addAnnotations];
    if(self.punchLocations.count>0)
        [self recenterMap];
    
    //Setting the current location of the user to be visible
    self.mapView.showsUserLocation=YES;
    
    if(self.punchInformation.count>0)
        [self addAnnotationDetailView];
    
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isDirectionViewAppear=FALSE;
    [SmartUIUtility sharedInstance].delegate=self;
    if([AppUtils getSystemVersion]>=7.0)
        self.view.backgroundColor=[UIColor whiteColor];
    if(self.navigationController)
    {
        self.navigationController.navigationBarHidden=FALSE;
        self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSArray *vComp = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[vComp objectAtIndex:0] intValue] >= 7) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset =20.0;
        viewBounds.origin.y = -topBarOffset;
        self.view.bounds = viewBounds;
    }
    [AppUtils setMapBusy:FALSE];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    if(isDirectionViewAppear==FALSE && delegate && [delegate conformsToProtocol:@protocol(SmartCoActionDelegate)])
       [delegate didCompleteCoActionWithSuccess:nil];
    
    if(showAnimation==TRUE)
   {
       [AppUtils showDebugLog:[NSString stringWithFormat:@"animationType is %d",self.animationType]];
       
       if(self.animationType == ANIMATION_CURL_PLAY)
           [AppUtils curlDownAnimationForView:self.navigationController.view];
       else if(self.animationType==ANIMATION_FLIP_PLAY)
           [AppUtils flipFromRightAnimationForView:self.navigationController.view];
       else
           [AppUtils showDebugLog:@"Hide map view, invalid case of animation"];
   }
}

-(void)configureBackButton
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init] ;
    if([AppUtils getSystemVersion]>=7.0)
         barButtonItem.title=@"";
    else
       barButtonItem.title = @"Back";
    
    self.navigationItem.backBarButtonItem = barButtonItem;
}
#define RectWidth  15
#define RectHeight 15
#define FontName  @"Times New Roman"
#define FontSize 12.0

-(void)addAnnotationDetailView
{
    
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,25)];
    
    CGFloat startPoint=0.0;
	CGFloat endPoint=0.0;
	
	for(NSInteger iCount=0 ; iCount <self.punchInformation.count; iCount++)
	{
        PunchInformation *punchInfo=[self.punchInformation objectAtIndex:iCount];
		NSString *infoStr=punchInfo.title;
		UIColor  *infoColor=[AppUtils colorFromHexString:punchInfo.hexColorForPin];

		CGSize pixelSize = [infoStr sizeWithFont:[UIFont fontWithName:FontName size:FontSize]];
		
		UIView *informationView = [[UIView alloc] initWithFrame:CGRectMake(0+startPoint,0,(pixelSize.width+RectWidth+40),20)];
		[informationView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		[informationView setBackgroundColor:[UIColor clearColor]];
		
		//create a rectangle
		UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(0,0,RectWidth,RectHeight)];
		rectView.backgroundColor =infoColor;
		
		//craete a  lable for showing information
		UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(rectView.frame.origin.x+rectView.frame.size.width+3,0,(pixelSize.width+50),RectHeight)];
		
        infoLabel.text = infoStr;
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.textColor=[UIColor blackColor];
		[infoLabel setFont:[UIFont systemFontOfSize:FontSize]];
		[informationView addSubview:rectView];
		[informationView addSubview:infoLabel];

		
		[scrollView addSubview:informationView];
		startPoint+=informationView.frame.size.width+RectWidth;
		endPoint+=informationView.frame.size.width;
        
	}
	scrollView.contentSize = CGSizeMake(endPoint+(self.punchInformation.count*RectWidth),15);
    
	[self.view addSubview:scrollView];
    
    
}

//Adding annotation pin to all those locations which are available
- (void)addAnnotations {
    
    for(PunchLocation *punchLocation in self.punchLocations) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:punchLocation.latitude longitude:punchLocation.longitude];
        [punchLocation setLocation:location];
        //[location release];
        
        CustomMapAnnotation *annotation = [[CustomMapAnnotation alloc] initWithPunchLocation:punchLocation];
        [self.mapView addAnnotation:annotation];
        //[annotation release];
    }
    
}

- (void) recenterMap {
    
	NSArray *coordinates = [self.mapView valueForKeyPath:@"annotations.coordinate"];
	CLLocationCoordinate2D maxCoord = {-90.0f, -180.0f};
	CLLocationCoordinate2D minCoord = {90.0f, 180.0f};
    
	for(NSValue *value in coordinates) {
        
		CLLocationCoordinate2D coord = {0.0f, 0.0f};
		[value getValue:&coord];
		if(coord.longitude > maxCoord.longitude) {
			maxCoord.longitude = coord.longitude;
		}
		if(coord.latitude > maxCoord.latitude) {
			maxCoord.latitude = coord.latitude;
		}
		if(coord.longitude < minCoord.longitude) {
			minCoord.longitude = coord.longitude;
		}
		if(coord.latitude < minCoord.latitude) {
			minCoord.latitude = coord.latitude;
		}
	}
	
	MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
	region.center.longitude = (minCoord.longitude + maxCoord.longitude) / 2.0;
	region.center.latitude = (minCoord.latitude + maxCoord.latitude) / 2.0;
	region.span.longitudeDelta = maxCoord.longitude - minCoord.longitude;
	region.span.latitudeDelta = maxCoord.latitude - minCoord.latitude;
	[self.mapView setRegion:region animated:YES];
}
# pragma mark- MKMapViewDelegate
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    
    static NSString *defaultPinID = @"currentloc";
    CustomMapAnnotation *theAnnotation = (CustomMapAnnotation *)annotation;
    CustomMapAnnotationView *annView=nil;
    if([theAnnotation isKindOfClass:[MKUserLocation class]])
    {
        MKUserLocation *userLocation=(MKUserLocation*)annotation;
        userLocation.title=@"Current Location";
        currentUserLocation=userLocation.location.coordinate;
        annView=[[CustomMapAnnotationView alloc] initWithAnnotation:userLocation reuseIdentifier:defaultPinID] ;
    }
    
   else//means annotation is not instance of MKUserLocation
   {
      
       if(![annotation isKindOfClass:[CustomMapAnnotation class]])
       {
           annView=nil;
       }
       else
       {
           // Create the ZSPinAnnotation object and reuse it
           annView = (CustomMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
           if (annView == nil)
           {
               annView = [[CustomMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
           }
    
           // Set the type of pin to draw and the color
           annView.annotationType = PinAnnotationTypeStandard;
           annView.annotationColor = theAnnotation.color;
           annView.canShowCallout = YES;
           annView.calloutOffset = CGPointMake(-5, 5);

          if(showAccessoryButton==TRUE)
           {
               NSLog(@"---------showAccessoryButton------SmartViewController->mapView:viewForAnnotation->customMapAnnotation------");
               [self addAccessoryButton:annView];
           }
       }
   }
    return annView;

}

/**Showing the accessory button on any annotation view when selecting map with directions.The 
 *click of the accessory button will take to the new screen showing the map with directions
 */
-(void)addAccessoryButton:(MKPinAnnotationView*)annView
{
    UIButton *accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accessoryButton.frame = CGRectMake(annView.frame.size.width-20, 0, 20, 20);
    accessoryButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    accessoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [accessoryButton setImage:[UIImage imageNamed:@"appezResources.bundle/leftarrow.png"] forState:UIControlStateNormal];
    [accessoryButton addTarget:self action:@selector(showDirectionVC:) forControlEvents:UIControlEventTouchUpInside];
    
    annView.rightCalloutAccessoryView = accessoryButton;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    CustomMapAnnotation *theAnnotation = (CustomMapAnnotation *)view.annotation;
    if(![theAnnotation isKindOfClass:[MKUserLocation class]])
    {
        selectedUserLocation=theAnnotation.coordinate;
    }
}

- (void) showContentView:(NSMutableArray *) overlapedAnnotations withMKAnnotationView:(MKAnnotationView *) view {
    // blank implementation for iPhone as of now
}

- (void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    CGRect visibleRect = [self.mapView annotationVisibleRect];
    
    double delay = 0.0;
    
    for (MKAnnotationView *view in views) {
        
        CGRect endFrame = view.frame;
        
        CGRect startFrame = endFrame;
        startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
        view.frame = startFrame;
        
        [UIView beginAnimations:@"drop" context:NULL];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelay:delay];
        view.frame = endFrame;
        
        [UIView commitAnimations];
        delay += 0.05;
    }
}

- (double) getCurrentZoomLevel:(MKMapView *) theMapView {
    CLLocationDegrees longitudeDelta = theMapView.region.span.longitudeDelta;
    CGFloat mapWidthInPixels = theMapView.bounds.size.width;
    double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
    double zoomer = MAX_GOOGLE_LEVELS - log2(zoomScale);
    if (zoomer < 0) zoomer = 0;
    return zoomer;
}

#pragma
#pragma mark - Methods
#pragma

/**
 *Method to navigate to the map with directions view.
 */
-(void)showDirectionVC:(id)sender
{
    self.isDirectionViewAppear=TRUE;
    
    if(currentUserLocation.latitude && currentUserLocation.longitude)
    {
        [[SmartUIUtility sharedInstance] showDirectionViewWithLocation:currentUserLocation WithLocation:selectedUserLocation];
    }
    else
    {
        if(delegate && [delegate conformsToProtocol:@protocol(SmartCoActionDelegate)])
            [delegate didCompleteCoActionWithError:UNKNOWN_CURRENT_LOCATION_EXCEPTION.intValue WithMessage:UNKNOWN_CURRENT_LOCATION_EXCEPTION_MESSAGE];
    }
}

//Setting the orientation of the activity view
-(void)setActivityViewOrientaion
{
    [[SmartUIUtility sharedInstance] adjustLayoutOnOrientation:self.orientation];
}

//This method is called when the device orientation is changed
- (void)orientationChanged:(NSNotification *)notification

{
    NSString *topBarbgColor=[AppStartupManager getTopbarStylingInfoBean].topbarBgColor;
    if(topBarbgColor!=nil){
        UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, -20)];
        statusBarView.backgroundColor = [AppUtils colorFromHexString:topBarbgColor];
        [self.view addSubview:statusBarView];
        //[statusBarView release];
    }
    
    self.orientation=[[UIApplication sharedApplication] statusBarOrientation];
    
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


//-------------------------------------------------------------------------------------------------------------------------
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

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    currentUserLocation=location.coordinate;
    
}
@end

