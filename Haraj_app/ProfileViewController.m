//
//  ProfileViewController.m
//  Haraj_app
//
//  Created by Spiel on 21/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "ProfileViewController.h"
#import "PatternViewCell.h"
#import "ImageCollectionViewCell.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "FRGWaterfallHeaderReusableView.h"
#import "UIImageView+WebCache.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "MyPostViewController.h"
#import "AllViewSwapeViewController.h"
#import "FavouriteViewController.h"
#import "ChoosePostViewController.h"
#import "BoostPostViewController.h"


@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegate,FRGWaterfallCollectionViewDelegate>

{
    NSMutableArray *modelArray;
    NSMutableArray *array;
    
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_ViewPost;
    NSMutableData *webData_ViewPost;
    NSMutableArray *Array_ViewPost;
}

@end

@implementation ProfileViewController
@synthesize searchTextField,searchImageView,profileImageView,nameLabel,lastnameLabel,favoritesValueLabel,postValueLabel,salepointValueLabel,favouriteLabel,saleLabel,postLabel,payImageView,payLabel,boostImageview,boostLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    defaults = [[NSUserDefaults alloc]init];

    
    // Do any additional setup after loading the view.
    FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.itemWidth = 173.0f;
    cvLayout.topInset = 1.0f;
    cvLayout.bottomInset = 10.0f;
    cvLayout.stickyHeader = YES;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // [self viewPostConnection];
    
    [self.collectionView setCollectionViewLayout:cvLayout];
    [self.collectionView reloadData];
    
    
    
    NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"ProImg"]];

    [profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
    profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2;
    profileImageView.clipsToBounds = YES;
    
    nameLabel.text = [defaults valueForKey:@"FirstName" ];
    lastnameLabel.text = [defaults valueForKey:@"LastName" ];
    
    [self viewPostConnection];
    
//---------------------------Favourite label tap gesture---------------------------------------------------------
     favoritesValueLabel.text = [defaults valueForKey:@"CountFav"];
     favoritesValueLabel.userInteractionEnabled = YES;
     favouriteLabel.userInteractionEnabled = YES;
    
  
    UITapGestureRecognizer *favourite_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favourite_ActionDetails:)];
    [favoritesValueLabel addGestureRecognizer:favourite_Tapped];
      UITapGestureRecognizer *favourite_Tapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favourite_ActionDetails:)];
    [favouriteLabel addGestureRecognizer:favourite_Tapped1];
    
//---------------------------Pay Fee label tap gesture---------------------------------------------------------
    
    payImageView.userInteractionEnabled = YES;
    payLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *ChoosePay_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChoosePay_ActionDetails:)];
    [payImageView addGestureRecognizer:ChoosePay_Tapped];
    UITapGestureRecognizer *ChoosePay_Tapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChoosePay_ActionDetails:)];
    [payLabel addGestureRecognizer:ChoosePay_Tapped1];
    
    
    
    //---------------------------Pay Fee label tap gesture---------------------------------------------------------
    
    boostImageview.userInteractionEnabled = YES;
    boostLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer * boost_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChooseBoost_ActionDetails:)];
    [boostImageview addGestureRecognizer:boost_Tapped];
    
    UITapGestureRecognizer *boost_Tapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChooseBoost_ActionDetails:)];
    [boostLabel addGestureRecognizer:boost_Tapped1];
    
  
    
}

