//
//  ActivityNextViewController.m
//  Haraj_app
//
//  Created by Spiel on 11/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "ActivityNextViewController.h"
#import "ProfileViewController.h"
#import "ActivityTableViewCell.h"
#import "Reachability.h"
#import "SBJsonParser.h"
#import "UIImageView+WebCache.h"
#import "FriendCahtingViewController.h"

#import "OnCellClickViewController.h"
#import "MyPostViewController.h"
#import "AFNetworking.h"

@interface ActivityNextViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    ActivityTableViewCell *ActivityCell;
    NSUserDefaults * defaults;
    NSTimer *homeTimer;

    
    NSDictionary *urlplist;
    NSURLConnection *Connection_Activity2;
    NSMutableData *webData_Activity2;
    NSMutableArray *Array_Activity2, *Array_Activity;
    
}


@end

@implementation ActivityNextViewController
@synthesize AllDataArray,touchedIndex,postIdLabel,postImageView,backbutton,labelheding,view_line;


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.view.frame.size.width==375 && self.view.frame.size.height==812)
    {
        [postImageView setFrame:CGRectMake(postImageView.frame.origin.x, postImageView.frame.origin.y+12, postImageView.frame.size.width, 86)];
        
         [postIdLabel setFrame:CGRectMake(postIdLabel.frame.origin.x, postIdLabel.frame.origin.y, postIdLabel.frame.size.width, 21)];
        
       [backbutton setFrame:CGRectMake(backbutton.frame.origin.x, backbutton.frame.origin.y+14, backbutton.frame.size.width, 28)];
        [labelheding setFrame:CGRectMake(labelheding.frame.origin.x, labelheding.frame.origin.y+14, labelheding.frame.size.width, 28)];
        [view_line setFrame:CGRectMake(view_line.frame.origin.x, view_line.frame.origin.y+9, view_line.frame.size.width, 1)];
        
        
        
    }
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    defaults = [[NSUserDefaults alloc]init];
    
    postIdLabel.text =[NSString stringWithFormat:@"%@%@",@" :رقم الإعلان",[[AllDataArray objectAtIndex:touchedIndex]valueForKey:@"postid"]];//POST ID[NSString stringWithFormat:@"POST ID: %@",[[AllDataArray objectAtIndex:touchedIndex]valueForKey:@"postid"]];
    
    
    postImageView.layer.cornerRadius = 10;
    postImageView.clipsToBounds = YES;
    
    postImageView.userInteractionEnabled = YES;
    
    
    NSURL * url=[NSURL URLWithString:[[AllDataArray objectAtIndex:touchedIndex] valueForKey:@"mediathumbnailurl"]];
    [postImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postImageTap:)];
    [self.postImageView addGestureRecognizer:tap];
    
    
    
    [self activityConnection2];

    
}

-(void)chatTimer
{
    homeTimer =  [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(activityConnection2) userInfo:nil  repeats:YES];
}


-(void)postImageTap:(UITapGestureRecognizer *)sender

