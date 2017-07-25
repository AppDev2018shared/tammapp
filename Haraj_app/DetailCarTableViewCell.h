//
//  DetailCarTableViewCell.h
//  Haraj_app
//
//  Created by Spiel on 20/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCarTableViewCell : UITableViewCell

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
@property (weak, nonatomic) IBOutlet UILabel *askingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;
@property (weak, nonatomic) IBOutlet UILabel *carMakeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carMakeImage;





@property (weak, nonatomic) IBOutlet UIImageView *favouriteImage;


@property (weak, nonatomic) IBOutlet UIButton *Button_makeoffer;
@property (weak, nonatomic) IBOutlet UIView *view_CordinateViewTapped;

@end
