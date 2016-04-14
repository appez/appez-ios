//  CustomMapAnnotation.h
//  appez
//
//  Created by Transility on 2/27/12.
/**
 * PunchLocation : Model bean containing attributes that define the user
 * coordinate on a map, punch location and Punch type.
 * */

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomMapAnnotationView.h"

@class PunchLocation;

@interface CustomMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) PunchLocation *punchLocation;

/// The coordinate for the annotation
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/// The title for the annotation
@property (nonatomic, copy) NSString *title;

/// The subtitle for the annotation
@property (nonatomic, copy) NSString *subtitle;

/// The color of the annotation
@property (nonatomic, strong) UIColor *color;

/// The type of annotation to draw
@property (nonatomic) PinAnnotationType type;

- (instancetype) initWithPunchLocation:(PunchLocation *) punchLocation;

@end
