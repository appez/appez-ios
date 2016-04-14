//
//  FileReadUtility.m
//  appez
//
//  Created by Transility on 04/01/13.
//
//

#import "FileReadUtility.h"
#import "SmartConstants.h"
#import "XMLReader.h"
//#import "SBJsonWriter.h"
#import "GTMBase64.h"
#import "MobiletException.h"
#import "ExceptionTypes.h"
#import "AppUtils.h"

@implementation FileReadUtility
@synthesize fileName;

-(instancetype)initFileReadUtility:(NSDictionary*)fileToReadInformation
{
    self = [super init];
    if (self)
    {
        fileToReadInfo=fileToReadInformation;
        self.fileName=[fileToReadInformation valueForKey:MMI_REQUEST_PROP_FILE_TO_READ_NAME];
    }
    return self;
}

-(NSString*)getFileContentInFolder
{
    NSString *filesData=NULL;
    assetFileNameLocationDict=[[NSMutableDictionary alloc]init];
    
    @try {

        NSDictionary *folderReadDetails=fileToReadInfo;
        if([folderReadDetails.allKeys containsObject:MMI_REQUEST_PROP_FILE_TO_READ_NAME])
        {
            NSString *folderNameToRead;
            formatToRead=[folderReadDetails valueForKey:MMI_REQUEST_PROP_FOLDER_FILE_READ_FORMAT];
            folderNameToRead=@"assets";
            folderNameToRead=[[AppUtils getAbsolutePathForFile:folderNameToRead] stringByAppendingPathComponent:self.fileName];
            
            if([folderReadDetails.allKeys containsObject:MMI_REQUEST_PROP_FOLDER_READ_SUBFOLDER] && [[folderReadDetails valueForKey:MMI_REQUEST_PROP_FOLDER_READ_SUBFOLDER] boolValue])
            {
                // That means the user has specified to read all the files of the specified format in the subfolders also.
                [self listAssetFilesFullDepth:folderNameToRead];
            }
            else {
                // This means user has specified to read files of provided format in the current folder only
                [self listAssetFilesInSpecifiedFolder:folderNameToRead];
            }
            
            NSMutableArray *filesArray=[[NSMutableArray alloc]init];
            NSInteger filesCount=assetFileNameLocationDict.allKeys.count;
            NSMutableDictionary *fileContentList=[[NSMutableDictionary alloc]init];
            
            if(assetFileNameLocationDict!=nil && filesCount>0)
            {
                for(int i=0 ; i<filesCount; i++)
                {
                    NSFileManager *fileManager=[[NSFileManager alloc]init];
                    NSString *key=[assetFileNameLocationDict.allKeys objectAtIndex:i];
                    NSString *filePath=[assetFileNameLocationDict valueForKey:key];
                    NSMutableDictionary *fileNode=[[NSMutableDictionary alloc]init];
                    
                    NSString *fileContent=[[NSString alloc]initWithData:[fileManager contentsAtPath:filePath] encoding:NSUTF8StringEncoding];
                    
                    fileContent=[GTMBase64 stringByEncodingData:[fileContent dataUsingEncoding:NSUTF8StringEncoding]];
                    
                    fileContent=[[fileContent stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [fileNode setValue:key forKey:MMI_RESPONSE_PROP_FILE_NAME];
                    [fileNode setValue:fileContent forKey:MMI_RESPONSE_PROP_FILE_CONTENT];
                    [fileNode setValue:@"" forKey:MMI_RESPONSE_PROP_FILE_TYPE];
                    [fileNode setValue:[NSNumber numberWithInt:0] forKey:MMI_RESPONSE_PROP_FILE_SIZE];
                    [filesArray addObject:fileNode];
                }
                [fileContentList setValue:filesArray forKey:MMI_RESPONSE_PROP_FILE_CONTENTS];
                filesData=[AppUtils getJsonFromDictionary:fileContentList];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception :%@",[exception description]);
    }
    return filesData;
}
    
/**
* This method returns the list of all the files and their path w.r.t. 'assets' folder EVEN IN SUBFOLDERS of the specified folder
*
* @param path : Path in which files need to be searched and read
*
* */
-(BOOL)listAssetFilesFullDepth:(NSString*)path
{
    BOOL isDir;
    NSArray *list=[[NSArray alloc]init];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    list=[fileManager subpathsAtPath:path];
    NSInteger listCount=list.count;
    
    @try {
        for (int i=0;i<listCount;i++)
        {
            NSString *fullFilePath=[path stringByAppendingPathComponent:list[i]];
         
            if([fileManager fileExistsAtPath:fullFilePath isDirectory:&isDir])
            {
                    //It means it is a file
                    if([[list[i] pathExtension] isEqualToString:[formatToRead stringByReplacingOccurrencesOfString:@"." withString:@""]])
                    {
                        [assetFileNameLocationDict setValue:fullFilePath forKey:[fullFilePath lastPathComponent]];
                    }
            }
        }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception :%@",[exception description]);

    }
    return TRUE;
}
/**
 * This method returns the list of all the files and their path w.r.t. 'assets' folder ONLY IN the specified folder
 *
 * @param path : Path in which files need to be searched and read
 *
 * */
-(BOOL)listAssetFilesInSpecifiedFolder:(NSString*)path
{
    NSError *error;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *list=[fileManager contentsOfDirectoryAtPath:path error:&error];
    NSInteger listCount=list.count;
    BOOL isDir;
    for(int i=0;i<listCount;i++)
    {
        NSString *fullFilePath=[path stringByAppendingPathComponent:list[i]];
        
        if([fileManager fileExistsAtPath:fullFilePath isDirectory:&isDir])
        {
            [AppUtils showDebugLog:[NSString stringWithFormat:@"full file path is %@",fullFilePath]];
        if([[list[i] pathExtension] isEqualToString:[formatToRead stringByReplacingOccurrencesOfString:@"." withString:@""]])
            [assetFileNameLocationDict setValue:fullFilePath forKey:[fullFilePath lastPathComponent]];
        }
    }
    return TRUE;
}
/**
 * Provides the contents of a file specified by the user.
 *
 * @return NSString : Well formatted JSON response containing the
 *         contents of the specified file
 *
 * */

-(NSString*)getFileContents
{
    NSString *fileData = NULL;
    NSMutableDictionary *fileContentObj=[[NSMutableDictionary alloc]init] ;
    NSMutableArray *fileContentsArray=[[NSMutableArray alloc]init] ;
    NSData   *data=NULL;
    NSBundle * mainBundle = [NSBundle mainBundle];
    //getting the full path which is of the form of a string containing '/assets/' as substring
    NSString *fullPath=[NSString stringWithFormat:@"%@/assets/%@",[mainBundle resourcePath],self.fileName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if([fileManager fileExistsAtPath:fullPath] == TRUE)
    {
        //If the file exists at the location
        
        data=[fileManager contentsAtPath:fullPath];
        
        //If the file format is xml then convert it into json format.
        if([self.fileName rangeOfString:FILE_TYPE_XML].length >0)
        {
            NSDictionary *dataDictionary=[XMLReader dictionaryForXMLData:data error:nil];
            //SBJsonWriter *jsonWriter=[SBJsonWriter new];
            fileData =[AppUtils getJsonFromDictionary:dataDictionary];
            //[jsonWriter release];
        }
        else{
        
        fileData=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
        }
        //If the file is already in json or ultimately converted to json from xml, remove newline, tab and carriage return characters from it.
            fileData=[GTMBase64 stringByEncodingData:[fileData dataUsingEncoding:NSUTF8StringEncoding]];
            fileData=[fileData stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
            fileData=[fileData stringByReplacingOccurrencesOfString:@"\\r" withString:@""];
            fileData=[fileData stringByReplacingOccurrencesOfString:@"\\t" withString:@""];
        
        NSMutableDictionary *fileContent=[[NSMutableDictionary alloc]init] ;
        [fileContent setValue:fileName forKey:MMI_RESPONSE_PROP_FILE_NAME];
        [fileContent setValue:fileData forKey:MMI_RESPONSE_PROP_FILE_CONTENT];
        [fileContent setValue:@"" forKey:MMI_RESPONSE_PROP_FILE_TYPE];
        [fileContent setValue:[NSString stringWithFormat:@"%d",0] forKey:MMI_RESPONSE_PROP_FILE_SIZE];
        [fileContentsArray addObject:fileContent];
        [fileContentObj setValue:fileContentsArray forKey:MMI_RESPONSE_PROP_FILE_CONTENTS];

        return [AppUtils getJsonFromDictionary:fileContentObj];
    }
    else
    {
        //if the file does not exist at the location
        @throw [MobiletException MobiletExceptionWithType:IO_EXCEPTION Message:nil];
    }

    return fileData;
}
@end
