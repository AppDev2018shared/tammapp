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


@interface OnCellClickViewController ()<UITableViewDataSource, UITableViewDelegate,UIPopoverPresentationControllerDelegate>
{
    UIView *sectionView;
    
    FirstImageViewCell *FirstCell;
    NSURL * imageUrl;
}

@end

@implementation OnCellClickViewController
@synthesize Array_UserInfo,swipeCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
   
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    
    switch (indexPath.section)
    {
                     case 0:
        {
            FirstCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
          //  [FirstCell.imageView sd_setImageWithURL:imageUrl];
            return FirstCell;
        }
            break;
        case 1:
        {
            DetailInfoCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            detailCell.locationLabel.text = [dic_request valueForKey:@"city1"];
            detailCell.hashtagLabel.text = [dic_request valueForKey:@"hashtags"];
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

//[detailCell.profileImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"swift.jpg"]options:SDWebImageRefreshCached];
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 434;
    }
    else if (indexPath.section == 1)
    {
        return 470;
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
    
    if (section==0)
    {
        
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, -100,self.view.frame.size.width,40)];//36
        
        
        UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 0, 40, 40)];
        [button1 setImage:[UIImage imageNamed:@"3dots"] forState:UIControlStateNormal];
        [button1 setTag:1];
        [button1 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(110, 0, 40, 40)];
        [button2 setImage:[UIImage imageNamed:@"Whitefavourite"] forState:UIControlStateNormal];
        [button2 setTag:2];
        [button2 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button2];
        
        UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width  - 95, 0, 40, 40)];
        [button3 setImage:[UIImage imageNamed:@"Whitearrow"] forState:UIControlStateNormal];
        [button3 setTag:3];
        [button3 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:button3];
        
        sectionView.tag=section;
        
    }
    
    
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
    if (section==0)
    {
        return 40;
    }
    
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

        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        

        
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
    
  //  grayView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width- 137.5, self.view.frame.size.height - 125, 275, 250)];
   // grayView.center=transparentView.center;
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



@end

//Consumer key (API Key):
//bB8ASgppAnfalb0BHCwa63dqU
//
//Consumer secret (API Secret):
//AC168EC7WKu588JAp04gZkPop2WHbeaznp5O9JQEldAXSnyiMy



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
