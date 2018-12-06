//
//  ChangePasswordViewController.m
//  Haraj_app
//
//  Created by Spiel on 17/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UIView+RNActivityView.h"
#import "UIViewController+KeyboardAnimation.h"


@interface ChangePasswordViewController ()
{
    NSDictionary * urlplist;
    NSUserDefaults *defaults;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabBarBottomSpace;
@end

@implementation ChangePasswordViewController
@synthesize backbutton,labelheding,view_line;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.view.frame.size.width==375 && self.view.frame.size.height==812)
    {
     
        [backbutton setFrame:CGRectMake(backbutton.frame.origin.x, backbutton.frame.origin.y+11, backbutton.frame.size.width, 28)];
        [labelheding setFrame:CGRectMake(labelheding.frame.origin.x, labelheding.frame.origin.y+11, labelheding.frame.size.width, 28)];
        [view_line setFrame:CGRectMake(view_line.frame.origin.x, view_line.frame.origin.y+8, view_line.frame.size.width, 1)];
        
        
        
    }
    defaults=[[NSUserDefaults alloc]init];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    CALayer *borderBottom_oldpassword = [CALayer layer];
    borderBottom_oldpassword.backgroundColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1 ].CGColor;
    borderBottom_oldpassword.frame = CGRectMake(0, self.Textfield_oldpassword.frame.size.height-0.8, self.Textfield_oldpassword.frame.size.width,0.5f);
    [self.Textfield_oldpassword.layer addSublayer:borderBottom_oldpassword];
    
    CALayer *borderBottom_newpassword = [CALayer layer];
    borderBottom_newpassword.backgroundColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1 ].CGColor;
    borderBottom_newpassword.frame = CGRectMake(0, self.Textfield_newpassword.frame.size.height-0.8, self.Textfield_newpassword.frame.size.width,0.5f);
    [self.Textfield_newpassword.layer addSublayer:borderBottom_newpassword];
    
    CALayer *borderBottom_confirmpassword = [CALayer layer];
    borderBottom_confirmpassword.backgroundColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1 ].CGColor;
    borderBottom_confirmpassword.frame = CGRectMake(0, self.Textfield_confirmpassword.frame.size.height-0.8, self.Textfield_confirmpassword.frame.size.width,0.5f);
    [self.Textfield_confirmpassword.layer addSublayer:borderBottom_confirmpassword];
    
    _Button_ChangePassword.enabled=NO;
    [_Button_ChangePassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _Button_ChangePassword.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    [_Textfield_oldpassword becomeFirstResponder];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    borderBottom_topheder.backgroundColor =[UIColor colorWithRed:186/255.0 green:188/255.0 blue:190/255.0 alpha:1.0].CGColor;
//    borderBottom_topheder.frame = CGRectMake(0, _view_Topheader.frame.size.height-1, _view_Topheader.frame.size.width,1);
//    [_view_Topheader.layer addSublayer:borderBottom_topheder];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self subscribeToKeyboard];
    
}
- (void)subscribeToKeyboard
{
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing) {
            self.tabBarBottomSpace.constant = CGRectGetHeight(keyboardRect);
            
            
        } else
        {
            
            self.tabBarBottomSpace.constant = 0.0f;
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self an_unsubscribeKeyboard];
}

-(IBAction)Button_BackAction:(id)sender
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)Button_ChangePasswordAction:(id)sender
{
    [self ChangePasswordCommunication];
}

-(IBAction)TextfieldAction_ChangePassword:(id)sender
{
    UITextField *textfield = (UITextField *)sender;
    if (textfield.tag==1)
    {
        
        if ([_Textfield_oldpassword.text isEqualToString:@""] || [_Textfield_newpassword.text isEqualToString:@""] || [_Textfield_confirmpassword.text isEqualToString:@""])
        {
            _Button_ChangePassword.enabled=NO;
            
            [_Button_ChangePassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _Button_ChangePassword.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        }
        else
        {
            _Button_ChangePassword.enabled=YES;
            
            [_Button_ChangePassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _Button_ChangePassword.backgroundColor=[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        }
    }
    if (textfield.tag==2)
    {
        
        if ([_Textfield_oldpassword.text isEqualToString:@""] || [_Textfield_newpassword.text isEqualToString:@""] || [_Textfield_confirmpassword.text isEqualToString:@""] || ![_Textfield_newpassword.text isEqualToString:_Textfield_confirmpassword.text])
        {
            _Button_ChangePassword.enabled=NO;
            [_Button_ChangePassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _Button_ChangePassword.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        }
        else
        {
            _Button_ChangePassword.enabled=YES;
            
            [_Button_ChangePassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _Button_ChangePassword.backgroundColor=[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        }
        
    }
    if (textfield.tag==3)
    {
        
        if ([_Textfield_oldpassword.text isEqualToString:@""] || [_Textfield_newpassword.text isEqualToString:@""] || [_Textfield_confirmpassword.text isEqualToString:@""] || ![_Textfield_newpassword.text isEqualToString:_Textfield_confirmpassword.text])
        {
            _Button_ChangePassword.enabled=NO;
            [_Button_ChangePassword setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _Button_ChangePassword.backgroundColor=[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
        }
        else
        {
            _Button_ChangePassword.enabled=YES;
            
            [_Button_ChangePassword setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _Button_ChangePassword.backgroundColor=[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        }
    }
}
-(void)ChangePasswordCommunication
{
    
    
    [self.view endEditing:YES];
    [self.view showActivityViewWithLabel:@"Changing"];
    NSString *userid= @"userid";
    NSString *useridVal=[defaults valueForKey:@"userid"];
    NSString *oldpassword= @"oldpassword";
    
    NSString *newpassword= @"newpassword";
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@",userid,useridVal,oldpassword,_Textfield_oldpassword.text,newpassword,_Textfield_newpassword.text];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"changepassword"];;
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
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 
                                                 if ([ResultString isEqualToString:@"changed"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password Changed" message:@"Your password has been changed successfully, and your new login details have also been sent to your registered email address. Thank-you" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                                                {
                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                }];
                                                     
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"error"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Please enter your correct password and try again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"  style:UIAlertActionStyleDefault handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 
                                                 
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 
                                             }
                                             
                                             else
                                             {
                                                 NSLog(@" error login1 ---%ld",(long)statusCode);
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                             }
                                             
                                             
                                         }
                                         else if(error)
                                         {
                                             [self.view hideActivityViewWithAfterDelay:0];
                                             NSLog(@"error login2.......%@",error.description);
                                         }
                                         
                                         
                                     }];
    [dataTask resume];
}



@end
