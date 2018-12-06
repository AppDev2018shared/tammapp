//
//  PropertyViewController.m
//  Haraj_app
//
//  Created by Spiel on 22/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "PropertyViewController.h"
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

#import "SVPullToRefresh.h"
#import "RootViewController.h"
@interface PropertyViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,FRGWaterfallCollectionViewDelegate>
{
    
    NSMutableArray *modelArray;
    CellModel *model;
    NSMutableArray *array;
    
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_ViewPost;
    NSMutableData *webData_ViewPost;
    NSMutableArray *Array_ViewPost ,*Array_Property;
    CGFloat cellWidth,cellHeight,cellVideoHeight;

}


@property (nonatomic, strong) NSMutableArray *cellHeights;

@end

@implementation PropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ArrayPropertyData:) name:@"arrayproperty_Info" object:nil];
    defaults = [[NSUserDefaults alloc]init];
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.collectionView.alwaysBounceVertical = YES;
    if ([[UIScreen mainScreen]bounds].size.width == 320)
    {
        cellWidth = 160.0f;
        cellHeight = 210.0;
        cellVideoHeight = 260.0;
    }
    else if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        cellWidth = 200.0f;
        cellHeight = 255.0;
        cellVideoHeight = 310.0;
    }
    else
    {
        cellWidth = 173.0f;
        cellHeight = 225.0;
        cellVideoHeight = 275.0;
    }

    

    
    FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.itemWidth = cellWidth;//173.0f;
    cvLayout.topInset = 1.0f;
    cvLayout.bottomInset = 10.0f;
    cvLayout.stickyHeader = YES;
    
    [self.collectionView setCollectionViewLayout:cvLayout];
    [self.collectionView reloadData];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    //------------- Pull to Refresh----------------------------
    
    [self.collectionView addPullToRefreshWithActionHandler:^{
        
        [self insertRowAtTop];
        
    }];
    
    
    
    // setup infinite scrolling
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        
        [self insertRowAtBottom];
        
    }];

    
    //[self viewPostConnection];


}

- (void)insertRowAtTop {
    
    
    
    // [self PulltoRefershtable];
    
    int64_t delayInSeconds = 2.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.collectionView.pullToRefreshView stopAnimating];
        
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PullToRefreshTop" object: self userInfo:nil];
}





- (void)insertRowAtBottom {
    
    
    if (_collectionView.contentOffset.y<0)
    {
        [self.collectionView.infiniteScrollingView setAlpha:0];
        [self.collectionView.infiniteScrollingView stopAnimating];
    }
    else
    {
        [self.collectionView.infiniteScrollingView setAlpha:1];
        int64_t delayInSeconds = 1.0;
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self.collectionView.infiniteScrollingView stopAnimating];
            
        });
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PullToRefreshBottom" object: self userInfo:nil];
    }
}
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_collectionView.contentOffset.y<0)
    {
        [self.collectionView.infiniteScrollingView setAlpha:0];
        [self.collectionView.infiniteScrollingView stopAnimating];
    }
    
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
        Array_Property = [[NSMutableArray alloc]init];
        
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
            if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"property"])
            {
                
               
                    [Array_Property addObject:[Array_ViewPost objectAtIndex:i]];
                
            }
        
        }
  }
    
    [self.collectionView reloadData];

}


-(void)viewWillAppear:(BOOL)animated
{
   //[self viewPostConnection];
    if ([[defaults valueForKey:@"refreshView"] isEqualToString:@"yes"])
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PullToRefreshTop" object: self userInfo:nil];
        
    }
    else
    {
        
    }
    
    [defaults setObject:@"no" forKey:@"refreshView"];
    
   [[self navigationController] setNavigationBarHidden:YES animated:YES];
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
     [self.collectionView.collectionViewLayout invalidateLayout];
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return Array_Property.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_request=[Array_Property objectAtIndex:indexPath.row];
    NSLog(@"dic= %@",dic_request);
    if([NSNull null] ==[[Array_Property  objectAtIndex:0]valueForKey:@"mediatype"] || [[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
    {
  // if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"]  )
   // {
        PatternViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
        
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        cell.activityIndicatorVideo.hidden = NO;
        [cell.activityIndicatorVideo startAnimating];
        
        if([NSNull null] ==[dic_request valueForKey:@"mediathumbnailurl"])
        {
            
            cell.videoImageView.image =[UIImage imageNamed:@"defaultpostimg.jpg"];
            cell.playImageView.image = [UIImage imageNamed:@""];
        }
        else
        {
          //  [cell.videoImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
            
            [cell.videoImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 cell.videoImageView.image = image;
                 cell.activityIndicatorVideo.hidden = YES;
                 [cell.activityIndicatorVideo stopAnimating];
             }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             {
                 cell.activityIndicatorVideo.hidden = YES;
                 [cell.activityIndicatorVideo stopAnimating];
             }
             ];
            cell.playImageView.image = [UIImage imageNamed:@"Play"];
            
            
        }
        
        
        cell.videoImageView.layer.cornerRadius = 10;
        cell.videoImageView.layer.masksToBounds = YES;
        
        if ([[dic_request valueForKey:@"showamount"]floatValue] > [[dic_request valueForKey:@"askingprice"]floatValue])
        {
            NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"showamount"]];//$
            cell.bidAmountLabel.text = show;
        }
        else
        {
            NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"askingprice"]];//$
            cell.bidAmountLabel.text = show;
        }

        
//        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
//        cell.bidAmountLabel.text = show;//[dic_request valueForKey:@"showamount"];
        cell.titleLabel.text =  [dic_request valueForKey:@"title"];
        cell.locationLabel.text = [dic_request valueForKey:@"city1"];
        cell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        cell.videoImageView.layer.cornerRadius = 10;
        cell.videoImageView.layer.masksToBounds = YES;
        return cell;
    }
    else
    {
        
        ImageCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        
        cell.videoImageView.layer.cornerRadius = 10;
        cell.videoImageView.layer.masksToBounds = YES;
        
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [cell.videoImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             cell.videoImageView.image = image;
             cell.activityIndicator.hidden = YES;
             [cell.activityIndicator stopAnimating];
         }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             cell.activityIndicator.hidden = YES;
             [cell.activityIndicator stopAnimating];
         }
         ];

        
        
        
      //  [cell.videoImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
        
        
        cell.locationLabel.text = [dic_request valueForKey:@"city1"];
        cell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        
        if ([[dic_request valueForKey:@"showamount"]floatValue] > [[dic_request valueForKey:@"askingprice"]floatValue])
        {
            NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"showamount"]];//$
            cell.bidAmountLabel.text = show;
        }
        else
        {
            NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"askingprice"]];//$
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
//    AllViewSwapeViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewSwapeViewController"];
    
    RootViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    // OnCellClickNewViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"OnCellClickNewViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
        set1.Array_Alldata = Array_Property;
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
    
    NSDictionary *dic_request=[Array_Property objectAtIndex:indexPath.row];
    CGFloat height;
    
    
    if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"]  )
    {
        height = cellVideoHeight;//275.0;
    }
    else
    {
        
        height = cellHeight;//225.0;
        
    }
    return height;
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return 15.0f;//(indexPath.section + 1) * 26.0f;
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

-(void)ArrayPropertyData: (NSNotification*) notification
{
    Array_Property = [[NSMutableArray alloc]init];
    // arrayCar_Data
    //arrayCar_Info
    Array_Property = [[notification userInfo] objectForKey:@"arrayproperty_Data"];
    
    NSLog(@"Array_Property%@",notification);
    NSLog(@"Array Array_Property car data===%@",Array_Property);
    [self.collectionView reloadData];
}
@end
