//
//  TwitterListViewController.m
//  care2Dare
//
//  Created by Spiel's Macmini on 5/17/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import "TwitterListViewController.h"
#import "Reachability.h"
#import "SBJsonParser.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "UIImageView+WebCache.h"
@interface TwitterListViewController ()
{
    NSDictionary *urlplist;
    NSUserDefaults * defaults;
    NSMutableArray * Arrat_TwitterList,*Arrat_TwitterList1,*ArryMerge_twitterlistSection0,*ArryMerge_twitterlistSection1;
    NSInteger  array_Countval;
    NSString *flagTwitterMergeArray;
    UIView *sectionView;
    CALayer *borderBottom_SectionView0,*borderBottom_SectionView1;
    CALayer *Bottomborder_Cell2;
      NSMutableArray * Array_searchFriend1;
    NSArray * Array_Add,*array_invite;
    
}
@end

@implementation TwitterListViewController
@synthesize tableview_twitter,indicator,Lable_JSONResult,cell_twitter,cell_twitter2,searchbar;
- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults=[[NSUserDefaults alloc]init];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    Array_searchFriend1=[[NSMutableArray alloc]init];
    Array_Add=[[NSArray alloc]init];
    array_invite=[[NSArray alloc]init];
    
    borderBottom_SectionView0 = [CALayer layer];
    borderBottom_SectionView1 = [CALayer layer];
    
    [tableview_twitter setHidden:YES];
    indicator.hidden=NO;
    [indicator startAnimating];
    Lable_JSONResult.hidden=YES;
    array_Countval=0;
    searchbar.showsCancelButton=NO;
    
   
    flagTwitterMergeArray=@"yes";
 
    
    [self twittercommunication];
    
}
- (void)twittercommunication
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
//        if ( [[defaults valueForKey:@"SettingLogin"] isEqualToString:@"FACEBOOK"] || [[defaults valueForKey:@"SettingLogin"]isEqualToString:@"EMAIL"])
//        {
//            useridVal =[defaults valueForKey:@"twitterids"];
//        }
//        else
//        {
          useridVal =[defaults valueForKey:@"userid"];
       // }
        NSString *requestt= @"request";
        NSString *requestvalt =@"TWITTER";

        
        
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
                                                     
                        Arrat_TwitterList=[[NSMutableArray alloc]init];
                        Arrat_TwitterList1=[[NSMutableArray alloc]init];
                        ArryMerge_twitterlistSection0=[[NSMutableArray alloc]init];
                        ArryMerge_twitterlistSection1=[[NSMutableArray alloc]init];
                                        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                     
                                    Arrat_TwitterList =[objSBJsonParser objectWithData:data];
                                                    
                             NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
                                                     
                            ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     
                            ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     
                                                     
                                                     
                        NSLog(@"Array_WorldExp ResultString %@",ResultString);
                                                     
                            
                            if (Arrat_TwitterList.count ==0)
                            {
                                [tableview_twitter setHidden:YES];
                                indicator.hidden=YES;
                                [indicator stopAnimating];
                                Lable_JSONResult.hidden=NO;
                            }
                               
                        if (Arrat_TwitterList.count !=0)
                        {
                    array_Countval=Arrat_TwitterList.count;
                            
//                            [arrayLevelImages addObjectsFromArray:tempArray];
//                            [arrayLevelImages addObjectsFromArray:tempArray];

                            for (int i=0; i<Arrat_TwitterList.count; i++)
                            {
                                if ([[[Arrat_TwitterList objectAtIndex:i]valueForKey:@"status"] isEqualToString:@"INVITE"])
                                {
                                    [Arrat_TwitterList1 addObject:[[Arrat_TwitterList objectAtIndex:i]valueForKey:@"friendtwitterid"]];
                                }
                                else
                                {
                                    [ArryMerge_twitterlistSection0 addObject:[Arrat_TwitterList objectAtIndex:i]];
                                }
                            }
                            if (Arrat_TwitterList1.count !=0)
                            {
                                 [self twitterlist_intigrate];
                            }
                            if (ArryMerge_twitterlistSection0.count !=0)
                            {
                                Array_Add=[ArryMerge_twitterlistSection0 mutableCopy];
                                [tableview_twitter setHidden:NO];
                                indicator.hidden=YES;
                                [indicator stopAnimating];
                                Lable_JSONResult.hidden=YES;
                                [tableview_twitter reloadData];
                            }
                           
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0)
    {
        return ArryMerge_twitterlistSection0.count;
    }
    if (section==1)
    {
        return ArryMerge_twitterlistSection1.count;
    }

    return 0;
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellone=@"Celltw1";
    static NSString *celltwo=@"Celltw2";
    switch (indexPath.section)
    {
        case 0:
        {
            cell_twitter = (TwitteroneTableViewCell *)[tableview_twitter dequeueReusableCellWithIdentifier:cellone forIndexPath:indexPath];
            NSDictionary * dictVal=[ArryMerge_twitterlistSection0 objectAtIndex:indexPath.row];
            cell_twitter.Button_invite.tag=indexPath.row;
            if (ArryMerge_twitterlistSection0.count-1==indexPath.row)
            {
                Bottomborder_Cell2 = [CALayer layer];
                Bottomborder_Cell2.backgroundColor = [UIColor clearColor].CGColor;
                Bottomborder_Cell2.frame = CGRectMake(0, cell_twitter.frame.size.height-1, cell_twitter.frame.size.width, 1);
                [cell_twitter2.layer addSublayer:Bottomborder_Cell2];
            }
            else
            {
                
                Bottomborder_Cell2 = [CALayer layer];
                Bottomborder_Cell2.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0].CGColor;
                Bottomborder_Cell2.frame = CGRectMake(0, cell_twitter.frame.size.height-1,cell_twitter.frame.size.width, 1);
                [cell_twitter.layer addSublayer:Bottomborder_Cell2];
                
                
            }
            NSLog(@"Image width ==%f",cell_twitter.image_profile_img.frame.size.width);
             NSLog(@"Image Height ==%f",cell_twitter.image_profile_img.frame.size.height);
            [cell_twitter.image_profile_img setFrame:CGRectMake(cell_twitter.image_profile_img.frame.origin.x, cell_twitter.image_profile_img.frame.origin.y, cell_twitter.image_profile_img.frame.size.height, cell_twitter.image_profile_img.frame.size.height)];
            NSURL * url=[NSURL URLWithString:[dictVal valueForKey:@"imageurl"]];
            
            [cell_twitter.image_profile_img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] options:SDWebImageRefreshCached];
             [cell_twitter.Button_invite addTarget:self action:@selector(AddUser:) forControlEvents:UIControlEventTouchUpInside];
            cell_twitter.label_fbname.text=[dictVal valueForKey:@"name"];
            cell_twitter.Button_invite.clipsToBounds=YES;
            cell_twitter.Button_invite.layer.cornerRadius=7.0f;
            return cell_twitter;
        }
            
            break;
            
        case 1:
        {
            cell_twitter2 = (TwittertwoTableViewCell *)[tableview_twitter dequeueReusableCellWithIdentifier:celltwo forIndexPath:indexPath];
            NSDictionary * dictVal=[ArryMerge_twitterlistSection1 objectAtIndex:indexPath.row];
            
            if (ArryMerge_twitterlistSection1.count-1==indexPath.row)
            {
                Bottomborder_Cell2 = [CALayer layer];
                Bottomborder_Cell2.backgroundColor = [UIColor clearColor].CGColor;
                Bottomborder_Cell2.frame = CGRectMake(0, cell_twitter2.frame.size.height-1, cell_twitter2.frame.size.width, 1);
                [cell_twitter2.layer addSublayer:Bottomborder_Cell2];
            }
            else
            {
                
                Bottomborder_Cell2 = [CALayer layer];
                Bottomborder_Cell2.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0].CGColor;
                Bottomborder_Cell2.frame = CGRectMake(0, cell_twitter2.frame.size.height-1,cell_twitter2.frame.size.width, 1);
                [cell_twitter2.layer addSublayer:Bottomborder_Cell2];
                
                
            }
            cell_twitter2.Button_invite1.clipsToBounds=YES;
            cell_twitter2.Button_invite1.layer.cornerRadius=7.0f;
                cell_twitter2.label_fbname1.text=[dictVal valueForKey:@"name"];
            cell_twitter2.Button_invite1.tag=indexPath.row;
            NSURL * url=[NSURL URLWithString:[dictVal valueForKey:@"imageurl"]];
            
              [cell_twitter2.image_profile_img1 setFrame:CGRectMake(cell_twitter2.image_profile_img1.frame.origin.x, cell_twitter2.image_profile_img1.frame.origin.y, cell_twitter2.image_profile_img1.frame.size.height, cell_twitter2.image_profile_img1.frame.size.height)];
            
            [cell_twitter2.image_profile_img1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] options:SDWebImageRefreshCached];
            
            
            [cell_twitter2.Button_invite1 addTarget:self action:@selector(InviteUser:) forControlEvents:UIControlEventTouchUpInside];
            return cell_twitter2;

        }
            break;
    }
    
    return nil;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        
        
        borderBottom_SectionView0.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0].CGColor;
        borderBottom_SectionView0.frame = CGRectMake(0, sectionView.frame.size.height-1, sectionView.frame.size.width, 1);
        [sectionView.layer addSublayer:borderBottom_SectionView0];
        
        UILabel * Label1=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, sectionView.frame.size.height)];
        //        Label1.backgroundColor=[UIColor clearColor];
        Label1.textColor=[UIColor lightGrayColor];
        Label1.font=[UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:15.0f];
        Label1.text=@"Add Friends";
        [sectionView addSubview:Label1];
        sectionView.tag=section;
        
    }
    if (section==1)
    {
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel * Label1=[[UILabel alloc]initWithFrame:CGRectMake(20,0, self.view.frame.size.width-40, sectionView.frame.size.height)];
        //        Label1.backgroundColor=[UIColor clearColor];
        Label1.textColor=[UIColor lightGrayColor];
        Label1.font=[UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:15.0f];
        Label1.text=@"Invite Twitter Friends";
        [sectionView addSubview:Label1];
        
        sectionView.tag=section;
        borderBottom_SectionView1.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0].CGColor;
        borderBottom_SectionView1.frame = CGRectMake(0, sectionView.frame.size.height-1, sectionView.frame.size.width, 1);
        [sectionView.layer addSublayer:borderBottom_SectionView1];
        
        
        
    }
    //   if (section==3)
    //    {
    //
    //
    //    }
    //
    
    return  sectionView;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        if (ArryMerge_twitterlistSection0.count==0)
        {
            return 0;
        }
        else
        {
            return 40;
        }
    }
    if (section==1)
    {
        if (ArryMerge_twitterlistSection1.count==0)
        {
            return 0;
        }
        else
        {
            return 40;
        }
    }
    return 0;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}
