//
//  SignUpViewController.m
//  care2Dare
//
//  Created by Spiel's Macmini on 3/3/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import "SignUpViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Reachability.h"
#import "UIView+RNActivityView.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "SBJsonParser.h"
#import "HomeNavigationController.h"
#import "LoginPageViewController.h"
#import <FirebaseAuth/FirebaseAuth.h>
#import "MobileViewController.h"

#define Buttonlogincolor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]
@interface SignUpViewController ()
{
    NSMutableArray * array_login;
     NSDictionary *urlplist;
    NSUserDefaults * defaults;
    NSString *emailFb,*DobFb,*nameFb,*genderfb,*profile_picFb,*Fbid,*regTypeVal,*EmailValidTxt,*Str_fb_friend_id,*Str_fb_friend_id_Count;
    NSMutableArray *fb_friend_id;
}
@end

@implementation SignUpViewController
@synthesize Label_TitleName,textfield_name,textfield_password,textfield_Dob,textfield_MobileNumber,Button_signip,view_LoginFB,View_LoginTW,Label_TermsAndCon,Button_LoginFb,Button_LoginTw;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    defaults=[[NSUserDefaults alloc]init];
    
    
    CALayer *borderBottom_uname = [CALayer layer];
    borderBottom_uname.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_uname.frame = CGRectMake(0, textfield_name.frame.size.height-0.8, textfield_name.frame.size.width,0.5f);
    [textfield_name.layer addSublayer:borderBottom_uname];
    
    
    
    CALayer *borderBottom_passeord = [CALayer layer];
    borderBottom_passeord.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_passeord.frame = CGRectMake(0, textfield_password.frame.size.height-0.8, textfield_password.frame.size.width,0.5f);
    [textfield_password.layer addSublayer:borderBottom_passeord];
    
    
    CALayer *borderBottom_dob = [CALayer layer];
    borderBottom_dob.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_dob.frame = CGRectMake(0, textfield_Dob.frame.size.height-0.8, textfield_Dob.frame.size.width,0.5f);
    [textfield_Dob.layer addSublayer:borderBottom_dob];
    
    
    CALayer *borderBottom_email = [CALayer layer];
    borderBottom_email.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_email.frame = CGRectMake(0, _textfield_Emailname.frame.size.height-0.8, _textfield_Emailname.frame.size.width,0.5f);
    [_textfield_Emailname.layer addSublayer:borderBottom_email];
    
    CALayer *borderBottom_mobile = [CALayer layer];
    borderBottom_mobile.backgroundColor = [UIColor whiteColor].CGColor;
    borderBottom_mobile.frame = CGRectMake(0, textfield_MobileNumber.frame.size.height-0.8, textfield_MobileNumber.frame.size.width,0.5f);
    [textfield_MobileNumber.layer addSublayer:borderBottom_mobile];
    
    
    
    Button_signip.clipsToBounds=YES;
    Button_signip.layer.cornerRadius=5.0f;
    Button_signip.layer.borderColor=[UIColor whiteColor].CGColor;
    Button_signip.layer.borderWidth=0.5;
    
    view_LoginFB.clipsToBounds=YES;
    view_LoginFB.layer.cornerRadius=5.0f;
    view_LoginFB.layer.borderColor=[UIColor whiteColor].CGColor;
    view_LoginFB.layer.borderWidth=1.0f;
    UITapGestureRecognizer * LoginFB =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LoginWithFbAction:)];
    [view_LoginFB addGestureRecognizer:LoginFB];
   

    
    
    View_LoginTW.clipsToBounds=YES;
    View_LoginTW.layer.cornerRadius=5.0f;
    View_LoginTW.layer.borderColor=[UIColor whiteColor].CGColor;
    View_LoginTW.layer.borderWidth=1.0f;
    UITapGestureRecognizer * LoginTW =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(LoginWithTwitterAction:)];
    [View_LoginTW addGestureRecognizer:LoginTW];
    
    
    CALayer *borderLeftFb = [CALayer layer];
    borderLeftFb.backgroundColor = [UIColor whiteColor].CGColor;
    
    borderLeftFb.frame = CGRectMake(0, 0, 1.0,Button_LoginFb.frame.size.height);
    [Button_LoginFb.layer addSublayer:borderLeftFb];
    
    CALayer *borderLeftTw = [CALayer layer];
    borderLeftTw.backgroundColor = [UIColor whiteColor].CGColor;
    
    borderLeftTw.frame = CGRectMake(0, 0, 1.0, Button_LoginTw.frame.size.height);
    [Button_LoginTw.layer addSublayer:borderLeftTw];
    
    UIFont *arialFont = [UIFont fontWithName:@"San Francisco Display" size:14.0];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: arialFont forKey:NSFontAttributeName];
    NSMutableAttributedString *aAttrString = [[NSMutableAttributedString alloc] initWithString:@"By signing in, you agree to our " attributes: arialDict];
    
    UIFont *VerdanaFont = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16.0];
    NSDictionary *verdanaDict = [NSDictionary dictionaryWithObject:VerdanaFont forKey:NSFontAttributeName];
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc]initWithString: @"Terms & Conditions" attributes:verdanaDict];
    
    [aAttrString appendAttributedString:vAttrString];
    
    
    Label_TermsAndCon.attributedText = aAttrString;
    Button_signip .enabled=NO;
    Button_signip.titleLabel.textColor =Buttonlogincolor;
    
    
    
    FRHyperLabel *label = self.termLabel;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"San Francisco Display" size:12]];
    
    //Step 1: Define a normal attributed string for non-link texts
    
    NSString *string = @"By signing in, you agree to our Terms & Conditions";
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:(255/255.0) green:255/255.0 blue:255/255.0 alpha:1],NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]};
    
    
    label.attributedText = [[NSAttributedString alloc]initWithString:string attributes:attributes];
    
    //Step 2: Define a selection handler block
    
    void(^handler)(FRHyperLabel *label, NSString *substring) = ^(FRHyperLabel *label, NSString *substring)
    {
        
        if ([substring isEqualToString:@"Terms & Conditions"])
        {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tammapp.com/terms.html"]];
            
        }
        
    };
    
    //Step 3: Add link substrings
    
    [label setLinksForSubstrings:@[@"Terms & Conditions"] withLinkHandler:handler];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)SignUpViewBack:(id)sender
{
    LoginPageViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginPageViewController"];
    [self.navigationController pushViewController:loginController animated:NO];
    
}
-(IBAction)LoginWithFbAction:(id)sender
{
      [self.view endEditing:YES];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
     
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Play:Date." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       [alertController dismissViewControllerAnimated:YES completion:nil];
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }
    else
    {
        [self.view showActivityViewWithLabel:@"Loading"];
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        
        
        [login logInWithReadPermissions: @[@"public_profile", @"email",@"user_friends"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             NSLog(@"Process result=%@",result);
             NSLog(@"Process error=%@",error);
             if (error)
             {
                 [self.view hideActivityViewWithAfterDelay:1];
                 
                 NSLog(@"Process error");
             }
             else if (result.isCancelled)
             {
                 [self.view hideActivityViewWithAfterDelay:1];
                 
                 NSLog(@"Cancelled");
             }
             else
             {
                 
                 
                 NSLog(@"Logged in");
                 NSLog(@"Process result123123=%@",result);
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,friends,first_name,last_name,gender,email,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         if ([result isKindOfClass:[NSDictionary class]])
                         {
                             NSLog(@"Results=%@",result);
                    emailFb=[result objectForKey:@"email"];
                Fbid=[result objectForKey:@"id"];
              //  nameFb=[NSString stringWithFormat:@"%@%@%@",[result objectForKey:@"first_name"],@" ",[result objectForKey:@"last_name"]];
                nameFb=[result objectForKey:@"name"];
                genderfb=[result objectForKey:@"gender"];
                            
                             
                  regTypeVal=@"FACEBOOK";
                         
                             NSArray * allKeys = [[result valueForKey:@"friends"]objectForKey:@"data"];
                             
                             //                             fb_friend_Name = [[NSMutableArray alloc]init];
                             fb_friend_id  =  [[NSMutableArray alloc]init];
                             
                             for (int i=0; i<[allKeys count]; i++)
                             {
                                 //   [fb_friend_Name addObject:[[[[result valueForKey:@"friends"]objectForKey:@"data"] objectAtIndex:i] valueForKey:@"name"]];
                                 
                                 [fb_friend_id addObject:[[[[result valueForKey:@"friends"]objectForKey:@"data"] objectAtIndex:i] valueForKey:@"id"]];
                                 
                             }
                             
                             Str_fb_friend_id=[fb_friend_id componentsJoinedByString:@","];
                             Str_fb_friend_id_Count=[NSString stringWithFormat:@"%lu",(unsigned long)fb_friend_id.count];
                             NSLog(@"Friends ID : %@",Str_fb_friend_id);

                             
        profile_picFb= [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",Fbid];
                             
                             NSLog(@"my url DataFBB=%@",result);
                             
                             [defaults setObject:nameFb forKey:@"UserName"];
                             [defaults setObject:profile_picFb forKey:@"ProImg"];
                             [defaults synchronize];
                             
                             
                             [self FbTwittercommunicationServer];
                             
                         }
                         
                         
                     }
                 }];
                 
             }
             
         }];
    }  
}
-(IBAction)LoginWithTwitterAction:(id)sender
{
      [self.view endEditing:YES];
     [self.view showActivityViewWithLabel:@"Loading"];
    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased completion:^(TWTRSession *session, NSError *error)
     {
         if (session)
         {
             
             NSLog(@"signed in as %@", [session userName]);
             NSLog(@"signed in as %@", session);
             
             TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
             NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                              URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                                       parameters:@{@"include_email": @"true", @"skip_status": @"true"}
                                                            error:nil];
             
             //@"https://api.twitter.com/1.1/users/show.json";
             
             
             [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  NSLog(@"datadata in as %@", data);
                  NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                  NSLog(@"ResultString in as %@", ResultString);
                  NSMutableDictionary *  Array_sinupFb=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                  
                  NSLog(@"Array_sinupFbArray_sinupFb in as %@", Array_sinupFb);
                  NSLog(@"emailemail in as %@", [Array_sinupFb valueForKey:@"email"]);
                   NSLog(@"location in as %@", [Array_sinupFb valueForKey:@"location"]);
                   NSLog(@"name in as %@", [Array_sinupFb valueForKey:@"name"]);
                  nameFb=[Array_sinupFb valueForKey:@"name"];
                  emailFb=[Array_sinupFb valueForKey:@"email"];
                  Fbid= [session userID];
                  regTypeVal =@"TWITTER";
                  genderfb=@"";
                  profile_picFb=[Array_sinupFb valueForKey:@"profile_image_url"];
                  
                  [self TwitterFriendsList];
                  
                  //[self FbTwittercommunicationServer];
                  [defaults setObject:nameFb forKey:@"UserName"];
                  [defaults setObject:profile_picFb forKey:@"ProImg"];
                  [defaults synchronize];
                  
              }];
             
             
             
         } else
         {
              [self.view hideActivityViewWithAfterDelay:1];
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}
-(IBAction)LoginButtonAction:(id)sender
{
    
   
    
    
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    
    
    if ([emailTest evaluateWithObject:_textfield_Emailname.text] == NO)
        
    {
        
      
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Invalid email address.Please try again" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    
        [_textfield_Emailname becomeFirstResponder];
         [textfield_Dob resignFirstResponder];
    }
    
    else
    {
       
    
    
    
    [self.view endEditing:YES];
    [textfield_Dob resignFirstResponder];
      [self.view showActivityViewWithLabel:@"Loading"];
    NSString *email= @"email";
    NSString *emailVal =_textfield_Emailname.text;
    
    NSString *name= @"name";
    NSString *nameVal =textfield_name.text;// [defautls valueForKey:@""];
    
    NSString *password= @"password";
    NSString *passwordVal =textfield_password.text;
    
    NSString *Dob= @"dateofbirth";
    NSString *DobVal =textfield_Dob.text;
    
    NSString *city= @"city";
    NSString *cityVal =[defaults valueForKey:@"Cityname"];;
    
    NSString *country= @"country";
    NSString *countryVal =[defaults valueForKey:@"Countryname"];
    
    NSString *devicetoken= @"devicetoken";
    NSString *devicetokenVal =@"123";
    
    NSString *regType= @"regtype";
    NSString *regTypeVal =@"EMAIL";
    
    NSString *Platform= @"platform";
    NSString *PlatformVal =@"ios";
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",email,emailVal,name,nameVal,password,passwordVal,Dob,DobVal,regType,regTypeVal,city,cityVal,country,countryVal,devicetoken,devicetokenVal,Platform,PlatformVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"loginsignup"];;
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
         
                array_login=[[NSMutableArray alloc]init];
                SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                array_login=[objSBJsonParser objectWithData:data];
                NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                //        Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_Swipe options:kNilOptions error:nil];
                
                ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                
                NSLog(@"array_loginarray_login %@",array_login);
                
                
                NSLog(@"array_login ResultString %@",ResultString);
                if ([ResultString isEqualToString:@"emailexists-facebook"])
                {
  [self.view hideActivityViewWithAfterDelay:0];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have a Facebook Account registered with this email id. Please login with Facebook." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }
                if ([ResultString isEqualToString:@"emailexists-twitter"])
                {
                    [self.view hideActivityViewWithAfterDelay:0];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have a Twitter Account registered with this email id. Please login with Twitter." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }
                if ([ResultString isEqualToString:@"emailexists-email"])
                {
                    [self.view hideActivityViewWithAfterDelay:0];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have an Account registered with this email id. Please login with your registered email." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                }

                if ([ResultString isEqualToString:@"nullerror"])
                {
[self.view hideActivityViewWithAfterDelay:0];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not retrieve one of the Account Ids. Please login and try again." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                
                    
                }
                if ([ResultString isEqualToString:@"inserterror"])
                {
                   
  
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not insert  Please try again" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                    [alertController addAction:actionOk];
                    [self presentViewController:alertController animated:YES completion:nil];
                   
                }
                
           if(array_login.count !=0)
                {
                    [self.view hideActivityViewWithAfterDelay:0];
                    
                    [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"challenges"]] forKey:@"challenges"];
                    
                    
                    
                    [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"email"]] forKey:@"email"];
                    
                    [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"friends"]] forKey:@"friends"];
                    
                    [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"name"]] forKey:@"name"];
                    
                    
                    [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"profileimage"]] forKey:@"profileimage"];
                    
                    [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"userid"]] forKey:@"userid"];
                    
                    [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"regtype"]] forKey:@"logintype"];
                    
