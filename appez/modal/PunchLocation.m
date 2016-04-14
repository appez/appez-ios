//  PunchLocation.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "PunchLocation.h"
#import "SmartConstants.h"

@implementation PunchLocation

@synthesize location;
@synthesize hexColorForPin;
@synthesize latitude;
@synthesize longitude;
@synthesize title;
@synthesize description;

//Checks if a location having certain latitude longitude is valid or not.
- (BOOL) hasValidGEOLocation {
    if (latitude == 0 && longitude == 0) {
        return false;
    }
    return true;
}

@end
