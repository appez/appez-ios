//
//  SmartDirectionViewController.h
//  appez
//
//  Created by Transility on 17/08/12.
//
/**
 * Native activity for showing the direction screen.
 *Uses Google Map web API for getting direction data
 **/

#import <UIKit/UIKit.h>
#import "NetworkService.h"
#import <MapKit/MapKit.h>
#import "AlertView.h"

@interface SmartDirectionViewController : UIViewController<SmartNetworkDelegate>
{
    NSDictionary *directionDict;
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D selectedLocation;
    NSMutableArray *directionArray;
  
}
@property (nonatomic,readwrite) UIInterfaceOrientation orientation;
@property(nonatomic,readwrite) CLLocationCoordinate2D currentLocation;
@property(nonatomic,readwrite) CLLocationCoordinate2D selectedLocation;
@property (retain, nonatomic) IBOutlet UIWebView *mWebView;
@property (retain, nonatomic) IBOutlet UIImageView *mImageView;
-(void)createView;
-(void)setActivityViewOrientaion;
@end
