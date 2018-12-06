//
//  MyPostViewController.m
//  Haraj_app
//
//  Created by Spiel on 12/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "MyPostViewController.h"
#import "FirstImageViewCell.h"
#import "UIImageView+WebCache.h"
#import "TwoImageOnClickTableViewCell.h"
#import "SBJsonParser.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "BoostPost.h"
#import "UIView+RNActivityView.h"
#import "Reachability.h"
#import "UIView+WebCache.h" 
#import "AFNetworking.h"
#import <MediaPlayer/MediaPlayer.h>
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH self.view.frame.size.width-138
#define CELL_CONTENT_MARGIN 0.0f

@interface MyPostViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, UITextFieldDelegate,UITextViewDelegate,MPMediaPickerControllerDelegate,MPMediaPlayback>

{
    MPMoviePlayerViewController *movieController ;
    NSDictionary *urlplist;
    UIView *sectionView;
    UIScrollView *scrollView;
    UIImageView *imageView, *imageView1;
    UIPageControl *pageControll;
    FirstImageViewCell *FirstCell;
    NSURL * imageUrl;
    NSUserDefaults *defaults;
    NSInteger total_image;
    UIButton* playButton, *seeCommentButton, *submitPostButton;
    
    CGFloat Xpostion, Ypostion, Xwidth, Yheight, ScrollContentSize,Xpostion_label, Ypostion_label, Xwidth_label, Yheight_label,Cell_DescLabelX,Cell_DescLabelY,Cell_DescLabelW,Cell_DescLabelH,TextView_ViewX,TextView_ViewY,TextView_ViewW,TextView_ViewH;
    CGFloat button_threeDotsx,button_threeDotsy,button_threeDotsw,button_threeDotsh,button_favx,button_favy,button_favw,button_favh,button_arrowx,button_arrowy,button_arroww,button_arrowh,button_threeDotsBigx,button_threeDotsBigy,button_threeDotsBigw,button_threeDotsBigh;
    CGFloat FavIV_X,FavIV_Y,FavIV_W,FavIV_H,FavLabel_X,FavLabel_Y,FavLabel_W,FavLabel_H;
    
    NSMutableArray *Array_Moreimages, *Array_Chats, *Array_Comments, *Array_ItemSold, *Array_Favourite,*Array_Boost;
    NSString *str_LabelCoordinates,*str_TappedLabel, *str_fav;
    NSString *text, *nochats, *paymentmodeStr,*boostpackVal,*boostAmountVal;
    UITextView *commentPostTextView1;
    UILabel *postplaceholderLabel;
    BOOL fav;
    
    UIButton *floatButton;

    
    EnterPrice *myCustomXIBViewObj;
    BoostPost *myBoostXIBViewObj;
    
    CGRect rect;
    NSString *eventidvalue;
    NSString *seeCommentStr;
    
    
    CGFloat locImage_x,locImage_y,locImage_w,locImage_h,locLabel_x,locLabel_y,locLabel_,locLabel_h,userLabel_x,userLabel_y,userLabel_w,userLabel_h,proImage_x,proImage_y,proImage_w,proImage_h,postidLabel_x,postidLabel_y,postidLabel_w,postidLabel_h,durLabel_x,durLabel_y,durLabel_w,durLabel_h,carMakeBGView_x,carMakeBGView_y,carMakeBGView_w,carMakeBGView_h,carmakeImg_x,carmakeImg_y,carmakeImg_w,carmakeImg_h,carmakeLabel_x,carmakeLabel_y,carmakeLabel_w,carmakeLabel_h,titleLabel_x,titleLabel_y,titleLabel_w,titleLabel_h,hashLabel_x,hashLabel_y,hashLabel_w,hashLabel_h,KmBgView_x,KmBgView_y,KmBgView_w,KmBgView_h;
    
    

    
}
@property (strong,nonatomic)TwoImageOnClickTableViewCell * Cell_two;


@end

@implementation MyPostViewController
@synthesize Array_UserInfo,swipeCount,MoreImageArray,Cell_two,detailCell,detailCellCar,detailCellProperty,ComCell,Array_All_UserInfo,cell_postcomments,cell_seeallcomments,pageIndex,videoURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    rect = [[UIApplication sharedApplication] statusBarFrame];
    
    defaults = [[NSUserDefaults alloc]init];
    
    seeCommentStr = @"no";
    
    
    floatButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70,self.view.frame.size.height - 70 - rect.size.height, 60,60)];
    floatButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16];
    [floatButton setImage:[UIImage imageNamed:@"BoostButton"] forState:UIControlStateNormal];
    [floatButton addTarget:self action:@selector(floatButtonAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:floatButton];
    
       
    
  
    
    
    
    
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
        total_image=[[Array_UserInfo  valueForKey:@"mediacount"] integerValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide_Popover) name:@"HidePopOver" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide_BoostPopover) name:@"HideBoostPopOver" object:nil];
    
    
    
   // str_TappedLabel=@"no";
    str_LabelCoordinates=@"no";
    text = [Array_UserInfo valueForKey:@"description"];
    nochats = @"";
    
//    myCustomXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"EnterPrice" owner:self options:nil]objectAtIndex:0];
//    myCustomXIBViewObj.priceTextField.delegate = self;
    
 //   [self performSelector:@selector(delay) withObject:nil afterDelay:3.0];
    // self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    if ([[defaults valueForKey:@"Activitynext"]isEqualToString:@"yes"])
    {
      self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        
        [self.tableView setFrame:CGRectMake(0, 20, self.tableView.frame.size.width, self.tableView.frame.size.height)];
        [defaults setObject:@"no" forKey:@"Activitynext"];
    }
    
    else
        
    {

       self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    
    
    
    
    //---------auto layout-----------------
    
//    CGFloat mainScreenHeight = [[UIScreen mainScreen] bounds].size.height;
//    
//    
//    
//    // here baseScreenHeight is default screen height size for which we are implementing.
//    
//    CGFloat baseScreenHeight = 667; // here default iPhone 6 height
//    
//    
//    
//    // Note: try by changing baseScreenHeight via any iPhone screen height(480, 568, 667, 736) and see the changes in button height & space
//    
//    
//    
//    // here fixed space and height are fixed size with respect to iPhone 6 height.
//    
////    CGFloat fixedSpaceY = 28;
////    
////    CGFloat fixedSpaceX = 16;
//    
//    CGFloat fixedHeight = 363;
//    
//    CGFloat fixedWidth = [[UIScreen mainScreen] bounds].size.width;
//    
//    KmBgView_x = 0;
//    KmBgView_y = 0;
//    KmBgView_w =[[UIScreen mainScreen] bounds].size.width;
//    KmBgView_h = 363;
//    
//    
//    
//    // ratio is responsible to increase or decrease button height depends on iPhone device size.
//    
//    CGFloat ratio = mainScreenHeight/baseScreenHeight;
//    
////    CGFloat baseSpaceY = fixedSpaceY * ratio;
////    
////    CGFloat baseSpaceX = fixedSpaceX * ratio;
//    
//     KmBgView_h = fixedHeight * ratio;
//    
//   // CGFloat baseWidth = fixedWidth * ratio;
//    
    
    
    
    


    
}



