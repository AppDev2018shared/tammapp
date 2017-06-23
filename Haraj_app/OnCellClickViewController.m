//
//  OnCellClickViewController.m
//  Haraj_app
//
//  Created by Spiel on 08/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "OnCellClickViewController.h"
#import "FirstImageViewCell.h"
#import "UIImageView+WebCache.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "MyPostViewController.h"
#import "OnCellClickViewController.h"
#import "MoreImageScrollViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDAVAssetExportSession.h"
#import <AVFoundation/AVFoundation.h>
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "EnterComment.h"
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH self.view.frame.size.width-138

#define CELL_CONTENT_MARGIN 0.0f

@interface OnCellClickViewController ()<UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIView *sectionView, *transparentView1;
    
    UIScrollView *scrollView;
    UIImageView *imageView;
    UIPageControl *pageControll;
    
    NSString *nochats;
   
    FirstImageViewCell *FirstCell;
   
    NSInteger total_image;
    NSURL * imageUrl;
    NSUserDefaults *defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_MakeOffer, *Connection_SuggestPost;
    NSMutableData *webData_MakeOffer, *webData_SuggestPost;
    NSMutableArray *Array_MakeOffer, *Array_SuggestPost,*Array_Moreimages, *Array_Chats, *Array_Comments,*Array_Favourite;
    NSString * back_Arrow_Check;
    
    CGFloat newCellHeight;
    CGFloat Xpostion, Ypostion, Xwidth, Yheight, ScrollContentSize,Xpostion_label, Ypostion_label, Xwidth_label, Yheight_label,Cell_DescLabelX,Cell_DescLabelY,Cell_DescLabelW,Cell_DescLabelH,TextView_ViewX,TextView_ViewY,TextView_ViewW,TextView_ViewH;
    CGFloat FavIV_X,FavIV_Y,FavIV_W,FavIV_H,FavLabel_X,FavLabel_Y,FavLabel_W,FavLabel_H;
     CGFloat button_threeDotsx,button_threeDotsy,button_threeDotsw,button_threeDotsh,button_favx,button_favy,button_favw,button_favh,button_arrowx,button_arrowy,button_arroww,button_arrowh;
    
    NSString *str_LabelCoordinates,*str_TappedLabel,*str_postid,*str_userid, *str_fav;
    NSString *text;
    BOOL fav;
    
    
    UITextField *amountTextField ;
    UITextView *commentTextView, *commentPostTextView1;
    UILabel * postplaceholderLabel;
    UIButton *seeCommentButton, *confirmOfferButton, *submitPostButton;
    
    
     MPMoviePlayerViewController *movieController ;
}

@end

