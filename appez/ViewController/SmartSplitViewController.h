//
//  SmartSplitViewController.h
//  SmartSplitView
//
//  Created by appez on 7/18/12.
//  Copyright (c) 2012 appez Technologies Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartView.h"

@interface SmartSplitViewController : UIViewController<SmartAppDelegate,UIPopoverControllerDelegate,SmartNotificationDelegate>
{
    SmartView *masterSmartView;
    SmartView *detailSmartView;
    UIPopoverController *popOverController;
    
   @private NSString                *masterUri;
   @private NSString                *detailUri;
   @private BOOL                    showSplash;
   BOOL                    showPopOver;
   CGRect                  popOverPosition;
   CGSize                  popOverContentSize;
}

@property(nonatomic,readwrite) CGRect                  popOverPosition;
@property(nonatomic,readwrite) CGSize                  popOverContentSize;
@property(nonatomic,readwrite)  BOOL                    showPopOver;
-(instancetype)initWithExtendedSplashMasterPageUri:(NSString*)masterPage WithDetailPageUri:(NSString*)detailPage;
-(instancetype)initWithMasterPageUri:(NSString*)masterPage WithDetailPageUri:(NSString*)detailPage;
@end
