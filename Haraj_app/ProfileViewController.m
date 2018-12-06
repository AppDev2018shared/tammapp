 //
//  ProfileViewController.m
//  Haraj_app
//
//  Created by Spiel on 21/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "ProfileViewController.h"
#import "PatternViewCell.h"
#import "ImageCollectionViewCell.h"
#import "FRGWaterfallCollectionViewCell.h"
#import "FRGWaterfallCollectionViewLayout.h"
#import "FRGWaterfallHeaderReusableView.h"
#import "UIImageView+WebCache.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "MyPostViewController.h"
#import "FavouriteViewController.h"
#import "SalePointsViewController.h"
#import "ChoosePostViewController.h"
#import "BoostPostViewController.h"
#import "AccountSettViewController.h"
#import "Base64.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "LGPlusButtonsView.h"
#import "PostingViewController.h"
#import "EnterPrice.h"
#import "UIView+RNActivityView.h"
#import "AFNetworking.h"
#import "RootViewController.h"




@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegate,FRGWaterfallCollectionViewDelegate,UITextFieldDelegate>

{
    NSMutableArray *modelArray;
    NSMutableArray *array;
    
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_ViewPost;
    NSMutableData *webData_ViewPost;
    NSMutableArray *Array_ViewPost,*Array_SalePoints, *Array_ItemSold;
    
    int favouritesCount;
    
    UIActivityIndicatorView *activityindicator;
    UIImage *chosenImage;
    NSString * ImageNSdata,*encodedImage,*Str_profileurl, *paymentmodeStr , *PostIDValue;
    
    EnterPrice *myCustomXIBViewObj;
    
    PatternViewCell *Videocell;
    ImageCollectionViewCell *Imagecell;
    
    CGFloat cellWidth,cellHeight,cellVideoHeight;
    
}

@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;

@end

@implementation ProfileViewController
@synthesize searchTextField,searchImageView,profileImageView,nameLabel,lastnameLabel,favoritesValueLabel,postValueLabel,salepointValueLabel,favouriteLabel,saleLabel,postLabel,payImageView,payLabel,boostImageview,boostLabel,isFiltered,Button_Back,Button_setting,Img_Search,Button_CircleGreen,Label_CircleFrontgreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10,searchTextField.frame.size.height)];
    searchTextField.rightView = paddingView;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    

    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,36,22)];
   // [paddingView1 addSubview:searchImageView];
    
    searchTextField.leftView = paddingView1;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    if ([[UIScreen mainScreen]bounds].size.width == 320)
    {
        searchTextField.font = [UIFont fontWithName:@"SanFranciscoDiplay-Bold" size:16];
        
        cellWidth = 160.0f;
        cellHeight = 210.0;
        cellVideoHeight = 260.0;
        
    }
    else if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        cellWidth = 200.0f;
        cellHeight = 255.0;
        cellVideoHeight = 310.0;
    }
    else
    {
        cellWidth = 173.0f;
        cellHeight = 225.0;
        cellVideoHeight = 275.0;
    }
    
   
    if (self.view.frame.size.width==375 && self.view.frame.size.height==812)
    {
        
        
         [Label_CircleFrontgreen setFrame:CGRectMake(Label_CircleFrontgreen.frame.origin.x, Label_CircleFrontgreen.frame.origin.y+8, Label_CircleFrontgreen.frame.size.width, 40)];
        
         [Button_CircleGreen setFrame:CGRectMake(Button_CircleGreen.frame.origin.x, Button_CircleGreen.frame.origin.y+5, Button_CircleGreen.frame.size.width, 40)];
        
        [searchTextField setFrame:CGRectMake(searchTextField.frame.origin.x, searchTextField.frame.origin.y+17, searchTextField.frame.size.width, 35)];
        [Button_setting setFrame:CGRectMake(Button_setting.frame.origin.x, Button_setting.frame.origin.y+13, Button_setting.frame.size.width, 30)];
        [Button_Back setFrame:CGRectMake(Button_Back.frame.origin.x, Button_Back.frame.origin.y+16, Button_Back.frame.size.width, 30)];
        [Img_Search setFrame:CGRectMake(Img_Search.frame.origin.x, Img_Search.frame.origin.y+13, Img_Search.frame.size.width, 22)];
        
        [profileImageView setFrame:CGRectMake(profileImageView.frame.origin.x, profileImageView.frame.origin.y+12, profileImageView.frame.size.width, 100)];
    }
    
    
    
    favouritesCount = 0;
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    defaults = [[NSUserDefaults alloc]init];

    
    // Do any additional setup after loading the view.
    FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.itemWidth = cellWidth;//173.0f;
    cvLayout.topInset = 1.0f;
    cvLayout.bottomInset = 10.0f;
    cvLayout.stickyHeader = YES;
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self.collectionView setCollectionViewLayout:cvLayout];
    [self.collectionView reloadData];
    
    
 //------------------------------Profile Image Tap Action---------------------------------------------------
    
    profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2;
    profileImageView.clipsToBounds = YES;
    nameLabel.text = [defaults valueForKey:@"name" ];

    
    
    if ([[defaults valueForKey:@"logintype"] isEqualToString:@"FACEBOOK"]|| [[defaults valueForKey:@"logintype"] isEqualToString:@"TWITTER"])
    {
    
    
   // NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
 // [profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
        
//    [profileImageView sd_setImageWithURL:[NSURL URLWithString:[defaults valueForKey:@"profileimage"]] placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]options:SDWebImageRefreshCached];
        
        [profileImageView setImageWithURL:[NSURL URLWithString:[defaults valueForKey:@"profileimage"]] placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
        
    [self displayImage:profileImageView withImage:profileImageView.image];

        
        
        
    }
    else
    {
        
        profileImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *ViewTapprofile =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapprofileTappedView:)];
        [profileImageView addGestureRecognizer:ViewTapprofile];
        if(chosenImage == nil)
        {
            NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
            
            [profileImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
            
        }
        else
        {
             profileImageView.image = chosenImage;
        }

        
    }
    
    
    
    
    
    [self viewPostConnection];
    [self salePointsConnection];
    
    
    
