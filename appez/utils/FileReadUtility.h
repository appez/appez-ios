//
//  FileReadUtility.h
//  appez
//
//  Created by Transilityon 04/01/13.
//
/**
 * FileReadUtility : Utility class for reading contents of a specified
 * file in the device storage.
 */

#import <Foundation/Foundation.h>
#import "CommMessageConstants.h"
@interface FileReadUtility : NSObject
{
    NSString *fileName;
	NSDictionary *fileToReadInfo;
    NSString *formatToRead;
    NSMutableDictionary *assetFileNameLocationDict;
}
@property(nonatomic,retain) NSString *fileName;

-(instancetype)initFileReadUtility:(NSDictionary*)fileToReadInformation;
-(NSString*)getFileContents;
-(NSString*)getFileContentInFolder;

@end
