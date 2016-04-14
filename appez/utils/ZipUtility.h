//
//  ZipUtility.h
//  appez
//
//  Created by Transility on 5/25/14.
//
//

#import <Foundation/Foundation.h>
#import "SmartZipDelegate.h"
#import "ZipArchive.h"
@interface ZipUtility : NSObject<ZipArchiveDelegate>
{
    NSString *outputZipFile;
    NSString *sourceToArchive;
	BOOL isZipSuccess;
    id<SmartZipDelegate> smartZipDelegate;
}
-(void)zipIt;
-(instancetype)initWithSource:(NSString*)source targetArchive:(NSString*)targetArchive andDelegate:(id<SmartZipDelegate>)zipDelegate;
@end