-(void)viewWillAppear:(BOOL)animated
{
    
//    NSLog(@" array info %ld",(long)self.view.tag);
  //  NSLog(@" Array_All_UserInfo viewwillappear %@",Array_All_UserInfo);
//    str_postid= [[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"postid"];
//    str_userid =[[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"userid1"];
 //   NSLog(@" str_postid viewwillappear %@", [[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"postid"]);
  //  NSLog(@" str_userid viewwillappear %@",[[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"userid1"]);
    
    
    
    
    [self ChatCommentConnection];
     
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //calculate current page in scrollview
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
     pageControll.currentPage = page;
    NSLog (@"page %d",page);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;//1
    }
    else if (section == 2)
    {
        return 1;
    }
    else if (section == 3)
    {
       // if ([[defaults valueForKey:@"SeeCommentPressed"]isEqualToString:@"no"])
        if ([seeCommentStr isEqualToString:@"no"])
        {
            
            if (Array_Chats.count == 0)
            {
                return 1;
                
            }
            else
            {
                if (Array_Chats.count <= 1)
                {
                    return 1;
                }
                else if(Array_Chats.count == 2)
                {
                    return 2 ;
                }
                else
                {
                    return 3;
                }
                
            }
            
            
        }
        else
        
            
            return Array_Chats.count;
            
        }
        
        
        
    
    else if(section == 4)

    {
        if (Array_Chats.count < 4)
        {
            return 0;
            
        }
        else
        {
            return 1;
        }
        
    }
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;//5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    static NSString *cell_details=@"DetailCell";
    static NSString *cell_detailscar=@"DetailCellCar";
    static NSString *cell_detailsproperty=@"DetailCellProperty";
    
    static NSString *post_comments=@"PostCell1";
    static NSString *cell_comments=@"ComCell";
    static NSString *seeall_comments = @"PostCell2";

    static NSString *cell_two1=@"Cell_Two";
    switch (indexPath.section)
    {
        case 0:
        {
            
            if (total_image >=2)
            {
                
                Cell_two = [[[NSBundle mainBundle]loadNibNamed:@"TwoImageOnClickTableViewCell" owner:self options:nil] objectAtIndex:0];
                
                
                
                
                if (Cell_two == nil)
                {
                    
                    Cell_two = [[TwoImageOnClickTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_two1];
                    
                    
                }
                
                
                [Cell_two.button_threedots addTarget:self action:@selector(button_threedots_action:) forControlEvents:UIControlEventTouchUpInside];
                [Cell_two.button_threedotsBig addTarget:self action:@selector(button_threedots_action:) forControlEvents:UIControlEventTouchUpInside];
                [Cell_two.button_favourite addTarget:self action:@selector(button_favourite_action:) forControlEvents:UIControlEventTouchUpInside];
                [Cell_two.button_back addTarget:self action:@selector(button_back_action:) forControlEvents:UIControlEventTouchUpInside];
                UITapGestureRecognizer * moreTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreImage:)];
                if (total_image>=3)
                {
                    Cell_two.bgView.hidden=NO;
                    Cell_two.countLabel.text =[NSString stringWithFormat:@"%ld",total_image-2];
                }
                else
                {
                    Cell_two.bgView.hidden=YES;
                   
                }
                [Cell_two.bgView addGestureRecognizer:moreTap];
                
                button_threeDotsx=Cell_two.button_threedots.frame.origin.x;
                button_threeDotsy=Cell_two.button_threedots.frame.origin.y;
                button_threeDotsw=Cell_two.button_threedots.frame.size.width;
                button_threeDotsh=Cell_two.button_threedots.frame.size.height;
                button_threeDotsBigx=Cell_two.button_threedotsBig.frame.origin.x;
                button_threeDotsBigy=Cell_two.button_threedotsBig.frame.origin.y;
                button_threeDotsBigw=Cell_two.button_threedotsBig.frame.size.width;
                button_threeDotsBigh=Cell_two.button_threedotsBig.frame.size.height;
                button_favx=Cell_two.button_favourite.frame.origin.x;
                button_favy=Cell_two.button_favourite.frame.origin.y;
                button_favw=Cell_two.button_favourite.frame.size.width;
                button_favh=Cell_two.button_favourite.frame.size.height;
                button_arrowx=Cell_two.button_back.frame.origin.x;
                button_arrowy=Cell_two.button_back.frame.origin.y;
                button_arroww=Cell_two.button_back.frame.size.width;
                button_arrowh=Cell_two.button_back.frame.size.height;
                
                
                if ([[Array_UserInfo valueForKey:@"mediatype"] isEqualToString:@"IMAGE"])
                {
                    Cell_two.image_play1.hidden = YES;
                    
                }
                else
                {
                    
                    Cell_two.image_play1.hidden = NO;
                    
                }
                
                if ([[Array_UserInfo valueForKey:@"mediatype1"] isEqualToString:@"IMAGE"])
                {
                    
                    Cell_two.image_play2.hidden = YES;
                }
                else
                {
                    Cell_two.image_play2.hidden = NO;
                }
                NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"mediathumbnailurl"]];
                NSURL *url1=[NSURL URLWithString:[Array_UserInfo valueForKey:@"mediathumbnailurl1"]];
                
                Cell_two.activityIndicator1.hidden = NO;
                [Cell_two.activityIndicator1 startAnimating];
                
                Cell_two.activityIndicator2.hidden = NO;
                [Cell_two.activityIndicator2 startAnimating];
                
               // [Cell_two.image1 setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                
              //  [Cell_two.image2 setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [Cell_two.image1 setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     Cell_two.image1.image = image;
                     Cell_two.activityIndicator1.hidden = YES;
                     [Cell_two.activityIndicator1 stopAnimating];
                 }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                 {
                     Cell_two.activityIndicator1.hidden = YES;
                     [Cell_two.activityIndicator1 stopAnimating];
                 }
                 ];
                
                NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
                [Cell_two.image2 setImageWithURLRequest:request1 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     Cell_two.image2.image = image;
                     Cell_two.activityIndicator2.hidden = YES;
                     [Cell_two.activityIndicator2 stopAnimating];
                 }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                 {
                     Cell_two.activityIndicator2.hidden = YES;
                     [Cell_two.activityIndicator2 stopAnimating];
                 }
                 ];

                

                
                
                Cell_two.image1.userInteractionEnabled=YES;
                Cell_two.image1.tag=swipeCount;
                UITapGestureRecognizer *imageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreImage:)];
                [Cell_two.image1 addGestureRecognizer:imageTap1];
                
                Cell_two.image2.userInteractionEnabled=YES;
                Cell_two.image2.tag=swipeCount;
                UITapGestureRecognizer *imageTap2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreImage:)];
                [Cell_two.image2 addGestureRecognizer:imageTap2];
                
                Cell_two.image_play1.userInteractionEnabled=YES;
                Cell_two.image_play1.tag=swipeCount;
                UITapGestureRecognizer *imageTap3 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreImage:)];
                [Cell_two.image_play1 addGestureRecognizer:imageTap3];
                
                Cell_two.image_play2.userInteractionEnabled=YES;
                Cell_two.image_play2.tag=swipeCount;
                UITapGestureRecognizer *imageTap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreImage:)];
                [Cell_two.image_play2 addGestureRecognizer:imageTap4];
                
                
                
                return Cell_two;
                
                
            }
            else
            {
                FirstCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
               
//                if ([UIScreen mainScreen].bounds.size.width==375 && [UIScreen mainScreen].bounds.size.height==812)
//                {
//                    
//                    
//                    
//                    [FirstCell.button_threedots setFrame:CGRectMake(FirstCell.button_threedots.frame.origin.x, FirstCell.button_threedots.frame.origin.y+8, FirstCell.button_threedots.frame.size.width, 30)];
//                    
//                    [FirstCell.button_threedotsBig setFrame:CGRectMake(FirstCell.button_threedotsBig.frame.origin.x, FirstCell.button_threedotsBig.frame.origin.y+9, FirstCell.button_threedotsBig.frame.size.width, 30)];
//                    
//                    [FirstCell.button_back setFrame:CGRectMake(FirstCell.button_back.frame.origin.x, FirstCell.button_back.frame.origin.y+9, FirstCell.button_back.frame.size.width, 43)];
//                    
//                }
                
                [FirstCell.button_threedots addTarget:self action:@selector(button_threedots_action:) forControlEvents:UIControlEventTouchUpInside];
                 [FirstCell.button_threedotsBig addTarget:self action:@selector(button_threedots_action:) forControlEvents:UIControlEventTouchUpInside];
                [FirstCell.button_favourite addTarget:self action:@selector(button_favourite_action:) forControlEvents:UIControlEventTouchUpInside];
                [FirstCell.button_back addTarget:self action:@selector(button_back_action:) forControlEvents:UIControlEventTouchUpInside];
                button_threeDotsx=FirstCell.button_threedots.frame.origin.x;
                button_threeDotsy=FirstCell.button_threedots.frame.origin.y;
                button_threeDotsw=FirstCell.button_threedots.frame.size.width;
                button_threeDotsh=FirstCell.button_threedots.frame.size.height;
                button_threeDotsBigx=FirstCell.button_threedotsBig.frame.origin.x;
                button_threeDotsBigy=FirstCell.button_threedotsBig.frame.origin.y;
                button_threeDotsBigw=FirstCell.button_threedotsBig.frame.size.width;
                button_threeDotsBigh=FirstCell.button_threedotsBig.frame.size.height;
                button_favx=FirstCell.button_favourite.frame.origin.x;
                button_favy=FirstCell.button_favourite.frame.origin.y;
                button_favw=FirstCell.button_favourite.frame.size.width;
                button_favh=FirstCell.button_favourite.frame.size.height;
                button_arrowx=FirstCell.button_back.frame.origin.x;
                button_arrowy=FirstCell.button_back.frame.origin.y;
                button_arroww=FirstCell.button_back.frame.size.width;
                button_arrowh=FirstCell.button_back.frame.size.height;
                
                if ([[Array_UserInfo valueForKey:@"mediatype"] isEqualToString:@"IMAGE"])
                {
                    FirstCell.image_play.hidden = YES;
                }
                else
                {
                    
                    
                    
                    FirstCell.image_play.hidden = NO;
                }
                
                NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"mediathumbnailurl"]];
                videoURL = [NSURL URLWithString:[Array_UserInfo valueForKey:@"mediaurl"]];

              //  [FirstCell.imageView_thumbnails setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                [FirstCell.imageView_thumbnails setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
                 {
                     FirstCell.imageView_thumbnails.image = image;
                     FirstCell.activityIndicator.hidden = YES;
                     [FirstCell.activityIndicator stopAnimating];
                 }
                                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
                 {
                     FirstCell.activityIndicator.hidden = YES;
                     [FirstCell.activityIndicator stopAnimating];
                 }
                 ];
                
                FirstCell.imageView_thumbnails.userInteractionEnabled=YES;
                FirstCell.imageView_thumbnails.tag=swipeCount;
                
                if ([[Array_UserInfo valueForKey:@"mediathumbnailurl"] isEqualToString:@""])
                {
                    
                }
                else
                {
                
                UITapGestureRecognizer *imageTap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreImage:)];
                
                [FirstCell.imageView_thumbnails addGestureRecognizer:imageTap4];
                    
                    if ([[Array_UserInfo valueForKey:@"mediatype"] isEqualToString:@"IMAGE"])
                    {
                        [self displayImage:FirstCell.imageView_thumbnails withImage:FirstCell.imageView_thumbnails.image];
                        
                    }
                    else
                    {
                        
                    }
                
               // [self displayImage:FirstCell.imageView_thumbnails withImage:FirstCell.imageView_thumbnails.image];
                }
                
                return FirstCell;
            }
            
            
        }
            break;
        case 1:
            
            if ([[Array_UserInfo valueForKey:@"category"] isEqualToString:@"car"])
                
            {
                {
                    
                    
                    detailCellCar = [[[NSBundle mainBundle]loadNibNamed:@"DetailCarTableViewCell" owner:self options:nil] objectAtIndex:0];
                    
                    if (detailCellCar == nil)
                    {
                        
                        detailCellCar = [[DetailCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_detailscar];
                        
                        
                    }
                    
                    
                    if ([[UIScreen mainScreen]bounds].size.width == 320)
                    {
                        [detailCellCar.tapView setFrame:CGRectMake(31, 301, 278, 38)];
                        [detailCellCar.detailinfoTextView setFrame:CGRectMake(0, 0, 278, 38)];
                        [detailCellCar.detailinfoTextView1 setFrame:CGRectMake(0, 0, 278, 38)];
                        [detailCellCar.view_CordinateViewTapped setFrame:CGRectMake(0, 341, 320, 135)];
                        
                        [detailCellCar.askingPriceImageview setFrame:CGRectMake(69, 12, 45, 45)];
                        [detailCellCar.askingPriceHeadingLabel setFrame:CGRectMake(46, 57, 96, 37)];
                        [detailCellCar.askingPriceLabel setFrame:CGRectMake(21, 94, 140, 30)];
                        
                        [detailCellCar.highestOfferImageview setFrame:CGRectMake(207, 12, 45, 45)];
                        [detailCellCar.highestOfferHeadingLabel setFrame:CGRectMake(184, 57, 96, 37)];
                        [detailCellCar.priceLabel setFrame:CGRectMake(160, 94, 140, 30)];
                   
                        
                    }
                    
                    else if ([[UIScreen mainScreen]bounds].size.width == 414)
                    {
                        [detailCellCar.tapView setFrame:CGRectMake(40, 301, 361, 38)];
                        [detailCellCar.detailinfoTextView setFrame:CGRectMake(0, 0, 361, 38)];
                        [detailCellCar.detailinfoTextView1 setFrame:CGRectMake(0, 0, 361, 38)];
                        [detailCellCar.view_CordinateViewTapped setFrame:CGRectMake(0, 341, 414, 135)];
                        
                        [detailCellCar.askingPriceImageview setFrame:CGRectMake(104, 12, 45, 45)];
                        [detailCellCar.askingPriceHeadingLabel setFrame:CGRectMake(74, 57, 96, 37)];
                        [detailCellCar.askingPriceLabel setFrame:CGRectMake(44, 94, 140, 30)];
                        
                        [detailCellCar.highestOfferImageview setFrame:CGRectMake(266, 12, 45, 45)];
                        [detailCellCar.highestOfferHeadingLabel setFrame:CGRectMake(236, 57, 96, 37)];
                        [detailCellCar.priceLabel setFrame:CGRectMake(206, 94, 140, 30)];
                    }

                    
                    
                    else
                    {
                        
                    }

                    
                    
                    [detailCellCar.detailinfoTextView setText:text];
                    detailCellCar.locationLabel.text = [Array_UserInfo valueForKey:@"city1"];
                    detailCellCar.hashtagLabel.text = [Array_UserInfo valueForKey:@"hashtags"];
                    
                    detailCellCar.postidLabel.text = [NSString stringWithFormat:@"%@%@",[Array_UserInfo valueForKey:@"postid"],@" :رقم الإعلان"];//POST ID
                    [defaults setObject:[Array_UserInfo valueForKey:@"postid"] forKey:@"post-id"];
                    
                    
                    detailCellCar.usernameLabel.text = [Array_UserInfo valueForKey:@"usersname"];
                    detailCellCar.durationLabel.text = [Array_UserInfo valueForKey:@"postdur"];
                    
                    NSString *show = [NSString stringWithFormat:@"ر.س%@",[Array_UserInfo valueForKey:@"showamount"]];//$
                    detailCellCar.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
                    detailCellCar.askingPriceLabel.text = [NSString stringWithFormat:@"ر.س%@",[Array_UserInfo valueForKey:@"askingprice"]];//$

                    detailCellCar.timeLabel.text = [Array_UserInfo valueForKey:@"createtime"];
                    detailCellCar.titleLabel.text = [Array_UserInfo valueForKey:@"title"];
                    
                    detailCellCar.modelLabel.text = [Array_UserInfo valueForKey:@"carmodel"];
                    detailCellCar.mileageLabel.text = [NSString stringWithFormat:@"%@ KM",[Array_UserInfo valueForKey:@"carmileage"]];
                    
                    detailCellCar.carMakeLabel.text =[Array_UserInfo valueForKey:@"carmake"];
                    detailCellCar.carMakeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[Array_UserInfo valueForKey:@"carmake"]]];
                    
                    
                    NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"usersprofilepic"]];
                    
                    [detailCellCar.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
                    detailCellCar.profileImage.layer.cornerRadius = detailCellCar.profileImage.frame.size.height / 2;
                    detailCellCar.profileImage.clipsToBounds = YES;
                    
                    
                    detailCellCar.favouriteImage.userInteractionEnabled = YES;
                    detailCellCar.favouriteImage.tag=swipeCount;
                    UITapGestureRecognizer *favouriteImage_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favouriteImage_ActionDetails:)];
                    [detailCellCar.favouriteImage addGestureRecognizer:favouriteImage_Tapped];

                    
                    
                    if ([[Array_UserInfo valueForKey:@"favourite"]isEqualToString:@"TRUE"])
                    {
                        [detailCellCar.favouriteImage setImage:[UIImage imageNamed:@"FavouriteFill"]];
                    }
                    else
                    {
                        [detailCellCar.favouriteImage setImage:[UIImage imageNamed:@"Favourite"]];
                        
                    }
                    
#pragma mark - fdgfhjdgj;
                    
                    if (fav)
                    {
                        
                        
                        if ([str_fav isEqualToString:@"inserted"])
                        {
                            [detailCellCar .favouriteImage setImage:[UIImage imageNamed:@"FavouriteFill"]];
                        }
                        else
                        {
                            [detailCellCar .favouriteImage setImage:[UIImage imageNamed:@"Favourite"]];
                            
                        }
                        
                        fav = false;
                        
                    }

                    
                    //------------------------------------------$$$$$$$$$$$$$$$$$$$______________________________
                    
                    detailCellCar.tapView.userInteractionEnabled=YES;
                    detailCellCar.tapView.tag=swipeCount;
                    detailCellCar.detailinfoTextView.tag=swipeCount;
