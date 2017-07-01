//
//  CustomTableViewCell.m
//  BubbleChat
//
//  Created by Spiel's Macmini on 10/14/16.
//  Copyright © 2016 Spiel's Macmini. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell
@synthesize ProfileImg;
- (void)awakeFromNib {
    [super awakeFromNib];
    ProfileImg.clipsToBounds=YES;
    ProfileImg.layer.cornerRadius=ProfileImg.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
