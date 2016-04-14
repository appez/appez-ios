//
//  AppStartupManager.m
//  appez
//
//  Created by Transility on 29/10/12.

#import "AppStartupManager.h"
#import "SmartConstants.h"
#import "MobiletException.h"
#import "MenuInfoBean.h"
#import "TabInfoBean.h"
#import "AppUtils.h"

#import <QuartzCore/QuartzCore.h>

static NSMutableArray *tabInfoBeanCollection;
static NSMutableArray *menuInfoBeanCollection;
static ActionBarStylingInfoBean *actionBarStylingInfoBean;;


@implementation AppStartupManager

/**
 *Allocation of memory to the tab,menu and action info beans * received from the web layer.
 *
 * */
+(void)initialize
{
        tabInfoBeanCollection=[[NSMutableArray alloc] init];
        menuInfoBeanCollection=[[NSMutableArray alloc] init];
        actionBarStylingInfoBean=[[ActionBarStylingInfoBean alloc] init];
}

/**
 * User application calls this method when the startup information is
 * received from the web layer. Invoked in the 'AppInitActivity' of the
 * client application.
 *
 *
 * */

+(void)processAppStartupInfo:(NSString*)appStartupInfo
{
    if(tabInfoBeanCollection==nil && menuInfoBeanCollection==nil)
    {
        [AppStartupManager initialize];
    }
    @try {
        if (appStartupInfo != nil)
        {
            NSDictionary *json=[AppUtils getDictionaryFromJson:appStartupInfo];
            
            if ([json.allKeys containsObject:APP_STARTUP_INFO_NODE_MENUS]) {
                [AppStartupManager processMenuCreationInfo:[json valueForKey:APP_STARTUP_INFO_NODE_MENUS]];
            }
            if ([json.allKeys containsObject:APP_STARTUP_INFO_NODE_TABS]) {
                [AppStartupManager processTabCreationInfo:[json valueForKey:APP_STARTUP_INFO_NODE_TABS]];
            }
            if ([json.allKeys containsObject:APP_STARTUP_INFO_NODE_TOPBAR_STYLING_INFO]) {
                [AppStartupManager processTopbarStylingInformation:[json valueForKey:APP_STARTUP_INFO_NODE_TOPBAR_STYLING_INFO]];
            }
                      
        } else {
           @throw [MobiletException MobiletExceptionWithType:nil Message:nil];
        }
    } @catch (NSException *ex) {
        
        @throw [MobiletException MobiletExceptionWithType:nil Message:nil];
    }
    
}

/**
 * Processes information regarding application menus and puts them in
 * relevant collection
 *
 * @param menuCreationInfo
 *            : JSONArray that contains the collection of all the menu
 *            options available in the application
 *
 * */

+(void)processMenuCreationInfo:(NSArray*)menuCreationInfo
{
    if(tabInfoBeanCollection==nil && menuInfoBeanCollection==nil)
    {
        [AppStartupManager initialize];
    }
    NSArray *menuNodes = menuCreationInfo;

    @try {
        // looping through menu information nodes
        for (int i = 0; i < menuNodes.count; i++) {
            MenuInfoBean *menuInfoBean =[[MenuInfoBean alloc] init];
            NSDictionary *menuToAdd =[menuNodes objectAtIndex:i];
            menuInfoBean.menuLabel=[menuToAdd valueForKey:MENUS_CREATION_PROPERTY_LABEL];
            menuInfoBean.menuIcon=[menuToAdd valueForKey:MENUS_CREATION_PROPERTY_ICON];
            menuInfoBean.menuId=[menuToAdd valueForKey:MENUS_CREATION_PROPERTY_ID];
            
            [menuInfoBeanCollection addObject:menuInfoBean];
        }
    } @catch (NSException *ex) {
        @throw [MobiletException MobiletExceptionWithType:nil Message:nil];
    }
}

/**
 * Getter method for menuInfoBeanCollection
*/
+(NSMutableArray*)getMenuInfoCollection
{
    return menuInfoBeanCollection;
}

/**
 * Parses the contents of 'tab_info.xml' file and extracts tab creation info
 * from it
 * @param tabCreationInfo
 *            : JSONArray that contains the collection of all the tabs to be
 *            constructed in the application
 */