//                    UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
//                    [detailCellCar.tapView addGestureRecognizer:label_Desc_Tapped];
                    if ([str_LabelCoordinates isEqualToString:@"no"])
                    {
                        str_LabelCoordinates=@"yes";
                        
                        Cell_DescLabelX=detailCellCar.detailinfoTextView.frame.origin.x;
                        Cell_DescLabelY=detailCellCar.detailinfoTextView.frame.origin.y;
                        Cell_DescLabelW=detailCellCar.detailinfoTextView.frame.size.width;
                        Cell_DescLabelH=detailCellCar.detailinfoTextView.frame.size.height;
                        
                        TextView_ViewX=detailCellCar.tapView.frame.origin.x;
                        TextView_ViewY=detailCellCar.tapView.frame.origin.y;
                        TextView_ViewW=detailCellCar.tapView.frame.size.width;
                        TextView_ViewH=detailCellCar.tapView.frame.size.height;
                        
                        FavIV_Y=(detailCell.view_CordinateViewTapped.frame.origin.y-(detailCell.tapView.frame.origin.y+detailCell.tapView.frame.size.height));
                        
                        NSLog(@"Dynamic label heightc====%f",Cell_DescLabelX);
                        NSLog(@"Dynamic label heightc====%f",Cell_DescLabelY);
                        NSLog(@"Dynamic label heightc====%f",Cell_DescLabelW);
                        NSLog(@"Dynamic label heightc====%f",Cell_DescLabelH);
                        NSLog(@"FavIV_Y====%f",FavIV_Y);
                        
                      //  [detailCellCar.backgroundKMView setFrame:CGRectMake(0, 0, KmBgView_w, KmBgView_h)];
                        
                        
                    }
                    
                    
                    //[[AllArrayData objectAtIndex:0]valueForKey:@"title"];;
                    
                    
                    CGSize constraint = CGSizeMake(340 - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                    
                    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                    
                    CGFloat height = MAX(size.height, 30.0f);
                    NSLog(@"Dynamic label height====%f",height);
                    
                    
                    float rows = (detailCellCar.detailinfoTextView.contentSize.height - detailCellCar.detailinfoTextView.textContainerInset.top - detailCellCar.detailinfoTextView.textContainerInset.bottom) / detailCellCar.detailinfoTextView.font.lineHeight;
                    NSLog(@"Dynamic label rowsline====%f",rows);
                    //  cell_TwoDetails.label_Desc.numberOfLines=0;
                    
                    [detailCellCar.detailinfoTextView setText:text];
                    // detailCell.detailinfoTextView.tag=indexPath.row;
                    
                    CGFloat fixedWidth = detailCellCar.detailinfoTextView.frame.size.width;
                    CGSize newSize = [detailCellCar.detailinfoTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
                    NSInteger rHeight = size.height/17;
                    NSLog(@"No of lines: %ld",(long)rHeight);
                    detailCellCar.detailinfoTextView1.hidden=YES;
//                    if ([str_TappedLabel isEqualToString:@"no"])
//                    {
//                        if ((long)rHeight==1)
//                        {
//                            
//                            [detailCellCar.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH)];
//                            
//                            [detailCellCar.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH)];
//                            
//                            
//                        }
//                        else if ((long)rHeight==2)
//                        {
//                            
//                            [detailCellCar.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*1.6)];
//                            
//                            [detailCellCar.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*1.6)];
//                            
//                            
//                        }
//                        else if ((long)rHeight>=3)
//                        {
//                            detailCellCar.tapView.userInteractionEnabled=YES;
//                            detailCellCar.detailinfoTextView.textContainer.maximumNumberOfLines = 0;
//                            detailCellCar.detailinfoTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
//                            UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
//                            [detailCellCar.tapView addGestureRecognizer:label_Desc_Tapped];
//                            
//                            [detailCellCar.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*1.6)];
//                            
//                            [detailCellCar.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*1.6)];
//                            
//                            
//                        }
//                        
//                    }
//                    
//                    
//                    
//                    
//                    else
//                    {
                    
                        
                        CGRect newFrame = detailCellCar.detailinfoTextView.frame;
                        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
                        
                        detailCellCar.tapView.userInteractionEnabled=YES;
                        
//                        UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
//                        [detailCellCar.tapView addGestureRecognizer:label_Desc_Tapped];
                        [detailCellCar.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, newFrame.size.width,newFrame.size.height)];
                        [detailCellCar.detailinfoTextView setFrame:newFrame];
                        
                        
                   // }
                    
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelX);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelY);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelW);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelH);
                    detailCellCar.tapView.backgroundColor=[UIColor clearColor];
                    
                    [detailCellCar.view_CordinateViewTapped setFrame:CGRectMake(detailCellCar.view_CordinateViewTapped.frame.origin.x,(detailCellCar.view_CordinateViewTapped.frame.origin.y+detailCellCar.tapView.frame.size.height) - 38,detailCellCar.view_CordinateViewTapped.frame.size.width, detailCellCar.view_CordinateViewTapped.frame.size.height)];
                    
                    [detailCellCar.Button_makeoffer setFrame:CGRectMake(detailCellCar.Button_makeoffer.frame.origin.x,(detailCell.view_CordinateViewTapped.frame.origin.y+detailCellCar.view_CordinateViewTapped.frame.size.height),detailCellCar.Button_makeoffer.frame.size.width, detailCellCar.Button_makeoffer.frame.size.height)];
                    [detailCellCar.Button_makeoffer  addTarget:self action:@selector(makeOfferPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    return detailCellCar;
                }
                
                
                
            }
            
            
            else if ([[Array_UserInfo valueForKey:@"category"] isEqualToString:@"property"])
            {
                {
                    
                    
                    detailCellProperty = [[[NSBundle mainBundle]loadNibNamed:@"DetailPropertyTableViewCell" owner:self options:nil] objectAtIndex:0];
                    
                    if (detailCellProperty == nil)
                    {
                        
                        detailCellProperty = [[DetailPropertyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_detailsproperty];
                        
                        
                    }
                    
                    
                    [detailCellProperty.detailinfoTextView setText:text];
                    detailCellProperty.locationLabel.text = [Array_UserInfo valueForKey:@"city1"];
                    detailCellProperty.hashtagLabel.text = [Array_UserInfo valueForKey:@"hashtags"];
                    detailCellProperty.postidLabel.text =  [NSString stringWithFormat:@"%@%@",[Array_UserInfo valueForKey:@"postid"],@" :رقم الإعلان"];//POST ID
                    [defaults setObject:[Array_UserInfo valueForKey:@"postid"] forKey:@"post-id"];
                    
                    
                    detailCellProperty.usernameLabel.text = [Array_UserInfo valueForKey:@"usersname"];
                    detailCellProperty.durationLabel.text = [Array_UserInfo valueForKey:@"postdur"];
                    
                    NSString *show = [NSString stringWithFormat:@"ر.س %@",[Array_UserInfo valueForKey:@"showamount"]];//$
                    detailCellProperty.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
                    detailCellProperty.askingPriceLabel.text = [NSString stringWithFormat:@"ر.س %@",[Array_UserInfo valueForKey:@"askingprice"]];//$
                    detailCellProperty.timeLabel.text = [Array_UserInfo valueForKey:@"createtime"];
                    detailCellProperty.titleLabel.text = [Array_UserInfo valueForKey:@"title"];
                    
                    if ([[Array_UserInfo valueForKey:@"propertytype"] isEqualToString:@"SALE"] )
                    {
                        detailCellProperty.propertyTypeLabel.text = @"للبيع";
                    }
                    else
                    {
                        detailCellProperty.propertyTypeLabel.text = @"للإيجار";
                    }

                    
                    //detailCellProperty.propertyTypeLabel.text = [Array_UserInfo valueForKey:@"propertytype"];
                    
                    detailCellProperty.propertySizeLabel.text = [NSString stringWithFormat:@"%@ (Sqm)",[Array_UserInfo valueForKey:@"propertysize"]];
                    
                    detailCellProperty.noOfBedroomsLabel.text = [NSString stringWithFormat:@"%@ bedrooms",[Array_UserInfo valueForKey:@"noofrooms"]];
                    
                    
                    NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"usersprofilepic"]];
                    
                    [detailCellProperty.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
                    detailCellProperty.profileImage.layer.cornerRadius = detailCellProperty.profileImage.frame.size.height / 2;
                    detailCellProperty.profileImage.clipsToBounds = YES;
                    
                    
                    detailCellProperty.favouriteImage.userInteractionEnabled = YES;
                    detailCellProperty.favouriteImage.tag=swipeCount;
                    UITapGestureRecognizer *favouriteImage_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favouriteImage_ActionDetails:)];
                    [detailCellProperty.favouriteImage addGestureRecognizer:favouriteImage_Tapped];

                    
                    if ([[Array_UserInfo valueForKey:@"favourite"]isEqualToString:@"TRUE"])
                    {
                        [detailCellProperty.favouriteImage setImage:[UIImage imageNamed:@"FavouriteFill"]];
                    }
                    else
                    {
                        [detailCellProperty.favouriteImage setImage:[UIImage imageNamed:@"Favourite"]];
                        
                    }
                    
#pragma mark - fdgfhjdgj;
                    
                    if (fav)
                    {
                        
                        
                        if ([str_fav isEqualToString:@"inserted"])
                        {
                            [detailCellProperty .favouriteImage setImage:[UIImage imageNamed:@"FavouriteFill"]];
                        }
                        else
                        {
                            [detailCellProperty .favouriteImage setImage:[UIImage imageNamed:@"Favourite"]];
                            
                        }
                        
                        fav = false;
                        
                    }

                    
                    //------------------------------------------$$$$$$$$$$$$$$$$$$$______________________________
                    
                    detailCellProperty.tapView.userInteractionEnabled=YES;
                    detailCellProperty.tapView.tag=swipeCount;
                    detailCellProperty.detailinfoTextView.tag=swipeCount;