@implementation OnCellClickViewController
@synthesize Array_UserInfo,swipeCount,Cell_two,MoreImageArray,detailCell,detailCellCar,detailCellProperty,ComCell,SuggestCell,Array_All_UserInfo,cell_postcomments;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    defaults = [[NSUserDefaults alloc]init];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    NSLog(@" array info %@",Array_UserInfo);
    
    
    total_image=[[Array_UserInfo  valueForKey:@"mediacount"] integerValue];
    str_TappedLabel=@"no";
    str_LabelCoordinates=@"no";
    
    text = [Array_UserInfo valueForKey:@"description"];
    if ([[defaults valueForKey:@"imagetapped"] isEqualToString:@"yes"])
    {
                str_postid= [Array_UserInfo  valueForKey:@"postid"];
                str_userid =[Array_UserInfo valueForKey:@"userid1"];
                [self SuggestPostConnection];
    }
    
    nochats = @"";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide_EnterCommentPopover) name:@"HideEnterCommentPopOver" object:nil];
    
    
     [defaults setObject:@"no" forKey:@"SeeCommentPressed"];
    


    
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[defaults valueForKey:@"imagetapped"] isEqualToString:@"yes"])
    {
//        str_postid= [Array_UserInfo  valueForKey:@"postid"];
//        str_userid =[Array_UserInfo valueForKey:@"userid1"];
//        [self SuggestPostConnection];
    }
    else
    {
        NSLog(@" array info %ld",(long)self.view.tag);
        NSLog(@" Array_All_UserInfo viewwillappear %@",Array_All_UserInfo);
        str_postid= [[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"postid"];
        str_userid =[[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"userid1"];
        NSLog(@" str_postid viewwillappear %@", [[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"postid"]);
        NSLog(@" str_userid viewwillappear %@",[[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"userid1"]);
        
        [self SuggestPostConnection];
        [self ChatCommentConnection];
    }
    
 

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



#pragma mark - Swipe Methods Left and Right



#pragma mark - TableView Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return 1;
    }
    else if (section == 3)
    {
        if ([[defaults valueForKey:@"SeeCommentPressed"]isEqualToString:@"no"])
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
        {
            
            return Array_Chats.count;
            
        }
        
        
        
    }
   
    else if (section == 4)
    {
        return 1;
    }
   
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // imageUrl=[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:indexPath.row]];
    
//    NSDictionary *dic_request=[Array_UserInfo objectAtIndex:swipeCount];
//    NSLog(@"dic= %@",dic_request);
    static NSString *cell_two1=@"Cell_Two";
    
    static NSString *cell_details=@"DetailCell";
    static NSString *cell_detailscar=@"DetailCellCar";
    static NSString *cell_detailsproperty=@"DetailCellProperty";

    
    
    
    
    static NSString *cell_comments=@"ComCell";
    
    static NSString *cell_suggest=@"PostCell";
    static NSString *post_comments=@"PostCell1";
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
                [Cell_two.button_favourite addTarget:self action:@selector(button_favourite_action:) forControlEvents:UIControlEventTouchUpInside];
                [Cell_two.button_back addTarget:self action:@selector(button_back_action:) forControlEvents:UIControlEventTouchUpInside];
                UITapGestureRecognizer * moreTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreImage:)];
                if (total_image>=3)
                {
                    Cell_two.bgView.hidden=NO;
                    Cell_two.countLabel.text =[NSString stringWithFormat:@"%d",total_image-2];
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
                
                [Cell_two.image1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                
                [Cell_two.image2 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                
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
                
                [FirstCell.button_threedots addTarget:self action:@selector(button_threedots_action:) forControlEvents:UIControlEventTouchUpInside];
                [FirstCell.button_favourite addTarget:self action:@selector(button_favourite_action:) forControlEvents:UIControlEventTouchUpInside];
                [FirstCell.button_back addTarget:self action:@selector(button_back_action:) forControlEvents:UIControlEventTouchUpInside];
                
                button_threeDotsx=FirstCell.button_threedots.frame.origin.x;
                button_threeDotsy=FirstCell.button_threedots.frame.origin.y;
                button_threeDotsw=FirstCell.button_threedots.frame.size.width;
                button_threeDotsh=FirstCell.button_threedots.frame.size.height;
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
                
                [FirstCell.imageView_thumbnails sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                
                
                FirstCell.imageView_thumbnails.userInteractionEnabled=YES;
                FirstCell.imageView_thumbnails.tag=swipeCount;
                
                if ([[Array_UserInfo valueForKey:@"mediathumbnailurl"] isEqualToString:@""])
                {
                    
                }
                else
                {
                
                UITapGestureRecognizer *imageTap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoreImage:)];
                [FirstCell.imageView_thumbnails addGestureRecognizer:imageTap4];
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
                    
                    
                    [detailCellCar.detailinfoTextView setText:text];
                    detailCellCar.locationLabel.text = [Array_UserInfo valueForKey:@"city1"];
                    detailCellCar.hashtagLabel.text = [Array_UserInfo valueForKey:@"hashtags"];
                    detailCellCar.postidLabel.text = [NSString stringWithFormat:@"POST ID: %@",[Array_UserInfo valueForKey:@"postid"]];
                    [defaults setObject:[Array_UserInfo valueForKey:@"postid"] forKey:@"post-id"];
                    
                    
                    detailCellCar.usernameLabel.text = [Array_UserInfo valueForKey:@"usersname"];
                    detailCellCar.durationLabel.text = [Array_UserInfo valueForKey:@"postdur"];
                    
                    NSString *show = [NSString stringWithFormat:@"$%@",[Array_UserInfo valueForKey:@"showamount"]];
                    detailCellCar.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
                    detailCellCar.timeLabel.text = [Array_UserInfo valueForKey:@"createtime"];
                    detailCellCar.titleLabel.text = [Array_UserInfo valueForKey:@"title"];
                    
                    detailCellCar.modelLabel.text = [Array_UserInfo valueForKey:@"carmodel"];
                    detailCellCar.mileageLabel.text = [NSString stringWithFormat:@"%@ KM",[Array_UserInfo valueForKey:@"carmileage"]];
                    
                    
                    
                    NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"usersprofilepic"]];
                    
                    [detailCellCar.profileImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
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
                    UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
                    [detailCellCar.tapView addGestureRecognizer:label_Desc_Tapped];
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
                    if ([str_TappedLabel isEqualToString:@"no"])
                    {
                        if ((long)rHeight==1)
                        {
                            
                            [detailCellCar.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH)];
                            
                            [detailCellCar.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH)];
                            
                            
                        }
                        else if ((long)rHeight==2)
                        {
                            
                            [detailCellCar.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*2)];
                            
                            [detailCellCar.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*2)];
                            
                            
                        }
                        else if ((long)rHeight>=3)
                        {
                            detailCellCar.tapView.userInteractionEnabled=YES;
                            detailCellCar.detailinfoTextView.textContainer.maximumNumberOfLines = 0;
                            detailCellCar.detailinfoTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
                            UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
                            [detailCellCar.tapView addGestureRecognizer:label_Desc_Tapped];
                            
                            [detailCellCar.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*2)];
                            
                            [detailCellCar.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*2)];
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                    else
                    {
                        
                        
                        CGRect newFrame = detailCellCar.detailinfoTextView.frame;
                        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
                        
                        detailCellCar.tapView.userInteractionEnabled=YES;
                        
                        UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
                        [detailCellCar.tapView addGestureRecognizer:label_Desc_Tapped];
                        [detailCellCar.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, newFrame.size.width,newFrame.size.height)];
                        [detailCellCar.detailinfoTextView setFrame:newFrame];
                        
                        
                    }
                    
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelX);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelY);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelW);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelH);
                    detailCellCar.tapView.backgroundColor=[UIColor clearColor];
                    
                    [detailCellCar.view_CordinateViewTapped setFrame:CGRectMake(detailCellCar.view_CordinateViewTapped.frame.origin.x,(detailCellCar.tapView.frame.origin.y+detailCellCar.tapView.frame.size.height)+23,detailCellCar.view_CordinateViewTapped.frame.size.width, detailCellCar.view_CordinateViewTapped.frame.size.height)];
                    
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
                    detailCellProperty.postidLabel.text = [NSString stringWithFormat:@"POST ID: %@",[Array_UserInfo valueForKey:@"postid"]];
                    [defaults setObject:[Array_UserInfo valueForKey:@"postid"] forKey:@"post-id"];
                    
                    
                    detailCellProperty.usernameLabel.text = [Array_UserInfo valueForKey:@"usersname"];
                    detailCellProperty.durationLabel.text = [Array_UserInfo valueForKey:@"postdur"];
                    
                    NSString *show = [NSString stringWithFormat:@"$%@",[Array_UserInfo valueForKey:@"showamount"]];
                    detailCellProperty.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
                    detailCellProperty.timeLabel.text = [Array_UserInfo valueForKey:@"createtime"];
                    detailCellProperty.titleLabel.text = [Array_UserInfo valueForKey:@"title"];
                    
                    detailCellProperty.propertyTypeLabel.text = [Array_UserInfo valueForKey:@"propertytype"];
                    
                    detailCellProperty.propertySizeLabel.text = [NSString stringWithFormat:@"%@ (Sqm)",[Array_UserInfo valueForKey:@"propertysize"]];
                    
                    detailCellProperty.noOfBedroomsLabel.text = [NSString stringWithFormat:@"%@ bedrooms",[Array_UserInfo valueForKey:@"noofrooms"]];
                    
                    
                    NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"usersprofilepic"]];
                    
                    [detailCellProperty.profileImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
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
                    UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
                    [detailCellProperty.tapView addGestureRecognizer:label_Desc_Tapped];
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
                    if ([str_TappedLabel isEqualToString:@"no"])
                    {
                        if ((long)rHeight==1)
                        {
                            
                            [detailCellProperty.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH)];
                            
                            [detailCellProperty.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH)];
                            
                            
                        }
                        else if ((long)rHeight==2)
                        {
                            
                            [detailCellProperty.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*2)];
                            
                            [detailCellProperty.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*2)];
                            
                            
                        }
                        else if ((long)rHeight>=3)
                        {
                            detailCellProperty.tapView.userInteractionEnabled=YES;
                            detailCellProperty.detailinfoTextView.textContainer.maximumNumberOfLines = 0;
                            detailCellProperty.detailinfoTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
                            UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
                            [detailCellProperty.tapView addGestureRecognizer:label_Desc_Tapped];
                            
                            [detailCellProperty.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*2)];
                            
                            [detailCellProperty.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*2)];
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                    else
                    {
                        
                        
                        CGRect newFrame = detailCellProperty.detailinfoTextView.frame;
                        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
                        
                        detailCellProperty.tapView.userInteractionEnabled=YES;
                        
                        UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
                        [detailCellProperty.tapView addGestureRecognizer:label_Desc_Tapped];
                        [detailCellProperty.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, newFrame.size.width,newFrame.size.height)];
                        [detailCellProperty.detailinfoTextView setFrame:newFrame];
                        
                        
                    }
                    
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelX);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelY);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelW);
                    NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelH);
                    detailCellProperty.tapView.backgroundColor=[UIColor clearColor];
                    
                    [detailCellProperty.view_CordinateViewTapped setFrame:CGRectMake(detailCellProperty.view_CordinateViewTapped.frame.origin.x,(detailCellProperty.tapView.frame.origin.y+detailCellProperty.tapView.frame.size.height)+23,detailCellProperty.view_CordinateViewTapped.frame.size.width, detailCellProperty.view_CordinateViewTapped.frame.size.height)];
                    
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
            
            
            [detailCell.detailinfoTextView setText:text];
            detailCell.locationLabel.text = [Array_UserInfo valueForKey:@"city1"];
            detailCell.hashtagLabel.text = [Array_UserInfo valueForKey:@"hashtags"];
            detailCell.postidLabel.text = [NSString stringWithFormat:@"POST ID: %@",[Array_UserInfo valueForKey:@"postid"]];
            [defaults setObject:[Array_UserInfo valueForKey:@"postid"] forKey:@"post-id"];
            
            
            detailCell.usernameLabel.text = [Array_UserInfo valueForKey:@"usersname"];
            detailCell.durationLabel.text = [Array_UserInfo valueForKey:@"postdur"];
            
            NSString *show = [NSString stringWithFormat:@"$%@",[Array_UserInfo valueForKey:@"showamount"]];
            detailCell.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
            detailCell.timeLabel.text = [Array_UserInfo valueForKey:@"createtime"];
            detailCell.titleLabel.text = [Array_UserInfo valueForKey:@"title"];
            
            
            NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"usersprofilepic"]];
            
            [detailCell.profileImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
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
            
            detailCell.tapView.userInteractionEnabled=YES;
            detailCell.tapView.tag=swipeCount;
           detailCell.detailinfoTextView.tag=swipeCount;
            UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
            [detailCell.tapView addGestureRecognizer:label_Desc_Tapped];
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
           // detailCell.detailinfoTextView.tag=indexPath.row;
          
            CGFloat fixedWidth = detailCell.detailinfoTextView.frame.size.width;
            CGSize newSize = [detailCell.detailinfoTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            NSInteger rHeight = size.height/17;
            NSLog(@"No of lines: %ld",(long)rHeight);
            detailCell.detailinfoTextView1.hidden=YES;
            if ([str_TappedLabel isEqualToString:@"no"])
            {
                if ((long)rHeight==1)
                {
                    
                    [detailCell.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH)];
                    
                    [detailCell.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH)];
                    
                    
                }
                else if ((long)rHeight==2)
                {
                    
                  [detailCell.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*2)];
                    
                    [detailCell.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*2)];
                    
                    
                }
                else if ((long)rHeight>=3)
                {
                    detailCell.tapView.userInteractionEnabled=YES;
                    detailCell.detailinfoTextView.textContainer.maximumNumberOfLines = 0;
                    detailCell.detailinfoTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
                    UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
                    [detailCell.tapView addGestureRecognizer:label_Desc_Tapped];
                    
                    [detailCell.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, TextView_ViewW,TextView_ViewH*2)];
                    
                    [detailCell.detailinfoTextView setFrame:CGRectMake(Cell_DescLabelX,Cell_DescLabelY, Cell_DescLabelW,Cell_DescLabelH*2)];
                    
                    
                }
                
            }
            else
            {
                
                
                CGRect newFrame = detailCell.detailinfoTextView.frame;
                newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
                
                detailCell.tapView.userInteractionEnabled=YES;
                
                UITapGestureRecognizer *label_Desc_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(label_Desc_Tapped_ActionDetails:)];
                [detailCell.tapView addGestureRecognizer:label_Desc_Tapped];
                [detailCell.tapView setFrame:CGRectMake(TextView_ViewX,TextView_ViewY, newFrame.size.width,newFrame.size.height)];
                [detailCell.detailinfoTextView setFrame:newFrame];
                
                
            }
            
            NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelX);
            NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelY);
            NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelW);
            NSLog(@"Dynamic label heightccc====%f",Cell_DescLabelH);
            detailCell.tapView.backgroundColor=[UIColor clearColor];
            
            [detailCell.view_CordinateViewTapped setFrame:CGRectMake(detailCell.view_CordinateViewTapped.frame.origin.x,(detailCell.tapView.frame.origin.y+detailCell.tapView.frame.size.height)+23,detailCell.view_CordinateViewTapped.frame.size.width, detailCell.view_CordinateViewTapped.frame.size.height)];
            
             [detailCell.Button_makeoffer setFrame:CGRectMake(detailCell.Button_makeoffer.frame.origin.x,(detailCell.view_CordinateViewTapped.frame.origin.y+detailCell.view_CordinateViewTapped.frame.size.height),detailCell.Button_makeoffer.frame.size.width, detailCell.Button_makeoffer.frame.size.height)];
              [detailCell.Button_makeoffer  addTarget:self action:@selector(makeOfferPressed:) forControlEvents:UIControlEventTouchUpInside];
            
           
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
                ComCell.commentmsgLabel.text = @"No Chats available";
                ComCell.usernameLabel.hidden = YES;
                ComCell.durationLabel.hidden = YES;
                ComCell.profileImageView.hidden = YES;
                ComCell.commentmsgLabel.hidden = YES;
                ComCell.commentofferLabel.hidden = YES;
                
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(ComCell.frame.origin.x, ComCell.frame.origin.y, self.view.frame.size.width, ComCell.frame.size.height)];
                label.text = @"Be the first one to comment!";
                label.textColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
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
                    
                    
                    [ComCell.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                    
                    
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
                    
                    NSString * offerComment = [NSString stringWithFormat:@"Made an offer: $%@",[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"amount"]];
                    
                    
                    
                    ComCell.commentofferLabel.text = offerComment;//[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"amount"] ;
                    ComCell.durationLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"chatdur"];
                    ComCell.usernameLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"name"];
                    ComCell.commentmsgLabel.text = [[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"message"];
                    
                    NSURL *url=[NSURL URLWithString:[[Array_Chats objectAtIndex:indexPath.row]valueForKey:@"profileimage"]];
                    
                    
                    [ComCell.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                    
                    
                }
                
            }
            return ComCell;
        }
            
             break;

            
            
    
    