{
    
    NSLog(@"post image tapped") ;
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    if ([[[Array_Activity objectAtIndex:0] valueForKey:@"userid1"]isEqualToString:[defaults valueForKey:@"userid"]])
    {
    
        
         MyPostViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        set.Array_UserInfo = [Array_Activity objectAtIndex:0];
        set.swipeCount = touchedIndex;
        
         [defaults setObject:@"yes" forKey:@"Activitynext"] ;
            [defaults synchronize];
        
        [self.navigationController pushViewController:set animated:YES];
        
       
       

        
    }
    else
        
    {
        
        OnCellClickViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"OnCellClickViewController"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        set.Array_UserInfo = [Array_Activity objectAtIndex:0];
        set.swipeCount = touchedIndex;
        
        [defaults setObject:@"yes" forKey:@"Activitynext"] ;
        [defaults synchronize];
        
        [self.navigationController pushViewController:set animated:YES];
       

        
    }
  
    
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [self activityConnection2];
    [self chatTimer];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [homeTimer invalidate];
    homeTimer = nil;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return Array_Activity.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString * str=@"CellFav";
    //    FavouriteCell=(FavTableViewCell*)[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    //
    ActivityCell = [tableView dequeueReusableCellWithIdentifier:@"ActCell"];
    
    NSDictionary *dic_request=[Array_Activity objectAtIndex:indexPath.row];
    
    
    ActivityCell.profileImageView.layer.cornerRadius = ActivityCell.profileImageView.frame.size.height / 2;
    ActivityCell.profileImageView.layer.masksToBounds = YES;
    
    ActivityCell.greenAccessoryView.layer.cornerRadius = ActivityCell.greenAccessoryView.frame.size.height / 2;
    ActivityCell.greenAccessoryView.layer.masksToBounds = YES;
    
    ActivityCell.nameLabel.text = [dic_request valueForKey:@"name"];
    ActivityCell.messageLabel.text = [dic_request valueForKey:@"message"];
    
    NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"profilepic"]];
    [ActivityCell.profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
    
    
    // messageread
    
    if ([[dic_request valueForKey:@"messageread"]isEqualToString:@"no"])
    {
        ActivityCell.greenAccessoryView.hidden = NO;
        [ActivityCell.messageLabel setTextColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        
        
    }
    else
    {
        ActivityCell.greenAccessoryView.hidden = YES;
        [ActivityCell.messageLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    
    return ActivityCell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[UIScreen mainScreen]bounds].size.width ==320)
    {
        return 89;
    }
    else if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        return 113;
    }
    else
    {
        return 103;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    FriendCahtingViewController * chat=[mainStoryboard instantiateViewControllerWithIdentifier:@"FriendCahtingViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    NSMutableArray * addData=[[NSMutableArray alloc]init];
    [addData addObject: [Array_Activity objectAtIndex:indexPath.row]];
    chat.AllDataArray=addData;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:chat animated:YES];
    
    
    
    
}

-(void)activityConnection2
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
    }
    else
    {
        
        NSURL *url;//=[NSURL URLWithString:[urlplist valueForKey:@"singup"]];
        NSString *  urlStr=[urlplist valueForKey:@"activitystep2"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *postid = @"postid";
        NSString *postidVal = [[AllDataArray objectAtIndex:touchedIndex]valueForKey:@"postid"];
        
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",userid,useridVal,postid,postidVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_Activity2 = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_Activity2)
            {
                webData_Activity2 =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }
    
}

#pragma mark - NSURL CONNECTION Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    
    if(connection==Connection_Activity2)
    {
        [webData_Activity2 setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_Activity2)
    {
        [webData_Activity2 appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_Activity2)
    {
        
        Array_Activity=[[NSMutableArray alloc]init];
        Array_Activity2=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        //Array_Activity=[objSBJsonParser objectWithData:webData_Activity];
        Array_Activity2=[objSBJsonParser objectWithData:webData_Activity2];
        NSString * ResultString=[[NSString alloc]initWithData:webData_Activity2 encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_Activity2);
        NSLog(@"count= %lu",(unsigned long)Array_Activity2.count);
        NSLog(@"ResultString %@",ResultString);
        
      
        
        
        
        for (int i=0; i<Array_Activity2.count; i++)
                            {
            
                            NSString * name1=[[Array_Activity2 objectAtIndex:i]valueForKey:@"name"];
                            
                        for (int j=0; j<Array_Activity2.count; j++)
                            {
                                NSString * name2=[[Array_Activity2 objectAtIndex:j]valueForKey:@"name"];
                                
            
                            if ([name1 isEqualToString:name2])
                                {
                                        if (Array_Activity.count==0)
                                        {
                                            [Array_Activity addObject:[Array_Activity2 objectAtIndex:j]];
                                        }
                                    else
                                    {
                                        
                                    }
                                }
                            }
                            }
        
        
        
        
        //---------------------------------------------------------------------------------------------
        //
        //
        //
        //        if(Array_Activity1.count !=0)
        //            {
        //
        ////               for (int j=0; j<Array_Activity1.count; j++)
        ////                    {
        ////                        NSString * receiveruserid2;
        //////             if ([[defaults valueForKey:@"userid"]isEqualToString:[[Array_Activity1 objectAtIndex:j]valueForKey:@"receiveruserid"]])
        //////             {
        //////                 receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"senderuserid"];
        //////             }
        //////            else
        //////            {
        ////                receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"name"];
        ////           // }
        ////
        ////
        ////        //    NSString * receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"receiveruserid"];
        ////            NSString * postid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"postid"];
        ////
        ////                        if ([[Array_Activity valueForKeyPath :@"postid"] containsObject:postid2])
        ////
        ////                        {
        ////
        ////                        }
        ////                        else
        ////                        {
        ////                            [Array_Activity addObject:[Array_Activity1 objectAtIndex:j]];
        ////                        }
        ////
        ////                        }
        //
        //
        //
        //
        //
        //                for (int i=0; i<Array_Activity1.count; i++)
        //                {
        //
        //                NSString * name1=[[Array_Activity1 objectAtIndex:i]valueForKey:@"name"];
        //                NSString * id1=[[Array_Activity1 objectAtIndex:i]valueForKey:@"postid"];
        //            for (int j=0; j<Array_Activity1.count; j++)
        //                {
        //                    NSString * name=@"no";
        //                    NSString * name2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"name"];
        //                    NSString * id2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"postid"];
        //
        //                if ([name1 isEqualToString:name2])
        //                    {
        //                            if (Array_Activity.count==0)
        //                            {
        //                                [Array_Activity addObject:[Array_Activity1 objectAtIndex:j]];
        //                            }
        //                            else
        //                            {
        //                                if (![id1 isEqualToString:id2])
        //
        //                                {
        //
        //                                    for (int k=0; k<Array_Activity.count; k++)
        //                                    {
        //                                        NSString * name3=[[Array_Activity objectAtIndex:k]valueForKey:@"name"];
        //                                        NSString * id3=[[Array_Activity objectAtIndex:k]valueForKey:@"postid"];
        //                                        if ([name2 isEqualToString:name3] && [id2 isEqualToString:id3] )
        //                                        {
        //
        //                                            name=@"yes";
        //                                            break;
        //
        //                                        }
        //
        //                                    }
        //                                    if ([name isEqualToString:@"no"])
        //                                    {
        //                                        [Array_Activity addObject:[Array_Activity1 objectAtIndex:j]];
        //                                    }
        //                                }
        //                            }
        //                        }
        //                        else
        //                        {
        //                            for (int k=0; k<Array_Activity.count; k++)
        //                            {
        //                                NSString * name3=[[Array_Activity objectAtIndex:k]valueForKey:@"name"];
        //                                NSString * id3=[[Array_Activity objectAtIndex:k]valueForKey:@"postid"];
        //                                if ([name2 isEqualToString:name3] && [id2 isEqualToString:id3] )
        //                                {
        //
        //                                    name=@"yes";
        //                                    break;
        //
        //                                }
        //
        //                            }
        //                            if ([name isEqualToString:@"no"])
        //                            {
        //                                [Array_Activity addObject:[Array_Activity1 objectAtIndex:j]];
        //                            }
        //                        }
        //
        //
        //                        
        //                        
        //                        
        //                    }
        //                }
        //                NSLog(@"New array merge==%@",Array_Activity);
        //                NSLog(@"New countss==%lu",(unsigned long)Array_Activity.count);
        //                
        //                
        //                
        //                
        //                
        //                
        //                
        //                
        //                
        //                
        //                
        //                
        //                    }
        //        
        //        
        //        
        //          NSLog(@"countaftermerge array %@",Array_Activity);
        //        
        //        
        //        
        
        
        if ([ResultString isEqualToString:@"nochat"])
        {
            
            
        }
        
        
        
    }
    
    [self.tableView reloadData];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ProfileButton_Action:(id)sender
{
    
    [defaults setObject:@"Activity" forKey:@"profileTapped"];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ProfileViewController * profile=[mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:profile animated:YES];
    
    
    
    
}
- (IBAction)SearchButton_Action:(id)sender
{
    
}
- (IBAction)BackButton_Action:(id)sender
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