//                    UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
//                    [detailCellProperty.tapView addGestureRecognizer:label_Desc_Tapped];
                    if ([str_LabelCoordinates isEqualToString:@"no"])
                    {
                        str_LabelCoordinates=@"yes";
                        
                        Cell_DescLabelX=detailCellProperty.detailinfoTextView.frame.origin.x;
                        Cell_DescLabelY=detailCellProperty.detailinfoTextView.frame.origin.y;
                        Cell_DescLabelW=detailCellProperty.detailinfoTextView.frame.size.width;
                        Cell_DescLabelH=detailCellProperty.detailinfoTextView.frame.size.height;
                        
                        TextView_ViewX=detailCellProperty.tapView.frame.origin.x;
                        TextView_ViewY=detailCellProperty.tapView.frame.origin.y;
                        TextView_ViewW=detailCellProperty.tapView.frame.size.width;
                        TextView_ViewH=detailCellProperty.tapView.frame.size.height;
                        
                        FavIV_Y=(detailCellProperty.view_CordinateViewTapped.frame.origin.y-(detailCellProperty.tapView.frame.origin.y+detailCellProperty.tapView.frame.size.height));
                        
                        NSLog(@"Dynamic label heightc====%f",Cell_DescLabelX);
                        NSLog(@"Dynamic label heightc====%f",Cell_DescLabelY);
                        NSLog(@"Dynamic label heightc====%f",Cell_DescLabelW);
                        NSLog(@"Dynamic label heightc====%f",Cell_DescLabelH);
                        NSLog(@"FavIV_Y====%f",FavIV_Y);
                        
                    }
                    
                    
                    //[[AllArrayData objectAtIndex:0]valueForKey:@"title"];;
                    
                    
                    CGSize constraint = CGSizeMake(340 - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                    
                    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                    
                    CGFloat height = MAX(size.height, 30.0f);
                    NSLog(@"Dynamic label height====%f",height);
                    
                    
                    float rows = (detailCellProperty.detailinfoTextView.contentSize.height - detailCellProperty.detailinfoTextView.textContainerInset.top - detailCellProperty.detailinfoTextView.textContainerInset.bottom) / detailCellProperty.detailinfoTextView.font.lineHeight;
                    NSLog(@"Dynamic label rowsline====%f",rows);
                    //  cell_TwoDetails.label_Desc.numberOfLines=0;
                    
                    [detailCellProperty.detailinfoTextView setText:text];
                    // detailCell.detailinfoTextView.tag=indexPath.row;
                    
                    CGFloat fixedWidth = detailCellProperty.detailinfoTextView.frame.size.width;
                    CGSize newSize = [detailCellProperty.detailinfoTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
                    NSInteger rHeight = size.height/17;
                    NSLog(@"No of lines: %ld",(long)rHeight);
                    detailCellProperty.detailinfoTextView1.hidden=YES;
//                    if ([str_TappedLabel isEqualToString:@"no"])
//                    {
//                        if ((long)rHeight==1)
//                        {
//                            
//                            [detailCellProperty.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH)];
//                            
//                            [detailCellProperty.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH)];
//                            
//                            
//                        }
//                        else if ((long)rHeight==2)
//                        {
//                            
//                            [detailCellProperty.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*1.6)];
//                            
//                            [detailCellProperty.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*1.6)];
//                            
//                            
//                        }
//                        else if ((long)rHeight>=3)
//                        {
//                            detailCellProperty.tapView.userInteractionEnabled=YES;
//                            detailCellProperty.detailinfoTextView.textContainer.maximumNumberOfLines = 0;
//                            detailCellProperty.detailinfoTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
//                            UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
//                            [detailCellProperty.tapView addGestureRecognizer:label_Desc_Tapped];
//                            
//                            [detailCellProperty.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*1.6)];
//                            
//                            [detailCellProperty.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*1.6)];
//                            
//                            
//                        }
//                        
//                    }
//                    
//                    
//                    
//                    
//                    else
//                    {
                    
                        
                        CGRect newFrame = detailCellProperty.detailinfoTextView.frame;
                        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
                        
                        detailCellProperty.tapView.userInteractionEnabled=YES;
                        
//                        UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
//                        [detailCellProperty.tapView addGestureRecognizer:label_Desc_Tapped];
                        [detailCellProperty.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, newFrame.size.width,newFrame.size.height)];
                        [detailCellProperty.detailinfoTextView setFrame:newFrame];
                        
                        
                   // }
                    
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelX);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelY);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelW);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelH);
                    detailCellProperty.tapView.backgroundColor=[UIColor clearColor];
                    
                    [detailCellProperty.view_CordinateViewTapped setFrame:CGRectMake(detailCellProperty.view_CordinateViewTapped.frame.origin.x,(detailCellProperty.view_CordinateViewTapped.frame.origin.y+detailCellProperty.tapView.frame.size.height) - 38,detailCellProperty.view_CordinateViewTapped.frame.size.width, detailCellProperty.view_CordinateViewTapped.frame.size.height)];
                    
                    [detailCellProperty.Button_makeoffer setFrame:CGRectMake(detailCellProperty.Button_makeoffer.frame.origin.x,(detailCellProperty.view_CordinateViewTapped.frame.origin.y+detailCellProperty.view_CordinateViewTapped.frame.size.height),detailCellProperty.Button_makeoffer.frame.size.width, detailCellProperty.Button_makeoffer.frame.size.height)];
                    [detailCellProperty.Button_makeoffer  addTarget:self action:@selector(makeOfferPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                    return detailCellProperty;
                }
                
                
                
            }
            
            
            
            
            else
                
                
            {
                
                detailCell = [[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:self options:nil] objectAtIndex:0];
                
                
                
                
                if (detailCell == nil)
                {
                    
                    detailCell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_details];
                    
                    
                }
                
                
                if ([[UIScreen mainScreen]bounds].size.width == 320)
                {
                    [detailCell.tapView setFrame:CGRectMake(31, 176, 278, 38)];
                    [detailCell.detailinfoTextView setFrame:CGRectMake(0, 0, 278, 38)];
                    [detailCell.detailinfoTextView1 setFrame:CGRectMake(0, 0, 278, 38)];
                    [detailCell.view_CordinateViewTapped setFrame:CGRectMake(0, 216, 320, 135)];
                    
                    [detailCell.askingPriceImageview setFrame:CGRectMake(69, 12, 45, 45)];
                    [detailCell.askingPriceHeadingLabel setFrame:CGRectMake(46, 57, 96, 37)];
                    [detailCell.askingPriceLabel setFrame:CGRectMake(21, 94, 140, 30)];
                    
                    [detailCell.highestOfferImageview setFrame:CGRectMake(207, 12, 45, 45)];
                    [detailCell.highestOfferHeadingLabel setFrame:CGRectMake(184, 57, 96, 37)];
                    [detailCell.priceLabel setFrame:CGRectMake(160, 94, 140, 30)];
                  
                }
                else if ([[UIScreen mainScreen]bounds].size.width == 414)
                {
                    
                    [detailCell.tapView setFrame:CGRectMake(36, 176, 365, 38)];
                    [detailCell.detailinfoTextView setFrame:CGRectMake(0, 0, 365, 38)];
                    [detailCell.detailinfoTextView1 setFrame:CGRectMake(0, 0, 365, 38)];
                    [detailCell.view_CordinateViewTapped setFrame:CGRectMake(0, 216, 414, 135)];
                    
                    [detailCell.askingPriceImageview setFrame:CGRectMake(104, 12, 45, 45)];
                    [detailCell.askingPriceHeadingLabel setFrame:CGRectMake(74, 57, 96, 37)];
                    [detailCell.askingPriceLabel setFrame:CGRectMake(44, 94, 140, 30)];
                    
                    [detailCell.highestOfferImageview setFrame:CGRectMake(266, 12, 45, 45)];
                    [detailCell.highestOfferHeadingLabel setFrame:CGRectMake(236, 57, 96, 37)];
                    [detailCell.priceLabel setFrame:CGRectMake(206, 94, 140, 30)];
                    
                }
                
                else
                {
                    
                }
                
                
                
                detailCell.locationLabel.text = [Array_UserInfo valueForKey:@"city1"];
                detailCell.hashtagLabel.text = [Array_UserInfo valueForKey:@"hashtags"];
                //NSString *post = [NSString stringWithFormat:@"POST ID:%@",[dic_request valueForKey:@"postid"]];
                detailCell.postidLabel.text =  [NSString stringWithFormat:@"%@%@",[Array_UserInfo valueForKey:@"postid"],@" :رقم الإعلان"];//POST ID
                detailCell.usernameLabel.text = [Array_UserInfo valueForKey:@"usersname"];
                detailCell.durationLabel.text = [Array_UserInfo valueForKey:@"postdur"];
                
                NSString *show = [NSString stringWithFormat:@"ر.س %@",[Array_UserInfo valueForKey:@"showamount"]];//$
                detailCell.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
                detailCell.askingPriceLabel.text = [NSString stringWithFormat:@"ر.س %@",[Array_UserInfo valueForKey:@"askingprice"]];//$
                detailCell.timeLabel.text = [Array_UserInfo valueForKey:@"createtime"];
                detailCell.titleLabel.text = [Array_UserInfo valueForKey:@"title"];
                //detailCell.profileImage.image =
                
                NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"usersprofilepic"]];
                
                [detailCell.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
                detailCell.profileImage.layer.cornerRadius = detailCell.profileImage.frame.size.height / 2;
                detailCell.profileImage.clipsToBounds = YES;
                
                
                detailCell.favouriteImage.userInteractionEnabled = YES;
                detailCell.favouriteImage.tag=swipeCount;
                UITapGestureRecognizer *favouriteImage_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favouriteImage_ActionDetails:)];
                [detailCell.favouriteImage addGestureRecognizer:favouriteImage_Tapped];
                
                
                
                if ([[Array_UserInfo valueForKey:@"favourite"]isEqualToString:@"TRUE"])
                {
                    [detailCell.favouriteImage setImage:[UIImage imageNamed:@"FavouriteFill"]];
                }
                else
                {
                    [detailCell.favouriteImage setImage:[UIImage imageNamed:@"Favourite"]];
                    
                }
                
