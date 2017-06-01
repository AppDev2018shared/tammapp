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

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH self.view.frame.size.width-138
#define CELL_CONTENT_MARGIN 0.0f

@interface MyPostViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

{
    UIView *sectionView;
    UIScrollView *scrollView;
    UIImageView *imageView;
    UIPageControl *pageControll;
    FirstImageViewCell *FirstCell;
    NSURL * imageUrl;
    NSUserDefaults *defaults;
    NSString *total_image;
    
    CGFloat Xpostion, Ypostion, Xwidth, Yheight, ScrollContentSize,Xpostion_label, Ypostion_label, Xwidth_label, Yheight_label,Cell_DescLabelX,Cell_DescLabelY,Cell_DescLabelW,Cell_DescLabelH,TextView_ViewX,TextView_ViewY,TextView_ViewW,TextView_ViewH;
    CGFloat FavIV_X,FavIV_Y,FavIV_W,FavIV_H,FavLabel_X,FavLabel_Y,FavLabel_W,FavLabel_H;
    
    NSString *str_LabelCoordinates,*str_TappedLabel;
    NSString *text;

}
@property (strong,nonatomic)TwoImageOnClickTableViewCell * Cell_two;


@end

@implementation MyPostViewController
@synthesize Array_UserInfo,swipeCount,MoreImageArray,Cell_two,detailCell,ComCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    total_image = @"2";
    defaults = [[NSUserDefaults alloc]init];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
  //  imageUrl=[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:swipeCount]];
    
    //Add a left swipe gesture recognizer
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleSwipeLeft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
    
    //Add a right swipe gesture recognizer
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(handleSwipeRight:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:recognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide_Popover) name:@"HidePopOver" object:nil];
    
    str_TappedLabel=@"no";
    str_LabelCoordinates=@"no";
    text =@"udfgsdfgf iudhgiufd rgfod gfd ggdfhgiudfg fdihgdfiug dfiughfdiug dfihgdfiu gdfiguhdfuigh fdiughdfiugh dfiug hdfiughdfuig ghfdig dfigdf igfdiug fdiughdfiug fdiugh udfihg dfiugh uig dfiughdf";
    
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
- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
        
