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
@property(nonatomic,weak)IBOutlet UILabel * Label_TermsAndCon;


- (IBAction)facebookAction:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)Login_Action:(id)sender;
- (IBAction)CreateAccount_Action:(id)sender;




@end
