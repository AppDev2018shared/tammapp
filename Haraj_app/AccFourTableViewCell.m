//
//  AccFourTableViewCell.m
//  Play_Date
//
//  Created by Spiel's Macmini on 1/3/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import "AccFourTableViewCell.h"

@implementation AccFourTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.switchOutlet setOn:YES animated:YES];
    
   
    self.switchOutlet.transform = CGAffineTransformMakeScale(0.80, 0.80);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
