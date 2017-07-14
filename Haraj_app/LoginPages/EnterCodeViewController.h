//
//  EnterCodeViewController.h
//  Haraj_app
//
//  Created by Spiel on 14/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterCodeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textfield_Code;
@property (weak, nonatomic) IBOutlet UIButton *button_Verify;
@property (weak, nonatomic) IBOutlet UIButton *button_Back;
@property (weak, nonatomic) IBOutlet UIButton *button_Skip;


- (IBAction)Verify_Action:(id)sender;
- (IBAction)Back_Action:(id)sender;
- (IBAction)Skip_Action:(id)sender;
- (IBAction)Textfelds_Actions:(id)sender;

@end
