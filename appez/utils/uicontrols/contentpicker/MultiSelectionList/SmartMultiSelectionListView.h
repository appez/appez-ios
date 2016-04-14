//
//  appez
//
//  Created by Transility on 5/13/14.
//
//
#import <Foundation/Foundation.h>
#import "SmartPickerDelegate.h"

@interface SmartMultiSelectionListView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableSet *cellInfo;
}
@property (retain, nonatomic) NSString *message;
@property (retain, nonatomic) IBOutlet UIImageView *frameImage;
@property (retain, nonatomic) IBOutlet UITableView *smartList;
@property (retain, nonatomic) NSMutableArray *messagesArray;
@property(nonatomic,assign)id<SmartPickerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (retain, nonatomic) IBOutlet UIButton *okButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)doneButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
-(void)processSelectionListItems:(NSString*)listInfo;
@end