#pragma mark -suggest cell
        case 4:
        {
            
            SuggestCell = [[[NSBundle mainBundle]loadNibNamed:@"SuggestedTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            
            if (SuggestCell == nil)
            {
                
                SuggestCell = [[SuggestedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_suggest];
                
                
            }
            
            SuggestCell.sImageView1.hidden=YES;
            SuggestCell.sImageView2.hidden=YES;
            SuggestCell.sImageView3.hidden=YES;
            SuggestCell.sImageView4.hidden=YES;
            SuggestCell.sImageView5.hidden=YES;
            SuggestCell.sImageView6.hidden=YES;
            
            SuggestCell.sImageView1.tag=0;
            SuggestCell.sImageView2.tag=1;
            SuggestCell.sImageView3.tag=2;
            SuggestCell.sImageView4.tag=3;
            SuggestCell.sImageView5.tag=4;
            SuggestCell.sImageView6.tag=5;
            
            SuggestCell.sImageView1.userInteractionEnabled=YES;
            SuggestCell.sImageView2.userInteractionEnabled=YES;
            SuggestCell.sImageView3.userInteractionEnabled=YES;
            SuggestCell.sImageView4.userInteractionEnabled=YES;
            SuggestCell.sImageView5.userInteractionEnabled=YES;
            SuggestCell.sImageView6.userInteractionEnabled=YES;
            for (int i = 0; i < Array_SuggestPost.count; i++)
            {
                
                if (i == 0)
                {
                    
                    
                    NSDictionary *dic_request0=[Array_SuggestPost objectAtIndex:0];
                    NSURL *url0=[NSURL URLWithString:[dic_request0 valueForKey:@"mediaurl"]];
                    [SuggestCell.sImageView1 sd_setImageWithURL:url0 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                    UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped:)];
                    [SuggestCell.sImageView1 addGestureRecognizer:ImageTap];
                    SuggestCell.sImageView1.hidden=NO;
                    
                    
                }
                
                
                
                if (i == 1)
                {
                    
                    
                    NSDictionary *dic_request1=[Array_SuggestPost objectAtIndex:1];
                    NSURL *url1=[NSURL URLWithString:[dic_request1 valueForKey:@"mediaurl"]];
                    [SuggestCell.sImageView2 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                    UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped:)];
                    [SuggestCell.sImageView2 addGestureRecognizer:ImageTap];
                    SuggestCell.sImageView2.hidden=NO;
                    
                    
                }
                
                
                if (i == 2)
                {
                    
                    
                    NSDictionary *dic_request2=[Array_SuggestPost objectAtIndex:2];
                    NSURL *url2=[NSURL URLWithString:[dic_request2 valueForKey:@"mediaurl"]];
                    [SuggestCell.sImageView3 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                    
                    UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped:)];
                    [SuggestCell.sImageView3 addGestureRecognizer:ImageTap];
                    SuggestCell.sImageView3.hidden=NO;
                    
                }
                
                if (i == 3)
                {
                    
                    NSDictionary *dic_request3=[Array_SuggestPost objectAtIndex:3];
                    NSURL *url3=[NSURL URLWithString:[dic_request3 valueForKey:@"mediaurl"]];
                    [SuggestCell.sImageView4 sd_setImageWithURL:url3 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                    
                    UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped:)];
                    [SuggestCell.sImageView4 addGestureRecognizer:ImageTap];
                    SuggestCell.sImageView4.hidden=NO;
                    
                }
                
                if (i == 4)
                {
                    
                    NSDictionary *dic_request4=[Array_SuggestPost objectAtIndex:4];
                    NSURL *url4=[NSURL URLWithString:[dic_request4 valueForKey:@"mediaurl"]];
                    [SuggestCell.sImageView5 sd_setImageWithURL:url4 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                    
                    UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped:)];
                    [SuggestCell.sImageView5 addGestureRecognizer:ImageTap];
                    SuggestCell.sImageView5.hidden=NO;
                    
                }
                
                
                if (i == 5)
                {
                    
                    NSDictionary *dic_request5=[Array_SuggestPost objectAtIndex:5];
                    NSURL *url5=[NSURL URLWithString:[dic_request5 valueForKey:@"mediaurl"]];
                    [SuggestCell.sImageView6 sd_setImageWithURL:url5 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                    UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped:)];
                    [SuggestCell.sImageView6 addGestureRecognizer:ImageTap];
                    SuggestCell.sImageView6.hidden=NO;
                }
                
            }
            
            
            
            
            
            return SuggestCell;
            
        }
            break;

    
    }
    
    return nil;

}

