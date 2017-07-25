//
//  ActivityViewController.m
//  Haraj_app
//
//  Created by Spiel on 26/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "ActivityViewController.h"
#import "ProfileViewController.h"
#import "ActivityTableViewCell.h"
#import "Reachability.h"
#import "SBJsonParser.h"
#import "UIImageView+WebCache.h"
#import "FriendCahtingViewController.h"
#import "ActivityNextViewController.h"
#import "OnCellClickViewController.h"
#import "MyPostViewController.h"


@interface ActivityViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    ActivityTableViewCell *ActivityCell;
    NSUserDefaults * defaults;
    NSTimer *homeTimer, *notiTimer;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_Activity, *Connection_Notification;
    NSMutableData *webData_Activity, *webData_Notification;
    NSMutableArray *Array_Activity,*Array_Activity1, *Array_Notification;
    
    NSString *segmentPressed;
    CALayer *bottomBorder;
    
}

@end

@implementation ActivityViewController
@synthesize segmentedControl,greenViewInbox,greenViewNotification;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    segmentPressed =@"inbox";
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    defaults = [[NSUserDefaults alloc]init];
    [self activityConnection];
    
    
    
    segmentedControl.frame = CGRectMake(segmentedControl.frame.origin.x,segmentedControl.frame.origin.y, segmentedControl.frame.size.width, segmentedControl.frame.size.height + 10);
    
    NSDictionary *segmentedControlTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:20.0], NSForegroundColorAttributeName:[UIColor blackColor]};
    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateNormal];
//    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateHighlighted];
    
//    NSDictionary *segmentedControlTextAttributes1 = @{NSFontAttributeName:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:20.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
//    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes1 forState:UIControlStateSelected];
    
//    [segmentedControl setTintColor:[UIColor whiteColor]];
//    
//    segmentedControl.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
//    segmentedControl.layer.borderWidth = 1.0f;
//    segmentedControl.layer.cornerRadius = 5.0f;
    
    
    
    
    UIColor *grayColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:@[grayColor] forKeys:@[UITextAttributeTextColor]];
    [segmentedControl setTitleTextAttributes:attributes
                               forState:UIControlStateSelected];
    
    [segmentedControl setSelectedSegmentIndex:1];
    
    
    greenViewInbox.layer.cornerRadius = greenViewInbox.frame.size.height/2;
    greenViewInbox.clipsToBounds = YES;
    greenViewNotification.layer.cornerRadius = greenViewNotification.frame.size.height/2;
    greenViewNotification.clipsToBounds = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh_updateBadge) name:@"updateBadge" object:nil];
    
    
    [self refresh_updateBadge];
    
    
    
   
}

-(void)chatTimer
{
     homeTimer =  [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(activityConnection) userInfo:nil  repeats:YES];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [self activityConnection];
//    [self notificationConnection];
    [self chatTimer];
  
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [homeTimer invalidate];
    homeTimer = nil;
    
    [notiTimer invalidate];
    notiTimer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([segmentPressed isEqualToString:@"inbox"])
    {
    return Array_Activity.count;
    }
    else
    {
        return Array_Notification.count;
    }
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
    
    if ([segmentPressed isEqualToString:@"inbox"])
    {

    
   NSDictionary *dic_request=[Array_Activity objectAtIndex:indexPath.row];
    
    
    ActivityCell.profileImageView.layer.cornerRadius = 10; //ActivityCell.profileImageView.frame.size.height / 2;
    ActivityCell.profileImageView.layer.masksToBounds = YES;
    
    ActivityCell.greenAccessoryView.layer.cornerRadius = ActivityCell.greenAccessoryView.frame.size.height / 2;
    ActivityCell.greenAccessoryView.layer.masksToBounds = YES;
    
    ActivityCell.nameLabel.text = [dic_request valueForKey:@"title"];
    ActivityCell.messageLabel.text = [dic_request valueForKey:@"postid"];
    
    
    
   NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
    [ActivityCell.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]
                                            options:SDWebImageRefreshCached];
    
    
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
    
    
    
    }
    else
    {
        
        NSDictionary *dic_request=[Array_Notification   objectAtIndex:indexPath.row];
        
        
        ActivityCell.profileImageView.layer.cornerRadius = 10; //ActivityCell.profileImageView.frame.size.height / 2;
        ActivityCell.profileImageView.layer.masksToBounds = YES;
        
        ActivityCell.greenAccessoryView.layer.cornerRadius = ActivityCell.greenAccessoryView.frame.size.height / 2;
        ActivityCell.greenAccessoryView.layer.masksToBounds = YES;
        
        ActivityCell.nameLabel.text = [dic_request valueForKey:@"title"];
        
        
        ActivityCell.messageLabel.numberOfLines = 2;
        ActivityCell.messageLabel.text = [dic_request valueForKey:@"message"];
        
        
        
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        [ActivityCell.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]
                                                  options:SDWebImageRefreshCached];
        
        
        // messageread
        
        if ([[dic_request valueForKey:@"notificationread"]isEqualToString:@"no"])
        {
            ActivityCell.greenAccessoryView.hidden = NO;
            [ActivityCell.messageLabel setTextColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
            
            
        }
        else
        {
            ActivityCell.greenAccessoryView.hidden = YES;
            [ActivityCell.messageLabel setTextColor:[UIColor lightGrayColor]];
        }
        

        
        
        
    }
    
   return ActivityCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([segmentPressed isEqualToString:@"inbox"])
    {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivityNextViewController * chat=[mainStoryboard instantiateViewControllerWithIdentifier:@"ActivityNextViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    chat.AllDataArray = Array_Activity;
    chat.touchedIndex = indexPath.row;
    
    
//    NSMutableArray * addData=[[NSMutableArray alloc]init];
//    [addData addObject: [Array_Activity objectAtIndex:indexPath.row]];
//    chat.AllDataArray=addData;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:chat animated:YES];
    
    }
    
    else
    {
        
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        if ([[[Array_Notification objectAtIndex:indexPath.row] valueForKey:@"userid1"]isEqualToString:[defaults valueForKey:@"userid"]])
        {
            
            
            MyPostViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
            set.Array_UserInfo = [Array_Notification objectAtIndex:indexPath.row];
            set.swipeCount = indexPath.row;
            [self.navigationController pushViewController:set animated:YES];
            
            [defaults setObject:@"yes" forKey:@"Activitynext"] ;
            
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
            
            set.Array_UserInfo = [Array_Notification objectAtIndex:indexPath.row];
            set.swipeCount = indexPath.row;
            
            [self.navigationController pushViewController:set animated:YES];
            [defaults setObject:@"yes" forKey:@"Activitynext"];
            
            
        }
        
        
  
        
        
        
    }
    
    
}



