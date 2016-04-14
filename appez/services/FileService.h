//
//  FileService.h
//  appez
//
//  Created by Transility on 4/15/14.
//
//

#import <Foundation/Foundation.h>
#import "SmartService.h"
#import "SmartServiceDelegate.h"
#import "FileReadUtility.h"
#import "CommMessageConstants.h"
#import "SmartUnzipDelegate.h"
#import "SmartZipDelegate.h"

@interface FileService : SmartService<SmartZipDelegate,SmartUnzipDelegate>
{
    SmartEvent *smartEvent;
    id<SmartServiceDelegate> smartServiceDelegate;
    FileReadUtility *fileReadUtility;
    NSString *tempArchiveFileAbsLocation;
    NSString *tempSourceAbsLocation;
    NSString *zipAssetFolderName;
	BOOL isArchiveToCreateFile ;
}
-(instancetype)initFileServiceWithDelegate:(id<SmartServiceDelegate>)delegate;
@end
