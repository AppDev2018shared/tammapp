//
//  LoginWithViewController.m
//  Haraj_app
//
//  Created by Spiel on 06/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "LoginWithViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Bolts/Bolts.h>
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "UIView+RNActivityView.h"
#import "FRHyperLabel.h"
#import "LoginPageViewController.h"
#import "SignUpViewController.h"
#import "SBJsonParser.h"
#import "HomeNavigationController.h"


@interface LoginWithViewController ()
{
    
    NSUserDefaults *defaults;
    NSDictionary *urlplist;
    NSMutableArray *array_login;

    NSString *emailFb,*DobFb,*nameFb,*genderfb,*profile_picFb,*Fbid,*regTypeVal,*EmailValidTxt,*Str_fb_friend_id,*Str_fb_friend_id_Count;
    NSMutableArray *fb_friend_id;
}
@property (weak, nonatomic) IBOutlet FRHyperLabel *termLabel;

@end

@implementation LoginWithViewController
@synthesize facebookButton,twitterButton,Label_TermsAndCon;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    defaults=[[NSUserDefaults alloc]init];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    facebookButton.clipsToBounds=YES;
    facebookButton.layer.cornerRadius=5.0f;
    facebookButton.layer.borderColor=[UIColor whiteColor].CGColor;
    facebookButton.layer.borderWidth=1.5;
   // facebookButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    facebookButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    twitterButton.clipsToBounds=YES;
    twitterButton.layer.cornerRadius=5.0f;
    twitterButton.layer.borderColor=[UIColor whiteColor].CGColor;
    twitterButton.layer.borderWidth=1.5;
    twitterButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    

//    NSString *string = @"by signing in, you agree to our Terms";
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSRange range = [string rangeOfString:@"Terms"];
//    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:12.0] range:range];
//   
//    
//    label.attributedText = attString;
//    
//    
//    

    
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
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://play-date.ae/terms.html"]];
            
        }
        
    };
    
    //Step 3: Add link substrings
    
    [label setLinksForSubstrings:@[@"Terms & Conditions"] withLinkHandler:handler];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)facebookAction:(id)sender {
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
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,friends,name,first_name,last_name,gender,email,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     if ([result isKindOfClass:[NSDictionary class]])
                     {
                         NSLog(@"Results=%@",result);
                         emailFb=[result objectForKey:@"email"];
                         Fbid=[result objectForKey:@"id"];
                         //  nameFb=[NSString stringWithFormat:@"%@%@%@",[result objectForKey:@"first_name"],@" ",[result objectForKey:@"last_name"]];
                         nameFb=[result objectForKey:@"name"];
                         genderfb=[result objectForKey:@"gender"];
                         
                         
                         NSArray * allKeys = [[result valueForKey:@"friends"]objectForKey:@"data"];
                         
                         //                             fb_friend_Name = [[NSMutableArray alloc]init];
                         fb_friend_id  =  [[NSMutableArray alloc]init];
                         
                         for (int i=0; i<[allKeys count]; i++)
                         {
                             //   [fb_friend_Name addObject:[[[[result valueForKey:@"friends"]objectForKey:@"data"] objectAtIndex:i] valueForKey:@"name"]];
                             
                             [fb_friend_id addObject:[[[[result valueForKey:@"friends"]objectForKey:@"data"] objectAtIndex:i] valueForKey:@"id"]];
                             
                         }
                         Str_fb_friend_id_Count=[NSString stringWithFormat:@"%lu",(unsigned long)fb_friend_id.count];
                         Str_fb_friend_id=[fb_friend_id componentsJoinedByString:@","];
                         NSLog(@"Friends ID : %@",Str_fb_friend_id);
                         ///NSLog(@"Friends Name : %@",fb_friend_Name);
                         
                         profile_picFb= [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",Fbid];
                         
                         [defaults setObject:nameFb forKey:@"UserName"];
                         [defaults setObject:profile_picFb forKey:@"ProImg"];
                         [defaults synchronize];

                         
                         NSLog(@"my url DataFBB=%@",result);
                         regTypeVal =@"FACEBOOK";
                         
                         [self FbTwittercommunicationServer];
                         
                     }
                     
                     
                 }
             }];
             
         }
         
     }];
    
    


}

- (IBAction)twitterAction:(id)sender
{
    
    
    //[self.view showActivityViewWithLabel:@"Loading"];
    
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

-(void)FbTwittercommunicationServer
{
    
    
    
    //   [self.view showActivityViewWithLabel:@"Loading"];
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
                                                     
                                                     
                                                     
                                                     [defaults setObject:[[array_login objectAtIndex:0]valueForKey:@"email"] forKey:@"email"];
                                                     
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"friends"]] forKey:@"friends"];
                                                     
                                                     [defaults setObject:[[array_login objectAtIndex:0]valueForKey:@"name"] forKey:@"name"];
                                                     
                                                     
                                                     [defaults setObject:[[array_login objectAtIndex:0]valueForKey:@"profileimage"] forKey:@"profileimage"];
                                                     
                                                     [defaults setObject:[NSString stringWithFormat:@"%@",[[array_login objectAtIndex:0]valueForKey:@"userid"]] forKey:@"userid"];
                                                     
                                                     
                                                     [defaults setObject:@"yes" forKey:@"LoginView"];
                                                     
                                                     [defaults synchronize];
                                                     
                                                     
                                                     HomeNavigationController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
                                                     
                                                     //                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                     //                        HomeTabBarViewController *   Home_add= [mainStoryboard instantiateViewControllerWithIdentifier:@"HomeTabBarViewController"];
                                                     [[UIApplication sharedApplication].keyWindow setRootViewController:loginController];
                                                     
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

- (IBAction)termsAction:(id)sender {
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://play-date.ae/terms.html"]];
}
- (IBAction)Login_Action:(id)sender
{
    
    LoginPageViewController *loginController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginPageViewController"];
    [self.navigationController pushViewController:loginController animated:NO];
    
}
- (IBAction)CreateAccount_Action:(id)sender
{
    SignUpViewController *SignController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:SignController animated:NO];
}


@end
