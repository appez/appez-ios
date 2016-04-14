//
//  MultiSelectionCell.m
//  appez
//
//  Created by Transility on 5/13/14.
//
//

#import "MultiSelectionCell.h"

@implementation MultiSelectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_checkBox release];
    [_titleLabel release];
    [super dealloc];
}


@end
