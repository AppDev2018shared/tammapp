//
//  RootViewController.m
//  PageViewDemo
//
//  Created by abc on 18/02/15.
//  Copyright (c) 2015 com.TheAppGuruz. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
  
    NSUserDefaults * defaults;
   
}@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation RootViewController

@synthesize PageViewController;
@synthesize Array_Alldata;



- (void)viewDidLoad
{
    [super viewDidLoad];
    defaults=[[NSUserDefaults alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ScrollView_Disable:) name:@"ScrollViewDisable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ScrollView_Enable:) name:@"ScrollViewEnable" object:nil];

   
    
    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = self;
    
    UIPageViewController *startingViewController = [self viewControllerAtIndex:_tuchedIndex];
    
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    
    if (self.view.frame.size.width==375 && self.view.frame.size.height==812)
    {
        
        
          self.PageViewController.view.frame = CGRectMake(0,35, self.view.frame.size.width, self.view.frame.size.height+38);
        
    }
    else
    {
        self.PageViewController.view.frame = CGRectMake(0,20, self.view.frame.size.width, self.view.frame.size.height + 20);
    }
    
 
    
    [self addChildViewController:PageViewController];
    [self.view addSubview:PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Page View Datasource Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(id)viewController pageIndex];;
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;//[self viewControllerAtIndex:self.Array_Alldata.count-1];
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(id)viewController pageIndex];
    
    if (index == NSNotFound)
    {
        return [self viewControllerAtIndex:0];
    }
    
    index++;
    if (index == [self.Array_Alldata count])
    {
        return nil;// [self viewControllerAtIndex:0];
    }
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - Other Methods
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
  
    
    if (([self.Array_Alldata count] == 0) || (index >= [self.Array_Alldata count]))
    {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
//    MyPostViewController *pageContentViewController;
    NSLog(@"Account match==%@",[[Array_Alldata objectAtIndex:index] valueForKey:@"userid1"]); NSLog(@"Account defaults==%@",[defaults valueForKey:@"userid"]);
    if ([[[Array_Alldata objectAtIndex:index] valueForKey:@"userid1"]isEqualToString:[defaults valueForKey:@"userid"]])
            {
        
               MyPostViewController * pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPostViewController"];
                pageContentViewController.Array_UserInfo = [Array_Alldata objectAtIndex:index];
          pageContentViewController.pageIndex = index;
                return pageContentViewController;
            }
        
        
            else
            {
                    OnCellClickViewController *   pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnCellClickViewController"];
                pageContentViewController.Array_UserInfo = [Array_Alldata objectAtIndex:index];
                pageContentViewController.pageIndex = index;
                
              return pageContentViewController;
         
            }
        
    

 
    return nil;
}

#pragma mark - No of Pages Methods
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.Array_Alldata count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)ScrollView_Disable:(NSNotification *)notification
{
    for (UIScrollView *view in self.PageViewController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = NO;
        }
    }
    
    
    
}
-(void)ScrollView_Enable:(NSNotification *)notification
{
    
    for (UIScrollView *view in self.PageViewController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = YES;
        }
    }
    }



@end
