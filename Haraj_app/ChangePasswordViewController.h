//
//  ChangePasswordViewController.h
//  Haraj_app
//
//  Created by Spiel on 17/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController

@property(nonatomic,weak)IBOutlet UIButton * Button_Back;
@property(nonatomic,weak)IBOutlet UIButton * Button_ChangePassword;

@property(nonatomic,weak)IBOutlet UITextField * Textfield_oldpassword;
@property(nonatomic,weak)IBOutlet UITextField * Textfield_newpassword;
@property(nonatomic,weak)IBOutlet UITextField * Textfield_confirmpassword;




-(IBAction)Button_BackAction:(id)sender;
-(IBAction)Button_ChangePasswordAction:(id)sender;

-(IBAction)TextfieldAction_ChangePassword:(id)sender;

@end
