//
//  DrawingView.h
//  KronosTablet
//
//  Created by Transility on 8/9/13.
//

#import <Foundation/Foundation.h>
#import "AppUtils.h"

@interface DrawingView : UIView {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
}

@property CGPoint menuLocation;
@property CGPoint lastPoint;
@property(strong) UIImageView *backgroundImage;
@property(assign) UIMenuController *menuController;
@property BOOL isSelectedAreaDrawn;
-(void)setPenColor:(NSString*)hexString;
-(void)clear;
@end