//    swipeCount +=1;
//    NSLog(@ "Left= %ld",(long)swipeCount);
//   // imageUrl=[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:swipeCount]];
    
    if (swipeCount >= 0 && swipeCount < Array_UserInfo.count-1)
    {
        swipeCount +=1;
        
    //to animate the view as new view is loaded
    [UIView animateWithDuration:0.1 animations:^{
        
        self.tableView.frame = CGRectMake( -self.tableView.frame.size.width, self.tableView.frame.origin.y , self.tableView.frame.size.width, self.tableView.frame.size.height);
        // [self loadData];
        [self.tableView reloadData];
        
        
    } completion:^(BOOL finished) {
        self.tableView.frame = CGRectMake( self.tableView.frame.size.width,self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0.0, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
        }];
    }];
    
    //        selectedDay++;
    //        [self fetchDataFromWeb];
    }
    
    else
    {
        swipeCount =Array_UserInfo.count-1;
    }

    
    
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    
    
    swipeCount -=1;
    
    if (swipeCount < 0)
    {
        swipeCount = 0;
    }
    else
    {

    NSLog(@ "Right= %ld",(long)swipeCount);
  //  imageUrl=[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:swipeCount]];
    
    //to animate the view as new view is loaded
    [UIView animateWithDuration:0.1 animations:^{
        
        self.tableView.frame = CGRectMake(  self.tableView.frame.size.width,  self.tableView.frame.origin.y ,  self.tableView.frame.size.width,  self.tableView.frame.size.height);
        // [self loadData];
        [self.tableView reloadData];
        
    } completion:^(BOOL finished) {
        self.tableView.frame = CGRectMake( - self.tableView.frame.size.width, self.tableView.frame.origin.y,  self.tableView.frame.size.width,  self.tableView.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = CGRectMake(0.0,  self.tableView.frame.origin.y,  self.tableView.frame.size.width,  self.tableView.frame.size.height);
        }];
    }];
    }
    //        selectedDay--;
    //        [self fetchDataFromWeb];
    
    
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
    static NSString *cell_comments=@"ComCell";
    NSDictionary *dic_request=[Array_UserInfo objectAtIndex:swipeCount];
    NSLog(@"dic= %@",dic_request);
    static NSString *cell_two1=@"Cell_Two";
    switch (indexPath.section)
    {
        case 0:
        {
            
            if ([total_image isEqualToString:@"2"])
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
                Cell_two.countLabel.text = @"15";
                [Cell_two.bgView addGestureRecognizer:moreTap];
                
                
                return Cell_two;
                
                
            }
            else
            {
                FirstCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
                [FirstCell.button_threedots addTarget:self action:@selector(button_threedots_action:) forControlEvents:UIControlEventTouchUpInside];
                [FirstCell.button_favourite addTarget:self action:@selector(button_favourite_action:) forControlEvents:UIControlEventTouchUpInside];
                [FirstCell.button_back addTarget:self action:@selector(button_back_action:) forControlEvents:UIControlEventTouchUpInside];
                return FirstCell;
            }
            
            
        }
            break;
        case 1:
        {
            
            detailCell = [[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            
            
            
            if (detailCell == nil)
            {
                
                detailCell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_details];
                
                
            }
            
            

            detailCell.locationLabel.text = [dic_request valueForKey:@"city1"];
            detailCell.hashtagLabel.text = [dic_request valueForKey:@"hashtags"];
            //NSString *post = [NSString stringWithFormat:@"POST ID:%@",[dic_request valueForKey:@"postid"]];
            detailCell.postidLabel.text = [NSString stringWithFormat:@"POST ID:%@",[dic_request valueForKey:@"postid"]];
            detailCell.usernameLabel.text = [dic_request valueForKey:@"usersname"];
            
            NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
            detailCell.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
            detailCell.timeLabel.text = [dic_request valueForKey:@"createtime"];
            detailCell.titleLabel.text = [dic_request valueForKey:@"title"];
            //detailCell.profileImage.image =
            
            NSURL *url=[NSURL URLWithString:[dic_request valueForKey:@"usersprofilepic"]];
            
            [detailCell.profileImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
            detailCell.profileImage.layer.cornerRadius = detailCell.profileImage.frame.size.height / 2;
            detailCell.profileImage.clipsToBounds = YES;
            
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
            
            ComCell = [[[NSBundle mainBundle]loadNibNamed:@"CommentsTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            
            if (ComCell == nil)
            {
                
                ComCell = [[CommentsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_comments];
                
                
            }
            ComCell.profileImageView.layer.cornerRadius = ComCell.profileImageView.frame.size.height / 2;
            ComCell.profileImageView.clipsToBounds = YES;

            
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
        if ([total_image isEqualToString:@"2"])
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
            
            
            return 520+detailCell.detailinfoTextView1.frame.size.height-38 - 64;
            
            
            
            
        }
        else
        {
            
            if ((long)rHeight==1)
            {
                return 520 - 64;
            }
            else
            {
                return 520+26-64;
            }
            
            
        }

    }
    else if (indexPath.section == 2)
    {
        return 120;
    }
   
    
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==1)
    {
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];//36
        [sectionView setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2 + 50, 40)];
       
        [button1 setTitle:@"ITEM SOLD " forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:18];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
        [button1 setBackgroundColor:[UIColor colorWithRed:0/255.0 green:114/255.0 blue:48/255.0 alpha:1]];
        [button1 setImage:[UIImage imageNamed:@"Itemsold"] forState:UIControlStateNormal];
        [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -180)];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(sectionHeaderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width  - 95, 0, 40, 40)];
        [button2 setImage:[UIImage imageNamed:@"Share"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(sectionHeaderButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button2];
        sectionView.tag=section;
        
    }
    if (section==2)
    {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];//36
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 150, 40)];
        [button1 setTitle:@"Post a Comment" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(postCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
        
        
        UILabel *comment = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 100, 10, 150, 40)];
        comment.text = @"Comments";
        comment.textColor = [UIColor lightGrayColor];
        [sectionView addSubview:comment];
        
        sectionView.tag=section;
        
    }
    
    
    return sectionView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1)
    {
        return 40;
    }
    if (section==2)
    {
        return 40;
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
    
    
    if (section == 2)
    {
        
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,40)];//36
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        UIView *bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 39,self.view.frame.size.width,2)];//36
        [bottomView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [sectionView addSubview:bottomView];
        
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 160, 0, 150, 40)];
        [button1 setTitle:@"See all comments" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(seeCommentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
    }
    
    return sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 2;
    }
    
    if (section == 2)
    {
        return 40;
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
        NSLog(@"Item Sold Pressed");

        transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        transparentView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        grayView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width- 137.5, self.view.frame.size.height - 125, 275, 162)];
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
        
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(147, 41, 115, 18)];
        label2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Semibold" size:11];
        label2.textAlignment = NSTextAlignmentRight;
        label2.text = @"POST ID: 3589278W3";
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
        label4.text = @"Selecting confirm will remove item from APP Name.";
        [grayView addSubview:label4];
        
        
        UIButton *confirm=[[UIButton alloc]initWithFrame:CGRectMake(0, 130, 275, 32)];
        [confirm setTitle:@"CONFIRM" forState:UIControlStateNormal];
        [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        NSLog(@"Share Pressed");
    }
    
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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}