- (void)myAction
{
    
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
            
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:24.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 30.0f);
            NSLog(@"Dynamic label height====%f",height);
            NSInteger rHeight = size.height/24;
            [detailCellCar.detailinfoTextView1 setText:text];
            
            
            CGFloat fixedWidth = detailCellCar.detailinfoTextView1.frame.size.width;
            CGSize newSize = [detailCellCar.detailinfoTextView1 sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = detailCellCar.detailinfoTextView1.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            [detailCellCar.detailinfoTextView1 setFrame:(newFrame)];
            if ([str_TappedLabel isEqualToString:@"yes"])
            {
                
                
                return 546+detailCellCar.detailinfoTextView1.frame.size.height-38;
                
            }
            else
            {
                
                if ((long)rHeight==1)
                {
                    return 546;
                }
                else
                {
                    return 546 ;
                }
                
                
            }
            
            
            
        }
        
        else if ([[Array_UserInfo valueForKey:@"category"] isEqualToString:@"property"])
            
        {
            
            CGSize constraint = CGSizeMake(345 - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:24.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 30.0f);
            NSLog(@"Dynamic label height====%f",height);
            NSInteger rHeight = size.height/24;
            [detailCellProperty.detailinfoTextView1 setText:text];
            
            
            CGFloat fixedWidth = detailCellProperty.detailinfoTextView1.frame.size.width;
            CGSize newSize = [detailCellProperty.detailinfoTextView1 sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = detailCellProperty.detailinfoTextView1.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            [detailCellProperty.detailinfoTextView1 setFrame:(newFrame)];
            if ([str_TappedLabel isEqualToString:@"yes"])
            {
                
                
                return 627+detailCellProperty.detailinfoTextView1.frame.size.height-38;
                
            }
            else
            {
                
                if ((long)rHeight==1)
                {
                    return 627;
                }
                else
                {
                    return 627 ;
                }
                
                
            }
            
            
            
        }
        
        
        
        else
            
        {
            
            CGSize constraint = CGSizeMake(345 - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [text sizeWithFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:24.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 30.0f);
            NSLog(@"Dynamic label height====%f",height);
            NSInteger rHeight = size.height/24;
            [detailCell.detailinfoTextView1 setText:text];
            
            
            CGFloat fixedWidth = detailCell.detailinfoTextView1.frame.size.width;
            CGSize newSize = [detailCell.detailinfoTextView1 sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = detailCell.detailinfoTextView1.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            [detailCell.detailinfoTextView1 setFrame:(newFrame)];
            if ([str_TappedLabel isEqualToString:@"yes"])
            {
                
                
                return 456+detailCell.detailinfoTextView1.frame.size.height-38;
                
            }
            else
            {
                
                if ((long)rHeight==1)
                {
                    return 456;
                }
                else
                {
                    return 456 ;
                }
                
                
            }
            
            
            
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
            return 100;
           
        }
        else
            
        {
            if ([[[Array_Chats objectAtIndex:indexPath.row ] valueForKey:@"messagetype"] isEqualToString:@"TEXT"])
            {
                return 103;

            }
            else
            {
                return 142;

            }
            
            
        }
    }
    else if (indexPath.section == 4)
    {
        if (Array_SuggestPost.count==0)
        {
            return 0;
        }
        else if (Array_SuggestPost.count >=1)
        {
            return 140;
        }
        else if (Array_SuggestPost.count>=4)
        {
            return 280;
        }
        
    }
    
    return 0;
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==1)
    {
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];//36
        [sectionView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 40, 40)];
        [button1 setImage:[UIImage imageNamed:@"Phone"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(sectionHeaderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 20, 0, 40, 40)];
        [button2 setImage:[UIImage imageNamed:@"Comments"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(sectionHeaderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button2];
        
        UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width  - 95, 0, 40, 40)];
        [button3 setImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
        [button3 setTag:3];
        [button3 addTarget:self action:@selector(sectionHeaderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button3];
        
        sectionView.tag=section;
        
    }
    if (section==2)
    {
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,64)];
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        [button1 setTitle:@"MAKE AN OFFER" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:22];
    
        [button1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(makeOfferPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
        
//        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];//36
//        [sectionView setBackgroundColor:[UIColor whiteColor]];
//        
//        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 150, 40)];
//        [button1 setTitle:@"Post a Comment" forState:UIControlStateNormal];
//        [button1 setTitleColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
//        [button1 setTag:1];
//        [button1 addTarget:self action:@selector(postCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [sectionView addSubview:button1];
//        
//        
//        
//        UILabel *comment = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 10, 150, 40)];
//        comment.text = @"Comments";
//        comment.textColor = [UIColor lightGrayColor];
//        [sectionView addSubview:comment];
//        sectionView.tag=section;


    }
    
    if (section == 4)
    {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];//36
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        UILabel *comment = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, 10, 150, 40)];
        comment.text = @"Suggested Posts";
        comment.textColor = [UIColor lightGrayColor];
        [sectionView addSubview:comment];
        sectionView.tag=section;
    }
    
    return sectionView;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return 0;
    }
    if (section==1)
    {
        return 40;
    }
    if (section==2)
    {
         return 64;
    }
    if (section==3)
    {
        return 0;
    }
    if (section==4)
    {
        if (Array_SuggestPost.count==0)
        {
        return 0;
        }
        else
        {
        return 40;
        }
    }

    
    return 0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    if (section == 3)
    {
        
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];//36
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 39,self.view.frame.size.width,2)];//36
        [bottomView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [sectionView addSubview:bottomView];
        
        
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(8, 0, 122, 30)];
        [button1 setTitle:@"Post a comment" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:15];
        [button1 setTitleColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(postCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
        
        seeCommentButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 170, 0, 160, 40)];
        
        if ([[defaults valueForKey:@"SeeCommentPressed"]isEqualToString:@"no"])
        {
        [seeCommentButton setTitle:@"See all comments" forState:UIControlStateNormal];
            button1.hidden = YES;

        }
        else
        {
         [seeCommentButton setTitle:@"See less comments" forState:UIControlStateNormal];
            button1.hidden = NO;

        }
        
        [seeCommentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [seeCommentButton setTag:1];
        [seeCommentButton addTarget:self action:@selector(seeCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:seeCommentButton];
        
    }
    
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 1)
    {
        return 0;
    }
    if (section == 3)
    {
        if ([nochats isEqualToString:@"nochat"])
        {
            return 0;
        }
        
        else if(Array_Chats.count < 4)
        {
            return 0;
        }
        
        
        else
        {
            return 40;
        }
    }
    return 0;
}

