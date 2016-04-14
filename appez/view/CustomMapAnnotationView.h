//
//  CustomMapAnnotationView.h
//
//


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <MapKit/MapKit.h>

typedef enum {
    PinAnnotationTypeStandard,
    PinAnnotationTypeDisc,
    PinAnnotationTypeTag,
    PinAnnotationTypeTagStroke
} PinAnnotationType;

/*!
 A styled pin icon to be placed on an MKMapView. All drawing is done in CoreGraphics and cached as an image using NSCache.
 */
@interface CustomMapAnnotationView : MKPinAnnotationView

/// The annotation type to draw
@property (nonatomic) PinAnnotationType annotationType;

/// The color to draw the annotation
@property (nonatomic, strong) UIColor *annotationColor;

@end
