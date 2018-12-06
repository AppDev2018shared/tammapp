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
#import "SBJsonParser.h"
#import "Reachability.h"
#import "PostingViewController.h"
#import "CarsViewController.h"
#import "PropertyViewController.h"
#import "ElectronicViewController.h"
#import "AllViewController.h"
#import "PetsViewController.h"
#import "FurnitureViewController.h"
#import "ServicesViewController.h"
#import "OtherViewController.h"
#import "ProfileViewController.h"
#import "ActivityViewController.h"
#import "SearchViewController.h"
#import "SVPullToRefresh.h"

#import "LGPlusButtonsView.h"

//ViewControllerData

@interface ViewController ()<YSLContainerViewControllerDelegate,UISearchBarDelegate, UISearchResultsUpdating,UISearchControllerDelegate >
{
    UILabel *titleLabel;
    NSUserDefaults *defaults;
    CALayer *borderBottom_topheder;
    
    UIActivityIndicatorView *activityindicator;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_ViewPost;
    NSMutableData *webData_ViewPost;
    NSMutableArray *Array_ViewPost,*Array_Car,*Array_Property,*Array_Electronics,*Array_Pets,*Array_Furniture,*Array_Others,*Array_Services,*Array_ActivityTicker,*Array_ViewPost1;
    
    int favouritesCount;
    
    NSInteger pageCount,pageCount1,pageCount2,pageCount3,pageCount4,pageCount5,pageCount6,pageCount7,pageCount8;
    
    NSTimer *BadgeTimer;
    NSString *categorynameStr;
    
}

@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;


@end