//---------------------------Favourite label tap gesture---------------------------------------------------------
    
//    if ([defaults  valueForKey:@"CountFav"] == 0 || [defaults valueForKey:@"CountFav"] == NULL)
//    {
//        
//          favoritesValueLabel.text = @"0";
//        
//        
//    }
//    else
//    {
//         favoritesValueLabel.text = [defaults valueForKey:@"CountFav"];
//    }
    
   //  favoritesValueLabel.text = [defaults valueForKey:@"CountFav"];
     favoritesValueLabel.userInteractionEnabled = YES;
     favouriteLabel.userInteractionEnabled = YES;
    
  
    UITapGestureRecognizer *favourite_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favourite_ActionDetails:)];
    [favoritesValueLabel addGestureRecognizer:favourite_Tapped];
      UITapGestureRecognizer *favourite_Tapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favourite_ActionDetails:)];
    [favouriteLabel addGestureRecognizer:favourite_Tapped1];
    
    

//---------------------------Sale points label tap gesture---------------------------------------------------------
    
    
    
    
    salepointValueLabel.userInteractionEnabled = YES;
    saleLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *sale_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sale_ActionDetails:)];
    [salepointValueLabel addGestureRecognizer:sale_Tapped];
    UITapGestureRecognizer *sale_Tapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sale_ActionDetails:)];
    [saleLabel addGestureRecognizer:sale_Tapped1];
    
//---------------------------Pay Fee label tap gesture---------------------------------------------------------
    
    payImageView.userInteractionEnabled = YES;
    payLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *ChoosePay_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChoosePay_ActionDetails:)];
    [payImageView addGestureRecognizer:ChoosePay_Tapped];
    UITapGestureRecognizer *ChoosePay_Tapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChoosePay_ActionDetails:)];
    [payLabel addGestureRecognizer:ChoosePay_Tapped1];
    
    
    
    //--------------------------- Boost label tap gesture---------------------------------------------------------
    
    boostImageview.userInteractionEnabled = YES;
    boostLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer * boost_Tapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChooseBoost_ActionDetails:)];
    [boostImageview addGestureRecognizer:boost_Tapped];
    
    UITapGestureRecognizer *boost_Tapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChooseBoost_ActionDetails:)];
    [boostLabel addGestureRecognizer:boost_Tapped1];
    
 
// //---------Activity indicator------------------------------------------
    
    activityindicator = [[UIActivityIndicatorView alloc]init];
    activityindicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhiteLarge;
    activityindicator.color = [UIColor grayColor] ;
    [activityindicator startAnimating];
    activityindicator.center = self.collectionView.center;
    [self.view addSubview:activityindicator];

   
 //-------------------hide plus button--------------------------------------------------------------
    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HideProfile_PlusButton) name:@"HidePlusButtonProfile" object:nil];
    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide_Popover) name:@"HidePopOver" object:nil];
  
    
}

-(void)HideProfile_PlusButton
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hide" object:self userInfo:nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        
//      //  _plusButtonsViewMain.hidden = YES;
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            
//            _plusButtonsViewMain.alpha = 0;
//            
//        } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
//            _plusButtonsViewMain.hidden = YES;
//            _plusButtonsViewMain.alpha = 1.0;
//            //if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
//        }];
//
//    
//    
//    
//    });
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _plusButtonsViewMain.alpha = 0;
        
    } completion: ^(BOOL finished) {//creates a variable (BOOL) called "finished" that is set to *YES* when animation IS completed.
        _plusButtonsViewMain.hidden = YES;
        _plusButtonsViewMain.alpha = 1.0;
       
        //if animation is finished ("finished" == *YES*), then hidden = "finished" ... (aka hidden = *YES*)
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self salePointsConnection];


     [self viewPostConnection];
    
