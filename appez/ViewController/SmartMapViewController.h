//
//  SmartMapViewController.h
//  appez
//
//  Created by Transility on 09/08/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PunchLocation.h"
#import "CustomMapAnnotation.h"
#import "SmartCoActionDelegate.h"
#import "CommMessageConstants.h"
@interface SmartMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>
{

    NSMutableArray *punchLocations;
    NSMutableArray *punchInformation;
    CLLocationCoordinate2D currentUserLocation;
    CLLocationCoordinate2D selectedUserLocation;
    BOOL showAccessoryButton;
    BOOL showAnimation;
    NSString *mapData;
    int animationType;
}
-(void)configureBackButton;
-(void)addAnnotationDetailView;
@property (nonatomic,readwrite) UIInterfaceOrientation orientation;
@property(nonatomic,retain)    NSString *mapData;
@property(nonatomic,readwrite) int animationType;
@property(nonatomic,strong)    id<SmartCoActionDelegate>delegate;
@property(nonatomic,readwrite)    BOOL showAnimation;
@property(nonatomic,readwrite)    BOOL showAccessoryButton;
@property(nonatomic,retain) NSMutableArray *punchLocations;
@property(nonatomic,retain) NSMutableArray *punchInformation;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *locationManager;
-(void)setActivityViewOrientaion;

@end
