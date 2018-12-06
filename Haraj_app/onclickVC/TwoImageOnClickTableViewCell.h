//
//  TwoImageOnClickTableViewCell.h
//  Haraj_app
//
//  Created by Spiel on 25/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoImageOnClickTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;

@property (weak, nonatomic) IBOutlet UIImageView *image_play1;
@property (weak, nonatomic) IBOutlet UIImageView *image_play2;
@property (weak, nonatomic) IBOutlet UIButton  *button_threedots;
@property (weak, nonatomic) IBOutlet UIButton  *button_threedotsBig;

@property (weak, nonatomic) IBOutlet UIButton  *button_favourite;
@property (weak, nonatomic) IBOutlet UIButton  *button_back;

// more button click
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator1;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator2;

@end
