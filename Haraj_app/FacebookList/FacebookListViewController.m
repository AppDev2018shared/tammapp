//
//  FacebookListViewController.m
//  care2Dare
//
//  Created by Spiel's Macmini on 5/17/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import "FacebookListViewController.h"
#import "Reachability.h"
#import "SBJsonParser.h"
#import "UIImageView+WebCache.h"
@interface FacebookListViewController ()
{
    NSDictionary *urlplist;
    NSUserDefaults * defaults;
    NSMutableArray * Arrat_facebook;
    CALayer *Bottomborder_Cell2;
    NSString *userId_prof;
    NSArray * Array_searchFriend;
}
@end

@implementation FacebookListViewController
@synthesize tableview_facebook,indicator,Lable_JSONResult,cell_fb,searchbar;
- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults=[[NSUserDefaults alloc]init];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    Array_searchFriend=[[NSArray alloc]init];
    [self Facebookcommunication];
    [tableview_facebook setHidden:YES];
    indicator.hidden=NO;
    [indicator startAnimating];
    Lable_JSONResult.hidden=YES;
    searchbar.showsCancelButton=NO;
    
    

}
- (void)Facebookcommunication
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Care2dare." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        
        
        NSString *userid= @"userid";
        NSString *useridVal;
//        if ( [[defaults valueForKey:@"SettingLogin"] isEqualToString:@"TWITTER"]||[[defaults valueForKey:@"SettingLogin"]isEqualToString:@"EMAIL"])
//        {
//            useridVal =[defaults valueForKey:@"facebookid"];
//        }
//        else
//        {
       useridVal =[defaults valueForKey:@"userid"];
     //   }
        NSString *requestt= @"request";
        NSString *requestvalt =@"FACEBOOK";
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",userid,useridVal,requestt,requestvalt];
        
        
        