#pragma mark - Button Action

-(void)sectionHeaderButtonPressed:(id)sender
{
    if ([sender tag]== 1)
    {
        NSLog(@"Phone Pressed");
        
       
    }
    else if ([sender tag]== 2)
    {
        NSLog(@"Comments Pressed");
    }
    else
    {
        NSLog(@"Share Pressed");
    }
    
}

#pragma mark - more image button acction

-(void)sectionHeaderTopButtonPressed:(id)sender
{
    if ([sender tag]== 1)
    {
        NSLog(@"3 Dots Pressed");
        
        
    }
    else if ([sender tag]== 2)
    {
        NSLog(@"Whitefavourite Pressed");
    }
    else
    {
        NSLog(@"Whitearrow Pressed");
        
        

       
        
 [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//        
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
         transparentView.hidden = YES;
        

        
    }
    
}

-(void)postCommentButtonPressed:(id)sender
{
    
 [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDisable" object:self userInfo:nil];
    
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
    label1.text = @"Post comment";
    label1.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [grayView addSubview:label1];
    
    
    commentPostTextView1 = [[UITextView alloc]initWithFrame:CGRectMake(16, 49, 243, 128)];
    commentPostTextView1.textAlignment = NSTextAlignmentRight;
    commentPostTextView1.font = [UIFont fontWithName:@"SanFranciscoDisplay-medium" size:17];
    commentPostTextView1.layer.cornerRadius = 4;
    commentPostTextView1.clipsToBounds = YES;
    commentPostTextView1.spellCheckingType = NO;
    commentPostTextView1.autocorrectionType = NO;
    commentPostTextView1.delegate = self;
    [commentPostTextView1 becomeFirstResponder];
    
    [grayView addSubview:commentPostTextView1];
    
    postplaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 49, 231, 30)];
    postplaceholderLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-medium" size:17];
    postplaceholderLabel.textAlignment = NSTextAlignmentRight;
    postplaceholderLabel.text = @"Type your comment here...";
    
    postplaceholderLabel.textColor = [UIColor lightGrayColor];
    [grayView bringSubviewToFront:postplaceholderLabel];
    [grayView addSubview:postplaceholderLabel];
    
    submitPostButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 191, 275, 34)];
    [submitPostButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
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
    
    if (textView == commentTextView)
    {
        if ([textView.text isEqualToString:@""])
        {
            
            confirmOfferButton.enabled = NO;
            [confirmOfferButton setBackgroundColor:[UIColor grayColor]];
            
        }
        else
        {
            confirmOfferButton.enabled = YES;
            [confirmOfferButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        }
    }
    
    if ([amountTextField.text isEqualToString:@"$"])
    {
        confirmOfferButton.enabled = NO;
        [confirmOfferButton setBackgroundColor:[UIColor grayColor]];

    }
    
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
////    if (textView == commentTextView)
////    {
////        if ([text isEqualToString:@""])
////        {
////            confirmOfferButton.enabled = NO;
////            [confirmOfferButton setBackgroundColor:[UIColor grayColor]];
////        }
////        else
////        {
////            confirmOfferButton.enabled = YES;
////            [confirmOfferButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
////        }
////    }
////    
////    return YES;
//}

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
    
       [self AddChat_Connection];
    
}

-(void)AddChat_Connection
{
    
    
    
    NSString *postid= @"postid";
    NSString *postidVal =str_postid;
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    NSString *message= @"message";
    NSString *messageVal =commentPostTextView1.text;
    
    NSString *chat= @"chattype";
    NSString *chattypeVal =@"TEXT";

    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,message,messageVal,chat,chattypeVal];
    
    
    
#pragma mark - swipe sesion
    
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
                                                     
                                                      [defaults setObject:@"no" forKey:@"SeeCommentPressed"];
                                                     
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
                                                 
                                                 if ([ResultString isEqualToString:@"nopostid"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This item is no more available and has probably been sold by the seller." preferredStyle:UIAlertControllerStyleAlert];
                                                     
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

- (void)Hide_EnterCommentPopover
{
    [transparentView1 removeFromSuperview];
   // transparentView1.hidden= YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
}



-(void)seeCommentButtonPressed:(id)sender
{
    
    
    
    if ([[defaults valueForKey:@"SeeCommentPressed"]isEqualToString:@"no"])
    {
          [defaults setObject:@"yes" forKey:@"SeeCommentPressed"];
        
        [seeCommentButton setTitle:@"See less comments" forState:UIControlStateNormal];
        
        [self.tableView reloadData];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(Array_Chats.count)-1 inSection:3] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        

         NSLog(@"See Less Comments");
        
        
    }
    else
    {
        
        [seeCommentButton setTitle:@"See all comments" forState:UIControlStateNormal];

        [defaults setObject:@"no" forKey:@"SeeCommentPressed"];
        
         [self.tableView reloadData];
        
        
         NSLog(@"See all comments");
    }
    
    
    
    
    
}

-(void)makeOfferPressed:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDisable" object:self userInfo:nil];

    NSLog(@"makeOffer Pressed");
    
    transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    grayView=[[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-275)/2,self.view.frame.size.width - 250, 275, 250)];
    grayView.layer.cornerRadius=20;
    grayView.clipsToBounds = YES;
    [grayView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIButton *closeview=[[UIButton alloc]initWithFrame:CGRectMake(8, 8, 31, 31)];
    [closeview setTitle:@"X" forState:UIControlStateNormal];
    [closeview setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [closeview addTarget:self action:@selector(closedd:)
        forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:closeview];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(128, 8, 132, 21)];
    label1.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:17];
    label1.textAlignment = NSTextAlignmentRight;

    label1.text = @"Make an offer:";
    label1.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [grayView addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(128, 35, 132, 21)];
    label2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:10];
    label2.textAlignment = NSTextAlignmentRight;
    label2.text = [NSString stringWithFormat:@"POST ID: %@",[defaults valueForKey:@"post-id"]];//[defaults valueForKey:@"post-id"];//@"POST ID:45645648W3";
    label2.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [grayView addSubview:label2];
    
    amountTextField = [[UITextField alloc]initWithFrame:CGRectMake(17, 60, 243, 40)];
    amountTextField.textAlignment = NSTextAlignmentRight;
    amountTextField.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:22];
    //amountTextField.text = @"$";
    amountTextField.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    amountTextField.backgroundColor = [UIColor whiteColor];
    
    [amountTextField addTarget:self action:@selector(enterInAmountField ) forControlEvents:UIControlEventEditingChanged];
    
    amountTextField.layer.cornerRadius = 4;
    amountTextField.clipsToBounds = YES;
    amountTextField.delegate = self;
    amountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [amountTextField becomeFirstResponder];
    [grayView addSubview:amountTextField];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(52, 108, 208, 21)];
    label3.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:14];
    label3.textAlignment = NSTextAlignmentRight;
    label3.text = @"Add a comment with your offer?";
    [grayView addSubview:label3];
    
    commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(17, 132, 243, 65)];
    commentTextView.textAlignment = NSTextAlignmentRight;
    commentTextView.layer.cornerRadius = 4;
    commentTextView.clipsToBounds = YES;
    commentTextView.spellCheckingType = NO;
    commentTextView.autocorrectionType = NO;
    commentTextView.delegate = self;
    [grayView addSubview:commentTextView];
    
    
    confirmOfferButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 206, 275, 44)];
    [confirmOfferButton setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmOfferButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmOfferButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16];
    confirmOfferButton.enabled = NO;
    [confirmOfferButton setBackgroundColor:[UIColor grayColor]];
    
  //  [confirmOfferButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    
    [confirmOfferButton addTarget:self action:@selector(confirm:)
        forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:confirmOfferButton];
    
    
    [transparentView addSubview:grayView];
    [self.view addSubview:transparentView];
    
}