-(void)activityConnection
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
        NSString *  urlStr=[urlplist valueForKey:@"activity"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@",userid,useridVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_Activity = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_Activity)
            {
                webData_Activity =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }
    
}


-(void)notificationConnection
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
        NSString *  urlStr=[urlplist valueForKey:@"notifications"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@",userid,useridVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_Notification = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_Notification)
            {
                webData_Notification =[[NSMutableData alloc]init];
                
                
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
    
    if(connection==Connection_Activity)
    {
        [webData_Activity setLength:0];
        
        
    }
    
    if (connection == Connection_Notification)
    {
        [webData_Notification setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_Activity)
    {
        [webData_Activity appendData:data];
    }
    
    if (connection == Connection_Notification)
    {
        [webData_Notification appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_Activity)
    {
        
        Array_Activity=[[NSMutableArray alloc]init];
          Array_Activity1=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        //Array_Activity=[objSBJsonParser objectWithData:webData_Activity];
        Array_Activity1=[objSBJsonParser objectWithData:webData_Activity];
        NSString * ResultString=[[NSString alloc]initWithData:webData_Activity encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_Activity);
        NSLog(@"count= %lu",(unsigned long)Array_Activity.count);
        NSLog(@"ResultString %@",ResultString);
        
        Array_Activity = Array_Activity1;
        
//--------------------------------------------------------------------------------------------------
    
       
        
        
        
        
        
        
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
    
    if (connection==Connection_Notification)
    {
        
        Array_Notification=[[NSMutableArray alloc]init];
       
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_Notification=[objSBJsonParser objectWithData:webData_Notification];
        NSString * ResultString=[[NSString alloc]initWithData:webData_Notification encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_Notification);
        NSLog(@"count= %lu",(unsigned long)Array_Notification.count);
        NSLog(@"ResultString %@",ResultString);
    }
    
    [self.tableView reloadData];
}





- (IBAction)segmentedControl_Action:(id)sender
{
    
    NSLog(@"%ld",(long)segmentedControl.selectedSegmentIndex);
    
    
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        NSLog(@"notification");
        
        [self notificationConnection];
        
        segmentPressed = @"notification";
        
        
        notiTimer =  [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(notificationConnection) userInfo:nil  repeats:YES];
        
        [homeTimer invalidate];
        homeTimer = nil;
        
        Array_Activity = nil;
        

       
        
    }
    else
    {
        NSLog(@"inbox");
        segmentPressed = @"inbox";
        [notiTimer  invalidate];
        notiTimer = nil;
        [self chatTimer];
        [self activityConnection];
        
        Array_Notification = nil;
        
    }
    
    // Removing previous selection
//    [bottomBorder removeFromSuperlayer];
//    
//    // Creating new layer for selection
//    bottomBorder             = [CALayer layer];
//    bottomBorder.borderColor = [UIColor redColor].CGColor;
//    bottomBorder.borderWidth = 3;
//    
//    // Calculating frame
//    CGFloat width            = segmentedControl.frame.size.width/2;
//    CGFloat x                = segmentedControl.selectedSegmentIndex * width;
//    CGFloat y                = segmentedControl.frame.size.height + 1;
//    bottomBorder.frame       = CGRectMake(x, y,width, bottomBorder.borderWidth);
//    
//    // Adding selection to segment
//    [segmentedControl.layer addSublayer:bottomBorder];
    
    
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

-(void)refresh_updateBadge
{
    if ([[defaults valueForKey:@"notificationcount"] isEqualToString:@"0"])
    {
        greenViewNotification.hidden = YES;
    }
    else
    {
        greenViewNotification.hidden = NO;
    }
    if ([[defaults valueForKey:@"chatcount"] isEqualToString:@"0"])
    {
        greenViewInbox.hidden = YES;
    }
    else
    {
        greenViewInbox.hidden = NO;
    }

    
}



@end
