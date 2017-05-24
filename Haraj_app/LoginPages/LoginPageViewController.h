//
//  LoginPageViewController.h
//  care2Dare
//
//  Created by Spiel's Macmini on 3/3/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginPageViewController : UIViewController
@property(nonatomic,weak)IBOutlet UILabel * Label_TitleName;
@property(nonatomic,weak)IBOutlet UITextField * textfield_uname;
@property(nonatomic,weak)IBOutlet UITextField * textfield_password;
@property(nonatomic,weak)IBOutlet UIButton *  Button_Login;

@property(nonatomic,weak)IBOutlet UIView * view_LoginFB;
@property(nonatomic,weak)IBOutlet UIView *  View_LoginTW;

@property(nonatomic,weak)IBOutlet UIButton *  Button_LoginFb;
@property(nonatomic,weak)IBOutlet UIButton *  Button_LoginTw;

@property(nonatomic,weak)IBOutlet UILabel * Label_TermsAndCon;

-(IBAction)SignUpView:(id)sender;

-(IBAction)ForgetPasswordAction:(id)sender;
-(IBAction)LoginWithFbAction:(id)sender;
-(IBAction)LoginWithTwitterAction:(id)sender;
-(IBAction)LoginButtonAction:(id)sender;
- (IBAction)usernameTxtAction:(id)sender;

@end