-(void)enterInAmountField
{
    if ([amountTextField.text isEqualToString:@"$"])
    {
        
        confirmOfferButton.enabled = NO;
        [confirmOfferButton setBackgroundColor:[UIColor grayColor]];
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (amountTextField.text.length  == 0)
    {
        amountTextField.text = @"$";
    }
    
    
    
    }

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [amountTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![newText hasPrefix:@"$"])
    {
        
        
        
        confirmOfferButton.enabled = NO;
        [confirmOfferButton setBackgroundColor:[UIColor grayColor]];
        
        return NO;
    }
    
    if (commentTextView.text.length ==  0)
    {
        confirmOfferButton.enabled = NO;
        [confirmOfferButton setBackgroundColor:[UIColor grayColor]];
    }
    else
    {
    
    confirmOfferButton.enabled = YES;
    [confirmOfferButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    }
    // Default:
    return YES;
    
}


#pragma mark - PopOver Button Action


- (void)closedd:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    
    [self.view endEditing:YES];
 
    transparentView.hidden=YES;
    
}

- (void)closedd1:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    
    [self.view endEditing:YES];
    
    transparentView1.hidden=YES;
    
}


- (void)confirm:(id)sender
{
    
   
    [self CreateMakeOfferConnection];
//     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
//    transparentView.hidden=YES;
//    [self.view endEditing:YES];
    
    
}



-(void) button_threedots_action:(id)sender
{
    
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
//     [self.navigationController popToRootViewControllerAnimated:YES];
//    }
   
    
   
}

