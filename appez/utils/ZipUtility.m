//
//  ZipUtility.m
//  appez
//
//  Created by Transility on 5/25/14.
//
//

#import "ZipUtility.h"
#import "ZipArchive.h"
#import "CommMessageConstants.h"
#import "AppUtils.h"
#import "ExceptionTypes.h"

@implementation ZipUtility

-(instancetype)initWithSource:(NSString *)source targetArchive:(NSString *)targetArchive andDelegate:(id<SmartZipDelegate>)zipDelegate
{
    self=[super init];
    if(self)
    {
        sourceToArchive=source;
        outputZipFile=targetArchive;
        smartZipDelegate=zipDelegate;
    }
    return self;
}

-(void)zipIt
{
   ZipArchive *zipArchive = [[ZipArchive alloc] init] ;
      BOOL isDir;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subpaths;
    NSString *exportPath=[sourceToArchive stringByDeletingLastPathComponent];

    if ([fileManager fileExistsAtPath:exportPath isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:exportPath];
    }
    [zipArchive CreateZipFile2:outputZipFile];
    NSString *path;
    for(path in subpaths)
    {
        NSString *longPath = [exportPath stringByAppendingPathComponent:path];
        if([fileManager fileExistsAtPath:longPath isDirectory:&isDir] && !isDir )
        {
            [zipArchive addFileToZip:longPath newname:path];
        }
    }
    isZipSuccess=[zipArchive CloseZipFile2];
    [self postExecution];
}

-(void)postExecution
{
    if(isZipSuccess)
    {
        NSMutableDictionary *zipOperationCompletionResponse=[[NSMutableDictionary alloc]init];
        [zipOperationCompletionResponse setValue:outputZipFile forKey:MMI_RESPONSE_PROP_FILE_ARCHIVE_LOCATION];
        NSString *unzipData=[AppUtils getJsonFromDictionary:zipOperationCompletionResponse];
        [smartZipDelegate didCompleteZipOperationWithSuccess:unzipData];
    }
    else
    {
        [smartZipDelegate didCompleteZipOperationWithError:FILE_ZIP_ERROR_MESSAGE];
    }
}

-(void)ErrorMessage:(NSString *)msg
{
    [AppUtils showDebugLog:msg];
}
@end
