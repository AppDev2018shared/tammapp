//
//  ProductDetailCell.h
//  Haraj_app
//
//  Created by Spiel on 16/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *sellingTextview;
@property (weak, nonatomic) IBOutlet UITextView *hashTextView;
@property (weak, nonatomic) IBOutlet UIImageView *locationStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationChangeButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;



@end
