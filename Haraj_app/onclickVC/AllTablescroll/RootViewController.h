//
//  RootViewController.h
//  PageViewDemo
//
//  Created by abc on 18/02/15.
//  Copyright (c) 2015 com.TheAppGuruz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnCellClickViewController.h"
#import "MyPostViewController.h"

@interface RootViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;

@property (strong, nonatomic) NSMutableArray * Array_Alldata;
@property (nonatomic,assign) NSInteger tuchedIndex;

@property (nonatomic,strong) UIPageViewController *PageViewController;

@end