@implementation ViewController
@synthesize navigationView,profile,activity,search,location,locationLabel,nameLabel,badgeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    favouritesCount = 0;
    pageCount = 0 ;
    
    
    Array_ViewPost =[[NSMutableArray alloc]init];
    Array_Car = [[NSMutableArray alloc]init];
    Array_Property= [[NSMutableArray alloc]init];
    Array_Electronics=[[NSMutableArray alloc]init];
    Array_Furniture=[[NSMutableArray alloc]init];
    Array_Pets=[[NSMutableArray alloc]init];
    Array_Services=[[NSMutableArray alloc]init];
    Array_Others=[[NSMutableArray alloc]init];
    NSLog(@"frame sizeaaa=%f",self.view.frame.size.height);
    if (self.view.frame.size.width==375 && self.view.frame.size.height==812)
    {
         [navigationView setFrame:CGRectMake(navigationView.frame.origin.x, navigationView.frame.origin.y, navigationView.frame.size.width,90)];
        
        [profile setFrame:CGRectMake(profile.frame.origin.x, profile.frame.origin.y+16, profile.frame.size.width, 30)];
         [activity setFrame:CGRectMake(activity.frame.origin.x, activity.frame.origin.y+16, activity.frame.size.width, 30)];
         [search setFrame:CGRectMake(search.frame.origin.x, search.frame.origin.y+16, search.frame.size.width, 30)];
         [location setFrame:CGRectMake(location.frame.origin.x, location.frame.origin.y+16, location.frame.size.width, 30)];
         [nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+14,40, 40)];
        
         [badgeLabel setFrame:CGRectMake(badgeLabel.frame.origin.x, badgeLabel.frame.origin.y+18, badgeLabel.frame.size.width, 22)];
        
         [locationLabel setFrame:CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.origin.y+8, locationLabel.frame.size.width, 20)];
    }
    categorynameStr = @"all";
    
    borderBottom_topheder = [CALayer layer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ViewControllerData) name:@"ViewControllerData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PullToRefreshTop:) name:@"PullToRefreshTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PullToRefreshBottom:) name:@"PullToRefreshBottom" object:nil];
    
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    defaults = [[NSUserDefaults alloc]init];
   // [defaults synchronize];
    
    self.navigationController.navigationBar.hidden=YES;
    
    //    [defaults setObject:@"ON" forKey:@"locationPresed"];
    
    
    
    //-------------------badge label for Activity -----------------------------------
    
    badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2 ;
    badgeLabel.clipsToBounds = YES;
    badgeLabel.hidden = YES;
    
    BadgeTimer =  [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(ActivityTicker_Connection) userInfo:nil  repeats:YES];
    
    
    //--------------------------------------------------------------------------------
    
    
    
    
    [profile setImage:[UIImage imageNamed:@"Profile"] forState:UIControlStateNormal];
    [profile setContentMode:UIViewContentModeScaleAspectFit];
    profile.tag = 1;
    [profile addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [activity setImage:[UIImage imageNamed:@"Activity"] forState:UIControlStateNormal];
    [activity setContentMode:UIViewContentModeScaleAspectFit];
    activity.tag = 2;
    [activity addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [search setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
    [search setContentMode:UIViewContentModeScaleAspectFit];
    search.tag = 3;
    [search addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    // [location setImage:[UIImage imageNamed:@"Location_off"] forState:UIControlStateNormal];
    location.tag = 4;
    [location addTarget:self action:@selector(topButton:) forControlEvents:UIControlEventTouchUpInside];
    // [defaults setObject:@"OFF" forKey:@"locationPresed"];
    
    
    if ([[defaults valueForKey:@"locationPresed"] isEqualToString:@"ON"])
    {
        [location setImage:[UIImage imageNamed:@"Location_on"] forState:UIControlStateNormal];
        
        locationLabel.hidden = NO;
        
        
    }
    else
        
    {
        
        [location setImage:[UIImage imageNamed:@"Location_off"] forState:UIControlStateNormal];
        locationLabel.hidden = YES;
    }
    [location setContentMode:UIViewContentModeScaleAspectFit];
    
    
    locationLabel.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    locationLabel.text = [defaults valueForKey:@"Cityname"];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:14];
    
    
    
    
    nameLabel.image = [UIImage imageNamed:@"NameLogo"];
    nameLabel.contentMode = UIViewContentModeScaleAspectFill;
    
    
    
    
    
    
    
    //View Controllers loading on container view
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CarsViewController *carVC =[mainStoryboard instantiateViewControllerWithIdentifier:@"CarsViewController"];
    carVC.title = @"سيارات";//@"Cars";
    
    PropertyViewController *propertyVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PropertyViewController"];
    propertyVC.title =@"عقار"; //@"Property";
    
    
    ElectronicViewController *electronicVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ElectronicViewController"];
    electronicVC.title = @"إلكترونيات";//@"Electronics";
    
    AllViewController *allVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewController"];
    allVC.title = @"الكل";//@"All";
    
    PetsViewController *petsVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PetsViewController"];
    petsVC.title = @"حيوانات أليفة";//@"Pets";
    
    FurnitureViewController * furnitureVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"FurnitureViewController"];
    furnitureVC.title = @"أثاث";//@"Furniture";
    
    ServicesViewController *serviceVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ServicesViewController"];
    serviceVC.title = @"خدمات";//@"Services";
    
    OtherViewController * otherVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"OtherViewController"];
    otherVC.title = @"أخرى";//@"Other";
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // ContainerView
    
    float statusHeight =[[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight =self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[allVC,carVC,propertyVC,electronicVC,petsVC,furnitureVC,serviceVC,otherVC]topBarHeight:statusHeight + navigationHeight
                                                                                parentViewController:self];
    
    //frame added....
    // containerVC.view.frame = CGRectMake(0,0,containerVC.view.frame.size.width, containerVC.view.frame.size.height);
    
    containerVC.delegate = self;
    containerVC.menuItemFont = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:18];
    [self.view addSubview:containerVC.view];
    
    
    //----Activity Indicator-----------------
    activityindicator = [[UIActivityIndicatorView alloc]init];
    activityindicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhiteLarge;
    activityindicator.color = [UIColor grayColor] ;
    [activityindicator startAnimating];
    activityindicator.center = containerVC.view.center;
    
    // [self.view addSubview:activityindicator];
    [containerVC.view addSubview:activityindicator];
    
    
    
    
    [self.view addSubview:navigationView];
    [self viewPostConnection];
    if ([[defaults valueForKey:@"tabindex"] isEqualToString:@"1"])
    {
        
        
        [defaults setObject:@"0" forKey:@"tabindex"];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityViewController * activity=[mainStoryboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        [self.navigationController pushViewController:activity animated:YES];
    }
    //  [self ActivityTicker_Connection];
    
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    borderBottom_topheder.backgroundColor =[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0].CGColor;
    borderBottom_topheder.frame = CGRectMake(0, navigationView.frame.size.height-1, navigationView.frame.size.width,1);
    [navigationView.layer addSublayer:borderBottom_topheder];
    
}
- (void)viewWillAppear:(BOOL)animated
{
     favouritesCount = 0;
    
    [super viewWillAppear:animated];
    
    borderBottom_topheder.backgroundColor =[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0].CGColor;
    borderBottom_topheder.frame = CGRectMake(0, navigationView.frame.size.height-1, navigationView.frame.size.width,1);
    [navigationView.layer addSublayer:borderBottom_topheder];

    
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
                                    
                                     set.name = @"سيارات";//@"car";
                                    
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
                                    [defaults setValue:@"عقار" forKey:@"Title"];//property
                                    [self postFunction];
                                }
                                else if(index == 3)
                                {
                                    [defaults setValue:@"إلكترونيات" forKey:@"Title"];//electronics
                                    [self postFunction];
                                }
                                else if(index == 4)
                                {
                                    [defaults setValue:@"حيوانات أليفة" forKey:@"Title"];//pets
                                    [self postFunction];
                                }
                                else if(index == 5)
                                {
                                    [defaults setValue:@"أثاث" forKey:@"Title"];//furniture
                                    [self postFunction];
                                }
                                else if(index == 6)
                                {
                                    [defaults setValue:@"خدمات" forKey:@"Title"];//services
                                    [self postFunction];
                                }
                                else if(index == 7)
                                {
                                    [defaults setValue:@"أخرى" forKey:@"Title"];//others
                                    [self postFunction];
                                }
                                
                                
                                
                            }];
    

    _plusButtonsViewMain.coverColor = [UIColor colorWithWhite:1.f alpha:1.0f];
    _plusButtonsViewMain.position = LGPlusButtonsViewPositionBottomRight;
    _plusButtonsViewMain.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    
    
    
    [_plusButtonsViewMain setButtonsTitles:@[@"", @"", @"", @"",@"",@"",@"",@""] forState:UIControlStateNormal];
   // [_plusButtonsViewMain setDescriptionsTexts:@[@"", @"Cars", @"Property", @"Electronics", @"Pets", @"Furniture", @"Services", @"Other"]];
    
  
    
     [_plusButtonsViewMain setDescriptionsTexts:@[@"", @"سيارات", @"عقار", @"إلكترونيات", @"حيوانات أليفة", @" أثاث", @"خدمات", @" أخرى"]];
    
    
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
    
    if ([[UIScreen mainScreen]bounds].size.width == 320)
    {
        for (NSUInteger i=1; i<=7; i++)
            [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, -6.f)
                                    forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    }
    else if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        for (NSUInteger i=1; i<=7; i++)
            [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, -18.f)
                                    forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
        
    }
    else
    {
        for (NSUInteger i=1; i<=7; i++)
            [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, -13.f)
                                    forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    }
    
