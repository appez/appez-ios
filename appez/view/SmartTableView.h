//
//  SmartTableView.h
//  SampleXib
//
//  Created by Transility on 25/09/12.
//

/**SmartTableView:
 *This class is responsible for displaying the table view containing required number of rows *
 under single column.
 */

#import <UIKit/UIKit.h>

@protocol SmartTableViewDelegate <NSObject>
-(void)didSelectRowAtPosition:(int)indexPath WithData:(id)data;
@end

@interface SmartTableView : UIView
{
    NSArray *smartItemArray;
    //id<SmartTableViewDelegate> delegate;
}
@property (assign, nonatomic)   id<SmartTableViewDelegate> delegate;
@property (retain, nonatomic)   NSArray *smartItemArray;
@property (retain, nonatomic)   IBOutlet UITableView *smartTableView;

@end
