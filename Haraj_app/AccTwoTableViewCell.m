//
//  AccTwoTableViewCell.m
//  SprintTags_Pro
//
//  Created by Spiel's Macmini on 8/19/16.
//  Copyright © 2016 Spiel's Macmini. All rights reserved.
//

#import "AccTwoTableViewCell.h"

@implementation AccTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.switchOutlet setOn:YES animated:YES];
    
    
    self.switchOutlet.transform = CGAffineTransformMakeScale(0.80, 0.70);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