-(void)twitterlist_intigrate
{
    NSArray  *tempArray;
    if (array_Countval>100)
    {
      tempArray= [Arrat_TwitterList1 subarrayWithRange:NSMakeRange(0, 99)];
        [Arrat_TwitterList1 removeObjectsInRange:(NSRange){0, 99}];
        array_Countval-=100;
       
        flagTwitterMergeArray=@"yes";
    }
    else
    {
        if (array_Countval !=0)
        {
        
         tempArray= [Arrat_TwitterList1 subarrayWithRange:NSMakeRange(0, Arrat_TwitterList1.count)];
             flagTwitterMergeArray=@"no";
       }

    }
    

    NSLog(@"Copy arrayyy %@",tempArray);
    
    
    
    
    NSString *Fbid=[defaults valueForKey:@"twitterid"];
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:Fbid];
     NSString * Str_fb_friend_id=[tempArray componentsJoinedByString:@","];
 //   NSString *url=[NSString stringWithFormat:@"%@%@",@"https://api.twitter.com/1.1/users/lookup.json?user_id=",Str_fb_friend_id];
    //683113,19563366,146374163,811972460560019456
    NSString *statusesShowEndpoint =[NSString stringWithFormat:@"%@%@",@"https://api.twitter.com/1.1/users/lookup.json?user_id=",Str_fb_friend_id];//]@"https://api.twitter.com/1.1/users/lookup.json?user_id=683113,19563366,146374163,811972460560019456";
    NSDictionary *params = @{@"id" : Fbid};
    NSError *clientError;
    
    NSURLRequest *request = [client URLRequestWithMethod:@"POST" URL:statusesShowEndpoint parameters:params error:&clientError];
    
    if (request) {
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data e.g.
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
               
                //NSArray *json22=[json objectForKey:@"id_str"];
                for (int i=0;i<json.count;i++)
                {
                    NSMutableDictionary * DictVal=[[NSMutableDictionary alloc]init];
                [DictVal setValue:[[json valueForKey:@"name"]objectAtIndex:i] forKey:@"name"];
                [DictVal setValue:[[json valueForKey:@"profile_image_url"]objectAtIndex:i] forKey:@"imageurl"];
                [DictVal setValue:[[json valueForKey:@"id_str"]objectAtIndex:i] forKey:@"id_str"];
                    [DictVal setValue:[[json valueForKey:@"screen_name"]objectAtIndex:i] forKey:@"screen_name"];
                    [ArryMerge_twitterlistSection1 addObject:DictVal];
                }
                

        NSLog(@"namename: %@",ArryMerge_twitterlistSection1);
                 array_invite=[ArryMerge_twitterlistSection1 mutableCopy];
                if ( [flagTwitterMergeArray isEqualToString:@"yes"])
                {
                    
                    [self twitterlist_intigrate];
                    [tableview_twitter setHidden:NO];
                    indicator.hidden=YES;
                    [indicator stopAnimating];
                    Lable_JSONResult.hidden=YES;
                       [tableview_twitter reloadData];
                    
                }
                else
                {
                    array_Countval=0;
                    [tableview_twitter setHidden:NO];
                    indicator.hidden=YES;
                    [indicator stopAnimating];
                    Lable_JSONResult.hidden=YES;
                    [tableview_twitter reloadData];
                    
                }
                
            }
            else
            {
                NSLog(@"Error: %@", connectionError);
                
                //[self twitterlist_intigrate];
            }
        }];
    }
    else
    {
        NSLog(@"Error: %@", clientError);
        
       // [self twitterlist_intigrate];
    }
    
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
-(void)InviteUser:(UIButton *)sender
{
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    NSString *screen_name=[[ArryMerge_twitterlistSection1 objectAtIndex:sender.tag]valueForKey:@"screen_name"];
    
    [composer setText:[NSString stringWithFormat:@"%@%@%@",@"@",screen_name,@" Download Care2Dare App and challenge your friends for a good cause! Get it from the Appstore now - http://www.care2Dare.com"]];
    //[composer setImage:[UIImage imageNamed:@"twitterBird"]];
    
    // Called from a UIViewController
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else
        {
            NSLog(@"Sending Tweet!");
        }
    }];
    
