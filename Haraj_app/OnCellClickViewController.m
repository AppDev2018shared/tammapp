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


#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH self.view.frame.size.width-138

#define CELL_CONTENT_MARGIN 0.0f

@interface OnCellClickViewController ()<UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIView *sectionView;
    
    UIScrollView *scrollView;
    UIImageView *imageView;
    UIPageControl *pageControll;
    
    FirstImageViewCell *FirstCell;
   
    NSString *total_image;
    NSURL * imageUrl;
    NSUserDefaults *defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_MakeOffer, *Connection_SuggestPost;
    NSMutableData *webData_MakeOffer, *webData_SuggestPost;
    NSMutableArray *Array_MakeOffer, *Array_SuggestPost;
    
    CGFloat newCellHeight;
    CGFloat Xpostion, Ypostion, Xwidth, Yheight, ScrollContentSize,Xpostion_label, Ypostion_label, Xwidth_label, Yheight_label,Cell_DescLabelX,Cell_DescLabelY,Cell_DescLabelW,Cell_DescLabelH,TextView_ViewX,TextView_ViewY,TextView_ViewW,TextView_ViewH;
    CGFloat FavIV_X,FavIV_Y,FavIV_W,FavIV_H,FavLabel_X,FavLabel_Y,FavLabel_W,FavLabel_H;
    
    NSString *str_LabelCoordinates,*str_TappedLabel,*str_postid,*str_userid;;
    NSString *text;
    
    UITextField *amountTextField ;
    UITextView *commentTextView;
     CGFloat button_threeDotsx,button_threeDotsy,button_threeDotsw,button_threeDotsh,button_favx,button_favy,button_favw,button_favh,button_arrowx,button_arrowy,button_arroww,button_arrowh;
}

@end

@implementation OnCellClickViewController
@synthesize Array_UserInfo,swipeCount,Cell_two,MoreImageArray,detailCell,ComCell,SuggestCell;

