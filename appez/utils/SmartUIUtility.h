//
//  cv.h
//  appez
//
//  Created by Transility on 5/14/14.
//
//

#import <Foundation/Foundation.h>
#import "SmartMultiSelectionListView.h"
#import "LoadingView.h"
#import "SmartDatePickerView.h"
#import "SmartCustomDatePickerView.h"
#import <MapKit/MapKit.h>
#import "SmartCoActionDelegate.h"
#import "SmartMessagePickerView.h"
#import "SmartEvent.h"
#import "SmartSignatureDelegate.h"
#import "SmartSignatureViewController.h"


@interface SmartUIUtility : NSObject  <UIActionSheetDelegate,UIPopoverControllerDelegate>
{
    LoadingView *loadingView;
    //id delegate;
    SmartDatePickerView *datePicker;
    SmartCustomDatePickerView *customDatePicker;
    SmartMessagePickerView         *messagePicker;
    UIPopoverController     *popOverController;
    SmartMultiSelectionListView *multiSelector;
}
@property(nonatomic,strong)  id delegate;
@property(nonatomic,retain) UIViewController *viewController;
@property(nonatomic,retain)  UIActionSheet *actionSheet;
@property(nonatomic,strong) SmartSignatureViewController *signVc;
+(SmartUIUtility*)sharedInstance;
+(void)tear;
-(void)showMapViewOnMainThread:(NSMutableArray*)mapData;
-(void)showActivityViewWithMessage:(NSString*)msgStr;
-(void)hideActivityView;
-(void)setActivityMessage:(NSString*)msgStr;
-(void)adjustLayoutOnOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(void)hideDatePicker;
-(void)showDatePickerWithDelegate:(id)aDelegate;
-(void)showCustomDatePickerWithDelegate:(id)aDelegate;
-(void)hideCustomDatePicker;
-(void)showMapView:(NSString*)mapData WithDelegate:(id<SmartCoActionDelegate>)smartDelegate WithAnimation:(BOOL)animation WithDirection:(BOOL)direction;
-(void)showDirectionViewWithLocation:(CLLocationCoordinate2D)currentCoordinate WithLocation:(CLLocationCoordinate2D)selectedCoordinate;
-(void)showIndicator;
-(void)hideIndicator;
-(void)showAction:(NSString*)actionData;
-(void)showSmartMessagePickerWithDelegate:(id)aDelegate WithMessage:(NSString*)messageList;
-(void)hideSmartMessagePicker;
-(void)showPopOverFromRect:(CGRect)rect WithView:(UIView*)popUpView;
-(void)hidePopOver;
-(void)showMultiSelectionListWithDelegate:(id)aDelegate WithMessage:(NSString*)messageList;
-(void)hideMultiSelector;
-(void)showSignatureView:(NSString *)requestData WithImageSaveFlag:(BOOL)shouldSaveSignature andWithDelegate:(id<SmartSignatureDelegate>)signatureDelegate;


@end
