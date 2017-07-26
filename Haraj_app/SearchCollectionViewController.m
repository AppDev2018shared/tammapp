//
//  SearchCollectionViewController.m
//  Haraj_app
//
//  Created by Spiel on 21/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "SearchCollectionViewController.h"
#import "PatternViewCell.h"
#import "ImageCollectionViewCell.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "FRGWaterfallHeaderReusableView.h"
#import "UIImageView+WebCache.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "UIView+RNActivityView.h"
#import "AllViewSwapeViewController.h"


@interface SearchCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegate,FRGWaterfallCollectionViewDelegate,UITextFieldDelegate>
{
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_SearchPost;
    NSMutableData *webData_SearchPost;
    NSMutableArray *Array_SearchPost;
    UIActivityIndicatorView *activityindicator;
    
    PatternViewCell *Videocell;
    ImageCollectionViewCell *Imagecell;
    FRGWaterfallCollectionViewLayout *cvLayout;
    UILabel *imagev;
}

@end

@implementation SearchCollectionViewController

@synthesize searchTextField,Button_Back,Button_Cancel,searchTextEnter,rowTapCategory;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    defaults = [[NSUserDefaults alloc]init];
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
     Button_Cancel.hidden = YES;
    
    searchTextField.text = searchTextEnter;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10,searchTextField.frame.size.height)];
    searchTextField.rightView = paddingView;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,36,22)];
    searchTextField.leftView = paddingView1;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.delegate=self;

    
    
    // Do any additional setup after loading the view.
    cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.itemWidth = 173.0f;
   
    cvLayout.bottomInset = 10.0f;
    cvLayout.stickyHeader = YES;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self.collectionView setCollectionViewLayout:cvLayout];
    [self.collectionView reloadData];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    
    // //---------Activity indicator------------------------------------------
    
    activityindicator = [[UIActivityIndicatorView alloc]init];
    activityindicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhiteLarge;
    activityindicator.color = [UIColor grayColor] ;
    [activityindicator startAnimating];
    activityindicator.center = self.collectionView.center;
    [self.view addSubview:activityindicator];
    
    
    
     _label_JsonResult.hidden=YES;
  
    
    if ([[_initialTitles valueForKey:@"typesection"]isEqualToString:@"section1"] )
    {
        cvLayout.topInset = 30.0f;
        //self.collectionView.contentInset = UIEdgeInsetsMake(50, 0, 30, 30);
     imagev = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 30)];
        //imagev.backgroundColor=[UIColor blackColor];
        imagev.text=[_initialTitles valueForKey:@"name"];
        imagev.textAlignment = NSTextAlignmentRight;
        imagev.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:24];
        [self.collectionView addSubview: imagev];
        [self.view addSubview: _collectionView];
    }
    else if ([[_initialTitles valueForKey:@"typesection"]isEqualToString:@"section2"] )
    {
        cvLayout.topInset = 1.0f;
        searchTextField.text =[_initialTitles valueForKey:@"name"];
    }
    
    
    [self SearchPostConnection];

}

-(void)viewWillAppear:(BOOL)animated
{
     [self SearchPostConnection];
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
//    if(isFiltered == YES)
//    {
//        return _filteredArray.count;
//    }
//    else
//    {
        return Array_SearchPost.count;
    //}
    //return Array_ViewPost.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_request;
//    
//    if(isFiltered == YES)
//    {
//        dic_request=[_filteredArray objectAtIndex:indexPath.row];
//        
//    }
//    else
//    {
//        dic_request=[Array_ViewPost objectAtIndex:indexPath.row];
//    }
//    
    dic_request=[Array_SearchPost objectAtIndex:indexPath.row];
    // NSDictionary *dic_request=[Array_ViewPost objectAtIndex:indexPath.row];
    NSLog(@"dic= %@",dic_request);
    
    NSString *xyz = [dic_request valueForKey:@"mediatype"];
    
    if([NSNull null] ==[[Array_SearchPost  objectAtIndex:0]valueForKey:@"mediatype"] || [[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
    {
        
        Videocell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
        
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        if([NSNull null] ==[dic_request valueForKey:@"mediathumbnailurl"])
        {
            
            Videocell.videoImageView.image =[UIImage imageNamed:@"defaultpostimg.jpg"];
            Videocell.playImageView.image = [UIImage imageNamed:@""];
        }
        else
        {
            [Videocell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]
                                                 options:SDWebImageRefreshCached];
            Videocell.playImageView.image = [UIImage imageNamed:@"Play"];
            //[cell.videoImageView sd_setImageWithURL:url];
            
        }
        
        Videocell.videoImageView.layer.cornerRadius = 10;
        Videocell.videoImageView.layer.masksToBounds = YES;
        
        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
        Videocell.bidAmountLabel.text = show;//[dic_request valueForKey:@"showamount"];
        Videocell.titleLabel.text =  [dic_request valueForKey:@"title"];
        Videocell.locationLabel.text = [dic_request valueForKey:@"city1"];
        Videocell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        
        Videocell.Button_ItemSold.tag = indexPath.item;
        NSLog(@"button tag :%ld",(long)Videocell.Button_ItemSold.tag);
        Videocell.Button_ItemSold.userInteractionEnabled=YES;
        UITapGestureRecognizer *imageTap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSoldButtonPressed:)];
        
        [Videocell.Button_ItemSold addGestureRecognizer:imageTap4];
        
        
        
        return Videocell;
    }
    else
    {
        
        Imagecell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        //        [cell.videoImageView sd_setImageWithURL:url];
        Imagecell.videoImageView.layer.cornerRadius = 10;
        Imagecell.videoImageView.layer.masksToBounds = YES;
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        [Imagecell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]
                                             options:SDWebImageRefreshCached];
        
        Imagecell.locationLabel.text = [dic_request valueForKey:@"city1"];
        Imagecell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
        Imagecell.bidAmountLabel.text = show;
        Imagecell.titleLabel.text = [dic_request valueForKey:@"title"];
        
        
        Imagecell.Button_ItemSold.tag = indexPath.item;
        NSLog(@"button tag :%ld",(long)Imagecell.Button_ItemSold.tag);
        Imagecell.Button_ItemSold.userInteractionEnabled=YES;
        UITapGestureRecognizer *imageTap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSoldButtonPressed:)];
        
        [Imagecell.Button_ItemSold addGestureRecognizer:imageTap4];
        
        return Imagecell;
    }
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AllViewSwapeViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewSwapeViewController"];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    
        set1.Array_Alldata = Array_SearchPost;
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
    
    NSDictionary *dic_request=[Array_SearchPost objectAtIndex:indexPath.row];
    CGFloat height;
    
    
    if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"] )
        
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
    return 0;//(indexPath.section + 1) * 26.0f;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//{