- (void)viewDidLoad
{
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
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    NSLog(@" array info %@",Array_UserInfo);
    
    
    
    str_TappedLabel=@"no";
    str_LabelCoordinates=@"no";
    
    text = [[Array_UserInfo objectAtIndex:swipeCount]valueForKey:@"description"];
    str_postid= [[Array_UserInfo objectAtIndex:swipeCount]valueForKey:@"postid"];
    str_userid = [[Array_UserInfo objectAtIndex:swipeCount]valueForKey:@"userid1"];
    [self SuggestPostConnection];
    
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
    
    if (swipeCount >= 0 && swipeCount < Array_UserInfo.count-1)
    {
        swipeCount +=1;
    
    
    NSLog(@ "Left= %ld",(long)swipeCount);
  //  imageUrl=[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:swipeCount]];
   
        str_postid= [[Array_UserInfo objectAtIndex:swipeCount]valueForKey:@"postid"];
        str_userid = [[Array_UserInfo objectAtIndex:swipeCount]valueForKey:@"userid1"];
         [self SuggestPostConnection];
    
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
        str_postid= [[Array_UserInfo objectAtIndex:swipeCount]valueForKey:@"postid"];
               str_userid = [[Array_UserInfo objectAtIndex:swipeCount]valueForKey:@"userid1"];
                [self SuggestPostConnection];
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
        
         ;
    }
    
    
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
        return 2;
    }
    else if (section == 3)
    {
        return 1;
    }
   
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // imageUrl=[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:indexPath.row]];
    
    NSDictionary *dic_request=[Array_UserInfo objectAtIndex:swipeCount];
    NSLog(@"dic= %@",dic_request);
    static NSString *cell_two1=@"Cell_Two";
    static NSString *cell_details=@"DetailCell";
    static NSString *cell_comments=@"ComCell";
    static NSString *cell_suggest=@"PostCell";
    
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
                
                
                if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"IMAGE"])
                {
                    Cell_two.image_play1.hidden = YES;
                    Cell_two.image_play2.hidden = YES;
                }
                else
                {
                    
                    Cell_two.image_play1.hidden = NO;
                    Cell_two.image_play2.hidden = NO;
                }
                
                NSURL *url=[NSURL URLWithString:[dic_request valueForKey:@"mediaurl"]];
                
                [Cell_two.image1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                
                [Cell_two.image2 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                
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
                
                /*
                 
                 if([NSNull null] ==[[Array_Car  objectAtIndex:0]valueForKey:@"mediatype"] || [[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
                 {
                 
                 //    if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"]  )
                 //    {
                 PatternViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
                 
                 NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediaurl"]];
                 if([NSNull null] ==[dic_request valueForKey:@"mediaurl"])
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
                 

                
                
                
                */
                
                if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"IMAGE"])
                {
                    FirstCell.image_play.hidden = YES;
                }
                else
                {
                    
                    FirstCell.image_play.hidden = NO;
                }
                
                NSURL *url=[NSURL URLWithString:[dic_request valueForKey:@"mediaurl"]];
                
                [FirstCell.imageView_thumbnails sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] options:SDWebImageRefreshCached];
                
                
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
            
            
            [detailCell.detailinfoTextView setText:text];
            detailCell.locationLabel.text = [dic_request valueForKey:@"city1"];
            detailCell.hashtagLabel.text = [dic_request valueForKey:@"hashtags"];
            detailCell.postidLabel.text = [NSString stringWithFormat:@"POST ID: %@",[dic_request valueForKey:@"postid"]];
            [defaults setObject:[dic_request valueForKey:@"postid"] forKey:@"post-id"];
            
            
            detailCell.usernameLabel.text = [dic_request valueForKey:@"usersname"];
            detailCell.durationLabel.text = [dic_request valueForKey:@"postdur"];
            
            NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
            detailCell.priceLabel.text = show;//[dic_request valueForKey:@"showamount"];
            detailCell.timeLabel.text = [dic_request valueForKey:@"createtime"];
            detailCell.titleLabel.text = [dic_request valueForKey:@"title"];
            
            
            NSURL *url=[NSURL URLWithString:[dic_request valueForKey:@"usersprofilepic"]];
            
            [detailCell.profileImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
            detailCell.profileImage.layer.cornerRadius = detailCell.profileImage.frame.size.height / 2;
            detailCell.profileImage.clipsToBounds = YES;
            

            
            
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
#pragma mark -suggest cell
        case 3:
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
            
            
            return 520+detailCell.detailinfoTextView1.frame.size.height-38;
            
        }
        else
        {
            
            if ((long)rHeight==1)
            {
                 return 520;
            }
            else
            {
                return 520+56;
            }
            
            
        }

        

    }
   
    else if (indexPath.section == 2)
    {
        return 120;
    }
    else if (indexPath.section == 3)
    {
        return 280;
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
    
    if (section == 3)
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
        return 40;
    }
    if (section==3)
    {
        return 40;
    }

    
    return 0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
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
    if (section == 2)
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
    [grayView addSubview:commentTextView];
    
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (amountTextField.text.length  == 0)
    {
        amountTextField.text = @"$";
    }
    
    //amountTextField.text = @"$";//[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [amountTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![newText hasPrefix:@"$"])
    {
        return NO;
    }
    
    // Default:
    return YES;
    
}


#pragma mark - PopOver Button Action


- (void)closedd:(id)sender
{
    [self.view endEditing:YES];
 
    transparentView.hidden=YES;
    
}

- (void)confirm:(id)sender
{
    
    
    [self CreateMakeOfferConnection];
    transparentView.hidden=YES;
    [self.view endEditing:YES];
    
    
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
    [transparentView addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(button_arrowx, button_arrowy, button_arroww, button_arrowh)];
    [button3 setImage:[UIImage imageNamed:@"Whitearrow"] forState:UIControlStateNormal];
    [button3 setTag:3];
    [button3 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [transparentView addSubview:button3];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,160,self.view.frame.size.width , self.view.frame.size.height -160)];
    scrollView.backgroundColor = [UIColor greenColor];
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
    
    
    
    [self.tableView reloadData];
//    [self.tableView  reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView  endUpdates];
    
    
}
#pragma mark - NSURL CONNECTION

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
            
        }
        else if ([ResultString isEqualToString:@"inserterror"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"TWe encountered some error, please try again." preferredStyle:UIAlertControllerStyleAlert];
            
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
