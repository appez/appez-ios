//  CustomMapAnnotation.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "CustomMapAnnotation.h"
#import "Strings.h"
#import "PunchLocation.h"
#import "AppUtils.h"
@implementation CustomMapAnnotation

- (instancetype) initWithPunchLocation:(PunchLocation *) punchLocation {
	self = [super init];
	if(nil != self) {
        self.punchLocation = punchLocation;
        self.coordinate = punchLocation.location.coordinate;
        self.color=[AppUtils colorFromHexString:punchLocation.hexColorForPin];
        self.title=self.punchLocation.title;
        self.subtitle=self.punchLocation.description;
	}
	return self;
}
/**
 Getter method that returns the title of the particular punch location to be displayed
 */
- (NSString *) title {
    return self.punchLocation.title;
}
/**
 Getter method that returns the subtitle of the particular punch location to be displayed
 */
- (NSString *) subtitle {
    return  self.punchLocation.description;
}

@end
