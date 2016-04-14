//
//  PunchInformation.h
//  appez
//
//  Created by Transility on 13/09/12.
//

#import <Foundation/Foundation.h>

@interface PunchInformation : NSObject
{
    NSString *title;
    int punchType;
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, readwrite) NSString * hexColorForPin;
@end
