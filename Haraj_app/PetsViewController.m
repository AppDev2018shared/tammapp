//
//  PetsViewController.m
//  Haraj_app
//
//  Created by Spiel on 22/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "PetsViewController.h"
#import "PatternViewCell.h"
#import "ImageCollectionViewCell.h"
#import "AFNetworking.h"
#import "CellModel.h"
#import "AFHTTPSessionManager.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "FRGWaterfallHeaderReusableView.h"
#import "OnCellClickViewController.h"
#import "MyPostViewController.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "PostingViewController.h"
#import "AllViewSwapeViewController.h"
@interface PetsViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,FRGWaterfallCollectionViewDelegate>
{
    
    NSMutableArray *modelArray;
    CellModel *model;
    NSMutableArray *array;
    
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_ViewPost;
    NSMutableData *webData_ViewPost;
    NSMutableArray *Array_ViewPost ,*Array_Pets;
}


@property (nonatomic, strong) NSMutableArray *cellHeights;


@end

@implementation PetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArraypetsData:) name:@"arraypets_Info" object:nil];
    defaults = [[NSUserDefaults alloc]init];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.itemWidth = 173.0f;
    cvLayout.topInset = 1.0f;
    cvLayout.bottomInset = 10.0f;
    cvLayout.stickyHeader = YES;
    
    [self.collectionView setCollectionViewLayout:cvLayout];
    [self.collectionView reloadData];
    
   //[self viewPostConnection];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--view post connection

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
        NSString *locationVal = @"ON";
        
        NSString *city= @"city";
        NSString *cityVal =@"mumbai";
        NSString *country= @"country";
        NSString *countryVal = @"India";
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,location,locationVal,city,cityVal,country,countryVal];
        
        
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
        Array_Pets = [[NSMutableArray alloc]init];
        Array_ViewPost=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_ViewPost=[objSBJsonParser objectWithData:webData_ViewPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_ViewPost encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_ViewPost);
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
        for (int i=0; i<Array_ViewPost.count; i++)
        {
            if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"pets"])
            {
                
                
                [Array_Pets addObject:[Array_ViewPost objectAtIndex:i]];
                NSLog(@"Car array = %@",Array_Pets);
                
            }
        }

        
        
    }
    [self.collectionView reloadData];

}


-(void)viewWillAppear:(BOOL)animated
{
    //[self viewPostConnection];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return Array_Pets.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_request=[Array_Pets objectAtIndex:indexPath.row];
    NSLog(@"dic= %@",dic_request);
    
    if([NSNull null] ==[[Array_Pets  objectAtIndex:0]valueForKey:@"mediatype"] ||[[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
    {
//    if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"]  )
//    {
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
        if ([dic_request valueForKey:@"showamount"] > [dic_request valueForKey:@"askingprice"])
        {
            NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
            cell.bidAmountLabel.text = show;
        }
        else
        {
            NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"askingprice"]];
            cell.bidAmountLabel.text = show;
        }

        
//        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
//        cell.bidAmountLabel.text = show;//[dic_request valueForKey:@"showamount"];
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
        
        if ([dic_request valueForKey:@"showamount"] > [dic_request valueForKey:@"askingprice"])
        {
            NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
            cell.bidAmountLabel.text = show;
        }
        else
        {
            NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"askingprice"]];
            cell.bidAmountLabel.text = show;
        }

//        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
//        cell.bidAmountLabel.text = show;
        cell.titleLabel.text = [dic_request valueForKey:@"title"];
        
        return cell;
    }
    
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AllViewSwapeViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewSwapeViewController"];
    
    
    // OnCellClickNewViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"OnCellClickNewViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    set1.Array_Alldata = Array_Pets;
    set1.tuchedIndex = indexPath.row;
    [self.navigationController pushViewController:set1 animated:YES];
    
    NSLog(@"Selected Index= %lditem",(long)indexPath.row);}


#pragma mark -Collection Cell layout

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic_request=[Array_Pets objectAtIndex:indexPath.row];
    CGFloat height;
    
    
    if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"]  )
    {
        height = 275.0;
    }
    else
    {
        
        height = 225.0;
        
    }
    return height;
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return 26.0f;//(indexPath.section + 1) * 26.0f;
}

- (NSMutableArray *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray arrayWithCapacity:900];
        for (NSInteger i = 0; i < 900; i++) {
            _cellHeights[i] = @(arc4random()%100*2+100);
        }
    }
    return _cellHeights;
}
-(void)ArraypetsData: (NSNotification*) notification
{
    Array_Pets = [[NSMutableArray alloc]init];
    // arrayCar_Data
    //arrayCar_Info
    Array_Pets = [[notification userInfo] objectForKey:@"arraypets_Data"];
    
    NSLog(@"Array_Pets%@",notification);
    NSLog(@"Array_PetsArray_Pets===%@",Array_Pets);
    [self.collectionView reloadData];
}




@end
