//
//  ViewController.h
//  Haraj_app
//
//  Created by udaysinh on 23/04/17.
//  Copyright (c) 2017 udaysinh. All rights reserved.
//


//Green colour RGB Value: 0, 144, 48
//Grey RGB Value: 186, 188, 190
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet  UIButton *profile;
@property (weak, nonatomic) IBOutlet UIButton *activity;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UIButton *location;
@property (weak, nonatomic) IBOutlet UIImageView *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

