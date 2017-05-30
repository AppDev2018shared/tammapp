//
//  OnCellClickViewController.m
//  Haraj_app
//
//  Created by Spiel on 08/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "OnCellClickViewController.h"
#import "FirstImageViewCell.h"
#import "DetailInfoCell.h"
#import "BidAmountCell.h"
#import "CommentCell.h"
#import "SuggestedPostCell.h"
#import "UIImageView+WebCache.h"

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH self.view.frame.size.width-138

#define CELL_CONTENT_MARGIN 0.0f

@interface OnCellClickViewController ()<UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate,UIScrollViewDelegate>
{
    UIView *sectionView;
    
    UIScrollView *scrollView;
    UIImageView *imageView;
    UIPageControl *pageControll;
    
    FirstImageViewCell *FirstCell;
    DetailInfoCell *detailCell;
    NSString *total_image;
    NSURL * imageUrl;
    NSUserDefaults *defaults;
    
    CGFloat newCellHeight;
    CGFloat Xpostion, Ypostion, Xwidth, Yheight, ScrollContentSize,Xpostion_label, Ypostion_label, Xwidth_label, Yheight_label,Cell_DescLabelX,Cell_DescLabelY,Cell_DescLabelW,Cell_DescLabelH,TextView_ViewX,TextView_ViewY,TextView_ViewW,TextView_ViewH;
    CGFloat FavIV_X,FavIV_Y,FavIV_W,FavIV_H,FavLabel_X,FavLabel_Y,FavLabel_W,FavLabel_H;
    
    NSString *str_LabelCoordinates,*str_TappedLabel;
    NSString *text;
}

@end

@implementation OnCellClickViewController
@synthesize Array_UserInfo,swipeCount,Cell_two,MoreImageArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
//    UIView *lineFix = [[UIView alloc] initWithFrame:CGRectMake(0, 77.5, self.tableView.frame.size.width, 0.5)];
//    lineFix.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    [self.tableView addSubview:lineFix];
    
    NSLog(@" array info %@",Array_UserInfo);
   
    total_image = @"1";

    
    
    str_TappedLabel=@"no";
    str_LabelCoordinates=@"no";
    text =@"udfgsdfgf iudhgiufd rgfod gfd ggdfhgiudfg fdihgdfiug dfiughfdiug dfihgdfiu gdfiguhdfuigh fdiughdfiugh dfiug hdfiughdfuig ghfdig dfigdf igfdiug fdiughdfiug fdiugh udfihg dfiugh uig dfiughdfuig hfdiugdfiuhgfdig ighfig gdfiughdf ghfdighdfihg fdiughifdu giufdgh i gdfghdfsagf gdsgfih asfdf gdsifui";
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

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    //Get location of the swipe
//    CGPoint location = [gestureRecognizer locationInView:self.tableView];
//    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:location];
//    FirstCell  = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
    
    swipeCount +=1;
    NSLog(@ "Left= %ld",(long)swipeCount);
  //  imageUrl=[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:swipeCount]];
   

    
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

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    
    
     swipeCount -=1;
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
        
//        selectedDay--;
//        [self fetchDataFromWeb];
    

}

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
        return 2;
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
            detailCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            detailCell.locationLabel.text = [dic_request valueForKey:@"city1"];
            detailCell.hashtagLabel.text = [dic_request valueForKey:@"hashtags"];
            [detailCell.hashtagLabel sizeToFit];
            detailCell.postidLabel.text = [NSString stringWithFormat:@"POST ID:%@",[dic_request valueForKey:@"postid"]];//[dic_request valueForKey:@"postid"];
            detailCell.usernameLabel.text = [dic_request valueForKey:@"usersname"];
            
            NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
            detailCell.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
            detailCell.timeLabel.text = [dic_request valueForKey:@"createtime"];
            detailCell.titleLabel.text = [dic_request valueForKey:@"title"];
            //detailCell.profileImage.image =
            
            NSURL * url=[[NSURL alloc]initWithString:[dic_request valueForKey:@"usersprofilepic"]];//[[Array_UserInfo objectAtIndex:0]valueForKey:@"usersprofilepic"];
            NSData *data = [[NSData alloc]initWithContentsOfURL:url];
            detailCell.profileImage.layer.cornerRadius = detailCell.profileImage.frame.size.height / 2;
            detailCell.profileImage.clipsToBounds = YES;
            
            detailCell.profileImage.image = [UIImage imageWithData:data];
            
           // [detailCell.profileImage sd_setImageWithURL:url];

          // [detailCell.profileImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"swift.jpg"]options:SDWebImageRefreshCached];
            
            
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
                
                
                
                NSLog(@"Dynamic label heightc====%f",Cell_DescLabelX);
                NSLog(@"Dynamic label heightc====%f",Cell_DescLabelY);
                NSLog(@"Dynamic label heightc====%f",Cell_DescLabelW);
                NSLog(@"Dynamic label heightc====%f",Cell_DescLabelH);
                
                
                
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
            

           
            return detailCell;
        }
            break;

        case 2:
        {
            BidAmountCell *BidCell = [tableView dequeueReusableCellWithIdentifier:@"BidCell"];
            [BidCell.makeOfferButton  addTarget:self action:@selector(makeOfferPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            return BidCell;
        }
            break;

        case 3:
        {
            CommentCell *ComCell = [tableView dequeueReusableCellWithIdentifier:@"ComCell"];
        
            ComCell.profileImageView.layer.cornerRadius = ComCell.profileImageView.frame.size.height / 2;
            ComCell.profileImageView.clipsToBounds = YES;

            
            return ComCell;
        }
            break;

        case 4:
        {
            SuggestedPostCell *SuggestCell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
            
            return SuggestCell;
            
        }
            break;

    
    }
    return nil;

}

