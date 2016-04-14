//
//  DrawingView.h
//  KronosTablet
//
//  Created by Transility on 8/9/13.
//

#import "DrawingView.h"
#import "Strings.h"


@implementation DrawingView

@synthesize menuLocation;
@synthesize lastPoint;
@synthesize backgroundImage;
@synthesize menuController;
@synthesize isSelectedAreaDrawn;

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    frame.origin.y = 0;
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame] ;
    [bgView setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:bgView];
    [bgView setAlpha:0.1];
    
    isSelectedAreaDrawn = NO;
    backgroundImage = [[UIImageView alloc] initWithImage:nil];
    backgroundImage.frame = frame;
    [self addSubview:backgroundImage];
    
    self.menuController = [UIMenuController sharedMenuController];
    
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPressGesture];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchMove:)];
    [self addGestureRecognizer:panGesture];
    return self;
}

-(void)setPenColor:(NSString *)hexString
{
    CGColorRef penColor=[[AppUtils colorFromHexString:hexString] CGColor];
    NSInteger numComponents = CGColorGetNumberOfComponents(penColor);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(penColor);
        red = components[0];
        green = components[1];
        blue = components[2];
        alpha = components[3];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if([menuController isMenuVisible]) {
        [menuController setMenuVisible:FALSE animated:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void) touchMove:(UIPanGestureRecognizer *) sender {
    
    CGPoint currentPoint = [sender locationInView:[sender view]];
    
    if([menuController isMenuVisible]) {
        [menuController setMenuVisible:FALSE animated:YES];
    }
    
    if ([sender state] == UIGestureRecognizerStateBegan) {
        lastPoint = currentPoint;
    }
    
    if([sender state] == UIGestureRecognizerStateChanged) {
        isSelectedAreaDrawn = YES;
        UIGraphicsBeginImageContext(self.frame.size);
        [backgroundImage.image drawInRect:CGRectMake(0, 0, backgroundImage.frame.size.width, backgroundImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),red,green,blue, 1.0);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        backgroundImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    lastPoint = currentPoint;
}

- (void) longPress:(UILongPressGestureRecognizer *) sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        self.menuLocation =  [sender locationInView:[sender view]];
        [menuController setTargetRect:CGRectMake(self.menuLocation.x, self.menuLocation.y, 0, 0) inView:[sender view]];
         menuController.arrowDirection = UIMenuControllerArrowDefault;
//        if(isSelectedAreaDrawn) {
//        } else {
//        }
        [menuController setMenuVisible:YES animated:YES];
        [menuController update];
    }
}

- (void) clearAll:(id) sender {
    self.backgroundImage.image = nil;
    isSelectedAreaDrawn = NO;
}

-(void)clear
{
    self.backgroundImage.image = nil;
    isSelectedAreaDrawn = NO;
}

- (void) removeFromSuperview {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}

@end