//    if ([defaults  valueForKey:@"CountFav"] == 0 || [defaults valueForKey:@"CountFav"] == NULL)
//    {
//        
//        favoritesValueLabel.text = @"0";
//        
//        
//    }
//    else
//    {
//        favoritesValueLabel.text = [defaults valueForKey:@"CountFav"];
//    }
//    
    
    
    [self.collectionView reloadData];
    
    
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [self plusbuttonView];
}


-(void)plusbuttonView
{
    _plusButtonsViewMain = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:8
                                                         firstButtonIsPlusButton:YES
                                                                   showAfterInit:YES
                                                                   actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
                            {
                                NSLog(@"actionHandler | title: %@, description: %@, index: %lu", title, description, (long unsigned)index);
                                
                                if (index == 1)
                                {
                                     [defaults setObject:@"profilepost" forKey:@"PlusButtonPressed"];
                                    
                                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                    
                                    
                                    PostingViewController * set=[mainStoryboard instantiateViewControllerWithIdentifier:@"PostingViewController"];
                                    
                                    set.name = @"سيارات";//car
                                    
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
                                    [defaults setValue:@" حيوانات أليفة" forKey:@"Title"];//pets
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
  //  [_plusButtonsViewMain setDescriptionsTexts:@[@"", @"Cars", @"Property", @"Electronics", @"Pets", @"Furniture", @"Services", @"Other"]];
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
    else
    {
        for (NSUInteger i=1; i<=7; i++)
            [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, -13.f)
                                    forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    }
    
//    for (NSUInteger i=1; i<=7; i++)
//        [_plusButtonsViewMain setButtonAtIndex:i offset:CGPointMake(-6.f, -13.f)
//                                forOrientation:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? LGPlusButtonsViewOrientationPortrait : LGPlusButtonsViewOrientationAll)];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [_plusButtonsViewMain setButtonAtIndex:0 titleOffset:CGPointMake(0.f, -2.f) forOrientation:LGPlusButtonsViewOrientationLandscape];
        [_plusButtonsViewMain setButtonAtIndex:0 titleFont:[UIFont systemFontOfSize:32.f] forOrientation:LGPlusButtonsViewOrientationLandscape];
    }
    
    
    [self.view addSubview:_plusButtonsViewMain];
    [self.view bringSubviewToFront:_plusButtonsViewMain];
    _plusButtonsViewMain.hidden = YES;
    
   // [_plusButtonsViewMain showButtonsAnimated:YES completionHandler:nil];
}

-(void)postFunction
{
    
    [defaults setObject:@"profilepost" forKey:@"PlusButtonPressed"];
    
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

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 10);
    
}

