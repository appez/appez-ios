//
//  SmartServiceRouter.m
//  appez
//
//  Created by Transility on 2/27/12.
//

#import "SmartServiceRouter.h"
#import "UIService.h"
#import "HTTPService.h"
#import "PersistenceService.h"
#import "MobiletException.h"
#import "ExceptionTypes.h"
#import "DatabaseService.h"
#import "MapService.h"
#import "FileService.h"
#import "CameraService.h"
#import "LocationService.h"

#import "SignatureService.h"

@implementation SmartServiceRouter


-(instancetype)initSmartServiceRouter:(id<SmartServiceDelegate>)delegate
{
    self = [super init];
    if (self) 
    {
        smartServiceDelegate=delegate;
        serviceDictionary=[[NSMutableDictionary alloc] init];
    }
    return self;
 
}

//------------------------------------------------------------------------------------------------------------------------------
/**
 * Returns instance of SmartService based on the service type
 * 
 * @param serviceType
 *            : Type of service
 * @param context
 *            : Application context
 * @return SmartService
 * */
-(SmartService*)getService:(int)serviceType
{
    SmartService *smartService = nil;
    NSString *key =[NSString stringWithFormat:@"%d",serviceType];
    if ([serviceDictionary valueForKey:key]!=nil)
    {
        smartService = [serviceDictionary valueForKey:key];
    } 
    else 
    {
        switch (serviceType) 
        {
			case UI_SERVICE:
				smartService = [[UIService alloc] initWithDelegate:smartServiceDelegate] ;
				break;
			case HTTP_SERVICE:
				smartService = [[HTTPService alloc] initHttpServiceWithDelegate:smartServiceDelegate] ;
				break;
            case DATA_PERSISTENCE_SERVICE:
				smartService = [[PersistenceService alloc] initPersistenceServiceWithDelegate:smartServiceDelegate] ;
				break;
            case DATABASE_SERVICE:
				smartService = [[DatabaseService alloc] initDatabaseServiceWithDelegate:smartServiceDelegate] ;
				break;
            case MAPS_SERVICE:
				smartService = [[MapService alloc] initMapServiceWithDelegate:smartServiceDelegate] ;
				break;
            case FILE_SERVICE:
				smartService = [[FileService alloc] initFileServiceWithDelegate:smartServiceDelegate] ;
				break;
            case CAMERA_SERVICE:
				smartService = [[CameraService alloc] initWithCameraServiceWithDelegate:smartServiceDelegate] ;
				break;
            case LOCATION_SERVICE:
                smartService=[[LocationService alloc] initWithSmartServiceDelegate:smartServiceDelegate];
                break;
            
            case SIGNATURE_SERVICE:
                smartService=[[SignatureService alloc]initWithSmartServiceDelegate:smartServiceDelegate];
                break;
                
            default:
                @throw [MobiletException MobiletExceptionWithType:SERVICE_TYPE_NOT_SUPPORTED_EXCEPTION Message:nil];

        }
        if (smartService != nil) {
            [serviceDictionary setObject:smartService forKey:key];
        }
    }
    return smartService;
}

/**
 * Removes the mentioned service from services set
 * 
 * @param serviceType
 *            : Type of service
 * @param isEventCompleted
 *            : Indicates whether or not the event is complete
 */
-(void)releaseService:(int)serviceType WithFlag:(BOOL)isEventCompleted
{
    NSString *key =[NSString stringWithFormat:@"%d",serviceType];
    if (([serviceDictionary objectForKey:key]!=nil) && isEventCompleted)
    {
        [serviceDictionary removeObjectForKey:key];
    }
}

@end

