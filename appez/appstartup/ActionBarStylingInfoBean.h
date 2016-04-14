//
//  ActionBarStylingInfoBean.h
//  appez
//
//  Created by Transility on 31/05/13.
//
//
/**
 * ActionBarStylingInfoBean : Model for holding the parsed information regarding
 * the styling and theme
 **/

#import <Foundation/Foundation.h>

@interface ActionBarStylingInfoBean : NSObject
{
    /**
     * Properties for the topbar of the application
     * */
    
    
    NSString*  topbarBgType;   // Indicates the type of background to be set for action bar.
    NSString*  topbarBgColor;  // Indicates the colour of the background to be set. Applicable if the
    // background type is COLOUR. Accepts hex value of the colour.
    
    NSString*  topbarBgImage;  // Indicates the image of the background to be set. Applicable if the
    // background type is IMAGE.
   
    NSArray*   topbarBgGradient;   // Indicates the gradient of the background to be set. Applicable if the
    // background type is GRADIENT. Defined as an array that contains the set of
    // gradient colours provided by the user.
    NSString*  topbarBgGradientType;   	// Indicates the type of gradient to be applied if the background type is
    // GRADIENT. Based on user specification, the gradient can be horizontal or
    // vertical type.
    NSString*  topbarTextColor;    	// Indicates the colour of text on the action bar tabs
    
    
    /**
     * Properties for the tab bar of the application (applicable for tab based
     // application only)
     * */
    
    NSString*  tabbarBgType;     // Indicates the type of background to be set for action bar tabs.
    NSString*  tabbarBgColor;  // Indicates the colour of the background to be set on action bar tabs.
    // Applicable if the
    // background type is COLOUR. Accepts hex value of the colour.
    NSString*  tabbarBgImage;  // Indicates the image of the background to be set. Applicable if the
    // background type is IMAGE.
    NSString*  tabbarBgGradient;   // Indicates the gradient of the background to be set. Applicable if the
    // background type is GRADIENT. Defined as an array that contains the set of
    // gradient colours provided by the user.
    NSString*  tabbarTextColor;    // Indicates the colour of text on the action bar tabs
}

@property(nonatomic,retain) NSString*  topbarBgType;
@property(nonatomic,retain) NSString*  topbarBgColor;
@property(nonatomic,retain) NSString*  topbarBgImage;
@property(nonatomic,retain) NSArray*   topbarBgGradient;
@property(nonatomic,retain) NSString*  topbarBgGradientType;
@property(nonatomic,retain) NSString*  topbarTextColor;

// Properties for the tab bar of the application(applicable for tab based
// application only)
@property(nonatomic,retain) NSString*  tabbarBgType;
@property(nonatomic,retain) NSString*  tabbarBgColor;
@property(nonatomic,retain) NSString*  tabbarBgImage;
@property(nonatomic,retain) NSString*  tabbarBgGradient;
@property(nonatomic,retain) NSString*  tabbarTextColor;

@end