-(void)favourite_ActionDetails:(UIGestureRecognizer *)reconizer
{
    NSLog(@"favourite tap");
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavouriteViewController * profile=[mainStoryboard instantiateViewControllerWithIdentifier:@"FavouriteViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:profile animated:YES];
   
}

-(void)sale_ActionDetails:(UIGestureRecognizer *)reconizer
{
    NSLog(@"sale_ActionDetails tap");
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SalePointsViewController * profile=[mainStoryboard instantiateViewControllerWithIdentifier:@"SalePointsViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:profile animated:YES];
    
}






-(void)ChoosePay_ActionDetails:(UIGestureRecognizer *)reconizer
{
    NSLog(@"ChoosePay_ActionDetails tap");
  
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChoosePostViewController * choose=[mainStoryboard instantiateViewControllerWithIdentifier:@"ChoosePostViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:choose animated:YES];
    
}
-(void)ChooseBoost_ActionDetails:(UIGestureRecognizer *)reconizer
{
    NSLog(@"ChooseBoost_ActionDetails tap");
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BoostPostViewController * choose=[mainStoryboard instantiateViewControllerWithIdentifier:@"BoostPostViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    choose.Array_Boost = Array_ViewPost;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:choose animated:YES];
    
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
////
////    if (string.length == 0)
////    {
////         isFiltered = NO;
////         [_filteredArray removeAllObjects];
////          [_filteredArray addObjectsFromArray:Array_ViewPost];
////       
////    }
////    else
////    {
////        
////        //set boolean flag
////        
////        isFiltered = YES;
////        
////        
////        //alloc and init filtered data
////        
////        _filteredArray = [[NSMutableArray alloc]init];
////        
////        [_filteredArray removeAllObjects];
////        //fast enumeration
////        
////        for (NSDictionary *obj in Array_ViewPost)
////        {
////            NSString *sTemp = [obj valueForKey:@"title"];
////            
////            NSRange titleRange = [sTemp rangeOfString:string options:NSCaseInsensitiveSearch];
////            
////            if (titleRange.location != NSNotFound)
////            {
////                [_filteredArray addObject:obj];
////            }
////            
////            
//////            if (titleRange.length > 0)
//////            {
//////                [_filteredArray addObject:obj];
//////
//////            }
////
////        }
////        
////        [self.collectionView reloadData];
////        
////    }
////    
////    
//    return true;
//}

- (IBAction)SearchEditing_Action:(id)sender
{
    
    if (searchTextField.text.length == 0)
    {
        isFiltered = NO;
        [_filteredArray removeAllObjects];
        [_filteredArray addObjectsFromArray:Array_ViewPost];
        
    }
    else
    {
        
        //set boolean flag
        
        isFiltered = YES;
        
        
        //alloc and init filtered data
        
        _filteredArray = [[NSMutableArray alloc]init];
        
      //  [_filteredArray removeAllObjects];
        //fast enumeration
        
        for (NSDictionary *obj in Array_ViewPost)
        {
            NSString *sTemp = [obj valueForKey:@"title"];
            NSString *sTemp2 = [obj valueForKey:@"hashtags"];
            NSString *sTemp3 = [obj valueForKey:@"description"];
            
            
            NSRange titleRange = [sTemp rangeOfString:searchTextField.text options:NSCaseInsensitiveSearch];
            NSRange titleRange2 = [sTemp2 rangeOfString:searchTextField.text options:NSCaseInsensitiveSearch];
            NSRange titleRange3 = [sTemp3 rangeOfString:searchTextField.text options:NSCaseInsensitiveSearch];
            
            if (titleRange.location != NSNotFound || titleRange2.location !=NSNotFound || titleRange3.location !=NSNotFound)
            {
                [_filteredArray addObject:obj];
            }
            
            
           
            
        }
        
        
    }

    [self.collectionView reloadData];

}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == searchTextField)
    {
        [searchTextField resignFirstResponder];
    }

    
    return NO;
}




- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == searchTextField)
    {
         isFiltered = YES;
    }
    
    
    if (myCustomXIBViewObj.priceTextField.text.length == 0)
    {
        myCustomXIBViewObj.priceTextField.text = @"ر.س";//$
        
    }
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(isFiltered == YES)
    {
        return _filteredArray.count;
    }
    else
    {
        return Array_ViewPost.count;
    }
    //return Array_ViewPost.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic_request;
    
    if(isFiltered == YES)
    {
        dic_request=[_filteredArray objectAtIndex:indexPath.row];

    }
    else
    {
         dic_request=[Array_ViewPost objectAtIndex:indexPath.row];
    }
   // NSDictionary *dic_request=[Array_ViewPost objectAtIndex:indexPath.row];
    NSLog(@"dic= %@",dic_request);
    
    
    if([NSNull null] ==[[Array_ViewPost  objectAtIndex:0]valueForKey:@"mediatype"] || [[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
    {
        
        Videocell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
        
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        Videocell.activityIndicatorVideo.hidden = NO;
        [Videocell.activityIndicatorVideo startAnimating];
        
        if([NSNull null] ==[dic_request valueForKey:@"mediathumbnailurl"] ||[[dic_request valueForKey:@"mediathumbnailurl"]isEqualToString:@""] )
        {
            
            Videocell.videoImageView.image =[UIImage imageNamed:@"defaultpostimg.jpg"];
            Videocell.playImageView.image = [UIImage imageNamed:@""];
            Videocell.activityIndicatorVideo.hidden = YES;
            [Videocell.activityIndicatorVideo stopAnimating];
        }
        else
        {
         
            [Videocell.videoImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
             {
                 Videocell.videoImageView.image = image;
                 Videocell.activityIndicatorVideo.hidden = YES;
                 [Videocell.activityIndicatorVideo stopAnimating];
             }
                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
             {
                 Videocell.activityIndicatorVideo.hidden = YES;
                 [Videocell.activityIndicatorVideo stopAnimating];
             }
             ];
            
            
            
            
            
            Videocell.playImageView.image = [UIImage imageNamed:@"Play"];
            //[cell.videoImageView sd_setImageWithURL:url];
            
        }
       
        Videocell.videoImageView.layer.cornerRadius = 10;
        Videocell.videoImageView.layer.masksToBounds = YES;
        
      //  NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"showamount"]];//$
        //Videocell.bidAmountLabel.text = show;//[dic_request valueForKey:@"showamount"];
        
        if ([[dic_request valueForKey:@"showamount"]floatValue] > [[dic_request valueForKey:@"askingprice"]floatValue])
        {
            NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"showamount"]];//$
            Videocell.bidAmountLabel.text = show;
        }
        else
        {
            NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"askingprice"]];//$
            Videocell.bidAmountLabel.text = show;
        }
        
        Videocell.titleLabel.text =  [dic_request valueForKey:@"title"];
        Videocell.locationLabel.text = [dic_request valueForKey:@"city1"];
        Videocell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        
        Videocell.Button_ItemSold.tag = indexPath.item;
        NSLog(@"button tag :%ld",(long)Videocell.Button_ItemSold.tag);
        Videocell.Button_ItemSold.userInteractionEnabled=YES;
        UITapGestureRecognizer *imageTap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSoldButtonPressed:)];
        
        [Videocell.Button_ItemSold addGestureRecognizer:imageTap4];
        
        
        
        return Videocell;
    }
    else
    {
        
        Imagecell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        //        [cell.videoImageView sd_setImageWithURL:url];
        
        Imagecell.activityIndicator.hidden = NO;
        [Imagecell.activityIndicator startAnimating];
        Imagecell.videoImageView.layer.cornerRadius = 10;
        Imagecell.videoImageView.layer.masksToBounds = YES;
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [Imagecell.videoImageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             Imagecell.videoImageView.image = image;
             Imagecell.activityIndicator.hidden = YES;
             [Imagecell.activityIndicator stopAnimating];
         }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error)
         {
             Imagecell.activityIndicator.hidden = YES;
             [Imagecell.activityIndicator stopAnimating];
         }
         ];

        if([NSNull null] ==[dic_request valueForKey:@"mediathumbnailurl"] || [[dic_request valueForKey:@"mediathumbnailurl"] isEqualToString:@""])
        {
            
           
            Imagecell.activityIndicator.hidden = YES;
            [Imagecell.activityIndicator stopAnimating];
        }
      //  [Imagecell.videoImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
        
        Imagecell.locationLabel.text = [dic_request valueForKey:@"city1"];
        Imagecell.timeLabel.text = [dic_request valueForKey:@"createtime"];
