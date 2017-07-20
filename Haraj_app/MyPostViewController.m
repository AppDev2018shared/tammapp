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
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH self.view.frame.size.width-138
#define CELL_CONTENT_MARGIN 0.0f

@interface MyPostViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate, UITextFieldDelegate,UITextViewDelegate>

{
    MPMoviePlayerViewController *movieController ;
    NSDictionary *urlplist;
    UIView *sectionView;
    UIScrollView *scrollView;
    UIImageView *imageView;
    UIPageControl *pageControll;
    FirstImageViewCell *FirstCell;
    NSURL * imageUrl;
    NSUserDefaults *defaults;
    NSInteger total_image;
    UIButton* playButton, *seeCommentButton, *submitPostButton;
    
    CGFloat Xpostion, Ypostion, Xwidth, Yheight, ScrollContentSize,Xpostion_label, Ypostion_label, Xwidth_label, Yheight_label,Cell_DescLabelX,Cell_DescLabelY,Cell_DescLabelW,Cell_DescLabelH,TextView_ViewX,TextView_ViewY,TextView_ViewW,TextView_ViewH;
    CGFloat button_threeDotsx,button_threeDotsy,button_threeDotsw,button_threeDotsh,button_favx,button_favy,button_favw,button_favh,button_arrowx,button_arrowy,button_arroww,button_arrowh;
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

    
}
@property (strong,nonatomic)TwoImageOnClickTableViewCell * Cell_two;


@end

@implementation MyPostViewController
@synthesize Array_UserInfo,swipeCount,MoreImageArray,Cell_two,detailCell,detailCellCar,detailCellProperty,ComCell,Array_All_UserInfo,cell_postcomments;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    rect = [[UIApplication sharedApplication] statusBarFrame];
    
    
    floatButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70,self.view.frame.size.height - 70 - rect.size.height, 60,60)];
    floatButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16];
    [floatButton setImage:[UIImage imageNamed:@"BoostButton"] forState:UIControlStateNormal];
    [floatButton addTarget:self action:@selector(floatButtonAction:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:floatButton];
    
       
    
  
    
    defaults = [[NSUserDefaults alloc]init];
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
        total_image=[[Array_UserInfo  valueForKey:@"mediacount"] integerValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide_Popover) name:@"HidePopOver" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide_BoostPopover) name:@"HideBoostPopOver" object:nil];
    
    
    
    str_TappedLabel=@"no";
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
        [defaults setObject:@"no" forKey:@"Activitynext"];
    }
    
    else
        
    {

       self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }

    
}



-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@" array info %ld",(long)self.view.tag);
    NSLog(@" Array_All_UserInfo viewwillappear %@",Array_All_UserInfo);