//                     [self JoinAction];
                    
                    
                    [defaults setObject:@"yes" forKey:@"LoginView"];
                    [defaults synchronize];
                    
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    MobileViewController * mobileController=[mainStoryboard instantiateViewControllerWithIdentifier:@"MobileViewController"];
                    [self.navigationController pushViewController:mobileController animated:YES];

                    
                    
//
//                    HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
//[[UIApplication sharedApplication].keyWindow setRootViewController:loginController];

                }
                
                
                
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
    
    
//    
//    [[FIRPhoneAuthProvider provider] verifyPhoneNumber:textfield_MobileNumber.text
//                                            completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
//                                                if (error) {
//                                                   // [self showMessagePrompt:error.localizedDescription];
//                                                    return;
//                                                }
//                                                // Sign in using the verificationID and the code sent to the user
//                                                // ...
//                                                
//                                                
//                                                [defaults setObject:verificationID forKey:@"authVerificationId"];
//                                                
//                                          
//                                            }];
    
    
    
    
    
    
    
    
}




-(void)JoinAction

{
    NSString *message = [NSString stringWithFormat:@"Enter the Authentication  code  sent to  number :%@",textfield_MobileNumber.text];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Event Code" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
     
     {
         
         //         textField.frame=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
         
         textField.placeholder = @"Event Code";
         
         
         
         //        textField.secureTextEntry = YES;
         
     }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Join" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    
                                    {
                                        
                                        NSLog(@"Current password %@", [[alertController textFields][0] text]);
                                        
                                        
                                        
                                        FIRAuthCredential *credential = [[FIRPhoneAuthProvider provider] credentialWithVerificationID:[defaults valueForKey:@"authVerificationId"] verificationCode:[[alertController textFields][0] text]];
                                        
                                        
                                        
                                        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRUser *user, NSError *error)
                                        {
                                            if (error)
                                            {
                                                return ;
                                            }
                                            else
                                            {
                                                
                                                HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                                                [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                            }
                                        }];
                                        
//                                        if ([[defaults valueForKey:@"authVerificationId"]isEqualToString:[[alertController textFields][0] text]])
//                                        {
//                                            
//                                         HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
//                                            [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
//                                            
//                                        }
                                        
                                        
                                        
                                    }];
    
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"Canelled");
        
    }];
    
    [alertController addAction:confirmAction];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}