//        NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"showamount"]];//$
//        Imagecell.bidAmountLabel.text = show;
        
        if ([[dic_request valueForKey:@"showamount"]floatValue] > [[dic_request valueForKey:@"askingprice"]floatValue])
        {
            NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"showamount"]];//$
            Imagecell.bidAmountLabel.text = show;
        }
        else
        {
            NSString *show = [NSString stringWithFormat:@"ر.س%@",[dic_request valueForKey:@"askingprice"]];//$
            Imagecell.bidAmountLabel.text = show;
        }
        Imagecell.titleLabel.text = [dic_request valueForKey:@"title"];
      
        
        Imagecell.Button_ItemSold.tag = indexPath.item;
        NSLog(@"button tag :%ld",(long)Imagecell.Button_ItemSold.tag);
         Imagecell.Button_ItemSold.userInteractionEnabled=YES;
        UITapGestureRecognizer *imageTap4 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSoldButtonPressed:)];
        
        [Imagecell.Button_ItemSold addGestureRecognizer:imageTap4];
        
        return Imagecell;
    }
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
   // AllViewSwapeViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewSwapeViewController"];
    
    RootViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"RootViewController"];

    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    if(isFiltered == YES)
    {
        set1.Array_Alldata = _filteredArray;
        set1.tuchedIndex = indexPath.row;
        
        
        
    }
    else
    {
        set1.Array_Alldata = Array_ViewPost;
        set1.tuchedIndex = indexPath.row;
    }
    
//    set1.Array_Alldata = Array_ViewPost;
//    set1.tuchedIndex = indexPath.row;
    [self.navigationController pushViewController:set1 animated:YES];
    
    NSLog(@"Selected Index= %lditem",(long)indexPath.row);
    
}


#pragma mark -Collection Cell layout

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // return [self.cellHeights[indexPath.section + 1 * indexPath.item] floatValue];
    
    NSDictionary *dic_request=[Array_ViewPost objectAtIndex:indexPath.row];
    CGFloat height;
    
    
    if ([[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"] )
        
    {
        height = cellVideoHeight;//275.0;
    }
    else
    {
        
        height = cellHeight;//225.0;
        
    }
    return height;
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return 26.0f;//(indexPath.section + 1) * 26.0f;
}




- (IBAction)CreatePost_Action:(id)sender
{
     _plusButtonsViewMain.hidden = NO;
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowOpen" object:self userInfo:nil];
    
    

    
}

- (IBAction)SettingButton_Action:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AccountSettViewController * setting=[mainStoryboard instantiateViewControllerWithIdentifier:@"AccountSettViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController pushViewController:setting animated:YES];
    
    
    
}

- (IBAction)BackButton_Action:(id)sender
{
    if ([[defaults valueForKey:@"profileTapped"] isEqualToString:@"Activity"])
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popViewControllerAnimated:YES];
        
         [defaults setObject:@"" forKey:@"profileTapped"];
        
    }
    else
    {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

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
        
        NSString *location= @"location";
        NSString *locationVal = @"OFF";
        
        NSString *myposts= @"myposts";
        NSString *mypostsVal = @"YES";
        
        NSString *mypostsDummy= @"dummy";
        NSString *mypostsDummyVAl = @"dummy";

        
        NSString *city= @"city";
        NSString *cityVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Cityname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));

        NSString *country= @"country";
        NSString *countryVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Countryname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,location,locationVal,city,cityVal,country,countryVal,myposts,mypostsVal,mypostsDummy,mypostsDummyVAl];
        
        
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
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_ViewPost=[objSBJsonParser objectWithData:webData_ViewPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_ViewPost encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_ViewPost);
        NSLog(@"count= %lu",(unsigned long)Array_ViewPost.count);
        NSLog(@"registration_status %@",[[Array_ViewPost objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
        
        if ([ResultString isEqualToString:@"done"])
        {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        if ([ResultString isEqualToString:@"noposts"])
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];

            
        }
        
        if (Array_ViewPost.count != 0)
        {
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];
        }

        
        if (Array_ViewPost.count == 0)
        {
            postValueLabel.text = @"0";
        }
        else
        {
            postValueLabel.text =[NSString stringWithFormat:@"%lu", (unsigned long)Array_ViewPost.count];
        }
        
        
        
        
        
    }
    [self.collectionView reloadData];
}