//    str_postid= [[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"postid"];
//    str_userid =[[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"userid1"];
    NSLog(@" str_postid viewwillappear %@", [[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"postid"]);
    NSLog(@" str_userid viewwillappear %@",[[Array_All_UserInfo objectAtIndex:(long)self.view.tag] valueForKey:@"userid1"]);
    
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
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // imageUrl=[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:indexPath.row]];
    
    static NSString *CellIdentifier = @"Cell";
    
    static NSString *cell_details=@"DetailCell";
    static NSString *cell_detailscar=@"DetailCellCar";
    static NSString *cell_detailsproperty=@"DetailCellProperty";
    
    static NSString *post_comments=@"PostCell1";
    static NSString *cell_comments=@"ComCell";
//    NSDictionary *dic_request=[Array_UserInfo objectAtIndex:swipeCount];
//    NSLog(@"dic= %@",dic_request);
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
                [self displayImage:FirstCell.imageView_thumbnails withImage:FirstCell.imageView_thumbnails.image];
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
                
                
                
                detailCell.locationLabel.text = [Array_UserInfo valueForKey:@"city1"];
                detailCell.hashtagLabel.text = [Array_UserInfo valueForKey:@"hashtags"];
                //NSString *post = [NSString stringWithFormat:@"POST ID:%@",[dic_request valueForKey:@"postid"]];
                detailCell.postidLabel.text = [NSString stringWithFormat:@"POST ID: %@",[Array_UserInfo valueForKey:@"postid"]];
                detailCell.usernameLabel.text = [Array_UserInfo valueForKey:@"usersname"];
                detailCell.durationLabel.text = [Array_UserInfo valueForKey:@"postdur"];
                
                NSString *show = [NSString stringWithFormat:@"$%@",[Array_UserInfo valueForKey:@"showamount"]];
                detailCell.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
                detailCell.timeLabel.text = [Array_UserInfo valueForKey:@"createtime"];
                detailCell.titleLabel.text = [Array_UserInfo valueForKey:@"title"];
                //detailCell.profileImage.image =
                
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
                ComCell.commentmsgLabel.text = @"No Chats available";
                ComCell.usernameLabel.hidden = YES;
                ComCell.durationLabel.hidden = YES;
                ComCell.profileImageView.hidden = YES;
                ComCell.commentmsgLabel.hidden = YES;
                ComCell.commentofferLabel.hidden = YES;
                
                
                UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(ComCell.frame.origin.x, ComCell.frame.origin.y, self.view.frame.size.width, ComCell.frame.size.height)];
                label.text = @" No Chats Available";
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
                    
                    
                    //                    NSIndexPath* ipath = [NSIndexPath indexPathForRow:Array_Chats.count-1 inSection:3];
                    //                    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
                    
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    
                    
                }
                
            }

            


            
            return ComCell;
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
                    return 456 + 38 ;
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
            return 100 + rect.size.height;
            
        }
        else
            
        {
            if ([[[Array_Chats objectAtIndex:indexPath.row ] valueForKey:@"messagetype"] isEqualToString:@"TEXT"])
            {
                return 103 + rect.size.height;
                
            }
            else
            {
                return 142 + rect.size.height;
                
            }
            
            
        }
    }
   
    
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==1)
    {
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];//36
        [sectionView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2 + 50, 44)];
       
        [button1 setTitle:@"ITEM SOLD " forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:18];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
        [button1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:114/255.0 blue:48/255.0 alpha:1]];
        [button1 setImage:[UIImage imageNamed:@"Itemsold"] forState:UIControlStateNormal];
        [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -180)];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(sectionHeaderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(292, 7, 33, 30)];
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
        return 2;
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
        label1.text = @"ITEM SOLD";
        label1.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        [grayView addSubview:label1];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(232, 8, 30, 30)];
        imageView.image = [UIImage imageNamed:@"Greenitemsold"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [grayView addSubview:imageView];
        
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(112, 41, 150, 18)];
        label2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Semibold" size:11];
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = [NSString stringWithFormat:@"POST ID: %@",[Array_UserInfo  valueForKey:@"postid"]];//@"POST ID: 3589278W3";
        label2.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        [grayView addSubview:label2];

        UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(8, 67, 254, 21)];
        label3.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:14];
        label3.textAlignment = NSTextAlignmentRight;
        label3.text = @"Are you sure this item has been sold?";
        [grayView addSubview:label3];

        
        UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(21, 87, 241, 35)];
        label4.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:14];
        label4.textAlignment = NSTextAlignmentRight;
        label4.numberOfLines = 2;
        label4.text = @"Selecting confirm will remove item from تم";
        [grayView addSubview:label4];
        
        
        UIButton *confirm=[[UIButton alloc]initWithFrame:CGRectMake(0, 130, 275, 32)];
        [confirm setTitle:@"CONFIRM" forState:UIControlStateNormal];
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
        
        NSString * texttoshare=[NSString stringWithFormat:@"You have been invited to use the Tamm app!\n\n\nDownload the app on your iPhone from http://www.tammapp.com and buy & sell items!"];
        
        
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDisable" object:self userInfo:nil];
    transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    