- (IBAction)Textfelds_Actions:(id)sender
{
  
    
    
    
    if (textfield_password .text.length !=0 && textfield_name.text.length !=0 && _textfield_Emailname.text.length !=0 )
    {
        
        Button_signip.enabled=YES;
   
    [Button_signip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       
    }
    else
    {
         [Button_signip setTitleColor:Buttonlogincolor forState:UIControlStateNormal];
        Button_signip.enabled=NO;
        
    }
}
-(void)TwitterFriendsList
{
    
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:Fbid];
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/friends/ids.json";
    NSDictionary *params = @{@"id" : Fbid};
    NSError *clientError;
    
    NSURLRequest *request = [client URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    
    if (request) {
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data e.g.
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                NSArray *json22=[json objectForKey:@"ids"];
                
                
                NSLog(@"jsonjson: %d",json22.count);
                
                Str_fb_friend_id=[json22 componentsJoinedByString:@","];
                Str_fb_friend_id_Count=[NSString stringWithFormat:@"%d",json22.count];
                NSLog(@"Str_fb_friend_id: %@",Str_fb_friend_id);
                NSLog(@"jsonjson: %@",json22);
                
                [self FbTwittercommunicationServer];
            }
            else
            {
                NSLog(@"Error: %@", connectionError);
                
                [self TwitterFriendsList];
            }
        }];
    }
    else
    {
        NSLog(@"Error: %@", clientError);
        
        [self TwitterFriendsList];
    }
    
    
    
}