#pragma mark- salepoint count connection

-(void)salePointsConnection

{
    
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@",userid,useridVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"salepoints"];;
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
                                                 
                                                 Array_SalePoints=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_SalePoints =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_SalePoints %@",Array_SalePoints);
                                               
                                                 if (Array_SalePoints.count !=0)
                                                 {
                                                     favoritesValueLabel.text = [NSString stringWithFormat:@"%@",[[Array_SalePoints objectAtIndex:0] valueForKey:@"totalfav"]];
                                                     
                                                     salepointValueLabel.text =[NSString stringWithFormat:@"%@",[[Array_SalePoints objectAtIndex:0] valueForKey:@"salepoints"]];
                                                     
                                                 }
                                                
//                                                 else
//                                                 {
//                                                     
//                                                     salepointValueLabel.text = [NSString stringWithFormat:@"%@ Points",ResultString];
//                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
                                                     
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Boosted" message:@"Thank-you for your payment, your post has been successfully boosted!" preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 
                                                 
                                                 
                                                 
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


//----------------------------Action Sheet----------------------------------------------

- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image  {
    
    
    [imageView setImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setupImageViewer];
    imageView.clipsToBounds = YES;
}

- (void)ViewTapprofileTappedView:(UITapGestureRecognizer *)recognizer
{
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from gallery",@"Take a picture",nil];
    popup.tag = 777;
    [popup showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheetTaggg==%ld",(long)actionSheet.tag);
    
    if ((long)actionSheet.tag == 777)
    {
        NSLog(@"INDEXAcrtionShhet==%ld",(long)buttonIndex);
        
        if (buttonIndex== 0)
        {
            
            
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                //[picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                picker.allowsEditing = NO;
                
                [self presentViewController:picker animated:true completion:nil];
            }
        }
        else  if (buttonIndex== 1)
        {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:picker animated:true completion:nil];
        }
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    
    chosenImage = info[UIImagePickerControllerOriginalImage];
    profileImageView.image=chosenImage;
    
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    ImageNSdata = [Base64 encode:imageData];
    
    
    encodedImage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdata,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    
    [self savepictureCommunication];
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)savepictureCommunication
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Tamm." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        
        NSString *userid1= @"userid";
        NSString *useridVal1 =[defaults valueForKey:@"userid"];
        
        NSString *profileimage= @"profileimage";
        
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",userid1,useridVal1,profileimage,encodedImage];
        
        
#pragma mark - swipe sesion
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"savepicture"];;
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
                                                     NSMutableArray * array_profilepic=[[NSMutableArray alloc]init];
                                                     SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                     array_profilepic=[objSBJsonParser objectWithData:data];
                                                     NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     if (array_profilepic.count !=0)
                                                     {
    
  Str_profileurl=@"";
                                                         Str_profileurl=[[array_profilepic objectAtIndex:0]valueForKey:@"profilepic"];
                            [defaults setObject:Str_profileurl forKey:@"profileimage"];
        
       
                                                     }
                                                     
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
    };
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //_plusButtonsViewMain.hidden = YES;
}


//--------------------------ITEM SOLD METHOD---------------------------------------------------------


//-(void)itemSoldButtonPressed:(id)sender
//{

