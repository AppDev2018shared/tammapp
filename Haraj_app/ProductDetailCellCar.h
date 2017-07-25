//
//  ProductDetailCellCar.h
//  Haraj_app
//
//  Created by Spiel on 17/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailCellCar : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *sellingTextview;
@property (weak, nonatomic) IBOutlet UITextView *hashTextView;
@property (weak, nonatomic) IBOutlet UIImageView *locationStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationChangeButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *mileageTextField;
@property (weak, nonatomic) IBOutlet UITextField *carMakeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *carMakeImageView;




@end
