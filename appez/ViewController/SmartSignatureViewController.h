//
//  SmartSignatureViewController.h
//  appez
//
//  Created by Transility on 29/11/14.
//
//

#import <UIKit/UIKit.h>
#import "AppUtils.h"
#import "DrawingView.h"
#import "SmartSignatureDelegate.h"
#import "CommMessageConstants.h"
#import "SmartConstants.h"


@interface SmartSignatureViewController : UIViewController

{
    DrawingView *drawableView;
    
    BOOL shouldSaveSignImage;
	NSString *signPenColor;
	NSString *signImageFormat;
}

@property BOOL shouldSaveSignature;
@property(nonatomic,retain) NSString *signingParameters;
@property(nonatomic,assign)    id<SmartSignatureDelegate> delegate;
@property (nonatomic, retain) DrawingView *drawableView;
@property (nonatomic, retain) IBOutlet UIView *dataContextView;
- (IBAction)clearCanvas:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)saveImage:(id)sender;
@property (retain, nonatomic) IBOutlet UIView *signatureView;
@property (nonatomic,readwrite) UIInterfaceOrientation orientation;
@property (retain, nonatomic) IBOutlet UIView *signatureContainerView;

@end