#pragma mark - fdgfhjdgj;
                
                if (fav)
                {
                    
                    
                    if ([str_fav isEqualToString:@"inserted"])
                    {
                        [detailCell .favouriteImage setImage:[UIImage imageNamed:@"FavouriteFill"]];
                    }
                    else
                    {
                        [detailCell .favouriteImage setImage:[UIImage imageNamed:@"Favourite"]];
                        
                    }
                    
                    fav = false;
                    
                }
                
                //------------------------------------------$$$$$$$$$$$$$$$$$$$______________________________

                
                
                
                if ([str_LabelCoordinates isEqualToString:@"no"])
                {
                    str_LabelCoordinates=@"yes";
                    
                    Cell_DescLabelX=detailCell.detailinfoTextView.frame.origin.x;
                    Cell_DescLabelY=detailCell.detailinfoTextView.frame.origin.y;
                    Cell_DescLabelW=detailCell.detailinfoTextView.frame.size.width;
                    Cell_DescLabelH=detailCell.detailinfoTextView.frame.size.height;
                    
                    TextView_ViewX=detailCell.tapView.frame.origin.x;
                    TextView_ViewY=detailCell.tapView.frame.origin.y;
                    TextView_ViewW=detailCell.tapView.frame.size.width;
                    TextView_ViewH=detailCell.tapView.frame.size.height;
                    
                    FavIV_Y=(detailCell.view_CordinateViewTapped.frame.origin.y-(detailCell.tapView.frame.origin.y+detailCell.tapView.frame.size.height));
                    
                    NSLog(@"Dynamic label heightc====%f",Cell_DescLabelX);
                    NSLog(@"Dynamic label heightc====%f",Cell_DescLabelY);
                    NSLog(@"Dynamic label heightc====%f",Cell_DescLabelW);
                    NSLog(@"Dynamic label heightc====%f",Cell_DescLabelH);
                    NSLog(@"FavIV_Y====%f",FavIV_Y);
                    
                    
                    
                }
                
                
                //[[AllArrayData objectAtIndex:0]valueForKey:@"title"];;
                
                
                CGSize constraint = CGSizeMake(340 - (CELL_CONTENT_MARGIN * 2), 20000.0f);
                
                CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
                
                CGFloat height = MAX(size.height, 30.0f);
                NSLog(@"Dynamic label height====%f",height);
                
                
                float rows = (detailCell.detailinfoTextView.contentSize.height - detailCell.detailinfoTextView.textContainerInset.top - detailCell.detailinfoTextView.textContainerInset.bottom) / detailCell.detailinfoTextView.font.lineHeight;
                NSLog(@"Dynamic label rowsline====%f",rows);
                //  cell_TwoDetails.label_Desc.numberOfLines=0;
                
                [detailCell.detailinfoTextView setText:text];
                detailCell.detailinfoTextView.tag=indexPath.row;
                detailCell.tapView.tag=indexPath.row;
                CGFloat fixedWidth = detailCell.detailinfoTextView.frame.size.width;
                CGSize newSize = [detailCell.detailinfoTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
                NSInteger rHeight = size.height/17;
                NSLog(@"No of lines: %ld",(long)rHeight);
                detailCell.detailinfoTextView1.hidden=YES;
                
//                if ([str_TappedLabel isEqualToString:@"no"])
//                {
//                    if ((long)rHeight==1)
//                    {
//                        
//                        [detailCell.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH)];
//                        
//                        [detailCell.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH)];
//                        
//                        
//                        
//                        
//                    }
//                    else if ((long)rHeight==2)
//                    {
//                        
//                        [detailCell.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*1.6)];
//                        
//                        [detailCell.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*1.6)];
//                        
//                        
//                    }
//                    else if ((long)rHeight>=3)
//                    {
//                        detailCell.tapView.userInteractionEnabled=YES;
//                        detailCell.detailinfoTextView.textContainer.maximumNumberOfLines = 0;
//                        detailCell.detailinfoTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
//                        UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
//                        [detailCell.tapView addGestureRecognizer:label_Desc_Tapped];
//                        
//                        
//                        
//                        
//                        [detailCell.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*1.6)];
//                        
//                        [detailCell.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*1.6)];
//                        
//                        
//                    }
//                    
//                }
//                else
//                {
                
                    
                    CGRect newFrame = detailCell.detailinfoTextView.frame;
                    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
                    
                    detailCell.tapView.userInteractionEnabled=YES;
                    
//                    UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
//                    [detailCell.tapView addGestureRecognizer:label_Desc_Tapped];
                    [detailCell.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, newFrame.size.width,newFrame.size.height)];
                    [detailCell.detailinfoTextView setFrame:newFrame];
                    
                    
               // }
                
                NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelX);
                NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelY);
                NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelW);
                NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelH);
                detailCell.tapView.backgroundColor=[UIColor clearColor];
                
                [detailCell.view_CordinateViewTapped setFrame:CGRectMake(detailCell.view_CordinateViewTapped.frame.origin.x,(detailCell.view_CordinateViewTapped.frame.origin.y+detailCell.tapView.frame.size.height) - 38,detailCell.view_CordinateViewTapped.frame.size.width, detailCell.view_CordinateViewTapped.frame.size.height)];
                
                [detailCell.Button_makeoffer setFrame:CGRectMake(detailCell.Button_makeoffer.frame.origin.x,(detailCell.view_CordinateViewTapped.frame.origin.y+detailCell.view_CordinateViewTapped.frame.size.height),detailCell.Button_makeoffer.frame.size.width, detailCell.Button_makeoffer.frame.size.height)];
                [detailCell.Button_makeoffer  addTarget:self action:@selector(makeOfferPressed:) forControlEvents:UIControlEventTouchUpInside];
                detailCell.Button_makeoffer.hidden = YES;
                
                
                return detailCell;
            }
            break;
            
        case 2:
        {
            
            cell_postcomments = [[[NSBundle mainBundle]loadNibNamed:@"PostHeaderTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            
            
            
            if (cell_postcomments == nil)
            {
                
                cell_postcomments = [[PostHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:post_comments];
                
                
            }
            
            [cell_postcomments.Button_PostComments addTarget:self action:@selector(postCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            return cell_postcomments;
        }
            break;
            
            
            
            
        case 3:
        {
            
            ComCell = [[[NSBundle mainBundle]loadNibNamed:@"CommentsTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            
            if (ComCell == nil)
            {
                
                ComCell = [[CommentsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_comments];
                
                
            }
            
            ComCell.profileImageView.layer.cornerRadius = ComCell.profileImageView.frame.size.height / 2;
            ComCell.profileImageView.clipsToBounds = YES;
            [ComCell.commentofferLabel setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:20]];
            [ComCell.commentmsgLabel setFont:[UIFont fontWithName:@"SanFranciscoDisplay-medium" size:15]];
            
            if (Array_Chats.count == 0 )
                
            
            {
                ComCell.commentmsgLabel.text = @"لا تتوفر دردشات";//@"No Chats available";
                ComCell.usernameLabel.hidden = YES;
                ComCell.durationLabel.hidden = YES;
                ComCell.profileImageView.hidden = YES;
                ComCell.commentmsgLabel.hidden = YES;
                ComCell.commentofferLabel.hidden = YES;
                
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(ComCell.frame.origin.x, ComCell.frame.origin.y, self.view.frame.size.width, ComCell.frame.size.height)];
                label.text = @"لا تتوفر دردشات";//@" No Chats Available";
                label.textAlignment = NSTextAlignmentCenter;
                [label setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:20]];
                [ComCell addSubview:label];
                [ComCell bringSubviewToFront:label];
            }
            else
            {
                if ([[[Array_Chats objectAtIndex:indexPath.row] valueForKey:@"messagetype"] isEqualToString:@"TEXT"])
                {
                    ComCell.usernameLabel.hidden = NO;
                    ComCell.durationLabel.hidden = NO;
                    ComCell.profileImageView.hidden = NO;
                    ComCell.commentmsgLabel.hidden = NO;
                    ComCell.commentofferLabel.hidden = YES;
                    
                    [ComCell.profileImageView setFrame:CGRectMake(self.view.frame.size.width - ComCell.profileImageView.frame.size.width - 8 , ComCell.profileImageView.frame.origin.y, ComCell.profileImageView.frame.size.width, ComCell.profileImageView.frame.size.height)];
                    
                    [ComCell.durationLabel setFrame:CGRectMake(8, ComCell.durationLabel.frame.origin.y, (ComCell.profileImageView.frame.origin.x - 8)/3, ComCell.usernameLabel.frame.size.height)];
                    
                    [ComCell.usernameLabel setFrame:CGRectMake(ComCell.durationLabel.frame.origin.x +ComCell.durationLabel.frame.size.width+ 8, ComCell.usernameLabel.frame.origin.y, (self.view.frame.size.width - ((ComCell.durationLabel.frame.origin.x + 8+ComCell.durationLabel.frame.size.width)+(ComCell.profileImageView.frame.size.width + 16))) , ComCell.usernameLabel.frame.size.height)];
                    
                    
                    [ComCell.commentofferLabel setFrame:CGRectMake(8, ComCell.commentofferLabel.frame.origin.y, self.view.frame.size.width - 16, ComCell.commentofferLabel.frame.size.height)];
                    
                    [ComCell.commentmsgLabel setFrame:CGRectMake(8, ComCell.commentofferLabel.frame.origin.y, self.view.frame.size.width - 16, ComCell.commentmsgLabel.frame.size.height)];
                    
                    NSLog(@"frame user label==%f",(self.view.frame.size.width - ((ComCell.durationLabel.frame.origin.x + 8+ComCell.durationLabel.frame.size.width)+(ComCell.profileImageView.frame.size.width + 16))));
                    
                    ComCell.durationLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"chatdur"];
                    ComCell.usernameLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"name"];
                    ComCell.commentmsgLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"message"];
                    
                    NSURL *url=[NSURL URLWithString:[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"profileimage"]];
                    
                    
                    [ComCell.profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                    
                    
                }
                
                if ([[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"messagetype"] isEqualToString:@"OFFER"])
                {
                    
                    ComCell.usernameLabel.hidden = NO;
                    ComCell.durationLabel.hidden = NO;
                    ComCell.profileImageView.hidden = NO;
                    ComCell.commentmsgLabel.hidden = NO;
                    ComCell.commentofferLabel.hidden = NO;
                    
                    [ComCell.profileImageView setFrame:CGRectMake(self.view.frame.size.width - ComCell.profileImageView.frame.size.width - 8 , ComCell.profileImageView.frame.origin.y, ComCell.profileImageView.frame.size.width, ComCell.profileImageView.frame.size.height)];
                    
                    [ComCell.durationLabel setFrame:CGRectMake(8, ComCell.durationLabel.frame.origin.y, (ComCell.profileImageView.frame.origin.x - 8)/3, ComCell.usernameLabel.frame.size.height)];
                    
                    [ComCell.usernameLabel setFrame:CGRectMake(ComCell.durationLabel.frame.origin.x +ComCell.durationLabel.frame.size.width+ 8, ComCell.usernameLabel.frame.origin.y, (self.view.frame.size.width - ((ComCell.durationLabel.frame.origin.x + 8+ComCell.durationLabel.frame.size.width)+(ComCell.profileImageView.frame.size.width + 16))) , ComCell.usernameLabel.frame.size.height)];
                    
                    
                    [ComCell.commentofferLabel setFrame:CGRectMake(8, ComCell.commentofferLabel.frame.origin.y, self.view.frame.size.width - 16, ComCell.commentofferLabel.frame.size.height)];
                    
                    [ComCell.commentmsgLabel setFrame:CGRectMake(8, ComCell.commentmsgLabel.frame.origin.y, self.view.frame.size.width - 16, ComCell.commentmsgLabel.frame.size.height)];
                    
                    NSLog(@"frame user label==%f",(self.view.frame.size.width - ((ComCell.durationLabel.frame.origin.x + 8+ComCell.durationLabel.frame.size.width)+(ComCell.profileImageView.frame.size.width + 16))));
                    
                    NSString * offerComment = [NSString stringWithFormat:@"تم إرسال العرض ر.س%@",[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"amount"]];//Made an offer:[NSString stringWithFormat:@"Made an offer: ر.س%@",[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"amount"]];//$
                    
                    
                    
                    ComCell.commentofferLabel.text = offerComment;//[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"amount"] ;
                    ComCell.durationLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"chatdur"];
                    ComCell.usernameLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"name"];
                    ComCell.commentmsgLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"message"];
                    
                    NSURL *url=[NSURL URLWithString:[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"profileimage"]];
                    
                    
                    [ComCell.profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                    
                    
                    //                    NSIndexPath* ipath = [NSIndexPath indexPathForRow:Array_Chats.count-1 inSection:3];
                    //                    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];

#pragma mark- // latest comment
              //  [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                    
                }
                
            }

            


            
            return ComCell;
        }
            break;
            
            
        case 4:
        {
            
            cell_seeallcomments = [[[NSBundle mainBundle]loadNibNamed:@"PostFooterTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            
            
            
            if (cell_seeallcomments == nil)
            {
                
                cell_seeallcomments = [[PostFooterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:seeall_comments];
                
                
            }
            
            [cell_seeallcomments.Button_PostComments addTarget:self action:@selector(postCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell_seeallcomments.Button_SeeAllComments addTarget:self action:@selector(seeCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
    
            
            //if ([[defaults valueForKey:@"SeeCommentPressed"]isEqualToString:@"no"])
            if ([seeCommentStr isEqualToString:@"no"])
            {
                [cell_seeallcomments.Button_SeeAllComments setTitle:@"عرض جميع التعليقات" forState:UIControlStateNormal];//See all comments
                cell_seeallcomments.Button_PostComments.hidden = YES;
                
                
            }
            else
            {
                [cell_seeallcomments.Button_SeeAllComments setTitle:@"تعليقات أقل" forState:UIControlStateNormal];//See less comments
                cell_seeallcomments.Button_PostComments.hidden = NO;
                
                
            }
            
            
            return cell_seeallcomments;
        }
            break;
            
    }
    return nil;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (total_image >=2)
        {
            return 275;
        }
        else
        {
            return 434;
        }
    }
    else if (indexPath.section == 1)
        
        
    {
        
        if ([[Array_UserInfo valueForKey:@"category"] isEqualToString:@"car"])
            
        {
            
            CGSize constraint = CGSizeMake(345 - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 30.0f);
            NSLog(@"Dynamic label height====%f",height);
            NSInteger rHeight = size.height/17;
            [detailCellCar.detailinfoTextView1 setText:text];
            
            
            CGFloat fixedWidth = detailCellCar.detailinfoTextView1.frame.size.width;
            CGSize newSize = [detailCellCar.detailinfoTextView1 sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = detailCellCar.detailinfoTextView1.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            [detailCellCar.detailinfoTextView1 setFrame:(newFrame)];
//            if ([str_TappedLabel isEqualToString:@"yes"])
//            {
            
                
                return 477+detailCellCar.detailinfoTextView1.frame.size.height-36;
                
//            }
//            else
//            {
//                
//                if((long)rHeight==0)
//                {
//                    return 477;
//                }
//                
//                else if ((long)rHeight==1)
//                {
//                    return 477;
//                }
//
//                else
//                {
//                    return 477 + 25 ;
//                }
//                
//                
//            }
            
            
            
        }
        
        else if ([[Array_UserInfo valueForKey:@"category"] isEqualToString:@"property"])
            
        {
            
            CGSize constraint = CGSizeMake(345 - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 30.0f);
            NSLog(@"Dynamic label height====%f",height);
            NSInteger rHeight = size.height/17;
            [detailCellProperty.detailinfoTextView1 setText:text];
            
            
            CGFloat fixedWidth = detailCellProperty.detailinfoTextView1.frame.size.width;
            CGSize newSize = [detailCellProperty.detailinfoTextView1 sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = detailCellProperty.detailinfoTextView1.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            [detailCellProperty.detailinfoTextView1 setFrame:(newFrame)];
//            if ([str_TappedLabel isEqualToString:@"yes"])
//            {
                
                
                return 520+detailCellProperty.detailinfoTextView1.frame.size.height - 36;
                
//            }
//            else
//            {
//                
//                if ((long)rHeight == 0)
//                {
//                    return 520;
//                }
//                else if ((long)rHeight == 1)
//                {
//                    return 520;
//                }
//                else
//                {
//                    return 520 + 25 ;
//                }
//                
//                
//            }
            
            
            
        }
        
        
        
        else
            
        {
            
            CGSize constraint = CGSizeMake(345 - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 30.0f);
            NSLog(@"Dynamic label height====%f",height);
            NSInteger rHeight = size.height/17;
            [detailCell.detailinfoTextView1 setText:text];
            
            
            CGFloat fixedWidth = detailCell.detailinfoTextView1.frame.size.width;
            CGSize newSize = [detailCell.detailinfoTextView1 sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = detailCell.detailinfoTextView1.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            [detailCell.detailinfoTextView1 setFrame:(newFrame)];
//            if ([str_TappedLabel isEqualToString:@"yes"])
//            {
            
                
                return 344+detailCell.detailinfoTextView1.frame.size.height - 36;
                
//            }
//            else
//            {
//                
//                if ((long)rHeight == 0)
//                {
//                    return 344;
//                }
//                else if ((long)rHeight == 1)
//                {
//                    return 344;
//                }
//                
//                else
//                {
//                    return 344 + 20;
//                }
//                
//                
//            }
            
            
            
        }
    }
    
    else if (indexPath.section == 2)
    {
        return 45;
    }
    else if (indexPath.section == 3)
    {
        if (Array_Chats.count == 0)
        {
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99,375, 1)];
            line.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
            [ComCell addSubview:line];

            return 100 + rect.size.height;
            
        }
        
        else
            
        {
            if ([[[Array_Chats objectAtIndex:indexPath.row ] valueForKey:@"messagetype"] isEqualToString:@"TEXT"])
            {
                UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 102,375, 1)];
                line.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
                [ComCell addSubview:line];

                return 103;//+ rect.size.height;
                
            }
            else
            {
                UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 141,375, 1)];
                line.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
                [ComCell addSubview:line];

                return 142;// + rect.size.height;
                
            }
            
            
        }
    }
    else if (indexPath.section == 4)
    {

            return 45 + rect.size.height;
    }
   
    
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==1)
    {
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];//36
        [sectionView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width / 2) + 50, 44)];
       
        [button1 setTitle:@"السلع المباعة " forState:UIControlStateNormal];//ITEM SOLD
        button1.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:18];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
        [button1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:114/255.0 blue:48/255.0 alpha:1]];
        [button1 setImage:[UIImage imageNamed:@"Itemsold"] forState:UIControlStateNormal];
        if ([[UIScreen mainScreen]bounds].size.width == 414)
        {
             [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -200)];
        }
        else
        {
        [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -210)];
        }
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(sectionHeaderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
        UIButton *button2;// = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 7, 33, 30)];
        if ([[UIScreen mainScreen]bounds].size.width == 414)
        {
            button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 90, 7, 33, 30)];
        }
        else
        {
            button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 85, 7, 33, 30)];
        }
        
        [button2 setImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(sectionHeaderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button2];
        sectionView.tag=section;
        
    }
    
    return sectionView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1)
    {
        return 44;
    }
    
    
    return 0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,2)];//36
        [sectionView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
    }
    
    
