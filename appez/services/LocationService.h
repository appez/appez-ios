//
//  LocationService.h
//  appez
//
//  Created by Transility on 7/28/14.
//
//

#import <Foundation/Foundation.h>
#import "SmartService.h"
#import "AlertViewDelegate.h"
#import "SmartServiceDelegate.h"
#import "AlertView.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationService : SmartService<AlertViewDelegate,CLLocationManagerDelegate>
{
    id<SmartServiceDelegate> smartServiceDelegate;
    CLLocation *currentLocation;
    CLLocationManager *locManager;
    SmartEvent *smartEvent;
    float locationRequestTimeout;
    NSString *locationAccuracy;
    BOOL isUseGpsRequested,isUseNetworkRequested,isGPSEnabled,isNetworkEnabled;
    CLLocation *deviceCurrentLocation;
    AlertView *mDialogBuilder;
    CLLocationManager *locationManager;
}
@property(nonatomic, strong) CLLocationManager *locationManager;
-(instancetype)initWithSmartServiceDelegate:(id<SmartServiceDelegate>)delegate;
@end