-(void)itemSoldButtonPressed:(UITapGestureRecognizer *)sender
    {
        UIGestureRecognizer *rec = (UIGestureRecognizer*)sender;
        UIButton *button = (UIButton *)rec.view;
        NSLog(@"ImageTappedscroll ImageTappedscroll==%ld", (long)button.tag);
        
        
        if(isFiltered == YES)
        {
            PostIDValue = [[_filteredArray objectAtIndex:(long)button.tag]valueForKey:@"postid"];
        }
        else
        {
            PostIDValue = [[Array_ViewPost objectAtIndex:(long)button.tag]valueForKey:@"postid"];
        }
        
        
        
    
    NSLog(@"Item Sold Pressed");
    
    transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    grayView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 137.5, self.view.frame.size.width - 250, 275, 162)];
    grayView.center=transparentView.center;
    grayView.layer.cornerRadius=10;
    grayView.clipsToBounds = YES;
    [grayView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIButton *closeview=[[UIButton alloc]initWithFrame:CGRectMake(8, 8, 30, 30)];
    [closeview setTitle:@"X" forState:UIControlStateNormal];
    [closeview setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [closeview addTarget:self action:@selector(closedd:)
        forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:closeview];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(147, 8, 86, 30)];
    label1.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:16];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"السلع المباعة";//@"ITEM SOLD";
    label1.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [grayView addSubview:label1];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(232, 8, 30, 30)];
    imageView.image = [UIImage imageNamed:@"Greenitemsold"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [grayView addSubview:imageView];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(87, 41, 175, 18)];
    label2.font = [UIFont fontWithName:@"SanFranciscoDisplay-Semibold" size:11];
    label2.textAlignment = NSTextAlignmentRight;
    label2.text = [NSString stringWithFormat:@"%@%@",PostIDValue,@" :رقم الإعلان"];//POST ID [NSString stringWithFormat:@"رمز الإعلان: %@",PostIDValue];//@"POST ID: 3589278W3";
    
    
  //  label2.text = [NSString stringWithFormat:@"POST ID: %@",[[Array_ViewPost objectAtIndex:(long)button.tag]valueForKey:@"postid"]];
    
    label2.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [grayView addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(8, 67, 254, 21)];
    label3.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:14];
    label3.textAlignment = NSTextAlignmentRight;
        label3.text = @"متأكد أنه تم بيع السلعة؟";//@"Are you sure this item has been sold?";
    [grayView addSubview:label3];
    
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(21, 87, 241, 35)];
    label4.font = [UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:14];
    label4.textAlignment = NSTextAlignmentRight;
    label4.numberOfLines = 2;
    label4.text = @"اختيار تأكيد سوف يزيل السلعه.";//@"Selecting confirm will remove item from تم";
    [grayView addSubview:label4];
    
    
    UIButton *confirm=[[UIButton alloc]initWithFrame:CGRectMake(0, 130, 275, 32)];
    [confirm setTitle:@"تأكيد" forState:UIControlStateNormal];//CONFIRM
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    confirm.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16];
    [confirm setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    [confirm addTarget:self action:@selector(confirm:)
      forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:confirm];
    
    
    [transparentView addSubview:grayView];
    [self.view addSubview:transparentView];
    
}

- (void)closedd:(id)sender
{
    [self.view endEditing:YES];
    transparentView.hidden=YES;
    
}
- (void)confirm:(id)sender
{
    
    /* PAYMENTS POPUP (CREDIT CARD / BANK)
    transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    myCustomXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"EnterPrice" owner:self options:nil]objectAtIndex:0];
    
    myCustomXIBViewObj.frame = CGRectMake((self.view.frame.size.width- myCustomXIBViewObj.frame.size.width)/2,self.view.frame.size.width - 250, myCustomXIBViewObj.frame.size.width, myCustomXIBViewObj.frame.size.height);
    
    
    [self.view addSubview:myCustomXIBViewObj];
    
    [myCustomXIBViewObj.bankButton addTarget:self action:@selector(bankButton_Action:) forControlEvents:UIControlEventTouchUpInside];
    [myCustomXIBViewObj.bankButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [myCustomXIBViewObj.creditButton addTarget:self action:@selector(creditButton_Action:) forControlEvents:UIControlEventTouchUpInside];
    [myCustomXIBViewObj.creditButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        [myCustomXIBViewObj.bankButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -212)];
        [myCustomXIBViewObj.creditButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, -176)];
    }
    else
    {
        
    }
   
    [myCustomXIBViewObj.priceTextField addTarget:self action:@selector(enterInLabel ) forControlEvents:UIControlEventEditingChanged];
    
    myCustomXIBViewObj.priceTextField.delegate = self;
    [myCustomXIBViewObj.priceTextField becomeFirstResponder];
    myCustomXIBViewObj.postIdLabel.text =[NSString stringWithFormat:@"%@%@",PostIDValue,@" :رقم الإعلان"];//POST ID [NSString stringWithFormat:@"رمز الإعلان: %@",PostIDValue];//[NSString stringWithFormat:@"POST ID: %@",[Array_ViewPost  valueForKey:@"postid"]];
    myCustomXIBViewObj.layer.cornerRadius = 10;
    myCustomXIBViewObj.clipsToBounds = YES;
    
    [myCustomXIBViewObj setUserInteractionEnabled:YES];
    UITapGestureRecognizer *viewTapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped_Action:)];
    [myCustomXIBViewObj addGestureRecognizer:viewTapped];
    
    [transparentView1 addSubview:myCustomXIBViewObj];
    [self.view addSubview:transparentView1];
    transparentView.hidden=YES;
    
    myCustomXIBViewObj.bankButton.enabled = NO;
    [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
    
    myCustomXIBViewObj.creditButton.enabled = NO;
    [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
    */
    
    [self.view showActivityViewWithLabel:@"Closing Post..."];
    paymentmodeStr = @"FREE";
    [self ItemSold_Connection];
    NSLog(@"item_sold_free Pressed");
    [self.view endEditing:YES];
    [defaults setObject:@"yes" forKey:@"refreshView"];
    
}

-(void)viewTapped_Action:(UIGestureRecognizer *)reconizer
{
    [self.view endEditing:YES];
}