//    return <#expression#>
//}




-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview.backgroundColor = [UIColor whiteColor];
        
        if (reusableview==nil) {
            
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 375, 50)];
        }
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, reusableview.frame.size.width - 10 , reusableview.frame.size.height)];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:24];
        label.text= rowTapCategory;
       // [reusableview addSubview:label];
        return reusableview;
    }
    return nil;
}



#pragma mark - Search Post Connection

-(void)SearchPostConnection
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
        NSString *  urlStr=[urlplist valueForKey:@"search"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *location= @"location";
        NSString *locationVal = @"OFF";
        
        NSString *category,*categoryVal;
        if ([[_initialTitles valueForKey:@"typesection"]isEqualToString:@"section1"] )
        {
          category= @"category";
           categoryVal =[_initialTitles valueForKey:@"name"];
        }
        else if ([[_initialTitles valueForKey:@"typesection"]isEqualToString:@"section2"] )
        {
            category= @"search";
            categoryVal =[_initialTitles valueForKey:@"name"];
        }
        else
        {
            category= @"search";
            categoryVal =searchTextEnter;
        }
       
        
        
        
        NSString *city= @"city";
        NSString *cityVal = [defaults valueForKey:@"Cityname"];
        
        NSString *country= @"country";
        NSString *countryVal = [defaults valueForKey:@"Countryname"];;
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,location,locationVal,city,cityVal,country,countryVal,category,categoryVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_SearchPost = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_SearchPost)
            {
                webData_SearchPost =[[NSMutableData alloc]init];
                
                
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
    
    if(connection==Connection_SearchPost)
    {
        [webData_SearchPost setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_SearchPost)
    {
        [webData_SearchPost appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_SearchPost)
    {
        
        Array_SearchPost=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_SearchPost=[objSBJsonParser objectWithData:webData_SearchPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_SearchPost encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_SearchPost);
        NSLog(@"count= %lu",(unsigned long)Array_SearchPost.count);
        NSLog(@"registration_status %@",[[Array_SearchPost objectAtIndex:0]valueForKey:@"registration_status"]);
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
        
        if ([ResultString isEqualToString:@"noposts"])
        {
            _label_JsonResult.hidden=NO;
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
            
            
        }
        
        if (Array_SearchPost.count != 0)
        {
            _label_JsonResult.hidden=YES;
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }
        
     
        
    }
    [self.collectionView reloadData];
}



- (IBAction)SearchEditing_Action:(id)sender
{
    
    if (searchTextField.text.length == 0)
        
    {
        Button_Cancel.hidden = YES;
        Button_Back.hidden = NO;
       
        
    }
    
    else
    {
        Button_Cancel.hidden = NO;
        Button_Back.hidden = YES;
        
        
        
    }
    
    
    
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == searchTextField)
    {
        [searchTextField resignFirstResponder];
    }
    
    Button_Cancel.hidden = YES;
    Button_Back.hidden = NO;
    
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SearchCollectionViewController * searchCollection=[mainStoryboard instantiateViewControllerWithIdentifier:@"SearchCollectionViewController"];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    
//    searchCollection.searchTextEnter = self.searchTextField.text;
//    
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    [self.navigationController pushViewController:searchCollection animated:YES];
    
   cvLayout.topInset = 1.0f;
    imagev.hidden=YES;
    searchTextEnter=textField.text;
    NSLog(@"Search Action");
    [_initialTitles removeAllObjects];
      [activityindicator startAnimating];
    [self SearchPostConnection];
    return YES;
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

- (IBAction)CancelButton_Action:(id)sender
{
    [self.view endEditing:YES];
    searchTextField.text = nil;
    Button_Cancel.hidden = YES;
    Button_Back.hidden = NO;
    
    
}


@end