+(void)processTabCreationInfo:(NSArray*)tabCreationInfo
{
    @try {
        NSArray *tabNodes = tabCreationInfo;
        // looping through All tab information nodes
        for (int i = 0; i < tabNodes.count; i++) {
            TabInfoBean *tabInfoBean =[[TabInfoBean alloc] init];
            NSDictionary *tabToAdd =[tabNodes objectAtIndex:i];
            
            tabInfoBean.tabLabel=[tabToAdd valueForKey:TABS_CREATION_PROPERTY_LABEL];
            tabInfoBean.tabIcon=[tabToAdd valueForKey:TABS_CREATION_PROPERTY_ICON];
            tabInfoBean.tabId=[tabToAdd valueForKey:TABS_CREATION_PROPERTY_ID];
            tabInfoBean.tabContentUrl=[tabToAdd valueForKey:TABS_CREATION_PROPERTY_CONTENT_URL];
            
            [tabInfoBeanCollection addObject:tabInfoBean];
            //[tabInfoBean release];
        }
    } @catch (NSException *ex) {
        // TODO handle this exception in a better way
        @throw [MobiletException MobiletExceptionWithType:nil Message:nil];
    }
}

/**
 * Parses the contents of 'tab_info.xml' file and extracts tab creation info
 * from it.This
 * primarily includes the style and theme information.
 * @param stylingInfo
 *            : JSONObject that contains information regarding the theme and
 *            style of topbar of the application *
 */
+(void)processTopbarStylingInformation:(NSDictionary*)tabStylingInfo
{
    tabStylingInfo=[tabStylingInfo valueForKey:@"topbarstyle"];
    @try {
        
            [self processActionBarBgStylingInfo:tabStylingInfo];
            [self processActionBarTabBgStylingInfo:tabStylingInfo];
        
    } @catch (NSException *ex) {
        @throw [MobiletException MobiletExceptionWithType:nil Message:nil];
    }
}

/**
 * Processes information regarding application tabs and puts them in
 * relevant collection. Applicable for tab based application only.
 *
 * @param stylingInfo
 *            : JSONObject that contains information regarding the theme and
 *            style of topbar of the application
 *
 */
+(void)processActionBarBgStylingInfo:(NSDictionary*) stylingInfo
{
       
    @try {
        if ([stylingInfo.allKeys containsObject:TOPBAR_TXT_COLOR_TAG]) {
            actionBarStylingInfoBean.topbarTextColor=[stylingInfo valueForKey:TOPBAR_TXT_COLOR_TAG];
        }
        
        if ([stylingInfo.allKeys containsObject:TOPBAR_BACKGROUND_COLOR_TAG]) {
            actionBarStylingInfoBean.topbarBgColor=[stylingInfo valueForKey:TOPBAR_BACKGROUND_COLOR_TAG];
        }

        if ([stylingInfo.allKeys containsObject:TOPBAR_BACKGROUND_IMAGE_TAG]) {
            actionBarStylingInfoBean.topbarBgImage=[stylingInfo valueForKey:TOPBAR_BACKGROUND_IMAGE_TAG];
        }
        
        
        
            // Now we shall set the topbar background type. if the user has set
            // more than one type of backgrounds, then the priority order shall
            // be the following.
            // Image >> Gradient >> Color
            if (actionBarStylingInfoBean.topbarBgImage != nil) {
                actionBarStylingInfoBean.topbarBgType=TOPBAR_BG_TYPE_IMAGE;
            } else if (actionBarStylingInfoBean.topbarBgGradient != nil) {
                actionBarStylingInfoBean.topbarBgType=TOPBAR_BG_TYPE_GRADIENT;
            } else {
                actionBarStylingInfoBean.topbarBgType=TOPBAR_BG_TYPE_COLOR;
            }
    }
    @catch (NSException *exception) {
        
        @throw [MobiletException MobiletExceptionWithType:nil Message:nil];
    }

}

/**
 * Processes information regarding application tabs and puts them in
 * relevant collection. Applicable for tab based application only.
 *
 * @param stylingInfo
 *            : JSONObject that contains information regarding the theme and
 *            style of topbar of the application
 *
 */