//    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"EnterPrice" owner:self options:nil];
//    UIView *myView = [nibContents objectAtIndex:0];
    
    myCustomXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"EnterPrice" owner:self options:nil]objectAtIndex:0];
    
    myCustomXIBViewObj.frame = CGRectMake((self.view.frame.size.width- myCustomXIBViewObj.frame.size.width)/2,self.view.frame.size.width - 250, myCustomXIBViewObj.frame.size.width, myCustomXIBViewObj.frame.size.height);
    
    
    [self.view addSubview:myCustomXIBViewObj];
    
    [myCustomXIBViewObj.bankButton addTarget:self action:@selector(bankButton_Action:) forControlEvents:UIControlEventTouchUpInside];
    [myCustomXIBViewObj.bankButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [myCustomXIBViewObj.creditButton addTarget:self action:@selector(creditButton_Action:) forControlEvents:UIControlEventTouchUpInside];
    [myCustomXIBViewObj.creditButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [myCustomXIBViewObj.priceTextField addTarget:self action:@selector(enterInLabel ) forControlEvents:UIControlEventEditingChanged];
    
    myCustomXIBViewObj.priceTextField.delegate = self;
    [myCustomXIBViewObj.priceTextField becomeFirstResponder];
    myCustomXIBViewObj.postIdLabel.text =[NSString stringWithFormat:@"POST ID: %@",[Array_UserInfo  valueForKey:@"postid"]];
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

   
}
-(void)viewTapped_Action:(UIGestureRecognizer *)reconizer
{
    [self.view endEditing:YES];
}

-(void)enterInLabel
{
    NSString *askingpriceValString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
    askingpriceValString = [askingpriceValString substringFromIndex:1];
    
    float j = [askingpriceValString floatValue];
    
    float k = ((0.75*j)/100);
    
    myCustomXIBViewObj.caculatedAmountLabel.text =[NSString stringWithFormat:@"$ %0.2f",k]; //[NSString stringWithFormat:@"$ %@",askingpriceValString];
    
    if ([myCustomXIBViewObj.priceTextField.text isEqualToString:@"$"])
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
        myCustomXIBViewObj.priceTextField.text = @"$";
    
    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [myCustomXIBViewObj.priceTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![newText hasPrefix:@"$"])
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
     [self.view showActivityViewWithLabel:@"Making payment..."];
    paymentmodeStr = @"BANK";
    
    [self ItemSold_Connection];
    NSLog(@"Bank button Pressed");
    [self.view endEditing:YES];
}
-(void)creditButton_Action:(id)sender
{
    [self.view showActivityViewWithLabel:@"Making payment..."];
    paymentmodeStr = @"CARD";
    [self ItemSold_Connection];
    NSLog(@"creditButton_Action Pressed");
    [self.view endEditing:YES];
    
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
    NSString *messageVal =commentPostTextView1.text;
    
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




-(void)MoreImage:(UITapGestureRecognizer *)sender
{
#pragma mark- --more image scroll view
    
    if (total_image == 1)
    {
        UIGestureRecognizer *rec = (UIGestureRecognizer*)sender;
        UIImageView *imageView1 = (UIImageView *)rec.view;
        NSLog(@"ImageTappedscroll ImageTappedscroll==%ld", (long)imageView1.tag);
        
        
        if ([[[Array_Moreimages objectAtIndex:(long)imageView1.tag] valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
        {
            NSURL *url=[NSURL URLWithString:[[Array_Moreimages objectAtIndex:(long)imageView1.tag]valueForKey:@"mediaurl"]];
            movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            
            
            
            [self presentMoviePlayerViewControllerAnimated:movieController];
            [movieController.moviePlayer prepareToPlay];
            [movieController.moviePlayer play];
            
            
            
        }
        else
        {
            [self displayImage:FirstCell.imageView_thumbnails withImage:FirstCell.imageView_thumbnails.image];
        }
        
        
        
        
        
    }
    else
    {
        
        
        
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
                                                     
//                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//                                                     
//                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
//                                                     [alertController addAction:actionOk];
//                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
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
                                                         
                                                         imageView = [[UIImageView alloc] initWithFrame:frame];
                                                         imageView.userInteractionEnabled=YES;
                                                         imageView.clipsToBounds=YES;
                                                         imageView.contentMode = UIViewContentModeScaleAspectFill;
                                                         imageView.tag=i;
                                                         
                                                         playButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
                                                         [playButton setImage:[UIImage imageNamed:@"Play"] forState:UIControlStateNormal];
                                                         playButton.center=imageView.center;
                                                         playButton.tag=i;
                                                         playButton.backgroundColor=[UIColor clearColor];
                                                         [scrollView addSubview:imageView];
                                                         [scrollView addSubview:playButton];
                                                         
                                                         
                                                         NSLog (@"page %d",page);
                                                         
                                                        
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

#pragma mark - ChatConnectionCommunication
-(void)ChatCommentConnection
{
    
    
    //    NSString *postid= @"postid";
    //    NSString *postidVal =str_postid;
    //
    //    NSString *userid= @"userid";
    //    NSString *useridVal =str_userid;
    
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
    
    
    
    NSString *enterPriceString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
    enterPriceString = [enterPriceString substringFromIndex:1];
    
    NSString *price= @"sellprice";
    NSString *priceVal = enterPriceString;
    
    
    NSString *transactionString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.caculatedAmountLabel.text];
    transactionString = [transactionString substringFromIndex:1];
    
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
    
   
    
    myBoostXIBViewObj.postIdLabel.text =[NSString stringWithFormat:@"POST ID: %@",[Array_UserInfo  valueForKey:@"postid"]];
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



@end