//    if (section == 3)
//    {
//        
//        
//        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];//36
//        [sectionView setBackgroundColor:[UIColor whiteColor]];
//        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 39,self.view.frame.size.width,2)];//36
//        [bottomView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
//        [sectionView addSubview:bottomView];
//        
//        
//        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, 122, 30)];
//        [button1 setTitle:@"Post a comment" forState:UIControlStateNormal];
//        button1.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:15];
//        [button1 setTitleColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
//        [button1 setTag:1];
//        [button1 addTarget:self action:@selector(postCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [sectionView addSubview:button1];
//        
//        
//        seeCommentButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 170, 0, 160, 40)];
//        
//        if ([[defaults valueForKey:@"SeeCommentPressed"]isEqualToString:@"no"])
//        {
//            [seeCommentButton setTitle:@"See all comments" forState:UIControlStateNormal];
//            button1.hidden = YES;
//            
//        }
//        else
//        {
//            [seeCommentButton setTitle:@"See less comments" forState:UIControlStateNormal];
//            button1.hidden = NO;
//            
//        }
//        
//        [seeCommentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [seeCommentButton setTag:1];
//        [seeCommentButton addTarget:self action:@selector(seeCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [sectionView addSubview:seeCommentButton];
//        
//        
//    }
    
    return sectionView;
}





-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 2;
    }
    
//    if (section == 3)
//    {
//        if ([nochats isEqualToString:@"nochat"])
//        {
//            return 0;
//        }
//        
//        else if(Array_Chats.count < 4)
//        {
//            return 0;
//        }
//        else
//        {
//            return 40 + rect.size.height;
//        }
//    }
    return 0;
}

-(void)label_Desc_Tapped_ActionDetails:(UIGestureRecognizer *)reconizer
{
    
//    if ([str_TappedLabel isEqualToString:@"yes"])
//    {
//        str_TappedLabel=@"no";
//        
//    }
//    else
//    {
//        str_TappedLabel=@"yes";
//        
//    }
//    
//    
//    
//    [self.tableView reloadData];
        
    
}

#pragma mark - Button Action

-(void)sectionHeaderButtonPressed:(id)sender
{
    if ([sender tag]== 1)
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDisable" object:self userInfo:nil];
        
        NSLog(@"Item Sold Pressed");

        transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        transparentView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        grayView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 137.5, self.view.frame.size.width - 250, 275, 162)];
        grayView.center=transparentView.center;
        grayView.layer.cornerRadius=10;
        grayView.clipsToBounds = YES;
        [grayView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        UIButton *closeview=[[UIButton alloc]initWithFrame:CGRectMake(8, 8, 30, 30)];
        [closeview setTitle:@"X" forState:UIControlStateNormal];
        [closeview setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [closeview addTarget:self action:@selector(closedd:)
            forControlEvents:UIControlEventTouchUpInside];
        [grayView addSubview:closeview];
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(147, 8, 86, 30)];
        label1.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:16];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"السلع المباعة";//@"ITEM SOLD";
        label1.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        [grayView addSubview:label1];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(232, 8, 30, 30)];
        imageView.image = [UIImage imageNamed:@"Greenitemsold"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds=YES;
        [grayView addSubview:imageView];
        
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(87, 41, 175, 18)];
        label2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Semibold" size:11];
        label2.textAlignment = NSTextAlignmentRight;
        label2.text =  [NSString stringWithFormat:@"%@%@",[Array_UserInfo valueForKey:@"postid"],@" :رقم الإعلان"];//POST ID//@"POST ID: 3589278W3";
        label2.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        [grayView addSubview:label2];

        UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(8, 67, 254, 21)];
        label3.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:14];
        label3.textAlignment = NSTextAlignmentRight;
        label3.text = @"متأكد أنه تم بيع السلعة؟";//@"Are you sure this item has been sold?";
        [grayView addSubview:label3];

        
        UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(21, 87, 241, 35)];
        label4.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:14];
        label4.textAlignment = NSTextAlignmentRight;
        label4.numberOfLines = 2;
        label4.text = @"اختيار تأكيد سوف يزيل السلعه.";//@"Selecting confirm will remove item from تم";
        [grayView addSubview:label4];
        
        
        UIButton *confirm=[[UIButton alloc]initWithFrame:CGRectMake(0, 130, 275, 32)];
        [confirm setTitle:@"تأكيد" forState:UIControlStateNormal];//CONFIRM
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        confirm.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16];
        [confirm setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        [confirm addTarget:self action:@selector(confirm:)
          forControlEvents:UIControlEventTouchUpInside];
        [grayView addSubview:confirm];
        

        [transparentView addSubview:grayView];
        [self.view addSubview:transparentView];
        
        
    }
    
    else
    {
        NSLog(@"share button pressed");
        NSString * headtitle=[Array_UserInfo valueForKey:@"title"];
        NSString * headDesc=[Array_UserInfo valueForKey:@"description"];
        NSString * mediaurl=[Array_UserInfo valueForKey:@"mediaurl"];
        NSString * mediaurl1=[Array_UserInfo valueForKey:@"mediaurl1"];
        NSString * texttoshare=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@",@"Post: ",headtitle,@"\n\n",@"Description: ",headDesc,@"\n\n",@"Media:",@"\n",mediaurl,@"\n",mediaurl1,@"\n\n",@"Download Tamm from the Appstore today! Visit http://www.tammapp.com for more details."];
//        NSString * texttoshare=[NSString stringWithFormat:@"You have been invited to use the Tamm app!\n\n\nDownload the app on your iPhone from http://www.tammapp.com and buy & sell items!"];
        
        
        NSArray *activityItems1=@[texttoshare];
        NSArray *activityItems =@[UIActivityTypePrint,UIActivityTypeAirDrop,UIActivityTypeAssignToContact,UIActivityTypeAddToReadingList,UIActivityTypeOpenInIBooks];
        UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems1 applicationActivities:nil];
        activityViewControntroller.excludedActivityTypes = activityItems;
        [self presentViewController:activityViewControntroller animated:YES completion:nil];
    }

}


-(void) button_threedots_action:(id)sender
{
     NSLog(@"threedots");
    NSLog(@"threedots");
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"احذف إعلاني",nil];
    popup.tag = 777;
    [popup showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((long)actionSheet.tag == 777)
    {
        NSLog(@"INDEXAcrtionShhet==%ld",(long)buttonIndex);
        
        if (buttonIndex== 1)
        {
            
            
        }
        if (buttonIndex== 0)
        {
            
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"حذف الإعلان؟" message:@"هل انت متأكد من حذف هذا الإعلان؟ سوف يتم حذفه من تطبيق تم نهائيا."preferredStyle:UIAlertControllerStyleAlert];

//            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Delete Post?" message:@"Are you sure you want to delete your post? This will remove your post from App permanently."preferredStyle:UIAlertControllerStyleAlert];

            
            UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                            [self.view showActivityViewWithLabel:@"Deleting post..."];
                                            
                                            [self deletePostConnection];
                                            
                                        }];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                           
                                       }];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
           
            
           // [self deletePostConnection];
        }
    }
    
}

-(void) button_favourite_action:(id)sender
{
    
}
-(void) button_back_action:(id)sender
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
//    if ([[defaults valueForKey:@"imagetapped"] isEqualToString:@"yes"])
//    {
//        [defaults setObject:@"no" forKey:@"imagetapped"];
//        [defaults synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        
//    }
//    else
//    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//    
    
}


#pragma mark - PopOver Button Action


- (void)closedd:(id)sender
{
    [self.view endEditing:YES];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    transparentView.hidden=YES;
    
}


#pragma mark - EnterPrice XIB

- (void)confirm:(id)sender
{
    
    /* FOR PAYMENTS POPUP (BANK / CREDIT CARD)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDisable" object:self userInfo:nil];
    transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    myCustomXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"EnterPrice" owner:self options:nil]objectAtIndex:0];
    
    myCustomXIBViewObj.frame = CGRectMake((self.view.frame.size.width- myCustomXIBViewObj.frame.size.width)/2,self.view.frame.size.width - 250, myCustomXIBViewObj.frame.size.width, myCustomXIBViewObj.frame.size.height);
    
    
    [self.view addSubview:myCustomXIBViewObj];
    
    [myCustomXIBViewObj.bankButton addTarget:self action:@selector(bankButton_Action:) forControlEvents:UIControlEventTouchUpInside];
    [myCustomXIBViewObj.bankButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [myCustomXIBViewObj.creditButton addTarget:self action:@selector(creditButton_Action:) forControlEvents:UIControlEventTouchUpInside];
    [myCustomXIBViewObj.creditButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        [myCustomXIBViewObj.bankButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -168)];
        [myCustomXIBViewObj.creditButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, -176)];
    }
    else
    {
        
    }
    
    [myCustomXIBViewObj.priceTextField addTarget:self action:@selector(enterInLabel ) forControlEvents:UIControlEventEditingChanged];
    
    myCustomXIBViewObj.priceTextField.delegate = self;
    [myCustomXIBViewObj.priceTextField becomeFirstResponder];
    myCustomXIBViewObj.postIdLabel.text = [NSString stringWithFormat:@"%@%@",[Array_UserInfo valueForKey:@"postid"],@" :رقم الإعلان"];//POST ID
    myCustomXIBViewObj.layer.cornerRadius = 10;
    myCustomXIBViewObj.clipsToBounds = YES;
    
    [myCustomXIBViewObj setUserInteractionEnabled:YES];
    UITapGestureRecognizer *viewTapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped_Action:)];
    [myCustomXIBViewObj addGestureRecognizer:viewTapped];
    
    [transparentView1 addSubview:myCustomXIBViewObj];
    [self.view addSubview:transparentView1];
    transparentView.hidden=YES;
    
    myCustomXIBViewObj.bankButton.enabled = NO;
    [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
    
    myCustomXIBViewObj.creditButton.enabled = NO;
    [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
     */
    
    [self.view showActivityViewWithLabel:@"Closing Post..."];
    paymentmodeStr = @"FREE";
    [self ItemSold_Connection];
    NSLog(@"item_sold_free Pressed");
    [self.view endEditing:YES];
    [defaults setObject:@"yes" forKey:@"refreshView"];

   
}
-(void)viewTapped_Action:(UIGestureRecognizer *)reconizer
{
    [self.view endEditing:YES];
}

