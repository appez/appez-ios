//
//  MenuInfoBean.h
//  appez
//
//  Created by Transility on 25/10/12.
//

/**
 * MenuInfoBean : Model for holding all the required information fields,
 * corresponding to a single application menu
 *
 * */


#import <UIKit/UIKit.h>

@interface MenuInfoBean : NSObject
{
    // Indicates the label of the menu item. This label is the one that appears in the application
    NSString *menuLabel;
   
    // Indicates the icon of the menu item. This label is the one that appears
	// in
	// the application
    NSString *menuIcon;
    
    // Indicates a unique ID assigned to the menu item. This is specified by the
	// application developer for its reference. When any menu item is selected,
	// this menu ID is passed to the web layer.

    NSString *menuId;}

@property(nonatomic,retain) NSString       *menuLabel;
@property(nonatomic,retain) NSString       *menuIcon;
@property(nonatomic,retain) NSString       *menuId;
@end
