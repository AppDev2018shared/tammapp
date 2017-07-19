//
//  TwittertwoTableViewCell.m
//  care2Dare
//
//  Created by Spiel's Macmini on 5/18/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import "TwittertwoTableViewCell.h"

@implementation TwittertwoTableViewCell
@synthesize image_profile_img1;
- (void)awakeFromNib {
    [super awakeFromNib];
    image_profile_img1.clipsToBounds=YES;
    image_profile_img1.layer.cornerRadius=image_profile_img1.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