- (void)myAction{
    
    
    
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
      //  NSString *text =@"udfgsdfgf dgsgfgsdf gdfghdfsagf gdsgfih asfdf gdsifui";//[[AllArrayData objectAtIndex:0]valueForKey:@"title"];;
        
        
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
            
            
            return 470+detailCell.detailinfoTextView1.frame.size.height-38;
            
            
            
            
        }
        else
        {
            
            if ((long)rHeight==1)
            {
                      return 470;
            }
            else
            {
                return 470+26;
            }
            
            
        }

        

    }
    else if (indexPath.section == 2)
    {
        return 84;
    }
    else if (indexPath.section == 3)
    {
        return 120;
    }else if (indexPath.section == 4)
    {
        return 150;
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
    if (section==3)
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
    if (section==1)
    {
        return 40;
    }
    if (section==3)
    {
        return 40;
    }
    if (section==4)
    {
        return 40;
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
    if (section == 3)
    {
        return 40;
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
    
   NSLog(@"post comment Pressed");
    
}

-(void)seeCommentButtonPressed:(id)sender
{
     NSLog(@"See comment Pressed");
    
}

-(void)makeOfferPressed:(id)sender
{
    NSLog(@"makeOffer Pressed");
    
    transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    grayView=[[UIView alloc]initWithFrame:CGRectMake(50,256, 275, 250)];
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
    label2.text = @"POST ID:45645648W3";
    label2.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [grayView addSubview:label2];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(17, 60, 243, 40)];
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:22];
    textField.text = @"$20000";
    textField.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 4;
    textField.clipsToBounds = YES;
    [grayView addSubview:textField];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(52, 108, 208, 21)];
    label3.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:14];
    label3.textAlignment = NSTextAlignmentRight;
    label3.text = @"Add a comment with your offer?";
    [grayView addSubview:label3];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(17, 132, 243, 65)];
    textView.textAlignment = NSTextAlignmentRight;
    textView.layer.cornerRadius = 4;
    textView.clipsToBounds = YES;
    [grayView addSubview:textView];
    
    
    UIButton *confirm=[[UIButton alloc]initWithFrame:CGRectMake(0, 206, 275, 44)];
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

#pragma mark - PopOver Button Action


- (void)closedd:(id)sender
{
 
    transparentView.hidden=YES;
    
}

- (void)confirm:(id)sender
{
    
    transparentView.hidden=YES;
    
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

-(void)MoreImage:(UITapGestureRecognizer *)sender
{
#pragma mark- --more image scroll view
    
    transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor=[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.95];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(15,20, 40, 40)];
    [button1 setImage:[UIImage imageNamed:@"3dots"] forState:UIControlStateNormal];
    [button1 setTag:1];
    [button1 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(80, 20, 40, 40)];
    [button2 setImage:[UIImage imageNamed:@"Whitefavourite"] forState:UIControlStateNormal];
    [button2 setTag:2];
    [button2 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width  - 95, 20, 40, 40)];
    [button3 setImage:[UIImage imageNamed:@"Whitearrow"] forState:UIControlStateNormal];
    [button3 setTag:3];
    [button3 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button3];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , self.view.frame.size.height -160)];
    scrollView.center = transparentView.center;
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
    
    
    
    [self.tableView beginUpdates];
    [self.tableView  reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView  endUpdates];
    
    
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
