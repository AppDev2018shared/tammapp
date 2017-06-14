//
//  MoreImageScrollViewController.m
//  Haraj_app
//
//  Created by Spiel's Macmini on 6/14/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "MoreImageScrollViewController.h"

@interface MoreImageScrollViewController ()

@end

@implementation MoreImageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    //    transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //    transparentView.backgroundColor=[UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:0.95];
    //
    //    NSLog(@"FirstCell=%f",FirstCell.button_threedots.frame.origin.y);
    //    NSLog(@"cell two=%f",Cell_two.button_threedots.frame.origin.y);
    //
    //    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(button_threeDotsx,button_threeDotsy, button_threeDotsw, button_threeDotsh)];
    //    [button1 setImage:[UIImage imageNamed:@"3dots"] forState:UIControlStateNormal];
    //    [button1 setTag:1];
    //    [button1 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    [transparentView addSubview:button1];
    //
    //    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(button_favx, button_favy, button_favw, button_favh)];
    //    [button2 setImage:[UIImage imageNamed:@"Whitefavourite"] forState:UIControlStateNormal];
    //    [button2 setTag:2];
    //    [button2 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    [transparentView addSubview:button2];
    //
    //    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(button_arrowx, button_arrowy, button_arroww, button_arrowh)];
    //    [button3 setImage:[UIImage imageNamed:@"Whitearrow"] forState:UIControlStateNormal];
    //    [button3 setTag:3];
    //    [button3 addTarget:self action:@selector(sectionHeaderTopButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    [transparentView addSubview:button3];
    //
    //    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,160,self.view.frame.size.width , self.view.frame.size.height -160)];
    //    scrollView.backgroundColor = [UIColor greenColor];
    //    scrollView.center = transparentView.center;
    //    scrollView.delegate = self;
    //    scrollView.pagingEnabled = YES;
    //
    //    MoreImageArray = [[NSArray alloc] initWithObjects:@"1.png", @"2.png", @"3.png", nil];
    //
    //    for (int i = 0; i < [MoreImageArray count]; i++ ) {
    //        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //
    //        CGRect frame;
    //        frame.origin.x = scrollView.frame.size.width * i;
    //        frame.origin.y = 0;
    //        frame.size = scrollView.frame.size;
    //
    //        imageView = [[UIImageView alloc] initWithFrame:frame];
    //        // imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:i]];
    //        // imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[Array_UserInfo valueForKey:@"image_url"] objectAtIndex:swipeCount + i]]]];
    //        //  [FirstCell.imageView sd_setImageWithURL:imageUrl];
    //        imageView.contentMode = UIViewContentModeCenter;
    //        imageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    //        [scrollView addSubview:imageView];
    //
    //        NSLog (@"page %d",page);
    //
    //    }
    //    scrollView.contentSize = CGSizeMake(scrollView.frame.size.
    //                                        width *[MoreImageArray count],
    //                                        scrollView.frame.size.height);
    //
    //    pageControll = [[UIPageControl alloc]init];
    //    pageControll.frame = CGRectMake(375/2-20, transparentView.frame.size.height - 100, 40, 10);
    //    pageControll.numberOfPages = MoreImageArray.count;
    //    pageControll.currentPage = 0;
    //    [pageControll setPageIndicatorTintColor:[UIColor grayColor]];
    //    
    //    [transparentView addSubview:scrollView];
    //    [transparentView addSubview:pageControll];
    //    [self.view addSubview:transparentView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Button_BackAction:(id)sender
{
    
}
-(IBAction)Button_ThreedotsAction:(id)sender
{
    
}
-(IBAction)Button_FavouriteAction:(id)sender
{
    
}

@end