-(void)MoreImage:(UITapGestureRecognizer *)sender
{
#pragma mark- --more image scroll view
    
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDisable" object:self userInfo:nil];
    
    transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor=[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.95];
    
    NSLog(@"FirstCell=%f",FirstCell.button_threedots.frame.origin.y);
    NSLog(@"cell two=%f",Cell_two.button_threedots.frame.origin.y);
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(button_threeDotsx,button_threeDotsy, button_threeDotsw, button_threeDotsh)];
    [button1 setImage:[UIImage imageNamed:@"3dots"] forState:UIControlStateNormal];
    [button1 setTag:1];
    [button1 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(button_favx, button_favy, button_favw, button_favh)];
    [button2 setImage:[UIImage imageNamed:@"Whitefavourite"] forState:UIControlStateNormal];
    [button2 setTag:2];
    [button2 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //[transparentView addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(button_arrowx, button_arrowy, button_arroww, button_arrowh)];
    [button3 setImage:[UIImage imageNamed:@"Whitearrow"] forState:UIControlStateNormal];
    [button3 setTag:3];
    [button3 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button3];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,160,self.view.frame.size.width , self.view.frame.size.height -160)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.center = transparentView.center;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    
   
    
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
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag=i;
        
         UIButton* playButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        playButton.tag=i;
        [playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
        playButton.center=imageView.center;
        playButton.backgroundColor=[UIColor clearColor];
        [scrollView addSubview:imageView];
        [scrollView addSubview:playButton];
        
        NSLog (@"page %d",page);
        playButton.hidden = YES;
      
        if (i==0)
        {
              NSURL *url=[NSURL URLWithString:[Array_UserInfo valueForKey:@"mediathumbnailurl"]];
             [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
            if ([[Array_UserInfo valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
            {
             
                playButton.hidden = NO;
                
            }
        }
        else if (i==1)
        {
      
        NSURL *url1=[NSURL URLWithString:[Array_UserInfo valueForKey:@"mediathumbnailurl1"]];
        
        [imageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
            if ([[Array_UserInfo valueForKey:@"mediatype1"] isEqualToString:@"VIDEO"])
            {
                playButton.hidden = NO;
            
                
            }

        }
        else
        {
            NSURL *url1=[NSURL URLWithString:@""];
            
            [imageView sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
           playButton.hidden = YES;
           
        }
        
        
 
        
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.
                                        width *total_image,
                                        scrollView.frame.size.height);
    
    pageControll = [[UIPageControl alloc]init];
    pageControll.frame = CGRectMake(375/2-20, transparentView.frame.size.height - 100, 40, 10);
    if (total_image>=2)
    {
         pageControll.hidden=NO;;
        pageControll.numberOfPages = total_image;
    }
    else
    {
        pageControll.hidden=YES;;
    }
    pageControll.currentPage = 0;
    [pageControll setPageIndicatorTintColor:[UIColor grayColor]];
    
    [transparentView addSubview:scrollView];
    [transparentView addSubview:pageControll];
    [self.view addSubview:transparentView];
   
    [self Communication_moreImage];
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
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:actionOk];
                        [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
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
                        
                        imageView = [[UIImageView alloc] initWithFrame:frame];
                        imageView.userInteractionEnabled=YES;
                        imageView.clipsToBounds=YES;
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.tag=i;
                        
                         UIButton* playButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
                        [playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
                        playButton.center=imageView.center;
                        playButton.tag=i;
                        playButton.backgroundColor=[UIColor clearColor];
                        [scrollView addSubview:imageView];
                        [scrollView addSubview:playButton];
                        
                        
                        NSLog (@"page %d",page);
                       playButton.hidden = YES;
                  
                        
                        NSURL *url=[NSURL URLWithString:[[Array_Moreimages objectAtIndex:i] valueForKey:@"mediathumbnailurl"]];
                        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                        
                        
                        
                        if ([[[Array_Moreimages objectAtIndex:i] valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
                        {
                          
                           playButton.hidden = NO;
                            playButton.userInteractionEnabled=YES;
                            UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTappedscroll:)];
                            [imageView addGestureRecognizer:ImageTap];
                            UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTappedscroll:)];
                            [playButton addGestureRecognizer:ImageTap1];
                            
                        }
                        else
                        {
                            [self displayImage:imageView withImage:imageView.image];
                            playButton.hidden = YES;
                    
                        }
                        
                        
                        
                    }
                    
                    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width *Array_Moreimages.count,scrollView.frame.size.height);
                    
                    pageControll.frame = CGRectMake(375/2-20, transparentView.frame.size.height - 100, 40, 10);
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
-(void)label_Desc_Tapped_ActionDetails:(UIGestureRecognizer *)reconizer
{
    
    if ([str_TappedLabel isEqualToString:@"yes"])
    {
        str_TappedLabel=@"no";
        
    }
    else
    {
        str_TappedLabel=@"yes";
        
    }
    
    
    
    [self.tableView reloadData];
//    [self.tableView  reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView  endUpdates];
}

-(void)favouriteImage_ActionDetails:(UIGestureRecognizer *)reconizer
{
    
    
    NSLog(@"FAVORITE TAPPED");
    
    NSString *postid= @"postid";
    NSString *postidVal =str_postid;//[defaults valueForKey:@"post-id"];
    
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

#pragma mark - NSURL CONNECTION

-(void)ChatCommentConnection
{
    
    
//    NSString *postid= @"postid";
//    NSString *postidVal =str_postid;
//    
//    NSString *userid= @"userid";
//    NSString *useridVal =str_userid;
    
    NSString *postid= @"postid";
    NSString *postidVal =str_postid;//[defaults valueForKey:@"post-id"];
    
    NSString *userid= @"userid";
    NSString *useridVal =str_userid;//[defaults valueForKey:@"userid"];

    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",postid,postidVal,userid,useridVal];
    
    
    
#pragma mark - swipe sesion
    
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
                                                 
                                                
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_Chats %@",Array_Chats);
                                                 
                                                 if ([ResultString isEqualToString:@"nochat"])
                                                 {
                                                     nochats = ResultString;
                                                     
                                                     
                                                     [self.tableView reloadData];
                                                     

                                                     
                                                     
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

                                                 
                                                 if ( Array_Chats.count != 0)
                                                 {
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

-(void)SuggestPostConnection
{
    
    NSLog(@"createButtonPressed");
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
        NSString *  urlStr=[urlplist valueForKey:@"suggestpost"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *postid= @"postid";
        NSString *postidVal =str_postid;
        
        NSString *userid= @"userid";
        NSString *useridVal =str_userid;
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",postid,postidVal,userid,useridVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_SuggestPost = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_SuggestPost)
            {
                
                webData_SuggestPost =[[NSMutableData alloc]init];
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }
    

    
    
}

-(void)CreateMakeOfferConnection
{
    
    NSLog(@"createButtonPressed");
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
        NSString *  urlStr=[urlplist valueForKey:@"makeoffer"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *postid= @"postid";
        NSString *postidVal =[defaults valueForKey:@"post-id"];
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        
        
        
        
        NSString *offerAmount;
        NSString *offerAmountVal;
        
        if ([amountTextField.text isEqualToString:@""])
        {
            offerAmount= @"offeramount";
            offerAmountVal = @"0" ;
        }
        else
        {
            NSString *askingpriceValString = [NSString stringWithFormat:@"%@",amountTextField.text];
            askingpriceValString = [askingpriceValString substringFromIndex:1];
            offerAmount= @"offeramount";
            offerAmountVal =askingpriceValString;
        }
        

//        NSString *askingpriceValString = [NSString stringWithFormat:@"%@",amountTextField.text];
//        askingpriceValString = [askingpriceValString substringFromIndex:1];
//        
//        NSString *offerAmount= @"offeramount";
//        NSString *offerAmountVal = askingpriceValString;   //[defaults valueForKey:@"amountEntered"];
        
        NSString *comment= @"comment";
        NSString *commentVal =commentTextView.text;//[defaults valueForKey:@"commentEntered"];
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,offerAmount,offerAmountVal,comment,commentVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_MakeOffer = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_MakeOffer)
            {
                webData_MakeOffer =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }

    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    
    if(connection==Connection_MakeOffer)
    {
        [webData_MakeOffer setLength:0];
        
        
    }
    if(connection==Connection_SuggestPost)
    {
        [webData_SuggestPost setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_MakeOffer)
    {
        [webData_MakeOffer appendData:data];
    }
    
    if(connection==Connection_SuggestPost)
    {
        [webData_SuggestPost appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_MakeOffer)
    {
        
        Array_MakeOffer=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_MakeOffer=[objSBJsonParser objectWithData:webData_MakeOffer];
        NSString * ResultString=[[NSString alloc]initWithData:webData_MakeOffer encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_MakeOffer);
        NSLog(@"registration_status %@",[[Array_MakeOffer objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
        if ([ResultString isEqualToString:@"done"])
        {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Offer Accepted" message:@"Thank-you for making your offer. You will be informed if you win the bid or if someone outbids you." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
            transparentView.hidden=YES;
            [self.view endEditing:YES];
            
             [self ChatCommentConnection];
            
        }
        else if ([ResultString isEqualToString:@"inserterror"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"The server encountered some error, please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if ([ResultString isEqualToString:@"amountless"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Offer Rejected" message:@"Your offer is less than the previous highest offer. Please increase your amount and bid again. Thank-you." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        else if ([ResultString isEqualToString:@"nullerror"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Please enter the amount that you wish to offer." preferredStyle:UIAlertControllerStyleAlert];
            
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


        
        

    }
    
    if (connection == Connection_SuggestPost)
    {
        Array_SuggestPost=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_SuggestPost=[objSBJsonParser objectWithData:webData_SuggestPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_SuggestPost encoding:NSUTF8StringEncoding];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"Array_SuggestPost %@",Array_SuggestPost);
        
        NSLog(@"ResultString %@",ResultString);
        
        NSLog(@"Array count = %ld",Array_SuggestPost.count);
 [self.tableView reloadData];
        
        
    }
    
}
-(void)ImageTapped:(UIGestureRecognizer *)reconizer
{
    UIGestureRecognizer *rec = (UIGestureRecognizer*)reconizer;
    
    UIImageView *imageView1 = (UIImageView *)rec.view;
    NSLog(@"Imageview tap==:==%ld", (long)imageView1.tag);
      NSLog(@"Imageview tap_Array==%@",[Array_SuggestPost objectAtIndex:(long)imageView1.tag]);
    [defaults setObject:@"yes" forKey:@"imagetapped"];
    [defaults synchronize];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
//        serviceVC.swipeCount=(long)imageView1.tag;
//              serviceVC.view.tag=(long)imageView1.tag;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
   

    if ([[[Array_SuggestPost objectAtIndex:(long)imageView1.tag] valueForKey:@"userid1"]isEqualToString:[defaults valueForKey:@"userid"]])
    {
        
        
        MyPostViewController * serviceVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
        serviceVC.Array_UserInfo=[Array_SuggestPost objectAtIndex:(long)imageView1.tag];;
         [self.navigationController pushViewController:serviceVC animated:YES];
    }
    else
    {
        
        
        OnCellClickViewController *serviceVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"OnCellClickViewController"];
       serviceVC.Array_UserInfo=[Array_SuggestPost objectAtIndex:(long)imageView1.tag];;
         [self.navigationController pushViewController:serviceVC animated:YES];
    }
   

    
}


@end

//Consumer key (API Key):
//bB8ASgppAnfalb0BHCwa63dqU
//
//Consumer secret (API Secret):
//AC168EC7WKu588JAp04gZkPop2WHbeaznp5O9JQEldAXSnyiMy


//com.bba.tamm
//
//facebook id: 907643802709363
//
//display name:  تم
//
//Apple id: 1233044805
//


//- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer {
//    newsList = [[NSMutableArray alloc] init];
//    
//    //to animate the view as new view is loaded
//    [UIView animateWithDuration:0.1 animations:^{
//        
//        viewContent.frame = CGRectMake( -viewContent.frame.size.width, viewContent.frame.origin.y , viewContent.frame.size.width, viewContent.frame.size.height);
//        [self loadData];
//        
//    } completion:^(BOOL finished) {
//        viewContent.frame = CGRectMake( viewContent.frame.size.width,viewContent.frame.origin.y, viewContent.frame.size.width, viewContent.frame.size.height);
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            viewContent.frame = CGRectMake(0.0, viewContent.frame.origin.y, viewContent.frame.size.width, viewContent.frame.size.height);
//        }];
//    }];
//    
//    selectedDay++;
//    [self fetchDataFromWeb];
//}

//- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer {
//    newsList = [[NSMutableArray alloc] init];
//    
//    //to animate the view as new view is loaded
//    [UIView animateWithDuration:0.1 animations:^{
//        
//        viewContent.frame = CGRectMake( viewContent.frame.size.width, viewContent.frame.origin.y , viewContent.frame.size.width, viewContent.frame.size.height);
//        [self loadData];
//        
//    } completion:^(BOOL finished) {
//        viewContent.frame = CGRectMake( -viewContent.frame.size.width,viewContent.frame.origin.y, viewContent.frame.size.width, viewContent.frame.size.height);
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            viewContent.frame = CGRectMake(0.0, viewContent.frame.origin.y, viewContent.frame.size.width, viewContent.frame.size.height);
//        }];
//    }];
//    
//    selectedDay--;
//    [self fetchDataFromWeb];
//}
