//
//  DetailInfoCell.h
//  Haraj_app

//
//  Created by Spiel on 09/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *postidLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hashtagLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailinfoTextView;
@property (weak, nonatomic) IBOutlet UITextView *detailinfoTextView1;
@property (weak, nonatomic) IBOutlet UIView *tapView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *exipresImageView;
@property (weak, nonatomic) IBOutlet UILabel *expiresInLabel;
@property (weak, nonatomic) IBOutlet UIImageView *highestImageView;
@property (weak, nonatomic) IBOutlet UILabel *highestLabel;




@end