-(void)enterInLabel
{
//    NSString *askingpriceValString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
//    askingpriceValString = [askingpriceValString substringFromIndex:1];
    
    NSString *askingpriceValString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
    askingpriceValString = [askingpriceValString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];
    
    
    float j = [askingpriceValString floatValue];
    
    float k = ((1*j)/100); //0.75 instead of 1
    
    myCustomXIBViewObj.caculatedAmountLabel.text =[NSString stringWithFormat:@"ر.س %0.2f",k]; //[NSString stringWithFormat:@"$ %@",askingpriceValString];
    
    if ([myCustomXIBViewObj.priceTextField.text isEqualToString:@"ر.س"])
    {
        
        myCustomXIBViewObj.bankButton.enabled = NO;
        [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
        myCustomXIBViewObj.creditButton.enabled = NO;
        [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
        
    }
    
    
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (myCustomXIBViewObj.priceTextField.text.length == 0)
//    {
//        myCustomXIBViewObj.priceTextField.text = @"$";
//        
//    }
//    
//}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    if (textField == searchTextField)
    {
        
    }
    else if (textField == myCustomXIBViewObj.priceTextField)
    {
    
    
    NSString *newText = [myCustomXIBViewObj.priceTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![newText hasPrefix:@"ر.س"])//$
    {
        
        myCustomXIBViewObj.bankButton.enabled = NO;
        [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
        myCustomXIBViewObj.creditButton.enabled = NO;
        [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
        
        
        return NO;
    }
    
    myCustomXIBViewObj.bankButton.enabled = YES;
    [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    myCustomXIBViewObj.creditButton.enabled = YES;
    [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    
    
    
    // Default:
    
    NSLog(@"%lu",textField.text.length);
    
    }
    
    return YES;
    
}



-(void)bankButton_Action:(id)sender
{
 
  //[self.view showActivityViewWithLabel:@"Making payment..."];
    paymentmodeStr = @"BANK";
    
  //  [self ItemSold_Connection];
    NSLog(@"Bank button Pressed");
    [self.view endEditing:YES];
    
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Bank Details" message:@"Please transfer the amount to the below bank details:\n\nBank name: ABC Bank\nBank branch: JVPD\nIFSC Code : 123ABC\nAccount No.:7894123415487\n\nPlease mail us the reference no. to support@tammapp.com once you have made the payment.\n\nAre you sure you wish to make payment?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                {
                                    [self.view showActivityViewWithLabel:@"Making payment..."];
                                    [self ItemSold_Connection];
                                    [defaults setObject:@"yes" forKey:@"refreshView"];
                                 
                                }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                  
                                   
                               }];
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
   
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
-(void)creditButton_Action:(id)sender
{
    [self.view showActivityViewWithLabel:@"Making payment..."];
    paymentmodeStr = @"CARD";
    [self ItemSold_Connection];
    NSLog(@"creditButton_Action Pressed");
    [self.view endEditing:YES];
    [defaults setObject:@"yes" forKey:@"refreshView"];
}

- (void)Hide_Popover
{
   [self.view endEditing:YES];
    transparentView1.hidden= YES;
}

#pragma mark - ItemSold Connection
-(void)ItemSold_Connection
{
    NSString *postid= @"postid";
    NSString *postidVal = PostIDValue;
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    
//    NSString *enterPriceString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
//    enterPriceString = [enterPriceString substringFromIndex:1];
    NSString *enterPriceString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
    enterPriceString = [enterPriceString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];
    NSInteger number = [enterPriceString intValue];
    
    NSString *price= @"sellprice";
    NSString *priceVal = [NSString stringWithFormat:@"%ld",number];
    
//    NSString *transactionString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.caculatedAmountLabel.text];
//    transactionString = [transactionString substringFromIndex:1];
    NSString *transactionString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.caculatedAmountLabel.text];
    transactionString = [transactionString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];
    
    NSString *transaction= @"commission";
    NSString *transactionVal = transactionString;
    
    NSString *paymentmode= @"paymentmode";
    NSString *paymentmodeVal = paymentmodeStr;
    
    
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,price,priceVal,transaction,transactionVal,paymentmode,paymentmodeVal];
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"itemsold"];;
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
                                                 
                                                 Array_ItemSold=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_ItemSold =[objSBJsonParser objectWithData:data];
                                                 
                                               
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_ItemSold %@",Array_ItemSold);
                                                 
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
                                                     
                                                     [self.view endEditing:YES];
                                                     transparentView1.hidden= YES;
                                                     transparentView.hidden = YES; //for confirm popup
                                                
//                                                     CATransition *transition = [CATransition animation];
//                                                     transition.duration = 0.3;
//                                                     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                                                     transition.type = kCATransitionPush;
//                                                     transition.subtype = kCATransitionFromRight;
//                                                     [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//                                                     
//                                                     [self.navigationController popViewControllerAnimated:YES];
                                                     
                                                       [self viewPostConnection];
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"The server encountered some error, please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"nopostid"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This item is no more available and has probably been sold by the seller." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"nullerror"])
                                                 {
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Please enter the price at which the item has been sold." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                 }
                                                 
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 
                                                 
                                                 
                                                 
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
