//
//  BoostPostViewController.m
//  Haraj_app
//
//  Created by Spiel on 22/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "BoostPostViewController.h"
#import "FavTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BoostPost.h"
#import "SBJsonParser.h"


@interface BoostPostViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    FavTableViewCell *FavouriteCell;
    NSUserDefaults * defaults;
    NSDictionary *urlplist;
    
    NSMutableArray *Array_Boostphp;
    NSString *boostpackVal,*boostAmountVal, *postIdVal;
    BoostPost *myBoostXIBViewObj;
}


@end

@implementation BoostPostViewController
@synthesize Array_Boost;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    defaults = [[NSUserDefaults alloc]init];
    
    
   
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return Array_Boost.count;
    
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
    
        NSDictionary *dic_request=[Array_Boost objectAtIndex:indexPath.row];
    
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    myBoostXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"BoostPost" owner:self options:nil]objectAtIndex:0];
    
    myBoostXIBViewObj.frame = CGRectMake((self.view.frame.size.width- myBoostXIBViewObj.frame.size.width)/2,self.view.frame.size.width - 250, myBoostXIBViewObj.frame.size.width, myBoostXIBViewObj.frame.size.height);
    
    
    [self.view addSubview:myBoostXIBViewObj];
    
    
    
    myBoostXIBViewObj.postIdLabel.text =[NSString stringWithFormat:@"POST ID: %@",[[Array_Boost  valueForKey:@"postid"]objectAtIndex:indexPath.row]];
    postIdVal = [[Array_Boost  valueForKey:@"postid"]objectAtIndex:indexPath.row];
    
    myBoostXIBViewObj.layer.cornerRadius = 10;
    myBoostXIBViewObj.clipsToBounds = YES;
    
    [myBoostXIBViewObj.imageViewButton1 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *viewTapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton1_Action:)];
    [myBoostXIBViewObj.imageViewButton1 addGestureRecognizer:viewTapped1];
    
    [myBoostXIBViewObj.imageViewButton2 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *viewTapped2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton2_Action:)];
    [myBoostXIBViewObj.imageViewButton2 addGestureRecognizer:viewTapped2];
    
    [myBoostXIBViewObj.imageViewButton3 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *viewTapped3 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton3_Action:)];
    [myBoostXIBViewObj.imageViewButton3 addGestureRecognizer:viewTapped3];
    
    
    [myBoostXIBViewObj.closeButton addTarget:self action:@selector(boostCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [transparentView1 addSubview:myBoostXIBViewObj];
    [self.view addSubview:transparentView1];
    
    
}

-(void)boostCloseAction:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    transparentView1.hidden = YES;
    
}

-(void)imageViewButton1_Action:(UIGestureRecognizer *)reconizer
{
    NSLog(@"imageViewButton1_Action");
    
    boostpackVal = @"24H";
    boostAmountVal = @"4";
    [self boostConnection];
    
}
-(void)imageViewButton2_Action:(UIGestureRecognizer *)reconizer
{
    boostpackVal = @"48H";
    boostAmountVal = @"6";
    NSLog(@"imageViewButton2_Action");
    [self boostConnection];
    
}


-(void)imageViewButton3_Action:(UIGestureRecognizer *)reconizer
{
    NSLog(@"imageViewButton3_Action");
    boostpackVal = @"72H";
    boostAmountVal = @"10";
    [self boostConnection];
    
}

-(void)boostConnection
{
    NSString *postid= @"postid";
         //[Array_UserInfo  valueForKey:@"postid"];
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    NSString *boostpack= @"boostpack";
    
    
    NSString *boostamount= @"boostamount";
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",postid,postIdVal,userid,useridVal,boostpack,boostpackVal,boostamount,boostAmountVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"boostpost"];;
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
                                                 
                                                 Array_Boost=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_Boost =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_Boost %@",Array_Boost);
                                                 
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Boosted" message:@"Thank-you for your payment, your post has been successfully boosted!" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"alreadyboosted"])
                                                 {
                                                     
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your post is already boosted. Please wait for it to get over to boost again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"We encountered an error in boosting your post. Please try again or contact support." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"nopostid"])
                                                 {
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This item is no more available and cannot be boosted." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
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



                                         
                                         

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
}


- (IBAction)SearchButton_Action:(id)sender {
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
