//
//  MobileViewController.h
//  Haraj_app
//
//  Created by Spiel on 14/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textfield_MobileNumber;

@property (weak, nonatomic) IBOutlet UIButton *button_Submit;
@property (weak, nonatomic) IBOutlet UIButton *button_Skip;


- (IBAction)Submit_Action:(id)sender;
- (IBAction)Skip_Action:(id)sender;
- (IBAction)Textfelds_Actions:(id)sender;

@end