-(void)enterInLabel
{
//    NSString *askingpriceValString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
//    askingpriceValString = [askingpriceValString substringFromIndex:1];
    
    NSString *askingpriceValString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
    askingpriceValString = [askingpriceValString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];
    
    float j = [askingpriceValString floatValue];
    
    float k = ((1*j)/100); //0.75 instead of 1
    
    myCustomXIBViewObj.caculatedAmountLabel.text =[NSString stringWithFormat:@"ر.س %0.2f",k]; //[NSString stringWithFormat:@"$ %@",askingpriceValString];//$
    
    if ([myCustomXIBViewObj.priceTextField.text isEqualToString:@"ر.س"])//$
    {
        
        myCustomXIBViewObj.bankButton.enabled = NO;
        [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
        myCustomXIBViewObj.creditButton.enabled = NO;
        [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
        
    }
    

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (myCustomXIBViewObj.priceTextField.text.length == 0)
    {
        myCustomXIBViewObj.priceTextField.text = @"ر.س";//$
    
    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [myCustomXIBViewObj.priceTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![newText hasPrefix:@"ر.س"])//$
    {
        
        myCustomXIBViewObj.bankButton.enabled = NO;
        [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
        myCustomXIBViewObj.creditButton.enabled = NO;
        [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
        
        
        return NO;
    }
    
    myCustomXIBViewObj.bankButton.enabled = YES;
    [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    myCustomXIBViewObj.creditButton.enabled = YES;
    [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    
    
    
    // Default:
    
    NSLog(@"%lu",textField.text.length);
    
    return YES;
    
}

-(void)bankButton_Action:(id)sender
{
    // [self.view showActivityViewWithLabel:@"Making payment..."];
    paymentmodeStr = @"BANK";
    
   // [self ItemSold_Connection];
    NSLog(@"Bank button Pressed");
    [self.view endEditing:YES];
    
    
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Bank Details" message:@"Please transfer the amount to the below bank details:\n\nBank name: ABC Bank\nBank branch: JVPD\nIFSC Code : 123ABC\nAccount No.:7894123415487\n\nPlease mail us the reference no. to support@tammapp.com once you have made the payment.\n\nAre you sure you wish to make payment?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                {
                                    [self.view showActivityViewWithLabel:@"Making payment..."];
                                    [self ItemSold_Connection];
                                    [defaults setObject:@"yes" forKey:@"refreshView"];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                   
                                   
                               }];
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];

    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)creditButton_Action:(id)sender
{
    [self.view showActivityViewWithLabel:@"Making payment..."];
    paymentmodeStr = @"CARD";
    [self ItemSold_Connection];
    NSLog(@"creditButton_Action Pressed");
    [self.view endEditing:YES];
    [defaults setObject:@"yes" forKey:@"refreshView"];
    
}

- (void)Hide_Popover
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    transparentView1.hidden= YES;
    [self.view endEditing:YES];
}

- (void)Hide_BoostPopover
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    transparentView1.hidden= YES;
}


-(void)sectionHeaderTopButtonPressed:(id)sender
{
    if ([sender tag]== 1)
    {
        NSLog(@"3 Dots Pressed");
        
        NSLog(@"threedots");
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"بلّغ محتوى غير مناسب",nil];//Report as inappropriate,cancel
        popup.tag = 777;
        [popup showInView:self.view];
        
        
    }
    else if ([sender tag]== 2)
    {
        NSLog(@"Whitefavourite Pressed");
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
            transparentView.hidden = YES;
            NSLog(@"Whitearrow Pressed");
    }
    
}

#pragma mark -postCommentButtonPressed

-(void)postCommentButtonPressed:(id)sender
{
    
    NSLog(@"post comment Pressed");
    
    transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    grayView=[[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-275)/2,self.view.frame.size.width - 250, 275, 225)];
    grayView.layer.cornerRadius=20;
    grayView.clipsToBounds = YES;
    [grayView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
    UIButton *closeview=[[UIButton alloc]initWithFrame:CGRectMake(8, 8, 30, 30)];
    [closeview setTitle:@"X" forState:UIControlStateNormal];
    [closeview setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [closeview addTarget:self action:@selector(closedd1:)
        forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:closeview];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(75, 8, 184, 30)];
    label1.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:17];
    label1.textAlignment = NSTextAlignmentRight;
    label1.text = @"أضف تعليق";//@"Post comment";
    label1.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [grayView addSubview:label1];
    
    
    commentPostTextView1 = [[UITextView alloc]initWithFrame:CGRectMake(16, 49, 243, 128)];
    commentPostTextView1.textAlignment = NSTextAlignmentRight;
    commentPostTextView1.font = [UIFont fontWithName:@"SanFranciscoDisplay-medium" size:17];
    commentPostTextView1.layer.cornerRadius = 4;
    commentPostTextView1.clipsToBounds = YES;
    commentPostTextView1.keyboardType = UIKeyboardTypeDefault;
    commentPostTextView1.spellCheckingType = NO;
    commentPostTextView1.autocorrectionType = NO;
    commentPostTextView1.delegate = self;
    [commentPostTextView1 becomeFirstResponder];
    
    [grayView addSubview:commentPostTextView1];
    
    postplaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 49, 231, 30)];
    postplaceholderLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-medium" size:17];
    postplaceholderLabel.textAlignment = NSTextAlignmentRight;
    postplaceholderLabel.text = @"اكتب تعليقك هنا...";//@"Type your comment here...";
    
    postplaceholderLabel.textColor = [UIColor lightGrayColor];
    [grayView bringSubviewToFront:postplaceholderLabel];
    [grayView addSubview:postplaceholderLabel];
    
    submitPostButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 191, 275, 34)];
    [submitPostButton setTitle:@"ارسل" forState:UIControlStateNormal];//submit
    [submitPostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitPostButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16];
    
    submitPostButton.enabled = NO;
    [submitPostButton setBackgroundColor:[UIColor grayColor]];
    
    // [submitPostButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    [submitPostButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:submitPostButton];
    
    
    [transparentView1 addSubview:grayView];
    
    [self.view addSubview:transparentView1];
}

- (void)closedd1:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    
    [self.view endEditing:YES];
    
    transparentView1.hidden=YES;
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@""])
    {
        postplaceholderLabel.hidden = NO;
        submitPostButton.enabled = NO;
        [submitPostButton setBackgroundColor:[UIColor grayColor]];
        
    }
    else
        
    {
        postplaceholderLabel.hidden = YES;
        submitPostButton.enabled = YES;
        [submitPostButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        postplaceholderLabel.hidden = NO;
        
    }
    else
        
    {
        postplaceholderLabel.hidden = YES;
        
    }
}
- (void)submit:(id)sender
{
    
    [self.view showActivityViewWithLabel:@"Posting..."];
    
    [self AddChat_Connection];
    
}

#pragma mark - AddChat_Connection