+(void)processActionBarTabBgStylingInfo:(NSDictionary*)stylingInfo
{
    
    @try {
            if ([stylingInfo.allKeys containsObject:TABBAR_TXT_COLOR_TAG]) {
                actionBarStylingInfoBean.tabbarTextColor=[stylingInfo valueForKey:TABBAR_TXT_COLOR_TAG];
            }
                    
            if ([stylingInfo.allKeys containsObject:TABBAR_BACKGROUND_COLOR_TAG]) {
                actionBarStylingInfoBean.tabbarBgColor=[stylingInfo valueForKey:TABBAR_BACKGROUND_COLOR_TAG];
            }
                
            if ([stylingInfo.allKeys containsObject:TABBAR_BACKGROUND_IMAGE_TAG]) {
                actionBarStylingInfoBean.tabbarBgImage=[stylingInfo valueForKey:TABBAR_BACKGROUND_IMAGE_TAG];
            }
        
            if ([stylingInfo.allKeys containsObject:TABBAR_BACKGROUND_GRADIENT_TAG]) {
                actionBarStylingInfoBean.tabbarBgGradient=[stylingInfo valueForKey:TABBAR_BACKGROUND_GRADIENT_TAG ];
            }

        // Now we shall set the tabbar background type. if the user has set
        // more than one type of backgrounds, then the priority order shall
        // be the following.
        // Image >> Gradient >> Color
        if (actionBarStylingInfoBean.tabbarBgImage != nil) {
            actionBarStylingInfoBean.tabbarBgType=TABBAR_BG_TYPE_IMAGE;
        } else if (actionBarStylingInfoBean.tabbarBgGradient != nil) {
            actionBarStylingInfoBean.tabbarBgType=TABBAR_BG_TYPE_GRADIENT;
        } else {
            actionBarStylingInfoBean.tabbarBgType=TABBAR_BG_TYPE_COLOR;
        }
            [self customizeAppearence];
        
    }
    @catch (NSException *exception) {
        
         @throw [MobiletException MobiletExceptionWithType:nil Message:nil];
    }
        
}

//Getter method for tabInfoCollection
+(NSMutableArray*)getTabInfoCollection
{
    return tabInfoBeanCollection;
}

//Getter method for topbarStylingInfoBean
+(ActionBarStylingInfoBean*)getTopbarStylingInfoBean
{
    return actionBarStylingInfoBean;
}
+(void)customizeAppearence
{
    // Customizing the tab bar
    if([actionBarStylingInfoBean.tabbarBgType isEqualToString:BAR_BG_TYPE_IMAGE])
    {
         NSString * fullPath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/assets/web_assets/app/smartphone/resources/images/ios/tab/%@.png",actionBarStylingInfoBean.tabbarBgImage]];
        UIImage *tabBackground = [[UIImage imageWithContentsOfFile:fullPath]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [[UITabBar appearance] setBackgroundImage:tabBackground];
    }
     else if([actionBarStylingInfoBean.tabbarBgType isEqualToString:BAR_BG_TYPE_COLOR])
    {
        [[UITabBar appearance] setTintColor:[AppUtils colorFromHexString:actionBarStylingInfoBean.tabbarBgColor]];
    }
    else if ([actionBarStylingInfoBean.tabbarBgType isEqualToString:BAR_BG_TYPE_GRADIENT])
    {
        NSLog(@"AppStartup->customizeAppearance");
    }
    
      // Customizing the navigation bar
    if ([actionBarStylingInfoBean.topbarBgType isEqualToString:TOPBAR_BG_TYPE_IMAGE]) {
        // set the background image for action bar
        NSString * fullPath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"/assets/web_assets/app/smartphone/resources/images/ios/tab/%@.png",actionBarStylingInfoBean.tabbarBgImage]];
        UIImage *topBarBackground = [[UIImage imageWithContentsOfFile:fullPath]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
      
        [[UINavigationBar appearance] setBackgroundImage:topBarBackground forBarMetrics:UIBarMetricsDefault];
        
    } else if ([actionBarStylingInfoBean.topbarBgType isEqualToString:TOPBAR_BG_TYPE_GRADIENT]) {

}
}
@end
