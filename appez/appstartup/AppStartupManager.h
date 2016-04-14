//
//  AppStartupManager.h
//  appez
//
//  Created by Transility on 29/10/12.
//
/**
 * AppStartupManager: Processes the startup information receives from the web
 * layer at the start of the application. Typically this contains information
 * regarding the styling of the native action bar, styling information of the
 * action bar tabs(in case of tab based application) along with the menu
 * information of all the application menus
 *
 * */

#import <Foundation/Foundation.h>
#import "ActionBarStylingInfoBean.h"

@interface AppStartupManager : NSObject
{
    // Required for dynamic creation of menu items
    NSMutableArray *menuInfoBeanCollection;
    NSMutableArray *tabInfoBeanCollection;
}
+(void)processMenuCreationInfo:(NSArray*)menuCreationInfo;
+(void)processTabCreationInfo:(NSArray*)tabCreationInfo;
+(void)processAppStartupInfo:(NSString*)appStartupInfo;
+(void)processTopbarStylingInformation:(NSDictionary*)tabStylingInfo;
+(NSMutableArray*)getTabInfoCollection;
+(NSMutableArray*)getMenuInfoCollection;
+(ActionBarStylingInfoBean*)getTopbarStylingInfoBean;
@end
