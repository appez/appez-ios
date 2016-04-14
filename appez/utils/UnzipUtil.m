//
//  UnzipUtil.m
//  appez
//
//  Created by Transility on 3/25/14.
//
//

#import "UnzipUtil.h"
#import "SmartConstants.h"
#import "AppUtils.h"
#import "ExceptionTypes.h"

@implementation UnzipUtil

-(instancetype)initWithFileName:(NSString *)fileName fileLocation:(NSString *)fileLocation andDelegate:(id<SmartUnzipDelegate>)unzipDelegate
{
    self=[super init];
    if(self)
    {
    isUnzipSuccess=TRUE;
    zipFileName=fileName;
    zipfileLocation=fileLocation;
    smartUnzipDelegate=unzipDelegate;
    }
    return self;
}

-(void)extractUpgradeAssets
{
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    [AppUtils showDebugLog:[NSString stringWithFormat:@"zip file name %@",zipFileName]];
    
    if ([zipArchive UnzipOpenFile: zipFileName])
    {
        isUnzipSuccess = [zipArchive UnzipFileTo:zipfileLocation overWrite:YES];
        
        [self postExecution];
        [zipArchive UnzipCloseFile];
        
    }
    else
    {
        [AppUtils showDebugLog:@"UnzipUtil-->extractUpgradeAssets-->error uncompressing file"];
        [smartUnzipDelegate didCompleteUnZipOperationWithError:FILE_UNZIP_ERROR_MESSAGE];
    }
}

-(void)postExecution
{
    if (isUnzipSuccess)
    {
        NSMutableDictionary *zipOperationCompletionResponse=[[NSMutableDictionary alloc]init];
        [zipOperationCompletionResponse setValue:zipfileLocation forKey:MMI_RESPONSE_PROP_FILE_UNARCHIVE_LOCATION];
        NSString *unzipData=[AppUtils getJsonFromDictionary:zipOperationCompletionResponse];
        [smartUnzipDelegate didCompleteUnZipOperationWithSuccess:unzipData];
    }
    else
    {    //There was some problem extracting the ZIP file
        [smartUnzipDelegate didCompleteUnZipOperationWithError:FILE_UNZIP_ERROR_MESSAGE];
    }
}


-(void)ErrorMessage:(NSString *)msg
{
    [smartUnzipDelegate didCompleteUnZipOperationWithError:msg];

}

@end
