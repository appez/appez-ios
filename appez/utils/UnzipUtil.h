//
//  UnzipUtil.h
//  appez
//
//  Created by Transility on 3/25/14.
//
//

#import <Foundation/Foundation.h>
#import "SmartUnzipDelegate.h"
#import "ZipArchive.h"

@interface UnzipUtil : NSObject<ZipArchiveDelegate>
{
    id<SmartUnzipDelegate> smartUnzipDelegate;
    NSString *zipFileName;
    NSString *zipfileLocation;
    @private BOOL isUnzipSuccess;
}
-(instancetype)initWithFileName:(NSString*)fileName fileLocation:(NSString*)fileLocation andDelegate:(id<SmartUnzipDelegate>)unzipDelegate;
-(void)extractUpgradeAssets;
@end
