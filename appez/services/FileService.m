//
//  FileService.m
//  appez
//
//  Created by Transility on 4/15/14.
//
//
#import "SmartConstants.h"
#import "MobiletException.h"
#import "WebEvents.h"
#import "ExceptionTypes.h"
#import "AppUtils.h"
#import "FileService.h"
#import "UnzipUtil.h"
#import "SmartUnzipDelegate.h"
#import "CommMessageConstants.h"
#import "ZipUtility.h"

@interface FileService(PrivateMethods)
-(void)didCompleteFileOperationWithSuccess:(NSString *)fileResponseData;
-(void)didCompleteFileOperationWithError:(int)exceptionType andMessage:(NSString*)exceptionMessage;
-(void)readFileContents;
-(void)extractArchiveFile;
-(void)createArchiveFile;
@end

@implementation FileService
/**
 * Creates the instance of FileReadingService
 * @param smartServiceDelegate
 */

-(instancetype)initFileServiceWithDelegate:(id<SmartServiceDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        smartServiceDelegate=delegate;
    }
    return self;
}


-(void)performAction:(SmartEvent*)smartevent
{
    @try {
        fileReadUtility =[[FileReadUtility alloc]initFileReadUtility:smartevent.smartEventRequest.serviceRequestData];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception :%@",[exception description]);

    }
    
    smartEvent = smartevent;
    
    switch (smartEvent.smartEventRequest.serviceOperationId) {
            
        case WEB_READ_FILE_CONTENTS:
            [self readFileContents];
            break;
            
        case WEB_READ_FOLDER_CONTENTS:
            [self readFolderContents];
            break;
            
        case WEB_UNZIP_FILE_CONTENTS:
            [self extractArchiveFile];
            break;
            
        case WEB_ZIP_CONTENTS:
            [self createArchiveFile];
            break;
    }
}

/**
 * Responsible for the creation of ZIP archive file based on the specified
 * file/folder by the user
 *
 * */
