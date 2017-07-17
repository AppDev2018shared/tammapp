//
//  FavouriteViewController.m
//  Haraj_app
//
//  Created by Spiel on 21/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavTableViewCell.h"
#import "Reachability.h"
#import "SBJsonParser.h"
#import "UIImageView+WebCache.h"
#import "AllViewSwapeViewController.h"

@interface FavouriteViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    FavTableViewCell *FavouriteCell;
    NSUserDefaults * defaults;
    
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_ViewFavPost;
    NSMutableData *webData_ViewFavPost;
    NSMutableArray *Array_ViewFavPost;
    
    UIActivityIndicatorView *activityindicator;
    
}

@end

@implementation FavouriteViewController
@synthesize postCountLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [[NSUserDefaults alloc]init];
   // postCountLabel.text = [defaults valueForKey:@"CountFav"];
    
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    [self viewFavouritePostConnection];
    
    
    //---------Activity indicator------------------------------------------
    
    activityindicator = [[UIActivityIndicatorView alloc]init];
    activityindicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhiteLarge;
    activityindicator.color = [UIColor grayColor] ;
    [activityindicator startAnimating];
    activityindicator.center = self.view.center;
    [self.view addSubview:activityindicator];

    
}

-(void)viewWillAppear:(BOOL)animated
{
     [self viewFavouritePostConnection];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return Array_ViewFavPost.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString * str=@"CellFav";
    FavouriteCell=(FavTableViewCell*)[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    
 //   FavouriteCell = [tableView dequeueReusableCellWithIdentifier:@"CellFav"];
    
     NSDictionary *dic_request=[Array_ViewFavPost objectAtIndex:indexPath.row];
    
    
    FavouriteCell.postImageView.layer.cornerRadius = 10;
    FavouriteCell.postImageView.layer.masksToBounds = YES;
    
    FavouriteCell.postIdLabel.text =[NSString stringWithFormat:@"POST ID:%@",[dic_request valueForKey:@"postid"]] ;
    FavouriteCell.durationLabel.text = [dic_request valueForKey:@"postdur"];
    FavouriteCell.titleLabel.text = [dic_request valueForKey:@"title"];
    
    
    NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
    [FavouriteCell.postImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]
                                    options:SDWebImageRefreshCached];

    
    
    
    
    
    
    return FavouriteCell;

    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AllViewSwapeViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewSwapeViewController"];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    set1.Array_Alldata = Array_ViewFavPost;
    set1.tuchedIndex = indexPath.row;
    [self.navigationController pushViewController:set1 animated:YES];
    
    NSLog(@"Selected Index= %lditem",(long)indexPath.row);
    
}


-(void)viewFavouritePostConnection
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
        NSString *  urlStr=[urlplist valueForKey:@"viewfavourites"];
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
        
        Connection_ViewFavPost = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_ViewFavPost)
            {
                webData_ViewFavPost =[[NSMutableData alloc]init];
                
                
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
    
    if(connection==Connection_ViewFavPost)
    {
        [webData_ViewFavPost setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_ViewFavPost)
    {
        [webData_ViewFavPost appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_ViewFavPost)
    {
        
        Array_ViewFavPost=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_ViewFavPost=[objSBJsonParser objectWithData:webData_ViewFavPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_ViewFavPost encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_ViewFavPost);
        NSLog(@"Array_ViewFavPostcount= %lu",(unsigned long)Array_ViewFavPost.count);
        NSLog(@"registration_status %@",[[Array_ViewFavPost objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
        
        postCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)Array_ViewFavPost.count];
        
        
        [defaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)Array_ViewFavPost.count] forKey:@"CountFav"];
        
//        if (Array_ViewFavPost.count != 0)
//        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
//        }
        
    }
    [self.tableView reloadData];
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