-(void)viewWillAppear:(BOOL)animated
{
    // [self viewPostConnection];
    
    [self.collectionView reloadData];
    
    
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)favourite_ActionDetails:(UIGestureRecognizer *)reconizer
{
    NSLog(@"favourite tap");
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavouriteViewController * profile=[mainStoryboard instantiateViewControllerWithIdentifier:@"FavouriteViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:profile animated:YES];
   
}

-(void)ChoosePay_ActionDetails:(UIGestureRecognizer *)reconizer
{
    NSLog(@"ChoosePay_ActionDetails tap");
  
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChoosePostViewController * choose=[mainStoryboard instantiateViewControllerWithIdentifier:@"ChoosePostViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:choose animated:YES];
    
}
-(void)ChooseBoost_ActionDetails:(UIGestureRecognizer *)reconizer
{
    NSLog(@"ChooseBoost_ActionDetails tap");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BoostPostViewController * choose=[mainStoryboard instantiateViewControllerWithIdentifier:@"BoostPostViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    choose.Array_Boost = Array_ViewPost;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:choose animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return Array_ViewPost.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic_request=[Array_ViewPost objectAtIndex:indexPath.row];
    NSLog(@"dic= %@",dic_request);
    
    NSString *xyz = [dic_request valueForKey:@"mediatype"];
    
    if([NSNull null] ==[[Array_ViewPost  objectAtIndex:0]valueForKey:@"mediatype"] || [[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
    {
        
        PatternViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
        
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        if([NSNull null] ==[dic_request valueForKey:@"mediathumbnailurl"])
        {
            
            cell.videoImageView.image =[UIImage imageNamed:@"defaultpostimg.jpg"];
            cell.playImageView.image = [UIImage imageNamed:@""];
        }
        else
        {
            [cell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]
                                            options:SDWebImageRefreshCached];
            cell.playImageView.image = [UIImage imageNamed:@"Play"];
            //[cell.videoImageView sd_setImageWithURL:url];
            
        }
        
        
        
        cell.videoImageView.layer.cornerRadius = 10;
        cell.videoImageView.layer.masksToBounds = YES;
        
        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
        cell.bidAmountLabel.text = show;//[dic_request valueForKey:@"showamount"];
        cell.titleLabel.text =  [dic_request valueForKey:@"title"];
        cell.locationLabel.text = [dic_request valueForKey:@"city1"];
        cell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        
        
        return cell;
    }
    else
    {
        
        ImageCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        //        [cell.videoImageView sd_setImageWithURL:url];
        cell.videoImageView.layer.cornerRadius = 10;
        cell.videoImageView.layer.masksToBounds = YES;
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        [cell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]
                                        options:SDWebImageRefreshCached];
        
        cell.locationLabel.text = [dic_request valueForKey:@"city1"];
        cell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
        cell.bidAmountLabel.text = show;
        cell.titleLabel.text = [dic_request valueForKey:@"title"];
        
        return cell;
    }
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MyPostViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    
//    set1.Array_UserInfo = Array_ViewPost;
//    set1.swipeCount = 2;
//    [self.navigationController pushViewController:set1 animated:YES];
//    
//    NSLog(@"Selected Index= %lditem",(long)indexPath.row);
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AllViewSwapeViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewSwapeViewController"];
    
    
    // OnCellClickNewViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"OnCellClickNewViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    set1.Array_Alldata = Array_ViewPost;
    set1.tuchedIndex = indexPath.row;
    [self.navigationController pushViewController:set1 animated:YES];
    
    NSLog(@"Selected Index= %lditem",(long)indexPath.row);
    
}


#pragma mark -Collection Cell layout

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // return [self.cellHeights[indexPath.section + 1 * indexPath.item] floatValue];
    
    NSDictionary *dic_request=[Array_ViewPost objectAtIndex:indexPath.row];
    CGFloat height;
    
    
    if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"] )
        
    {
        height = 300.0;
    }
    else
    {
        
        height = 250.0;
        
    }
    return height;
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return 26.0f;//(indexPath.section + 1) * 26.0f;
}




- (IBAction)SettingButton_Action:(id)sender
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
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewPostConnection
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
        NSString *  urlStr=[urlplist valueForKey:@"viewpost"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *location= @"location";
        NSString *locationVal = @"OFF";
        
        NSString *myposts= @"myposts";
        NSString *mypostsVal = @"YES";
        
       

        
        NSString *city= @"city";
        NSString *cityVal = [defaults valueForKey:@"Cityname"];

        NSString *country= @"country";
        NSString *countryVal = [defaults valueForKey:@"Countryname"];;
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,location,locationVal,city,cityVal,country,countryVal,myposts,mypostsVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_ViewPost = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_ViewPost)
            {
                webData_ViewPost =[[NSMutableData alloc]init];
                
                
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
    
    if(connection==Connection_ViewPost)
    {
        [webData_ViewPost setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_ViewPost)
    {
        [webData_ViewPost appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_ViewPost)
    {
        
        Array_ViewPost=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_ViewPost=[objSBJsonParser objectWithData:webData_ViewPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_ViewPost encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_ViewPost);
        NSLog(@"count= %lu",(unsigned long)Array_ViewPost.count);
        NSLog(@"registration_status %@",[[Array_ViewPost objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
        
        if ([ResultString isEqualToString:@"done"])
        {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        
        postValueLabel.text =[NSString stringWithFormat:@"%lu", (unsigned long)Array_ViewPost.count];
        
        
    }
    [self.collectionView reloadData];
}





@end
