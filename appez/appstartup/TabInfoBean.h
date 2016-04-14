//
//  TabInfoBean
//  SmartTab
//
//  Created by Transility on 27/08/12.
//
//

/**
 * TabInfoBean : Model for holding all the required information fields,
 * corresponding to a single application tab.(Applicable to tab based
 * application only)
 *
 * */

#import <Foundation/Foundation.h>

@interface TabInfoBean : NSObject
{
    NSString *tabLabel ; // Indicates the label of the tab item.It appears in the tab bar of the application
	NSString *tabIcon ;  //This will indicate the icon of the tab
	NSString *tabId ;    //This will indicate the page URL which is associated with this tab.On selecting this tab, the page specified gets loaded
	NSString *tabContentUrl ;
}
@property(nonatomic,retain) NSString *tabLabel;
@property(nonatomic,retain) NSString *tabIcon;
@property(nonatomic,retain) NSString *tabId;
@property(nonatomic,retain) NSString *tabContentUrl;
@end
