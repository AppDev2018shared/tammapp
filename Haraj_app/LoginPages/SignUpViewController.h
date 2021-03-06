//
//  SignUpViewController.h
//  care2Dare
//
//  Created by Spiel's Macmini on 3/3/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRHyperLabel.h"

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *Image_logo;
@property(nonatomic,weak)IBOutlet UILabel * Label_TitleName;
@property(nonatomic,weak)IBOutlet UITextField * textfield_name;
@property(nonatomic,weak)IBOutlet UITextField * textfield_Emailname;
@property(nonatomic,weak)IBOutlet UITextField * textfield_password;
@property(nonatomic,weak)IBOutlet UITextField * textfield_Dob;
@property (weak, nonatomic) IBOutlet UITextField *textfield_MobileNumber;

@property(nonatomic,weak)IBOutlet UIButton *  Button_signip;

@property(nonatomic,weak)IBOutlet UIView * view_LoginFB;
@property(nonatomic,weak)IBOutlet UIView *  View_LoginTW;

@property(nonatomic,weak)IBOutlet UIButton *  Button_LoginFb;
@property(nonatomic,weak)IBOutlet UIButton *  Button_LoginTw;

@property(nonatomic,weak)IBOutlet UILabel * Label_TermsAndCon;
@property (weak, nonatomic) IBOutlet FRHyperLabel *termLabel;


-(IBAction)SignUpViewBack:(id)sender;
-(IBAction)LoginWithFbAction:(id)sender;
-(IBAction)LoginWithTwitterAction:(id)sender;
-(IBAction)LoginButtonAction:(id)sender;
- (IBAction)Textfelds_Actions:(id)sender;

@end