//@https://api.twitter.com/1.1/direct_messages/new.json?text=hello%2C%20tworld.%20welcome%20to%201.1.&screen_name=theseancook
//     NSString *Fbid=[defaults valueForKey:@"twitterid"];
//    NSString *useridd=[[ArryMerge_twitterlistSection1 objectAtIndex:sender.tag]valueForKey:@"id_str"];
//    
//    TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:Fbid];
////Download Care2Dare App and challenge your friends for a good cause! Get it from the Appstore now -
//    NSString *statusesShowEndpoint =[NSString stringWithFormat:@"%@%@",@"https://api.twitter.com/1.1/direct_messages/new.json?text=http://www.care2Dare.com&user_id=",useridd];
//    NSDictionary *params = @{@"id" : Fbid};
//    NSError *clientError;
//    
//    NSURLRequest *request = [client URLRequestWithMethod:@"POST" URL:statusesShowEndpoint parameters:params error:&clientError];
//    
//    if (request) {
//        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError)
//        {
//            if (data) {
//                // handle the response data e.g.
//                NSError *jsonError;
//                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//             NSLog(@"jsonjsonjson: %@", json);
//              
//                
//            }
//            else
//            {
//                NSLog(@"Error: %@", connectionError);
//                
//               
//            }
//        }];
//    }
//    else
//    {
//        NSLog(@"Error: %@", clientError);
//        
//        // [self twitterlist_intigrate];
//    }

    
    
    
    
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
        
       
        NSString *userid1= @"userid1";
        NSString *useridval1= [defaults valueForKey:@"userid"];
        
        NSString *userid2= @"userid2";
        NSString * userId_prof=[[ArryMerge_twitterlistSection0 valueForKey:@"frienduserid"]objectAtIndex:sender.tag];
        
        
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
                                                         
                                                         
                                                [self twittercommunication];
                                                         
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
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
      searchbar.showsCancelButton=YES;
 NSArray * Array_searchFriend=[[array_invite arrayByAddingObjectsFromArray:Array_Add]mutableCopy];
    if (searchText.length==0)
    {
        
        [Array_searchFriend1 removeAllObjects];
        [ArryMerge_twitterlistSection0 removeAllObjects];
        [ArryMerge_twitterlistSection1 removeAllObjects];
        
        [Array_searchFriend1 addObjectsFromArray:Array_searchFriend];
         [ArryMerge_twitterlistSection0 addObjectsFromArray:Array_Add];
         [ArryMerge_twitterlistSection1 addObjectsFromArray:array_invite];
        
    }
    else
        
    {
        
        [Array_searchFriend1 removeAllObjects];
         [ArryMerge_twitterlistSection0 removeAllObjects];
         [ArryMerge_twitterlistSection1 removeAllObjects];
        
        for (NSDictionary *book in Array_searchFriend)
        {
            NSString * string=[book objectForKey:@"name"];
            
            NSRange r=[string rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (r.location !=NSNotFound )
            {
                
                [Array_searchFriend1 addObject:book];
                
            }
            
        }
        for (int i=0; i<Array_searchFriend1.count; i++)
        {
            if ([[[Array_searchFriend1 objectAtIndex:i]valueForKey:@"status"] isEqualToString:@"ADD"])
            {
                [ArryMerge_twitterlistSection0 addObject:[Array_searchFriend1 objectAtIndex:i]];
            }
            else
            {
                [ArryMerge_twitterlistSection1 addObject:[Array_searchFriend1 objectAtIndex:i]];
            }
        }
        
    }
    
    
    
    [tableview_twitter reloadData];
    
    
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
        searchbar.showsCancelButton=NO;
   [self.view endEditing:YES];
}
@end