-(void)FbTwittercommunicationServer
{
    
    [self.view showActivityViewWithLabel:@"Loading"];
    NSString *email= @"email";
    NSString *fbid1;
    if ([regTypeVal isEqualToString:@"FACEBOOK"])
    {
        fbid1= @"fbid";
    }
    else
    {
        fbid1= @"twitterid";
    }
    
    
    NSString *gender= @"gender";
    NSString *name= @"name";
    NSString *imageurl= @"imageurl";
    // [defautls valueForKey:@""];
    
    NSString *password= @"password";
    NSString *passwordVal =@"";
    
    NSString *Dob= @"dateofbirth";
    NSString *DobVal =@"";
    
    NSString *city= @"city";
    NSString *cityVal =[defaults valueForKey:@"Cityname"];;
    
    NSString *country= @"country";
    NSString *countryVal =[defaults valueForKey:@"Countryname"];
    
    NSString *devicetoken= @"devicetoken";
    NSString *devicetokenVal =@"123";
    
    NSString *regType= @"regtype";
    
    
    NSString *Platform= @"platform";
    NSString *PlatformVal =@"ios";
    
    NSString *nooffriends= @"nooffriends";
    
    NSString *friendlist= @"friendlist";
    NSString *friendlistval =[NSString stringWithFormat:@"%@",Str_fb_friend_id];
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",fbid1,Fbid,email,emailFb,gender,genderfb,name,nameFb,password,passwordVal,Dob,DobVal,regType,regTypeVal,city,cityVal,country,countryVal,devicetoken,devicetokenVal,Platform,PlatformVal,imageurl,profile_picFb,nooffriends,Str_fb_friend_id_Count,friendlist,friendlistval];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"loginsignup"];;
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
                                                 
    array_login=[[NSMutableArray alloc]init];
    SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
    array_login=[objSBJsonParser objectWithData:data];
    NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_Swipe options:kNilOptions error:nil];
                                                 
   ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
         NSLog(@"array_loginarray_login %@",array_login);
         NSLog(@"array_login ResultString %@",ResultString);
        if ([ResultString isEqualToString:@"emailexists-facebook"])
            {
       [self.view hideActivityViewWithAfterDelay:0];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have a Facebook Account registered with this email id. Please login with Facebook." preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
        style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
             }
          if ([ResultString isEqualToString:@"emailexists-twitter"])
            {
            [self.view hideActivityViewWithAfterDelay:0];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have a Twitter Account registered with this email id. Please login with Twitter." preferredStyle:UIAlertControllerStyleAlert];
                                                     
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
    style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
                                                 }
        if ([ResultString isEqualToString:@"emailexists-email"])
                                                 {
        [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You already have an Account registered with this email id. Please login with your registered email." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"nullerror"])
                                                 {
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not retrieve one of the Account Ids. Please login and try again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Could not insert  Please try again" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                 }
                                                 
                    if(array_login.count !=0)
                        {
                        [self.view hideActivityViewWithAfterDelay:0];
                            
                            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"challenges"]] forKey:@"challenges"];
                            
                            
                            
                            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"email"]] forKey:@"email"];
                            
                            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"friends"]] forKey:@"friends"];
                            
                            [defaults setObject:[[array_login objectAtIndex:0]valueForKey:@"name"] forKey:@"name"];
                            
                            
                            [defaults setObject:[[array_login objectAtIndex:0]valueForKey:@"profileimage"] forKey:@"profileimage"];
                            
                            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"userid"]] forKey:@"userid"];
                            
                            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"regtype"]] forKey:@"logintype"];
                            
                            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"mobileno"]] forKey:@"mobileNumber"];
                            [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"verified"]] forKey:@"verified"];
                            
                            
                            [defaults setObject:@"yes" forKey:@"LoginView"];
                            [defaults synchronize];
                            
                            
                            
                            if ([[[array_login objectAtIndex:0]valueForKey:@"verified"] isEqualToString:@"yes"])
                                
                            {
                                HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                                [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                
                            }
                            else
                            {
                                
                                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                MobileViewController * mobileController=[mainStoryboard instantiateViewControllerWithIdentifier:@"MobileViewController"];
                                [self.navigationController pushViewController:mobileController animated:YES];
                                
                            }

                            
                            
//        HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
//        [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                                 }
                                                 
                                                 
                                                 
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    
    UIDatePicker *datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    datePicker.date = [NSDate date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    NSDate *currDate = [NSDate date];
    
    // minimum date date picker
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currDate options:0];
    
    [datePicker setMaximumDate:currDate];
    
    [datePicker setMinimumDate:minDate];
    
    
    [df setDateFormat:@"yyyy-MM-dd "];
    
    // [df setDateFormat:@"dd-MM-yyyy"];
    
 
        NSDate *date=[df dateFromString:[df stringFromDate:[NSDate date]]];
        [datePicker setDate:date];

    
    
    
    
    [datePicker addTarget:self
                   action:@selector(LabelChange1:)
         forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor=[UIColor lightGrayColor];
    [textfield_Dob setInputView:datePicker];
    
}
- (void)LabelChange1:(UIDatePicker *)datePicker
{
    //    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //   // df.dateStyle = NSDateFormatterMediumStyle;
    //    //   df.dateStyle = NSDateFormatterShortStyle;
    //       [df setDateFormat:@"yyyy-MM-dd "];
    
#pragma mark - Date DD MM YYYY
    
    NSDateFormatter *showdf = [[NSDateFormatter alloc]init];
    [showdf setDateFormat:@"dd-MM-yyyy"];
    
    
    //
    //    datelabel_txt.text = [NSString stringWithFormat:@"%@",
    //                          [df stringFromDate:datePicker.date]];
    
    textfield_Dob.text = [NSString stringWithFormat:@"%@",
                          [showdf stringFromDate:datePicker.date]];
    
    
    
    
    
    
    
    
    if (textfield_Dob.text.length==0)
    {
       
        
    }
    else
    {
      
        
    }
    
    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  
    [self.view endEditing:YES];
    
}
@end
