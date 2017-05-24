//
//  LoginWithViewController.h
//  Haraj_app
//
//  Created by Spiel on 06/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginWithViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UILabel *termLabel;

- (IBAction)facebookAction:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)termsAction:(id)sender;




@end
