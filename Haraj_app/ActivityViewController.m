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


@interface ActivityViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    ActivityTableViewCell *ActivityCell;
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_Activity;
    NSMutableData *webData_Activity;
    NSMutableArray *Array_Activity,*Array_Activity1;
    
}

@end

@implementation ActivityViewController
@synthesize segmentedControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    defaults = [[NSUserDefaults alloc]init];
    [self activityConnection];
    
    segmentedControl.frame = CGRectMake(segmentedControl.frame.origin.x,segmentedControl.frame.origin.y, segmentedControl.frame.size.width, segmentedControl.frame.size.height + 10);
    
    NSDictionary *segmentedControlTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:20.0], NSForegroundColorAttributeName:[UIColor blackColor]};
    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateNormal];
//    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateHighlighted];
//    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateSelected];
    
    UIColor *grayColor = [UIColor darkGrayColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjects:@[grayColor] forKeys:@[UITextAttributeTextColor]];
    [segmentedControl setTitleTextAttributes:attributes
                               forState:UIControlStateSelected];
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [self activityConnection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    return ActivityCell;
    
    
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

#pragma mark - NSURL CONNECTION Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    
    if(connection==Connection_Activity)
    {
        [webData_Activity setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_Activity)
    {
        [webData_Activity appendData:data];
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
        
     //   Array_Activity = Array_Activity1;
        
//--------------------------------------------------------------------------------------------------
//        if(Array_Activity1.count !=0)
//        {
//            
//            
//            for (int j=0; j<Array_Activity1.count; j++)
//            {
//                NSString * receiveruserid2;
//                if ([[defaults valueForKey:@"userid"]isEqualToString:[[Array_Activity1 objectAtIndex:j]valueForKey:@"receiveruserid"]])
//                {
//                    receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"senderuserid"];
//                }
//                else
//                {
//                    receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"receiveruserid"];
//                }
//                
//                
//                //    NSString * receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"receiveruserid"];
//                NSString * postid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"postid"];
//                
//                
//                
//                
//            }
//            
//        }
//        

    
//---------------------------------------------------------------------------------------------
        

        
                if(Array_Activity1.count !=0)
                {

                   
                for (int j=0; j<Array_Activity1.count; j++)
                    {
                        NSString * receiveruserid2;
             if ([[defaults valueForKey:@"userid"]isEqualToString:[[Array_Activity1 objectAtIndex:j]valueForKey:@"receiveruserid"]])
             {
                 receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"senderuserid"];
             }
            else
            {
                receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"receiveruserid"];
            }
                 
                 
        //    NSString * receiveruserid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"receiveruserid"];
            NSString * postid2=[[Array_Activity1 objectAtIndex:j]valueForKey:@"postid"];
                        
                        if ([[Array_Activity valueForKeyPath :@"receiveruserid"] containsObject:receiveruserid2] && [[Array_Activity valueForKeyPath :@"postid"] containsObject:postid2] )
                            
                            
                        {

                        }
                        else
                        {
                            [Array_Activity addObject:[Array_Activity1 objectAtIndex:j]];
                        }
                            
                        }
                       
                    }
        
        
        
          NSLog(@"countaftermerge array %@",Array_Activity);
        
        
        
        
     
        if ([ResultString isEqualToString:@"nochat"])
        {
            
            
        }
        
        
        
    }
    
    [self.tableView reloadData];
}





- (IBAction)segmentedControl_Action:(id)sender
{
    
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