#pragma mark - swipe sesion
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"invite_fb_twitter"];;
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
                                                     
                                                     Arrat_facebook=[[NSMutableArray alloc]init];
                                                     
                                                     SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                     
                                                     Arrat_facebook =[objSBJsonParser objectWithData:data];
                                            Array_searchFriend=[objSBJsonParser objectWithData:data];
                                                     NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     
                                                     
                                                     
                                                     NSLog(@"Array_WorldExp ResultString %@",ResultString);
                                                     
                                                     
                                                     if (Arrat_facebook.count ==0)
                                                     {
                                                         [tableview_facebook setHidden:YES];
                                                         indicator.hidden=YES;
                                                         [indicator stopAnimating];
                                                         Lable_JSONResult.hidden=NO;
                                                     }
                                                     
                                                     if (Arrat_facebook.count !=0)
                                                     {
                                                         [tableview_facebook setHidden:NO];
                                                         indicator.hidden=YES;
                                                         [indicator stopAnimating];
                                                         Lable_JSONResult.hidden=YES;
                                                         [tableview_facebook reloadData];
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
    
}
-(IBAction)Button_Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return Arrat_facebook.count;
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellone=@"Cellfb";
    
    
    cell_fb = (FacebookoneTableViewCell *)[tableview_facebook dequeueReusableCellWithIdentifier:cellone forIndexPath:indexPath];
    NSDictionary * dictVal=[Arrat_facebook objectAtIndex:indexPath.row];
    
    if (Arrat_facebook.count-1==indexPath.row)
    {
        Bottomborder_Cell2 = [CALayer layer];
        Bottomborder_Cell2.backgroundColor = [UIColor clearColor].CGColor;
        Bottomborder_Cell2.frame = CGRectMake(0, cell_fb.frame.size.height-1, cell_fb.frame.size.width, 1);
        [cell_fb.layer addSublayer:Bottomborder_Cell2];
    }
    else
    {
        
            Bottomborder_Cell2 = [CALayer layer];
            Bottomborder_Cell2.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0].CGColor;
            Bottomborder_Cell2.frame = CGRectMake(0, cell_fb.frame.size.height-1,cell_fb.frame.size.width, 1);
            [cell_fb.layer addSublayer:Bottomborder_Cell2];
        
        
    }

    NSURL * url=[NSURL URLWithString:[dictVal valueForKey:@"imageurl"]];
 
    
   
    [cell_fb.image_profile_img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] options:SDWebImageRefreshCached];
    cell_fb.label_fbname.text=[dictVal valueForKey:@"name"];
    cell_fb.Button_invite.tag=indexPath.row;
    cell_fb.Button_invite.clipsToBounds=YES;
    cell_fb.Button_invite.layer.cornerRadius=7.0f;
    if ([[dictVal valueForKey:@"status"] isEqualToString:@"ADD"])
    {
        cell_fb.Button_invite.enabled=YES;
        [cell_fb.Button_invite setTitle:@"ADD" forState:UIControlStateNormal];
          [cell_fb.Button_invite addTarget:self action:@selector(AddUser:) forControlEvents:UIControlEventTouchUpInside];
         [cell_fb.Button_invite setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
         [cell_fb.Button_invite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if ([[dictVal valueForKey:@"status"] isEqualToString:@"INVITE"])
    {
        cell_fb.Button_invite.enabled=YES;
        [cell_fb.Button_invite setTitle:@"INVITE" forState:UIControlStateNormal];
          [cell_fb.Button_invite addTarget:self action:@selector(InviteUser:) forControlEvents:UIControlEventTouchUpInside];
        [cell_fb.Button_invite setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        [cell_fb.Button_invite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }
    else if ([[dictVal valueForKey:@"status"] isEqualToString:@"ADDED"])
    {
        cell_fb.Button_invite.enabled=NO;
        [cell_fb.Button_invite setTitle:@"ADDED" forState:UIControlStateNormal];
        [cell_fb.Button_invite setBackgroundColor:[UIColor clearColor]];
        [cell_fb.Button_invite setTitleColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1] forState:UIControlStateNormal];
    }
  
    
    return cell_fb;
    
    
    
}
-(void)InviteUser:(UIButton *)sender
{
  
}
-(void)AddUser:(UIButton *)sender
{
 
    
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable)
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Care2dare." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           exit(0);
                                       }];
            
            [alertController addAction:actionOk];
            
            UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            alertWindow.rootViewController = [[UIViewController alloc] init];
            alertWindow.windowLevel = UIWindowLevelAlert + 1;
            [alertWindow makeKeyAndVisible];
            [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
            
        }
        else
        {
            
            [cell_fb.Button_invite setTitle:@"Added" forState:UIControlStateNormal];
            NSString *userid1= @"userid1";
            NSString *useridval1= [defaults valueForKey:@"userid"];
            
            NSString *userid2= @"userid2";
            userId_prof=[[Arrat_facebook valueForKey:@"frienduserid"]objectAtIndex:sender.tag];
            
            
            NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",userid1,useridval1,userid2,userId_prof];
            
            
            
#pragma mark - swipe sesion
            
            NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
            
            NSURL *url;
            NSString *  urlStrLivecount=[urlplist valueForKey:@"addfriend"];;
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
                                                         
                                                        
                                                         if ([ResultString isEqualToString:@"requested"])
                                                         {
                                                             
                                                            
                                                             [self Facebookcommunication];
                                                             
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
        
    
  }
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    searchbar.showsCancelButton=YES;
    if (searchText.length==0)
    {
        
        [Arrat_facebook removeAllObjects];
        [Arrat_facebook addObjectsFromArray:Array_searchFriend];
        
    }
    else
        
    {
        
        [Arrat_facebook removeAllObjects];
        
        for (NSDictionary *book in Array_searchFriend)
        {
            NSString * string=[book objectForKey:@"name"];
           
            NSRange r=[string rangeOfString:searchText options:NSCaseInsensitiveSearch];
           
            if (r.location !=NSNotFound )
            {
              
                [Arrat_facebook addObject:book];
                
            }
            
        }
        
    }
    
    
    
    [tableview_facebook reloadData];
    
    
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchbar.showsCancelButton=NO;
    [self.view endEditing:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
@end
