//
//  SmartMessagePicker.h
//  appez
//
//  Created by Transility on 07/01/13.
//
/**
 This utility class is responsible for showing the single select list.
 */

#import <Foundation/Foundation.h>
#import "SmartPickerDelegate.h"

@interface SmartMessagePickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>
{
    int selectedIndex;
}
@property (retain, nonatomic) NSMutableArray *messagesArray;
@property(nonatomic,assign)    id<SmartPickerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIPickerView *smartPicker;
@property (retain, nonatomic) NSString *message;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
- (IBAction)doneButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
-(void)processSelectionListItemInfo:(NSString*)listInfo;

@end
