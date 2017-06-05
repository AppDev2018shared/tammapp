//
//  ViewController.m
//  Haraj_app
//
//  Created by udaysinh on 23/04/17.
//  Copyright (c) 2017 udaysinh. All rights reserved.
//https://github.com/Zws-China/ImageLayout
//https://github.com/usagimaru/USGScrollingTabBar

#import "ViewController.h"
#import "YSLContainerViewController.h"
#import "PostingViewController.h"
#import "CarsViewController.h"
#import "PropertyViewController.h"
#import "ElectronicViewController.h"
#import "AllViewController.h"
#import "PetsViewController.h"
#import "FurnitureViewController.h"
#import "ServicesViewController.h"
#import "OtherViewController.h"

#import "LGPlusButtonsView.h"



@interface ViewController ()<YSLContainerViewControllerDelegate>
{
    UILabel *titleLabel;
    NSUserDefaults *defaults;
}
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [[NSUserDefaults alloc]init];
  //  [defaults setObject:@"no" forKey:@"LoginView"];
    [defaults synchronize];
    
//    ViewController *mController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    
//    [self.view.layer addAnimation:transition forKey:nil];
//    
//    [self.navigationController pushViewController:mController animated:YES];

    
    // Do any additional setup after loading the view, typically from a nib.
    // NavigationBar
    
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
    
    CarsViewController *carVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"CarsViewController"];
    carVC.title = @"Cars";
    
    PropertyViewController *propertyVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PropertyViewController"];
    propertyVC.title = @"Property";
    
    
    ElectronicViewController *electronicVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ElectronicViewController"];
    electronicVC.title = @"Electronics";
    
    AllViewController *allVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewController"];
    allVC.title = @"All";
    
    PetsViewController *petsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PetsViewController"];
    petsVC.title = @"Pets";
    
    FurnitureViewController * furnitureVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"FurnitureViewController"];
    furnitureVC.title = @"Furniture";
    
    ServicesViewController *serviceVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ServicesViewController"];
    serviceVC.title = @"Service";
    
    OtherViewController * otherVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"OtherViewController"];
    otherVC.title = @"Other";
    
    
    
    // ContainerView
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[allVC,carVC,propertyVC,electronicVC,petsVC,furnitureVC,serviceVC,otherVC]topBarHeight:statusHeight + navigationHeight
                                                            parentViewController:self];
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:18];
    [self.view addSubview:containerVC.view];
    
    
   
    

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _plusButtonsViewMain = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:8
                                                         firstButtonIsPlusButton:YES
                                                                   showAfterInit:YES
                                                                   actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                            {
                                NSLog(@"actionHandler | title: %@, description: %@, index: %lu", title, description, (long unsigned)index);
                                
                                if (index == 1)
                                {
                                    
                                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    
                                    
                                    PostingViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"PostingViewController"];
                                    
                                     set.name = @"car" ;
                                    
                                    CATransition *transition = [CATransition animation];
                                    transition.duration = 0.3;
                                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                    transition.type = kCATransitionPush;
                                    transition.subtype = kCATransitionFromLeft;
                                    
                                    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                                    
                                    [self.navigationController pushViewController:set animated:YES];
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePlusButton" object:self userInfo:nil];
                                }
                                else if(index == 2)
                                {
                                    [defaults setValue:@"property" forKey:@"Title"];
                                    [self postFunction];
                                }
                                else if(index == 3)
                                {
                                    [defaults setValue:@"electronics" forKey:@"Title"];
                                    [self postFunction];
                                }
                                else if(index == 4)
                                {
                                    [defaults setValue:@"pets" forKey:@"Title"];
                                    [self postFunction];
                                }
                                else if(index == 5)
                                {
                                    [defaults setValue:@"furniture" forKey:@"Title"];
                                    [self postFunction];
                                }
                                else if(index == 6)
                                {
                                    [defaults setValue:@"services" forKey:@"Title"];
                                    [self postFunction];
                                }
                                else if(index == 7)
                                {
                                    [defaults setValue:@"others" forKey:@"Title"];
                                    [self postFunction];
                                }
                                
                                
                                
                            }];
    
    
    _plusButtonsViewMain.coverColor = [UIColor colorWithWhite:2.f alpha:0.3];
    _plusButtonsViewMain.position = LGPlusButtonsViewPositionBottomRight;
    _plusButtonsViewMain.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    [_plusButtonsViewMain setButtonsTitles:@[@"", @"", @"", @"",@"",@"",@"",@""] forState:UIControlStateNormal];
    [_plusButtonsViewMain setDescriptionsTexts:@[@"", @"Cars", @"Property", @"Electronics", @"Pets", @"Furniture", @"Services", @"Other"]];
    [_plusButtonsViewMain setButtonsImages:@[[UIImage imageNamed:@"Float"], [UIImage imageNamed:@"Cars"], [UIImage imageNamed:@"Property"], [UIImage imageNamed:@"Electronics"], [UIImage imageNamed:@"Pets"], [UIImage imageNamed:@"Furniture"], [UIImage imageNamed:@"Services"], [UIImage imageNamed:@"Other"]]
                                  forState:UIControlStateNormal
                            forOrientation:LGPlusButtonsViewOrientationAll];
    
    [_plusButtonsViewMain setButtonsAdjustsImageWhenHighlighted:NO];
    
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonsBackgroundColor:[UIColor colorWithRed:0.2 green:0.6 blue:1.f alpha:1.f] forState:UIControlStateHighlighted|UIControlStateSelected];
    
    [_plusButtonsViewMain setButtonsSize:CGSizeMake(44.f, 44.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonsLayerCornerRadius:44.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonsTitleFont:[UIFont boldSystemFontOfSize:24.f] forOrientation:LGPlusButtonsViewOrientationAll];
//    [_plusButtonsViewMain setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
//    [_plusButtonsViewMain setButtonsLayerShadowOpacity:0.5];
//    [_plusButtonsViewMain setButtonsLayerShadowRadius:3.f];
//    [_plusButtonsViewMain setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    
    [_plusButtonsViewMain setButtonAtIndex:0 size:CGSizeMake(56.f, 56.f)
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 layerCornerRadius:56.f/2.f
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:40.f]
                            forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    
    [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -3.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:1 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:2 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:3 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:4 backgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:4 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:5 backgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:5 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:6 backgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:6 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    [_plusButtonsViewMain setButtonAtIndex:7 backgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
    [_plusButtonsViewMain setButtonAtIndex:7 backgroundColor:[UIColor colorWithRed:0.f green:0.8 blue:0.f alpha:1.f] forState:UIControlStateHighlighted];
    
    
    
    
    [_plusButtonsViewMain setDescriptionsBackgroundColor:[UIColor colorWithRed:186/255.0 green:188/255.0 blue:190/255.0 alpha:1]];
    [_plusButtonsViewMain setDescriptionsTextColor:[UIColor whiteColor]];
    [_plusButtonsViewMain setDescriptionsFont:[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:15] forOrientation:LGPlusButtonsViewOrientationAll];
//    [_plusButtonsViewMain setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
//    [_plusButtonsViewMain setDescriptionsLayerShadowOpacity:0.25];
//    [_plusButtonsViewMain setDescriptionsLayerShadowRadius:1.f];
//    [_plusButtonsViewMain setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [_plusButtonsViewMain setDescriptionsOffset:CGPointMake(24.f, 0.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setDescriptionsLayerCornerRadius:12.f forOrientation:LGPlusButtonsViewOrientationAll];
    [_plusButtonsViewMain setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 16.f, 4.f, 20.f) forOrientation:LGPlusButtonsViewOrientationAll];
    
    for (NSUInteger i=1; i<=7; i++)
        [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, -13.f)
                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
  
    [self.view addSubview:_plusButtonsViewMain];
    
}


-(void)postFunction
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PostingViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"PostingViewController"];
    
    set.name = [defaults valueForKey:@"Title"] ;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:set animated:YES];
    
    
    
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
