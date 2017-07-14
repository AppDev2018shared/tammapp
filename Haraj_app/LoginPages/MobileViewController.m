//
//  MobileViewController.m
//  Haraj_app
//
//  Created by Spiel on 14/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "MobileViewController.h"
#import "HomeNavigationController.h"
#import "EnterCodeViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import "UIView+RNActivityView.h"

#define Buttonlogincolor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

@interface MobileViewController ()
{
    NSUserDefaults * defaults;
}

@end

@implementation MobileViewController
@synthesize button_Skip,button_Submit,textfield_MobileNumber ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    defaults=[[NSUserDefaults alloc]init];
    
    CALayer *borderBottom_mobile = [CALayer layer];
    borderBottom_mobile.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_mobile.frame = CGRectMake(0, textfield_MobileNumber.frame.size.height-0.8, textfield_MobileNumber.frame.size.width,0.5f);
    [textfield_MobileNumber.layer addSublayer:borderBottom_mobile];
    
    
    
    button_Submit.clipsToBounds=YES;
    button_Submit.layer.cornerRadius=5.0f;
    button_Submit.layer.borderColor=[UIColor whiteColor].CGColor;
    button_Submit.layer.borderWidth=0.5;

    
    button_Skip.clipsToBounds=YES;
    button_Skip.layer.cornerRadius=5.0f;
    button_Skip.layer.borderColor=[UIColor whiteColor].CGColor;
    button_Skip.layer.borderWidth=0.5;
    
    
    button_Submit .enabled=NO;
    button_Submit.titleLabel.textColor =Buttonlogincolor;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Textfelds_Actions:(id)sender
{
    
    
    if (textfield_MobileNumber .text.length !=0 )
    {
        
        button_Submit.enabled=YES;
        
        [button_Submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else
    {
        [button_Submit setTitleColor:Buttonlogincolor forState:UIControlStateNormal];
        button_Submit.enabled=NO;
        
    }
    
    
}



- (IBAction)Submit_Action:(id)sender
{
    
    [self.view showActivityViewWithLabel:@"Sending..."];
    [[FIRPhoneAuthProvider provider] verifyPhoneNumber:textfield_MobileNumber.text
                                            completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
                                                if (error) {
                                                    // [self showMessagePrompt:error.localizedDescription];
                                                    
                                                    
                                                    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not send you a verification code. Please check your mobile no. and try again."preferredStyle:UIAlertControllerStyleAlert];
                                                    
                                                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                                                                {
                                                                                    
                                                                                    
                                                                                    
                                                                                }];
                                                    
                                                    [alert addAction:yesButton];
                                                    [self presentViewController:alert animated:YES completion:nil];
                                                    [self.view hideActivityViewWithAfterDelay:0];


                                                    return;
                                                }
                                                // Sign in using the verificationID and the code sent to the user
                                                // ...
                                                
                                                
                                                [defaults setObject:verificationID forKey:@"authVerificationId"];
                                                
                                                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                EnterCodeViewController * codeController=[mainStoryboard instantiateViewControllerWithIdentifier:@"EnterCodeViewController"];
                                                [self.navigationController pushViewController:codeController animated:YES];

                                                [defaults setObject:textfield_MobileNumber.text forKey:@"mobileNumber"];
                                                [self.view hideActivityViewWithAfterDelay:0];
                                                
                                            }];
    
    
    
    
}

- (IBAction)Skip_Action:(id)sender
{
    
    HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
 
    
}
@end
