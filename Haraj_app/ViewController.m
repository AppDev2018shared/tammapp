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
    NSMutableArray *Array_ViewPost,*Array_Car,*Array_Property,*Array_Electronics,*Array_Pets,*Array_Furniture,*Array_Others,*Array_Services,*Array_ActivityTicker;
    
    int favouritesCount;
    
    NSTimer *BadgeTimer;
}
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;


@end

@implementation ViewController
@synthesize navigationView,profile,activity,search,location,locationLabel,nameLabel,badgeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    favouritesCount = 0;
    
    borderBottom_topheder = [CALayer layer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ViewControllerData) name:@"ViewControllerData" object:nil];
    
    
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    defaults = [[NSUserDefaults alloc]init];
//  [defaults setObject:@"no" forKey:@"LoginView"];
    [defaults synchronize];
    
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
    serviceVC.title = @"Services";
    
    OtherViewController * otherVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"OtherViewController"];
    otherVC.title = @"Other";
    
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
    [containerVC.view addSubview:activityindicator];
    

    
    [self.view addSubview:navigationView];
    [self viewPostConnection];
    
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
    
    
    _plusButtonsViewMain.coverColor = [UIColor colorWithWhite:1.f alpha:0.90];
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
        
        
        
     //   FavouriteViewController * profile=[mainStoryboard instantiateViewControllerWithIdentifier:@"FavouriteViewController"];
        
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
        
            [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        //    set1.Array_Alldata = Array_ViewPost;
        //    set1.tuchedIndex = indexPath.row;
            [self.navigationController pushViewController:profile animated:YES];
        //    
        //    NSLog(@"Selected Index= %lditem",(long)indexPath.row);
        
        
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
        
        
//   UISearchController     *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//        searchController.searchResultsUpdater = self;
//        searchController.dimsBackgroundDuringPresentation = NO;
//        searchController.searchBar.delegate = self;
        

        

        
        
        
        
        
    }
    else
    {
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
//            NSDictionary *arrayCar_Info =
//            [NSDictionary dictionaryWithObjectsAndKeys:Array_Car,@"", nil];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"arrayCar_Info" object:self userInfo:arrayCar_Info];

        }
        
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
        
        [self viewPostConnection];
        
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
        
        NSURL *url;//=[NSURL URLWithString:[urlplist valueForKey:@"singup"]];
        NSString *  urlStr=[urlplist valueForKey:@"viewpost"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *location1= @"location";
        NSString *location1Val = [defaults valueForKey:@"locationPresed"];
        
        NSString *city= @"city";
        NSString *cityVal = [defaults valueForKey:@"Cityname"];
        NSString *country= @"country";
        NSString *countryVal =[defaults valueForKey:@"Countryname"];
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,location1,location1Val,city,cityVal,country,countryVal];
        
        
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
        
        Array_ViewPost=[[NSMutableArray alloc]init];
        Array_Car = [[NSMutableArray alloc]init];
        Array_Property= [[NSMutableArray alloc]init];
        Array_Electronics=[[NSMutableArray alloc]init];
        Array_Furniture=[[NSMutableArray alloc]init];
        Array_Pets=[[NSMutableArray alloc]init];
        Array_Services=[[NSMutableArray alloc]init];
        Array_Others=[[NSMutableArray alloc]init];
      
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_ViewPost=[objSBJsonParser objectWithData:webData_ViewPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_ViewPost encoding:NSUTF8StringEncoding];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_ViewPost);
        NSLog(@"count= %lu",(unsigned long)Array_ViewPost.count);
        NSLog(@"registration_status %@",[[Array_ViewPost objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
        
        if ([ResultString isEqualToString:@"noposts"])
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"No post availables" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:nil];
//            [alertController addAction:actionOk];
//            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        if (Array_ViewPost.count != 0)
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
            
            for (int i=0; i<Array_ViewPost.count; i++)
            {
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"car"])
                {
                    
                    
                    [Array_Car addObject:[Array_ViewPost objectAtIndex:i]];
                    
                    NSLog(@"Array car = %@",Array_Car);
                    
                }
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"property"])
                {
                    
                    
                    [Array_Property addObject:[Array_ViewPost objectAtIndex:i]];
                    
                }
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"electronics"])
                {
                    
                    
                    [Array_Electronics addObject:[Array_ViewPost objectAtIndex:i]];
                    NSLog(@"Car array = %@",Array_Electronics);
                    
                }
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"pets"])
                {
                    
                    
                    [Array_Pets addObject:[Array_ViewPost objectAtIndex:i]];
                    NSLog(@"Car array = %@",Array_Pets);
                    
                }
                
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"furniture"])
                {
                    
                    
                    [Array_Furniture addObject:[Array_ViewPost objectAtIndex:i]];
                    NSLog(@"Car array = %@",Array_Furniture);
                    
                }
                
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"others"])
                {
                    
                    
                    [Array_Others addObject:[Array_ViewPost objectAtIndex:i]];
                    NSLog(@"Car array = %@",Array_Others);
                    
                }
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"category"]isEqualToString:@"services"])
                {
                    
                    
                    [Array_Services addObject:[Array_ViewPost objectAtIndex:i]];
                    NSLog(@"Car array = %@",Array_Services);
                    
                }
                
                if ([[[Array_ViewPost objectAtIndex:i]valueForKey:@"favourite"]isEqualToString:@"TRUE"])
                {
                    
                    favouritesCount++;
                    
                    NSLog(@"favouritesCount %d",favouritesCount);
                    
                    [defaults setObject:[NSString stringWithFormat:@"%d",favouritesCount] forKey:@"CountFav"];
                    
                    
                }

                
            }
            
            
            // all NSNotificationCenter defaultCenter callings
            
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
            }
            if (Array_Services.count != 0)
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
       
               
        
        
        
    }
}

-(void)ViewControllerData
{
    [self viewPostConnection];
    
}

#pragma mark - Badge Connection

-(void)ActivityTicker_Connection
{
    
    NSLog(@"FAVORITE TAPPED");
    
    
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


@end