//    for (NSUInteger i=1; i<=7; i++)
//        [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, -13.f)
//                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
//    
    
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
  
    [self.view addSubview:_plusButtonsViewMain];
    
    
    
    
    [self viewPostConnection];
    
 
    
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
        
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileViewController * profile=[mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:profile animated:YES];
        
        
        
    }
    
    else if ([sender tag]== 2)
    {
        NSLog(@"activity Button Pressed");
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityViewController * activity=[mainStoryboard instantiateViewControllerWithIdentifier:@"ActivityViewController"];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        [self.navigationController pushViewController:activity animated:YES];
        
        
        
    }
    else if ([sender tag]== 3)
    {
        NSLog(@"search Button Pressed");
        
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController * searchController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        
        [self.navigationController pushViewController:searchController animated:YES];
        
    }
    else
    {
        
        activityindicator.hidden = NO;
        [activityindicator startAnimating];

        if ([[defaults valueForKey:@"locationPresed"] isEqualToString:@"ON"])
        {
            [location setImage:[UIImage imageNamed:@"Location_off"] forState:UIControlStateNormal];
            locationLabel.hidden = YES;
            [defaults setObject:@"OFF" forKey:@"locationPresed"];
           
            
        }
        else
            
        {
            [location setImage:[UIImage imageNamed:@"Location_on"] forState:UIControlStateNormal];
            locationLabel.hidden = NO;
            [defaults setObject:@"ON" forKey:@"locationPresed"];
            
            

        }
        
        [Array_ViewPost removeAllObjects];
        [Array_Car removeAllObjects];
        [Array_Property removeAllObjects];
        [Array_Electronics removeAllObjects];
        [Array_Pets removeAllObjects];
        [Array_Furniture removeAllObjects];
        [Array_Services removeAllObjects];
        [Array_Others removeAllObjects];
        
        
    

        
        NSDictionary *arrayCar_Info7 =
        [NSDictionary dictionaryWithObjectsAndKeys:Array_ViewPost,@"", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayall_Info" object:self userInfo:arrayCar_Info7];
        
        NSDictionary *arrayCar_Info =
        [NSDictionary dictionaryWithObjectsAndKeys:Array_Car,@"", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayCar_Info" object:self userInfo:arrayCar_Info];
        
        NSDictionary *arrayCar_Info6 =
        [NSDictionary dictionaryWithObjectsAndKeys:Array_Property,@"", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayproperty_Info" object:self userInfo:arrayCar_Info6];
        
        NSDictionary *arrayCar_Info1 =
        [NSDictionary dictionaryWithObjectsAndKeys:Array_Electronics,@"", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayelectronic_Info" object:self userInfo:arrayCar_Info1];
        
        NSDictionary *arrayCar_Info2 =
        [NSDictionary dictionaryWithObjectsAndKeys:Array_Pets,@"", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arraypets_Info" object:self userInfo:arrayCar_Info2];
        
        NSDictionary *arrayCar_Info3 =
        [NSDictionary dictionaryWithObjectsAndKeys:Array_Furniture,@"", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayfur_Info" object:self userInfo:arrayCar_Info3];
        
        NSDictionary *arrayCar_Info4 =
        [NSDictionary dictionaryWithObjectsAndKeys:Array_Services,@"", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayservice_Info" object:self userInfo:arrayCar_Info4];
        
        NSDictionary *arrayCar_Info5 =
        [NSDictionary dictionaryWithObjectsAndKeys:Array_Others,@"", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayother_Info" object:self userInfo:arrayCar_Info5];
        
        
        
        NSLog(@"location Button Pressed");
        
        pageCount=0;
        pageCount1=0;
        pageCount2=0;
        pageCount3=0;
        pageCount4=0;
        pageCount5=0;
        pageCount6=0;
        pageCount7=0;
        pageCount8=0;
        

       [self viewPostConnection];
    }
}

#pragma mark - YSLContainerViewControllerDelegate

- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
        NSLog(@"current Index : %ld",(long)index);
        NSLog(@"current controller : %@",controller);
    
    
    
    if ((long)index == 0)
    {
        categorynameStr = @"all";
        pageCount=pageCount1;
        if (Array_ViewPost.count == 0)
        {
            activityindicator.hidden = NO;
            [activityindicator startAnimating];
        }
        else
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }
        
    }
    else if ((long)index == 1)
    {
        categorynameStr = @"car";
        
        if (Array_Car.count == 0)
        {
            activityindicator.hidden = NO;
            [activityindicator startAnimating];
        }
        else
        {
        activityindicator.hidden = YES;
        [activityindicator stopAnimating];
        }
        pageCount=pageCount2;
        
    }
    else if ((long)index == 2)
    {
        categorynameStr = @"property";
        
        if (Array_Property.count == 0)
        {
            activityindicator.hidden = NO;
            [activityindicator startAnimating];
        }
        else
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }
        pageCount=pageCount3;
    }
    else if ((long)index == 3)
    {
        categorynameStr = @"electronics";
        
        if (Array_Electronics.count == 0)
        {
            activityindicator.hidden = NO;
            [activityindicator startAnimating];
        }
        else
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }
        pageCount=pageCount4;
    }
    else if ((long)index == 4)
    {
        categorynameStr = @"pets";
        
        if (Array_Pets.count == 0)
        {
            activityindicator.hidden = NO;
            [activityindicator startAnimating];
        }
        else
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }
        pageCount=pageCount5;
    }
    else if ((long)index == 5)
    {
        categorynameStr = @"furniture";
        if (Array_Furniture.count == 0)
        {
            activityindicator.hidden = NO;
            [activityindicator startAnimating];
            
        }
        else
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }
        pageCount=pageCount6;
    }
    else if ((long)index == 6)
    {
        categorynameStr = @"services";
        if (Array_Services.count == 0)
        {
            activityindicator.hidden = NO;
            [activityindicator startAnimating];
        }
        else
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }
        pageCount=pageCount7;
    }
    else
    {
        categorynameStr = @"others";
        if (Array_Others.count == 0)
        {
            activityindicator.hidden = NO;
            [activityindicator startAnimating];
            
        }
        else
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }
        pageCount=pageCount8;
    }
    
    [self viewPostConnection];
    
    
    
    
    
    
    
    [controller viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURL Connection

-(void)viewPostConnection
{
   
    
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
    
        
        NSURL *url;
        NSString *  urlStr=[urlplist valueForKey:@"viewpost"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *category = @"category";
        NSString *categoryVal = categorynameStr;
        
        NSString *location1= @"location";
        NSString *location1Val = [defaults valueForKey:@"locationPresed"];
        
        NSString *city= @"city";
        NSString *cityVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Cityname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        NSString *country= @"country";
        NSString *countryVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Countryname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;
        
        NSString *pages= @"pages";
        NSString *pagesVal =[NSString stringWithFormat:@"%ld",(long)pageCount];
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,location1,location1Val,city,cityVal,country,countryVal,pages,pagesVal,category,categoryVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_ViewPost = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_ViewPost)
            {
                webData_ViewPost =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }
    
}

#pragma mark - NSURL CONNECTION Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    
    if(connection==Connection_ViewPost)
    {
        [webData_ViewPost setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_ViewPost)
    {
        [webData_ViewPost appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_ViewPost)
    {
        

        Array_ViewPost1=[[NSMutableArray alloc]init];
//        Array_Car = [[NSMutableArray alloc]init];
//        Array_Property= [[NSMutableArray alloc]init];
//        Array_Electronics=[[NSMutableArray alloc]init];
//        Array_Furniture=[[NSMutableArray alloc]init];
//        Array_Pets=[[NSMutableArray alloc]init];
//        Array_Services=[[NSMutableArray alloc]init];
//        Array_Others=[[NSMutableArray alloc]init];
      
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_ViewPost1=[objSBJsonParser objectWithData:webData_ViewPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_ViewPost encoding:NSUTF8StringEncoding];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_ViewPost1);
        NSLog(@"count= %lu",(unsigned long)Array_ViewPost1.count);
        //NSLog(@"registration_status %@",[[Array_ViewPost1 objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
        
        if ([ResultString isEqualToString:@"noposts"])
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
            
        }
        
        
        
        
        if (Array_ViewPost1.count != 0)
        {
            
            
            
            
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
            
            if ([categorynameStr isEqualToString:@"all"])
            {
                if (pageCount1 == 0)
                {
                    [Array_ViewPost removeAllObjects];
                    
                }
               
                
                if ([[Array_ViewPost valueForKeyPath:@"pages"]containsObject:[[Array_ViewPost1 objectAtIndex:Array_ViewPost1.count-1]valueForKey:@"pages"]])
                {
                    
                }
                else
                {
                    
                    [Array_ViewPost addObjectsFromArray:Array_ViewPost1];
                    pageCount1 ++;
                }
                
                

                
            }
            
            else if ([categorynameStr isEqualToString:@"car"])
            {
                if (pageCount2 == 0)
                {
                    [Array_Car removeAllObjects];
                    
                }
                
                if ([[Array_Car valueForKeyPath:@"pages"]containsObject:[[Array_ViewPost1 objectAtIndex:Array_ViewPost1.count-1]valueForKey:@"pages"]])
                {
                    
                    
                }
                else
                {
                    [Array_Car addObjectsFromArray:Array_ViewPost1];
                    pageCount2 ++;
                }

               // [Array_Car addObjectsFromArray:Array_ViewPost1];
            }
            else if ([categorynameStr isEqualToString:@"property"])
            {
                if (pageCount3 == 0)
                {
                    [Array_Property removeAllObjects];
                }
                
                if ([[Array_Property valueForKeyPath:@"pages"]containsObject:[[Array_ViewPost1 objectAtIndex:Array_ViewPost1.count-1]valueForKey:@"pages"]])
                {
                    
                }
                else
                {
                    [Array_Property addObjectsFromArray:Array_ViewPost1];
                    pageCount3++;
                }

               // [Array_Property addObjectsFromArray:Array_ViewPost1];
            }
            else if ([categorynameStr isEqualToString:@"electronics"])
            {
                if (pageCount4 == 0)
                {
                    [Array_Electronics removeAllObjects];
                }
                
                if ([[Array_Electronics valueForKeyPath:@"pages"]containsObject:[[Array_ViewPost1 objectAtIndex:Array_ViewPost1.count-1]valueForKey:@"pages"]])
                {
                    
                }
                else
                {
                    [Array_Electronics addObjectsFromArray:Array_ViewPost1];
                    pageCount4++;
                }

               // [Array_Electronics addObjectsFromArray:Array_ViewPost1];
            }
            else if ([categorynameStr isEqualToString:@"pets"])
            {
                if (pageCount5 == 0)
                {
                    [Array_Pets removeAllObjects];
                }
                if ([[Array_Pets valueForKeyPath:@"pages"]containsObject:[[Array_ViewPost1 objectAtIndex:Array_ViewPost1.count-1]valueForKey:@"pages"]])
                {
                    
                }
                else
                {
                    [Array_Pets addObjectsFromArray:Array_ViewPost1];
                    pageCount5++;
                }

                //[Array_Pets addObjectsFromArray:Array_ViewPost1];
            }
            else if ([categorynameStr isEqualToString:@"furniture"])
            {
                if (pageCount6 == 0)
                {
                    [Array_Furniture removeAllObjects];
                }
                if ([[Array_Furniture valueForKeyPath:@"pages"]containsObject:[[Array_ViewPost1 objectAtIndex:Array_ViewPost1.count-1]valueForKey:@"pages"]])
                {
                    
                }
                else
                {
                    [Array_Furniture addObjectsFromArray:Array_ViewPost1];
                    pageCount6++;
                }

                //[Array_Furniture addObjectsFromArray:Array_ViewPost1];
            }
            else if ([categorynameStr isEqualToString:@"services"])
            {
                if (pageCount7 == 0)
                {
                    [Array_Services removeAllObjects];
                }
                
                if ([[Array_Services valueForKeyPath:@"pages"]containsObject:[[Array_ViewPost1 objectAtIndex:Array_ViewPost1.count-1]valueForKey:@"pages"]])
                {
                    
                }
                else
                {
                    [Array_Services addObjectsFromArray:Array_ViewPost1];
                    pageCount7++;
                }

                //[Array_Services addObjectsFromArray:Array_ViewPost1];
            }
            else
            {
                if (pageCount8 == 0)
                {
                    [Array_Others removeAllObjects];
                }
                
                if ([[Array_Others valueForKeyPath:@"pages"]containsObject:[[Array_ViewPost1 objectAtIndex:Array_ViewPost1.count-1]valueForKey:@"pages"]])
                {
                    
                }
                else
                {
                    [Array_Others addObjectsFromArray:Array_ViewPost1];
                    pageCount8++;
                }

//                [Array_Others addObjectsFromArray:Array_ViewPost1];
            }
            

            
            
            
            for (int i=0; i<Array_ViewPost.count; i++)
            {

                
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"favourite"]isEqualToString:@"TRUE"])
                {
                    
                    favouritesCount++;
                    
                    NSLog(@"favouritesCount %d",favouritesCount);
                    
                    [defaults setObject:[NSString stringWithFormat:@"%d",favouritesCount] forKey:@"CountFav"];
                    
                    
                }
                else
                {
                    if (Array_ViewPost.count == 1)
                    {
                        
                        [defaults setObject:@"0" forKey:@"CountFav"];
                    }
                    
                    
                    
                }

                
            }
            
            
            // All NSNotificationCenter defaultCenter callings
            
            NSDictionary *arrayCar_Info1 =
            [NSDictionary dictionaryWithObjectsAndKeys:Array_ViewPost,@"arrayall_Data", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayall_Info" object:self userInfo:arrayCar_Info1];
            
            if (Array_Car.count != 0)
            {
                
                NSDictionary *arrayCar_Info =
                [NSDictionary dictionaryWithObjectsAndKeys:Array_Car,@"arrayCar_Data", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayCar_Info" object:self userInfo:arrayCar_Info];
            }
            else
            {
                
            }
            if (Array_Property.count != 0)
            {
                
                NSDictionary *arrayCar_Info =
                [NSDictionary dictionaryWithObjectsAndKeys:Array_Property,@"arrayproperty_Data", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayproperty_Info" object:self userInfo:arrayCar_Info];
            }
            if (Array_Electronics.count != 0)
            {
                
                NSDictionary *arrayCar_Info =
                [NSDictionary dictionaryWithObjectsAndKeys:Array_Electronics,@"arrayelectronic_Data", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayelectronic_Info" object:self userInfo:arrayCar_Info];
            }
            if (Array_Pets.count != 0)
            {
                
                NSDictionary *arrayCar_Info =
                [NSDictionary dictionaryWithObjectsAndKeys:Array_Pets,@"arraypets_Data", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"arraypets_Info" object:self userInfo:arrayCar_Info];
            }
            if (Array_Furniture.count != 0)
            {
                
                NSDictionary *arrayCar_Info =
                [NSDictionary dictionaryWithObjectsAndKeys:Array_Furniture,@"arrayfur_Data", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayfur_Info" object:self userInfo:arrayCar_Info];
            }           if (Array_Services.count != 0)
            {
            
                NSDictionary *arrayCar_Info =
                [NSDictionary dictionaryWithObjectsAndKeys:Array_Services,@"arrayservice_Data", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayservice_Info" object:self userInfo:arrayCar_Info];
            }
            if (Array_Others.count != 0)
            {
                
                NSDictionary *arrayCar_Info =
                [NSDictionary dictionaryWithObjectsAndKeys:Array_Others,@"arrayother_Data", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayother_Info" object:self userInfo:arrayCar_Info];
            }
            
        }
        if ([ResultString isEqualToString:@"noposts"])
        {
       
           
           
           
           
           activityindicator.hidden = YES;
           [activityindicator stopAnimating];
           
           if ([categorynameStr isEqualToString:@"all"])
           {
               
                   [Array_ViewPost removeAllObjects];
               
               NSDictionary *arrayCar_Info1 =
               [NSDictionary dictionaryWithObjectsAndKeys:Array_ViewPost,@"arrayall_Data", nil];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayall_Info" object:self userInfo:arrayCar_Info1];
               
           }
           
           else if ([categorynameStr isEqualToString:@"car"])
           {
               
             
                   [Array_Car removeAllObjects];
              
               NSDictionary *arrayCar_Info =
               [NSDictionary dictionaryWithObjectsAndKeys:Array_Car,@"arrayCar_Data", nil];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayCar_Info" object:self userInfo:arrayCar_Info];
           }
           else if ([categorynameStr isEqualToString:@"property"])
           {
              
                   [Array_Property removeAllObjects];
               NSDictionary *arrayCar_Info =
               [NSDictionary dictionaryWithObjectsAndKeys:Array_Property,@"arrayproperty_Data", nil];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayproperty_Info" object:self userInfo:arrayCar_Info];
               
               // [Array_Property addObjectsFromArray:Array_ViewPost1];
           }
           else if ([categorynameStr isEqualToString:@"electronics"])
           {
               
                   [Array_Electronics removeAllObjects];
               NSDictionary *arrayCar_Info =
               [NSDictionary dictionaryWithObjectsAndKeys:Array_Electronics,@"arrayelectronic_Data", nil];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayelectronic_Info" object:self userInfo:arrayCar_Info];
               
               // [Array_Electronics addObjectsFromArray:Array_ViewPost1];
           }
           else if ([categorynameStr isEqualToString:@"pets"])
           {
              
                   [Array_Pets removeAllObjects];
               NSDictionary *arrayCar_Info =
               [NSDictionary dictionaryWithObjectsAndKeys:Array_Pets,@"arraypets_Data", nil];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"arraypets_Info" object:self userInfo:arrayCar_Info];
               
               //[Array_Pets addObjectsFromArray:Array_ViewPost1];
           }
           else if ([categorynameStr isEqualToString:@"furniture"])
           {
              
                   [Array_Furniture removeAllObjects];
               NSDictionary *arrayCar_Info =
               [NSDictionary dictionaryWithObjectsAndKeys:Array_Furniture,@"arrayfur_Data", nil];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayfur_Info" object:self userInfo:arrayCar_Info];
               
               //[Array_Furniture addObjectsFromArray:Array_ViewPost1];
           }
           else if ([categorynameStr isEqualToString:@"services"])
           {
               
                   [Array_Services removeAllObjects];
               NSDictionary *arrayCar_Info =
               [NSDictionary dictionaryWithObjectsAndKeys:Array_Services,@"arrayservice_Data", nil];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayservice_Info" object:self userInfo:arrayCar_Info];
               
               //[Array_Services addObjectsFromArray:Array_ViewPost1];
           }
           else
           {
               
                   [Array_Others removeAllObjects];
               NSDictionary *arrayCar_Info =
               [NSDictionary dictionaryWithObjectsAndKeys:Array_Others,@"arrayother_Data", nil];
               
               [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayother_Info" object:self userInfo:arrayCar_Info];
               
               //                [Array_Others addObjectsFromArray:Array_ViewPost1];
           }
           
//            [Array_ViewPost removeAllObjects];
//            
//            NSDictionary *arrayCar_Info1 =
//            [NSDictionary dictionaryWithObjectsAndKeys:Array_ViewPost,@"arrayall_Data", nil];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayall_Info" object:self userInfo:arrayCar_Info1];
           
           
           
      }
        
        
        
        
    }
}

-(void)ViewControllerData
{
    
//    if ([categorynameStr isEqualToString:@"all"])
//    {
//       categorynameStr = @"all";
//      
//        if (Array_ViewPost.count == 0)
//        {
//              pageCount=0;
//            activityindicator.hidden = NO;
//            [activityindicator startAnimating];
//        }
//        else
//        {
//            pageCount=pageCount1;
//            activityindicator.hidden = YES;
//            [activityindicator stopAnimating];
//        }
//        
//    }
//    else if  ([categorynameStr isEqualToString:@"car"])
//    {
//        categorynameStr = @"car";
//        
//        if (Array_Car.count == 0)
//        {pageCount=0;
//            activityindicator.hidden = NO;
//            [activityindicator startAnimating];
//        }
//        else
//        {pageCount=pageCount2;
//            activityindicator.hidden = YES;
//            [activityindicator stopAnimating];
//        }
//        
//        
//    }
//    else if  ([categorynameStr isEqualToString:@"property"])
//    {
//        categorynameStr = @"property";
//        
//        if (Array_Property.count == 0)
//        {
//              pageCount=0;
//            activityindicator.hidden = NO;
//            [activityindicator startAnimating];
//        }
//        else
//        {  pageCount=pageCount3;
//            activityindicator.hidden = YES;
//            [activityindicator stopAnimating];
//        }
//      
//    }
//    else if  ([categorynameStr isEqualToString:@"electronics"])
//    {
//        categorynameStr = @"electronics";
//        
//        if (Array_Electronics.count == 0)
//        {
//            pageCount=0;
//            activityindicator.hidden = NO;
//            [activityindicator startAnimating];
//        }
//        else
//        {
//            pageCount=pageCount4;
//            activityindicator.hidden = YES;
//            [activityindicator stopAnimating];
//        }
//        
//    }
//    else if  ([categorynameStr isEqualToString:@"pets"])
//    {
//        categorynameStr = @"pets";
//        
//        if (Array_Pets.count == 0)
//        { pageCount=0;
//            activityindicator.hidden = NO;
//            [activityindicator startAnimating];
//        }
//        else
//        { pageCount=pageCount5;
//            activityindicator.hidden = YES;
//            [activityindicator stopAnimating];
//        }
//       
//    }
//    else if ([categorynameStr isEqualToString:@"furniture"])
//    {
//        categorynameStr = @"furniture";
//        if (Array_Furniture.count == 0)
//        {
//             pageCount=0;
//            activityindicator.hidden = NO;
//            [activityindicator startAnimating];
//            
//        }
//        else
//        {
//             pageCount=pageCount6;
//            activityindicator.hidden = YES;
//            [activityindicator stopAnimating];
//        }
//       
//    }
//    else if ([categorynameStr isEqualToString:@"services"])
//    {
//        categorynameStr = @"services";
//        if (Array_Services.count == 0)
//        {
//            pageCount=0;
//            activityindicator.hidden = NO;
//            [activityindicator startAnimating];
//        }
//        else
//        {
//            pageCount=pageCount7;
//            activityindicator.hidden = YES;
//            [activityindicator stopAnimating];
//        }
//        
//    }
//    else
//    {
//        categorynameStr = @"others";
//        if (Array_Others.count == 0)
//        {
//            activityindicator.hidden = NO;
//            [activityindicator startAnimating];
//            
//        }
//        else
//        {
//            activityindicator.hidden = YES;
//            [activityindicator stopAnimating];
//        }
//        pageCount=pageCount8;
//    }
    
    
    [self viewPostConnection];
    
}

#pragma mark - Badge Connection

-(void)ActivityTicker_Connection
{
    
   
    
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@",userid,useridVal];
    
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"activityticker"];;
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
                                                 
                                                 Array_ActivityTicker=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_ActivityTicker =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_ActivityTicker %@",Array_ActivityTicker);
                                                 
                                                 
                                                 
                                                 NSString *badge = [NSString stringWithFormat:@"%@",[[Array_ActivityTicker objectAtIndex:0]  valueForKey:@"totalcount"]];
                                                 
                                                 if ([badge isEqualToString:@"0"])
                                                 {
                                                     badgeLabel.hidden = YES;
                                                 }
                                                 else
                                                 {
                                                     badgeLabel.hidden = NO;
                                                     badgeLabel.text = badge;
                                                 }
                                                 
                                                 NSString *notificationcount = [NSString stringWithFormat:@"%@",[[Array_ActivityTicker objectAtIndex:0]  valueForKey:@"notificationcount"]];
                                                 
                                                 if ([notificationcount isEqualToString:@"0"])
                                                 {
                                                     [defaults setObject:@"0" forKey:@"notificationcount"];
                                                 }
                                                 else
                                                 {
                                                     
                                                     [defaults setObject:notificationcount forKey:@"notificationcount"];
                                                     
                                                 }
                                                 
                                                 NSString *chatcount = [NSString stringWithFormat:@"%@",[[Array_ActivityTicker objectAtIndex:0]  valueForKey:@"chatcount"]];
                                                 
                                                 if ([chatcount isEqualToString:@"0"])
                                                 {
                                                     [defaults setObject:@"0" forKey:@"chatcount"];
                                                     
                                                 }
                                                 else
                                                 {
                                                      [defaults setObject:chatcount forKey:@"chatcount"];
                                                 }
                                                 
                                                 [defaults synchronize];
                                                 
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadge" object:self userInfo:nil];
                                             


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
-(void)PullToRefreshTop: (NSNotification*) notification
{
   
    if ([categorynameStr isEqualToString:@"all"])
    {
         pageCount1 = 0;
         pageCount=pageCount1;
    }
    if ([categorynameStr isEqualToString:@"car"])
    {
        pageCount2 = 0;
        pageCount=pageCount2;
    }
    if ([categorynameStr isEqualToString:@"property"])
    {
        pageCount3 = 0;
        pageCount=pageCount3;
    }
    if ([categorynameStr isEqualToString:@"electronics"])
    {
        pageCount4 = 0;
        pageCount=pageCount4;
    }
    if ([categorynameStr isEqualToString:@"pets"])
    {
        pageCount5 = 0;
        pageCount=pageCount5;
    }
    if ([categorynameStr isEqualToString:@"furniture"])
    {
        pageCount6 = 0;
        pageCount=pageCount6;
    }
    if ([categorynameStr isEqualToString:@"services"])
    {
        pageCount7 = 0;
        pageCount=pageCount7;
    }
    if ([categorynameStr isEqualToString:@"others"])
    {
        pageCount8 = 0;
        pageCount=pageCount8;
    }
    
    [self viewPostConnection];
    
}
-(void)PullToRefreshBottom: (NSNotification*) notification
{
    
     //pageCount=1;
    if ([categorynameStr isEqualToString:@"all"])
    {
        
        pageCount=pageCount1;
    }
    if ([categorynameStr isEqualToString:@"car"])
    {
       
        pageCount=pageCount2;
    }
    if ([categorynameStr isEqualToString:@"property"])
    {
     
        pageCount=pageCount3;
    }
    if ([categorynameStr isEqualToString:@"electronics"])
    {
        
        pageCount=pageCount4;
    }
    if ([categorynameStr isEqualToString:@"pets"])
    {
       
        pageCount=pageCount5;
    }
    if ([categorynameStr isEqualToString:@"furniture"])
    {
        
        pageCount=pageCount6;
    }
    if ([categorynameStr isEqualToString:@"services"])
    {
      
        pageCount=pageCount7;
    }
    if ([categorynameStr isEqualToString:@"others"])
    {
       
        pageCount=pageCount8;
    }

   [self viewPostConnection];
}

@end
