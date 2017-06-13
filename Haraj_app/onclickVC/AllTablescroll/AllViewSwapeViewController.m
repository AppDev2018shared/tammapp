//
//  AllViewSwapeViewController.m
//  Haraj_app
//
//  Created by Spiel's Macmini on 6/12/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "AllViewSwapeViewController.h"
#import "YSLContainerViewController1.h"
#import "OnCellClickViewController.h"
#import "MyPostViewController.h"
@interface AllViewSwapeViewController ()
{
    NSUserDefaults * defaults;
    
}

@end

@implementation AllViewSwapeViewController
@synthesize Array_Alldata,tuchedIndex;

- (void)viewDidLoad

{
      NSLog(@"All dataArray==%@",Array_Alldata);
    
    [super viewDidLoad];
    defaults=[[NSUserDefaults alloc]init];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 30;
    
    
    UIButton *profile = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [profile setImage:[UIImage imageNamed:@"Profile"] forState:UIControlStateNormal];
    profile.tag = 1;
    [profile addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemProfile = [[UIBarButtonItem alloc]initWithCustomView:profile];
    
    UIButton *activity = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [activity setImage:[UIImage imageNamed:@"Activity"] forState:UIControlStateNormal];
    activity.tag = 2;
    [activity addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemactivity = [[UIBarButtonItem alloc]initWithCustomView:activity];
    
    UIButton *search = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [search setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
    search.tag = 3;
    [search addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemsearch = [[UIBarButtonItem alloc]initWithCustomView:search];
    
    UIButton *location = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [location setImage:[UIImage imageNamed:@"Location_off"] forState:UIControlStateNormal];
    location.tag = 4;
    [location addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemlocation = [[UIBarButtonItem alloc]initWithCustomView:location];
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, 50, 30)];
    nameLabel.text = @"sAPP";
    nameLabel.textColor = [UIColor blackColor];
    UIBarButtonItem *itemName = [[UIBarButtonItem alloc]initWithCustomView:nameLabel];
    
    
    self.navigationItem.leftBarButtonItems= [NSArray arrayWithObjects:space,itemProfile,space,itemactivity,space,itemsearch,space,itemlocation,itemName,nil];
    
    
    
    //View Controllers
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    [defaults setObject:@"no" forKey:@"imagetapped"];
            [defaults synchronize];
    //
    NSMutableArray * view111=[[NSMutableArray alloc]init];
    
    for (int i=0; i<Array_Alldata.count; i++)
    {
        if ([[[Array_Alldata objectAtIndex:i] valueForKey:@"userid1"]isEqualToString:[defaults valueForKey:@"userid"]])
        {
            
            
            MyPostViewController * serviceVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
            serviceVC.Array_UserInfo=[Array_Alldata objectAtIndex:i];
            serviceVC.swipeCount=i;
            serviceVC.title =[NSString stringWithFormat:@"%@%d",@"Service",i];
            serviceVC.view.backgroundColor=[UIColor redColor];
            serviceVC.view.tag=i;
            serviceVC.Array_All_UserInfo=Array_Alldata;
            [view111 addObject:serviceVC];

                }
        else
        {
            
            
            OnCellClickViewController *serviceVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"OnCellClickViewController"];
            serviceVC.Array_UserInfo=[Array_Alldata objectAtIndex:i];
            serviceVC.swipeCount=i;
            serviceVC.title =[NSString stringWithFormat:@"%@%d",@"Service",i];
            serviceVC.view.backgroundColor=[UIColor redColor];
            serviceVC.view.tag=i;
            serviceVC.Array_All_UserInfo=Array_Alldata;
            [view111 addObject:serviceVC];
            NSLog(@"All dataArray==%@",[Array_Alldata objectAtIndex:i]);

                    }
    }
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController1 *containerVC = [[YSLContainerViewController1 alloc]initWithControllers:view111 topBarHeight:statusHeight + navigationHeight
                                                                                  parentViewController:self];
    containerVC.TuchedIndexCount=tuchedIndex;
   
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:18];
    [self.view addSubview:containerVC.view];
    
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


-(void)postFunction
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePlusButton" object:self userInfo:nil];
    
}


-(void)topButton:(id)sender
{
    if ([sender tag]== 1)
    {
        NSLog(@"Profile Button Pressed");
    }
    
    else if ([sender tag]== 2)
    {
        NSLog(@"activity Button Pressed");
    }
    else if ([sender tag]== 3)
    {
        NSLog(@"search Button Pressed");
    }
    else
    {
        NSLog(@"location Button Pressed");
    }
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    NSLog(@"current Index : %ld",(long)index);
    NSLog(@"current controller : %@",controller);
    
    
    
    
    
    [controller viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
