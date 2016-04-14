//  PunchLocation.h
//  appez
//
//  Created by Transility on 2/27/12.
//

/**
 * PunchLocation : Model bean containing attributes that define the user
 * location on a map, location description and its coloured marker. This model
 * defines the above mentioned properties for a single location on the map. For
 * marking multiple locations on the map, an array of these fields needs to be
 * sent from the web layer
 *
 * */

#import <CoreLocation/CoreLocation.h>
#import "SmartConstants.h"

@interface PunchLocation : NSObject {

    CLLocation *location;   //The encapsulated data type location which constitutes of latitude longitude, altitude etc to describe a location.
    NSString *title;        // Title of the location to be marked. This gets shown in the info-bubble
	// marker of the location.
    NSString  *description; // Description of the location to be marked. This gets shown in the
	// info-bubble marker of the location
    float latitude;         // Latitude of the location
    float longitude;    	// Longitude of the location
    int punchType;          
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString  *description;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, readwrite) NSString *hexColorForPin;
@property (nonatomic, readwrite) float latitude;
@property (nonatomic, readwrite) float longitude;

- (BOOL) hasValidGEOLocation;

@end
