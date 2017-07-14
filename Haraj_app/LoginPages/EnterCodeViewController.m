//
//  EnterCodeViewController.m
//  Haraj_app
//
//  Created by Spiel on 14/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "EnterCodeViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import "MobileViewController.h"
#import "HomeNavigationController.h"
#import "SBJsonParser.h"
#import "UIView+RNActivityView.h"

#define Buttonlogincolor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]



@interface EnterCodeViewController ()
{
    NSUserDefaults *defaults;
    NSDictionary *urlplist;
    NSMutableArray *Array_Verify;
}

@end

@implementation EnterCodeViewController
@synthesize textfield_Code,button_Skip,button_Back,button_Verify;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
     defaults=[[NSUserDefaults alloc]init];
    
    CALayer *borderBottom_code = [CALayer layer];
    borderBottom_code.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_code.frame = CGRectMake(0, textfield_Code.frame.size.height-0.8, textfield_Code.frame.size.width,0.5f);
    [textfield_Code.layer addSublayer:borderBottom_code];
    
    
    
    button_Verify.clipsToBounds=YES;
    button_Verify.layer.cornerRadius=5.0f;
    button_Verify.layer.borderColor=[UIColor whiteColor].CGColor;
    button_Verify.layer.borderWidth=0.5;
    
    button_Back.clipsToBounds=YES;
    button_Back.layer.cornerRadius=5.0f;
    button_Back.layer.borderColor=[UIColor whiteColor].CGColor;
    button_Back.layer.borderWidth=0.5;

    button_Skip.clipsToBounds=YES;
    button_Skip.layer.cornerRadius=5.0f;
    button_Skip.layer.borderColor=[UIColor whiteColor].CGColor;
    button_Skip.layer.borderWidth=0.5;
    
    button_Verify .enabled=NO;
    button_Verify.titleLabel.textColor =Buttonlogincolor;

    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Textfelds_Actions:(id)sender
{
    
    
    if (textfield_Code .text.length !=0 )
    {
        
        button_Verify.enabled=YES;
        
        [button_Verify setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else
    {
        [button_Verify setTitleColor:Buttonlogincolor forState:UIControlStateNormal];
        button_Verify.enabled=NO;
        
    }
    
    
}



- (IBAction)Verify_Action:(id)sender
{
    
    [self.view showActivityViewWithLabel:@"Verifying..."];
    
    FIRAuthCredential *credential = [[FIRPhoneAuthProvider provider] credentialWithVerificationID:[defaults valueForKey:@"authVerificationId"] verificationCode:textfield_Code.text];
    
    
    
    [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error)
     {
         if (error)
         {
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Verification code error!!!" message:@"Please enter correct verification code to verify"preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                         {
                                             
                                             
                                             
                                         }];
             
             [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];

             
             [self.view hideActivityViewWithAfterDelay:0];

             
             
             return ;
             
             
             
    
             
             
         }
         else
         {
             
//             HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
//             [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
             
             [self verifyMobileConnection];
         }
     }];

    
}

- (IBAction)Back_Action:(id)sender
{
   
     [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (IBAction)Skip_Action:(id)sender
{
    
    [defaults removeObjectForKey:@"mobileNumber"];
    
    HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];

    
}

-(void)verifyMobileConnection

{
    
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    NSString *mobileid = @"mobileno";
    NSString *mobileNumberVal =[defaults valueForKey:@"mobileNumber"];
    
    
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",userid,useridVal,mobileid,mobileNumberVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"verifymobile"];
    url =[NSURL URLWithString:urlStrLivecount];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];//Web API Method
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         
                                         if(data)
                                         {
                                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                             NSInteger statusCode = httpResponse.statusCode;
                                             if(statusCode == 200)
                                             {
                                                 
                                                 Array_Verify=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_Verify =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_Verify %@",Array_Verify);
                                                 
                                                 if ([ResultString isEqualToString:@"verified"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     
                                                     [defaults setObject:@"yes" forKey:@"verified"];

                                                     HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                                                     [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                                     
                                                 }
                                                 
                                                 
                                                 if ([ResultString isEqualToString:@"updateerror"])
                                                 {
                                                     
                                                     
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Update Error!!!" message:@"Sorry your number could not be updated, please try later" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 
                                                 
                                                 
                                                 
                                             }
                                             
                                             
                                             else
                                             {
                                                 NSLog(@" error login1 ---%ld",(long)statusCode);
                                                 
                                             }
                                             
                                             
                                         }
                                         else if(error)
                                         {
                                             
                                             NSLog(@"error login2.......%@",error.description);
                                         }
                                         
                                         
                                     }];
    [dataTask resume];
    
    
    
    
    
    
    
}



@end