-(void)createArchiveFile
{
    [self copySourceToMemory];
    NSString *targetArchiveFile=[[tempSourceAbsLocation stringByDeletingLastPathComponent]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",zipAssetFolderName]];
    // Add the logic for creating zip archive here
    ZipUtility *zipUtility=[[ZipUtility alloc]initWithSource:tempSourceAbsLocation targetArchive:targetArchiveFile andDelegate:self];
    [zipUtility zipIt];
}

-(void)copySourceToMemory
{
    NSString *assetSourceLocation=[smartEvent.smartEventRequest.serviceRequestData valueForKey:MMI_REQUEST_PROP_FILE_TO_READ_NAME];
    if(assetSourceLocation!=nil && [assetSourceLocation length]>0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        dateFormatter.dateFormat=@"yyyy-MM-dd-HH:mm";
        NSDate *date = [NSDate date];
        NSString *folderNameToSave = [NSString stringWithFormat:@"appez_zip_temp_%@", [dateFormatter stringFromDate:date]];
        zipAssetFolderName=[assetSourceLocation lastPathComponent];
        tempSourceAbsLocation=[[[AppUtils getDocumentpath] stringByAppendingPathComponent:folderNameToSave] stringByAppendingPathComponent:zipAssetFolderName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *bundlePath=[NSBundle mainBundle].bundlePath;
        NSString *absolutePath=[bundlePath stringByAppendingPathComponent:@"assets"];
        
        [AppUtils showDebugLog:[NSString stringWithFormat:@"tempSourceAbsLocation->%@",[absolutePath stringByAppendingPathComponent:assetSourceLocation]]];
        
        [fileManager createDirectoryAtPath:tempSourceAbsLocation withIntermediateDirectories:YES attributes:nil error:nil];
        
        if([fileManager fileExistsAtPath:tempSourceAbsLocation])
        {
            [fileManager removeItemAtPath:tempSourceAbsLocation error:nil];
        }
        [fileManager copyItemAtPath:[absolutePath stringByAppendingPathComponent:assetSourceLocation] toPath:tempSourceAbsLocation  error:nil];
    }
}


-(void)readFolderContents
{
    NSString *fileContents = nil;
    
    @try {
        // Read the contents of the folder using File reading utility
        fileContents =[fileReadUtility getFileContentInFolder];
        // Provide the data received from file reading operation
        [self didCompleteFileOperationWithSuccess:fileContents];
    }
    @catch (NSException *exception) {
        [self didCompleteFileOperationWithError:UNKNOWN_EXCEPTION.intValue andMessage:[exception description]];
    }
}

-(void)readFileContents
{
    NSString *fileContents = nil;
    
    @try {
        // Read the contents of the file using File reading utility
        fileContents =[fileReadUtility getFileContents];
        if(fileContents!=nil){
            // Provide the data received from file reading operation
            [self didCompleteFileOperationWithSuccess:fileContents];
        }
        else
        {
            [self didCompleteFileOperationWithError:IO_EXCEPTION.intValue andMessage:nil];
        }
    }
    @catch (NSException *exception) {
        [self didCompleteFileOperationWithError:UNKNOWN_EXCEPTION.intValue andMessage:[exception description]];
    }
}

-(void)copyArchiveFileToDocDirectory:(NSString*)archiveFileLocationInAssets
{
    tempArchiveFileAbsLocation=[AppUtils getDocumentpath];
    tempArchiveFileAbsLocation=[tempArchiveFileAbsLocation stringByAppendingPathComponent:@"temp.zip"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [AppUtils showDebugLog:[NSString stringWithFormat:@"after temp file loc %@",tempArchiveFileAbsLocation]];
    [fileManager copyItemAtPath:archiveFileLocationInAssets toPath:tempArchiveFileAbsLocation error:nil];
}

-(BOOL)deleteTempArchiveFile
{
    return  [AppUtils deleteFileAtPath:tempArchiveFileAbsLocation];
}

/**
 * Responsible for extracting the contents of the specified ZIP file. The
 * user specifies the location of the ZIP file wrt the application assets
 * folder
 *
 * */

-(void)extractArchiveFile
{
    NSString *folderLocation=NULL;
    NSString *assetArchiveFileLocation=[smartEvent.smartEventRequest.serviceRequestData valueForKey:MMI_REQUEST_PROP_FILE_TO_READ_NAME];
    NSString *bundlePath=[NSBundle mainBundle].bundlePath;
    NSString *absolutePath=[bundlePath stringByAppendingPathComponent:@"assets"];
    assetArchiveFileLocation=[absolutePath stringByAppendingPathComponent:assetArchiveFileLocation];
    
    [self copyArchiveFileToDocDirectory:assetArchiveFileLocation];
    
    if ([[assetArchiveFileLocation pathExtension] isEqualToString:@"zip"])
    {
        folderLocation=[tempArchiveFileAbsLocation stringByReplacingOccurrencesOfString:@".zip" withString:@""];
        UnzipUtil *unzipUtil=[[UnzipUtil alloc]initWithFileName:tempArchiveFileAbsLocation fileLocation:folderLocation andDelegate:self];
        [unzipUtil extractUpgradeAssets];
    }
    else
    {
        [self didCompleteFileOperationWithError:FILE_UNZIP_ERROR.intValue andMessage:FILE_UNZIP_ERROR_MESSAGE];
    }
}

-(BOOL)deleteTempFile
{
   return [AppUtils deleteFileAtPath:tempSourceAbsLocation];
}

-(void)didCompleteZipOperationWithSuccess:(NSString *)opCompData
{
    [self deleteTempFile];
    [self didCompleteFileOperationWithSuccess:opCompData];
}

-(void)didCompleteZipOperationWithError:(NSString *)errorMessage
{
    [self deleteTempFile];
    [self didCompleteFileOperationWithError:FILE_ZIP_ERROR.intValue andMessage:errorMessage];
}

/**
 * Delegate method that informs the successful completion of the Unzip Operation
 **/

-(void)didCompleteUnZipOperationWithSuccess:(NSString *)opCompData
{
    if([self deleteTempArchiveFile])
        [self didCompleteFileOperationWithSuccess:opCompData];
}

/**
 * Delegate method that informs the unsuccessful completion of the Unzip Operation
 **/
-(void)didCompleteUnZipOperationWithError:(NSString *)errorMessage
{
    [self didCompleteFileOperationWithError:FILE_UNZIP_ERROR.intValue andMessage:errorMessage];
}

/**
 * Specifies action to be taken on successful completion of file read
 * operation
 *
 * @param fileContent
 *            : Content of the file/folder that was read
 *
 * */

-(void)didCompleteFileOperationWithSuccess:(NSString *)fileResponseData
{
    SmartEventResponse *smEventResponse=[AppUtils createSuccessResponseWithserviceResponse:fileResponseData];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithSuccess:smartEvent];
}

/**
 * Specifies action to be taken on unsuccessful completion of file read
 * operation
 *
 * @param :exceptionMessage
 * */

-(void)didCompleteFileOperationWithError:(int)exceptionType andMessage:(NSString*)exceptionMessage
{
    SmartEventResponse *smEventResponse =[AppUtils createErrorResponseWithExceptionType:exceptionType andExceptionMessage:exceptionMessage];
    smartEvent.smartEventResponse=smEventResponse;
    [smartServiceDelegate didCompleteServiceWithError:smartEvent];
}

@end