-(void)AddChat_Connection
{
    
    
    
    NSString *postid= @"postid";
    NSString *postidVal =[Array_UserInfo  valueForKey:@"postid"];
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    NSString *message= @"message";
    NSString *messageVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)commentPostTextView1.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    NSString *chat= @"chattype";
    NSString *chattypeVal =@"TEXT";
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,message,messageVal,chat,chattypeVal];
    
    
    

    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"addchat"];;
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
                                                 
                                                 Array_Comments=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_Comments=[objSBJsonParser objectWithData:data];
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 NSLog(@"Array_Comments %@",Array_Comments);
                                                 
                                                 NSLog(@"array_login ResultString %@",ResultString);
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
                                                     
                                                     
                                                     [self.view endEditing:YES];
                                                     transparentView1.hidden= YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                   //  [defaults setObject:@"no" forKey:@"SeeCommentPressed"];
                                                     
                                                     seeCommentStr = @"no";
                                                     
                                                     [self ChatCommentConnection];
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"inserterror" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"messagenull"])
                                                 {
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"messagenull" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"nullerror"])
                                                 {
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"nullerror" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 
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


-(void)seeCommentButtonPressed:(id)sender
{
    
    
    
   // if ([[defaults valueForKey:@"SeeCommentPressed"]isEqualToString:@"no"])
      if ([seeCommentStr isEqualToString:@"no"])
    {
      //  [defaults setObject:@"yes" forKey:@"SeeCommentPressed"];
        seeCommentStr = @"yes";
        
        [cell_seeallcomments.Button_SeeAllComments setTitle:@"تعليقات أقل" forState:UIControlStateNormal];//see less comment
        
        [self.tableView reloadData];
        
        
//        if (Array_Chats.count > 0)
//            
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

        
        NSLog(@"See Less Comments");
        
        
    }
    else
    {
        
        [cell_seeallcomments.Button_SeeAllComments setTitle:@"عرض جميع التعليقات" forState:UIControlStateNormal];//See all comments
        
        //[defaults setObject:@"no" forKey:@"SeeCommentPressed"];
        seeCommentStr = @"no";
        
        [self.tableView reloadData];
        
        NSLog(@"See all comments");
    }
    
}




-(void)MoreImage:(UITapGestureRecognizer *)sender
{
#pragma mark- --more image scroll view
    
    if (total_image == 1)
    {
        UIGestureRecognizer *rec = (UIGestureRecognizer*)sender;
        UIImageView *imageView1 = (UIImageView *)rec.view;
        NSLog(@"ImageTappedscroll ImageTappedscroll==%ld", (long)imageView1.tag);
        
        
     //   if ([[[Array_Moreimages objectAtIndex:(long)imageView1.tag] valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
       // {
          //  NSURL *url=[NSURL URLWithString:[[Array_Moreimages objectAtIndex:(long)imageView1.tag]valueForKey:@"mediaurl"]];
        
        
        
            movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
            [self presentMoviePlayerViewControllerAnimated:movieController];
            [movieController.moviePlayer prepareToPlay];
            [movieController.moviePlayer play];
        
            
            
            
//        }
//        else
//        {
//            [self displayImage:FirstCell.imageView_thumbnails withImage:FirstCell.imageView_thumbnails.image];
//        }
        
        
        
        
        
    }
    else
    {
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDisable" object:self userInfo:nil];
        
        transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        transparentView.backgroundColor=[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.95];
        
        transparentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
         [transparentView setAutoresizesSubviews:YES];
        
        NSLog(@"FirstCell=%f",FirstCell.button_threedots.frame.origin.y);
        NSLog(@"cell two=%f",Cell_two.button_threedots.frame.origin.y);
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(button_threeDotsx,button_threeDotsy, button_threeDotsw, button_threeDotsh)];
        [button1 setImage:[UIImage imageNamed:@"3dots"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
       [transparentView addSubview:button1];
        
        UIButton *button1B = [[UIButton alloc]initWithFrame:CGRectMake(button_threeDotsBigx,button_threeDotsBigy, button_threeDotsBigw, button_threeDotsBigh)];
        [button1B setTag:1];
        [button1B addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [transparentView addSubview:button1B];

        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(button_favx, button_favy, button_favw, button_favh)];
        [button2 setImage:[UIImage imageNamed:@"Whitefavourite"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //[transparentView addSubview:button2];
        
        UIButton *button3;
        
        if ([[UIScreen mainScreen]bounds].size.width == 320)
        {
            button3 = [[UIButton alloc]initWithFrame:CGRectMake(button_arrowx- button_arroww + 16, button_arrowy, button_arroww, button_arrowh)];
        }
        else if ([[UIScreen mainScreen]bounds].size.width == 414)
        {
            button3 = [[UIButton alloc]initWithFrame:CGRectMake(button_arrowx+35 , button_arrowy, button_arroww, button_arrowh)];
        }
        else
        {
//            if ([UIScreen mainScreen].bounds.size.width==375 && [UIScreen mainScreen].bounds.size.height==812)
//            {
//                   button3 = [[UIButton alloc]initWithFrame:CGRectMake(button_arrowx, button_arrowy+20, button_arroww, button_arrowh-5)];
//                [button1 setFrame:CGRectMake(button_threeDotsx,button_threeDotsy+20, button_threeDotsw, button_threeDotsh-2)];
//
//                [button1B setFrame:CGRectMake(button_threeDotsBigx,button_threeDotsBigy+19, button_threeDotsBigw, button_threeDotsBigh)];
//
//            }
//            else
//            {
                button3 = [[UIButton alloc]initWithFrame:CGRectMake(button_arrowx, button_arrowy, button_arroww, button_arrowh)];
//            }
         
        }
        
        
        
        button3.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        [button3 setAutoresizesSubviews:YES];
       
        [button3 setImage:[UIImage imageNamed:@"Whitearrow"] forState:UIControlStateNormal];
        [button3 setTag:3];
        [button3 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [transparentView addSubview:button3];
       
        
              scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,160,self.view.frame.size.width , self.view.frame.size.height -160)];
       
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.center = transparentView.center;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        if ([UIScreen mainScreen].bounds.size.width==375 && [UIScreen mainScreen].bounds.size.height==812)
        {
            [scrollView setFrame:CGRectMake(0,scrollView.frame.origin.y-35,scrollView.frame.size.width , scrollView.frame.size.height)];
        }
        
        for(UIImageView* view in scrollView.subviews)
        {
            
            [view removeFromSuperview];
            
        }
        for(UIButton* view in scrollView.subviews)
        {
            
            [view removeFromSuperview];
            
        }

        
        
        
        
        for (int i = 0; i < total_image; i++ )
        {
            int page = scrollView.contentOffset.x / scrollView.frame.size.width;
            
            CGRect frame;
            frame.origin.x = scrollView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = scrollView.frame.size;
            
            imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView.userInteractionEnabled=YES;
            imageView.clipsToBounds=YES;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag=i;
            
            playButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
            [playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
            playButton.center=imageView.center;
            playButton.tag=i;
            playButton.backgroundColor=[UIColor clearColor];
            [scrollView addSubview:imageView];
            [scrollView addSubview:playButton];
            
            playButton.hidden = YES;
            
            NSLog (@"page %d",page);
            
            if (i==0)
            {
                NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"mediathumbnailurl"]];
                [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                if ([[Array_UserInfo valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
                {
                    playButton.hidden = NO;
                    
                    
                }
            }
            else if (i==1)
            {
                
                NSURL *url1=[NSURL URLWithString:[Array_UserInfo valueForKey:@"mediathumbnailurl1"]];
                
                [imageView setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                if ([[Array_UserInfo valueForKey:@"mediatype1"] isEqualToString:@"VIDEO"])
                {
                    playButton.hidden = NO;
                    
                    
                }
            }
            else
            {
                NSURL *url1=[NSURL URLWithString:@""];
                
                [imageView setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                playButton.hidden = YES;
            }
            
            
            
            
            
            
            
            
        }
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.
                                            width *total_image,
                                            scrollView.frame.size.height);
        
        pageControll = [[UIPageControl alloc]init];
        pageControll.frame = CGRectMake(transparentView.frame.size.width/2-20, transparentView.frame.size.height - 100, 40, 10);
        pageControll.numberOfPages = total_image;
        pageControll.currentPage = 0;
        [pageControll setPageIndicatorTintColor:[UIColor grayColor]];
        
        [transparentView addSubview:scrollView];
        [transparentView addSubview:pageControll];
        [self.view addSubview:transparentView];
        
        [self Communication_moreImage];
    }
}
-(void)Communication_moreImage
{
    
    
    NSString *postid= @"postid";
    NSString *postidVal =[Array_UserInfo  valueForKey:@"postid"];
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",postid,postidVal,userid,useridVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"postimages"];;
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
                                                 
                                                 Array_Moreimages=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_Moreimages=[objSBJsonParser objectWithData:data];
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 //        Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_Swipe options:kNilOptions error:nil];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 NSLog(@"array_loginarray_login %@",Array_Moreimages);
                                                 
                                                 NSLog(@"array_login ResultString %@",ResultString);
                                                 if ([ResultString isEqualToString:@"nullerror"])
                                                 {
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@" " preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"noimages"])
                                                 {
                                                     

                                                     
                                                     transparentView.hidden = YES;
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                     
                                                 }
                                                 if(Array_Moreimages.count !=0)
                                                 {
                                                     
                                                     
                                                     for(UIImageView* view in scrollView.subviews)
                                                     {
                                                         
                                                         [view removeFromSuperview];
                                                         
                                                     }
                                                     for(UIButton* view in scrollView.subviews)
                                                     {
                                                         
                                                         [view removeFromSuperview];
                                                         
                                                     }

                        for (int i = 0; i < Array_Moreimages.count; i++ )
                                                     {
                                                         int page = scrollView.contentOffset.x / scrollView.frame.size.width;
                                                         
                                                         CGRect frame;
                                                         frame.origin.x = scrollView.frame.size.width * i;
                                                         frame.origin.y = 0;
                                                         frame.size = scrollView.frame.size;
                                                         
                                                         imageView1 = [[UIImageView alloc] initWithFrame:frame];
                                                         imageView1.userInteractionEnabled=YES;
                                                         imageView1.clipsToBounds=YES;
                                                         imageView1.contentMode = UIViewContentModeScaleAspectFit;
                                                         imageView1.tag=i;
                                                         
                                                         playButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
                                                         [playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
                                                         playButton.center=imageView1.center;
                                                         playButton.tag=i;
                                                         playButton.backgroundColor=[UIColor clearColor];
                                                         
                                                         NSURL *url=[NSURL URLWithString:[[Array_Moreimages objectAtIndex:i] valueForKey:@"mediathumbnailurl"]];
                                                         
                                                         //                                   [imageView sd_setShowActivityIndicatorView:YES];
                                                         //                                   [imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
                                                         
                                                         [imageView1 setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                                          
                                                         [scrollView addSubview:imageView1];
                                                         [scrollView addSubview:playButton];
                                                         
                                                         
                                                         NSLog (@"page %d",page);
                                                         
                                                        
//                                  NSURL *url=[NSURL URLWithString:[[Array_Moreimages objectAtIndex:i] valueForKey:@"mediathumbnailurl"]];
//                                                         
////                                   [imageView sd_setShowActivityIndicatorView:YES];
////                                   [imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
//
//                                    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
                                                         
                                    
                                              
                                  
                     
                            if ([[[Array_Moreimages objectAtIndex:i] valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
                                                         {
                                                             playButton.hidden = NO;
                                                           
                                                             playButton.userInteractionEnabled=YES;
                    UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTappedscroll:)];
                            [imageView1 addGestureRecognizer:ImageTap];
                        UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTappedscroll:)];
                            [playButton addGestureRecognizer:ImageTap1];
                                                             
                                                         }
                                                         else
                                                         {
                            [self displayImage:imageView1 withImage:imageView1.image];
                                                             playButton.hidden = YES;
                                                             
                                                         }
                                                         
                                                         
                   
                                                         
                                                         
                                                         
                                                     }
                                                     
                           scrollView.contentSize = CGSizeMake(scrollView.frame.size.width *Array_Moreimages.count,scrollView.frame.size.height);
                                                     
                          pageControll.frame = CGRectMake(transparentView.frame.size.width/2-20, transparentView.frame.size.height - 100, 40, 10);
                         pageControll.numberOfPages = Array_Moreimages.count;
                          pageControll.currentPage = 0;
                                                   
                                     
                                                 
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
-(void)ImageTappedscroll:(UIGestureRecognizer *)reconizer
{
    UIGestureRecognizer *rec = (UIGestureRecognizer*)reconizer;
    
    UIImageView *imageView1 = (UIImageView *)rec.view;
    NSLog(@"ImageTappedscroll ImageTappedscroll==%ld", (long)imageView1.tag);
    NSURL *url=[NSURL URLWithString:[[Array_Moreimages objectAtIndex:(long)imageView1.tag]valueForKey:@"mediaurl"]];
    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    
    
    
    [self presentMoviePlayerViewControllerAnimated:movieController];
    [movieController.moviePlayer prepareToPlay];
    [movieController.moviePlayer play];
}
- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image
{
    [imageView setImage:image];
    [imageView setupImageViewer];
    
}

#pragma mark - ChatConnectionCommunication
-(void)ChatCommentConnection
{
    //[defaults setObject:@"no" forKey:@"SeeCommentPressed"];
   

    
    NSString *postid= @"postid";
    NSString *postidVal =[Array_UserInfo  valueForKey:@"postid"];
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",postid,postidVal,userid,useridVal];
    

    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"chatcomments"];;
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
                                                 
                                                 Array_Chats=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_Chats =[objSBJsonParser objectWithData:data];
                                                 
                                                 NSLog(@"array count = %d",Array_Chats.count);
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_Chats %@",Array_Chats);
                                                 
                                                 if ([ResultString isEqualToString:@"nochat"])
                                                 {
                                                     nochats = ResultString;
                                                     
                                                     
                                                     [self.tableView reloadData];
                                                     
                                                      
                                                 }
                                                 
                                                 if ( Array_Chats.count != 0)
                                                 {
                                                      seeCommentStr = @"no";
                                                     nochats = @"";
                                                     [self.tableView reloadData];
                                                     
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

#pragma mark - ItemSold Connection
-(void)ItemSold_Connection
{
    
    NSString *postid= @"postid";
    NSString *postidVal =[Array_UserInfo  valueForKey:@"postid"];
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    
//    NSString *enterPriceString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
//    enterPriceString = [enterPriceString substringFromIndex:1];
    
    NSString *enterPriceString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
    enterPriceString = [enterPriceString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];
    NSInteger number = [enterPriceString intValue];
  
    NSString *price= @"sellprice";
    NSString *priceVal = [NSString stringWithFormat:@"%ld",number];
    
    
//    NSString *transactionString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.caculatedAmountLabel.text];
//    transactionString = [transactionString substringFromIndex:1];
    
    NSString *transactionString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.caculatedAmountLabel.text];
    transactionString = [transactionString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];

    
  
    
    NSString *transaction= @"commission";
    NSString *transactionVal = transactionString;
    
    NSString *paymentmode= @"paymentmode";
    NSString *paymentmodeVal = paymentmodeStr;

    
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,price,priceVal,transaction,transactionVal,paymentmode,paymentmodeVal];
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"itemsold"];;
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
                                                 
                                                 Array_ItemSold=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_ItemSold =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_ItemSold %@",Array_ItemSold);
                                                 
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
                                                     
                                                     [self.view endEditing:YES];
                                                     transparentView1.hidden= YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                     CATransition *transition = [CATransition animation];
                                                     transition.duration = 0.3;
                                                     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                     transition.type = kCATransitionPush;
                                                     transition.subtype = kCATransitionFromRight;
                                                     [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                                                     
                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                     
                                                     
                                                      
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"The server encountered some error, please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                                                                          
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"nopostid"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This item is no more available and has probably been sold by the seller." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                        
                                                     
                                                     
                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"nullerror"])
                                                 {
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Please enter the price at which the item has been sold." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                 }
                                                 
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 
                                                 
                                                 
                                                 
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

-(void)favouriteImage_ActionDetails:(UIGestureRecognizer *)reconizer
{
    

    
    NSLog(@"FAVORITE TAPPED");
    
    NSString *postid= @"postid";
    NSString *postidVal =[Array_UserInfo  valueForKey:@"postid"];
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",postid,postidVal,userid,useridVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"addfavourite"];;
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
                                                 
                                                 Array_Favourite=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_Favourite =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_Favourite %@",Array_Favourite);
                                                 
                                                 if ([ResultString isEqualToString:@"inserted"])
                                                 {
                                                     
                                                     str_fav = @"inserted";
                                                     
                                                     fav = true;
                                                     
                                                     
                                                     
                                                     [self.tableView reloadData];
                                                     
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"deleted"])
                                                 {
                                                     
                                                     str_fav = @"deleted";
                                                     
                                                     fav = true;
                                                     
                                                     [self.tableView reloadData];
                                                     
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

#pragma mark - Boost

-(void)floatButtonAction:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDisable" object:self userInfo:nil];
    transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    myBoostXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"BoostPost" owner:self options:nil]objectAtIndex:0];
    
    myBoostXIBViewObj.frame = CGRectMake((self.view.frame.size.width- myBoostXIBViewObj.frame.size.width)/2,self.view.frame.size.width - 250, myBoostXIBViewObj.frame.size.width, myBoostXIBViewObj.frame.size.height);
    
    
    [self.view addSubview:myBoostXIBViewObj];
    
   
    
    myBoostXIBViewObj.postIdLabel.text = [NSString stringWithFormat:@"%@%@",[Array_UserInfo valueForKey:@"postid"],@" :رقم الإعلان"];//POST ID
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
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    boostpackVal = @"24H";
    boostAmountVal = @"4";
    [self boostConnection];
    
}
-(void)imageViewButton2_Action:(UIGestureRecognizer *)reconizer
{
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    boostpackVal = @"48H";
    boostAmountVal = @"6";
    NSLog(@"imageViewButton2_Action");
    [self boostConnection];

}


-(void)imageViewButton3_Action:(UIGestureRecognizer *)reconizer
{
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    NSLog(@"imageViewButton3_Action");
    boostpackVal = @"72H";
    boostAmountVal = @"10";
    [self boostConnection];

}

-(void)boostConnection
{
    NSString *postid= @"postid";
    NSString *postidVal =[Array_UserInfo  valueForKey:@"postid"];
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    NSString *boostpack= @"boostpack";
    
    
    NSString *boostamount= @"boostamount";
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,boostpack,boostpackVal,boostamount,boostAmountVal];
    
    
    
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
                                                     
//                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Boosted" message:@"Thank-you for your payment, your post has been successfully boosted!" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"تم الترويج!" message:@"شكراً لتسديدك المبلغ! إعلانك تم ترويجه بنجاح!" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"حسنا"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:^(UIAlertAction *action)
                                                                                {
                                                                                   
                                                                                    [defaults setObject:@"yes" forKey:@"refreshView"];
                                                                                    CATransition *transition = [CATransition animation];
                                                                                    transition.duration = 0.3;
                                                                                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                                    transition.type = kCATransitionPush;
                                                                                    transition.subtype = kCATransitionFromRight;
                                                                                    
                                                                                    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                                                                                    
                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                    
                                                                                    
                                                                                    
                                                                                }];
                                                     
                                                     
                                                 
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];

                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"alreadyboosted"])
                                                 {
                                                     
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
//                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your post is already boosted. Please wait for it to get over to boost again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"تنبيه!" message:@"إعلانك قد تم ترويجه. الرجاء المحاولة مرة أخرى عند انتهاء الوقت." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"حسنا"
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
                                                 
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 
                                                 
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

-(void)deletePostConnection
{
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Tamm." preferredStyle:UIAlertControllerStyleAlert];
        
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
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *postID= @"postid";
        NSString *postIDVal=[Array_UserInfo  valueForKey:@"postid"];

        
        
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",userid,useridVal,postID,postIDVal];
        
        
#pragma mark - swipe sesion
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"deletepost"];;
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
                                                     
                                                     
                                                     
                                                     
                                                     //  SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                     
                                                     NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     
                                                     if ([ResultString isEqualToString:@"done"])
                                                     {
                                                         
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"حُذِف الإعلان" message:@"تم حذف الإعلان من التطبيق نهائيا." preferredStyle:UIAlertControllerStyleAlert];

//                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Post Deleted" message:@"The post has been successfully deleted." preferredStyle:UIAlertControllerStyleAlert];

                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault
                                                                                                          handler:^(UIAlertAction *action)
                                                                                    {
                                                                                        
                                                                                        [defaults setObject:@"yes" forKey:@"refreshView"];
                                                                                        CATransition *transition = [CATransition animation];
                                                                                        transition.duration = 0.3;
                                                                                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                                        transition.type = kCATransitionPush;
                                                                                        transition.subtype = kCATransitionFromRight;
                                                                                        
                                                                                        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                                                                                        
                                                                                        [self.navigationController popViewControllerAnimated:YES];
                                                                                        
                                                                                        
                                                                                        
                                                                                    }];

                                                         [alertController addAction:actionOk];
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                     }
                                                     if ([ResultString isEqualToString:@"deleteerror"])
                                                     {
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This post could not be deleted . Please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault
                                                                                                          handler:nil];
                                                         [alertController addAction:actionOk];
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                     }
                                                     
                                                     
                                                     
                                                     [self.view hideActivityViewWithAfterDelay:0];
                                                     
                                                     
                                                     
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
    };
    

    
    
    
}



@end
