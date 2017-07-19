//
//  AccTwoPushTableViewCell.m
//  Haraj_app
//
//  Created by Spiel on 18/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "AccTwoPushTableViewCell.h"

@implementation AccTwoPushTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.switchOutlet setOn:YES animated:YES];
    
    
    self.switchOutlet.transform = CGAffineTransformMakeScale(0.80, 0.70);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