#pragma mark - PopOver Button Action


- (void)closedd:(id)sender
{
    
    transparentView.hidden=YES;
    
}

- (void)confirm:(id)sender
{
    
    transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"EnterPrice" owner:self options:nil];
    UIView *myView = [nibContents objectAtIndex:0];
    myView.center=transparentView1.center;
    myView.layer.cornerRadius = 10;
    myView.clipsToBounds = YES;
    [transparentView1 addSubview:myView];
    [self.view addSubview:transparentView1];
    transparentView.hidden=YES;
  
    
}
- (void)Hide_Popover
{
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
        
            transparentView.hidden = YES;
            NSLog(@"Whitearrow Pressed");
    }
    
}

-(void)postCommentButtonPressed:(id)sender
{
    
    NSLog(@"post comment Pressed");
    
}

-(void)seeCommentButtonPressed:(id)sender
{
    NSLog(@"See comment Pressed");
    
}




-(void)MoreImage:(UITapGestureRecognizer *)sender
{
#pragma mark- --more image scroll view
    
    
    transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor=[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.95];
    
    NSLog(@"FirstCell=%f",FirstCell.button_threedots.frame.origin.y);
     NSLog(@"cell two=%f",Cell_two.button_threedots.frame.origin.y);
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(8,12, 38, 42)];
    [button1 setImage:[UIImage imageNamed:@"3dots"] forState:UIControlStateNormal];
    [button1 setTag:1];
    [button1 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(80, 12, 50, 42)];
    [button2 setImage:[UIImage imageNamed:@"Whitefavourite"] forState:UIControlStateNormal];
    [button2 setTag:2];
    [button2 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(302, 12, 65, 43)];
    [button3 setImage:[UIImage imageNamed:@"Whitearrow"] forState:UIControlStateNormal];
    [button3 setTag:3];
    [button3 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button3];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,160,self.view.frame.size.width , self.view.frame.size.height -160)];
    scrollView.center = transparentView.center;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    
    MoreImageArray = [[NSArray alloc] initWithObjects:@"1.png", @"2.png", @"3.png", nil];
    
    for (int i = 0; i < [MoreImageArray count]; i++ ) {
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        
        imageView = [[UIImageView alloc] initWithFrame:frame];
        // imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
       // imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:swipeCount + i]]]];
      //  [FirstCell.imageView sd_setImageWithURL:imageUrl];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [scrollView addSubview:imageView];
        
        NSLog (@"page %d",page);
        
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.
                                        width *[MoreImageArray count],
                                        scrollView.frame.size.height);
    
    pageControll = [[UIPageControl alloc]init];
    pageControll.frame = CGRectMake(375/2-20, transparentView.frame.size.height - 100, 40, 10);
    pageControll.numberOfPages = MoreImageArray.count;
    pageControll.currentPage = 0;
    [pageControll setPageIndicatorTintColor:[UIColor grayColor]];
    
    [transparentView addSubview:scrollView];
    [transparentView addSubview:pageControll];
    [self.view addSubview:transparentView];
  
}


@end
