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
#import "AllViewSwapeViewController.h"
#import "FavouriteViewController.h"
#import "SalePointsViewController.h"
#import "ChoosePostViewController.h"
#import "BoostPostViewController.h"
#import "AccountSettViewController.h"
#import "Base64.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "LGPlusButtonsView.h"
#import "PostingViewController.h"



@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegate,FRGWaterfallCollectionViewDelegate,UITextFieldDelegate>

{
    NSMutableArray *modelArray;
    NSMutableArray *array;
    
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_ViewPost;
    NSMutableData *webData_ViewPost;
    NSMutableArray *Array_ViewPost,*Array_SalePoints;
    
    int favouritesCount;
    
    UIActivityIndicatorView *activityindicator;
    UIImage *chosenImage;
    NSString * ImageNSdata,*encodedImage;
    
}

@property (strong, nonatomic) LGPlusButtonsView *plusButtonsViewMain;

@end

@implementation ProfileViewController
@synthesize searchTextField,searchImageView,profileImageView,nameLabel,lastnameLabel,favoritesValueLabel,postValueLabel,salepointValueLabel,favouriteLabel,saleLabel,postLabel,payImageView,payLabel,boostImageview,boostLabel,isFiltered;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10,searchTextField.frame.size.height)];
    searchTextField.rightView = paddingView;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    

    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,36,22)];
   // [paddingView1 addSubview:searchImageView];
    
    searchTextField.leftView = paddingView1;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
   
    
    
    
    
    favouritesCount = 0;
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    defaults = [[NSUserDefaults alloc]init];

    
    // Do any additional setup after loading the view.
    FRGWaterfallCollectionViewLayout *cvLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    cvLayout.delegate = self;
    cvLayout.itemWidth = 173.0f;
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
    
    
    NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"ProImg"]];
    [profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
    [self displayImage:profileImageView withImage:profileImageView.image];

        
        
        
    }
    else
    {
        
        profileImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *ViewTapprofile =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ViewTapprofileTappedView:)];
        [profileImageView addGestureRecognizer:ViewTapprofile];
        if(chosenImage == nil)
        {
            NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"ProImg"]];
            
            [profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DefaultImg.jpg"] options:SDWebImageRefreshCached];
        }
        else
        {
             profileImageView.image = chosenImage;
        }

        
    }
    
    
    
    
    
    [self viewPostConnection];
    [self salePointsConnection];
    
//---------------------------Favourite label tap gesture---------------------------------------------------------
    
    if ([defaults  valueForKey:@"CountFav"] == 0)
    {
          favoritesValueLabel.text = @"0";
    }
    else
    {
         favoritesValueLabel.text = [defaults valueForKey:@"CountFav"];
    }
    
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
    
   
  
    
}

-(void)HideProfile_PlusButton
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hide" object:self userInfo:nil];

    
    _plusButtonsViewMain.hidden = YES;
    //[_plusButtonsViewMain removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self salePointsConnection];


     [self viewPostConnection];
     favoritesValueLabel.text = [defaults valueForKey:@"CountFav"];
    
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
//    
//    if (string.length == 0)
//    {
//         isFiltered = NO;
//         [_filteredArray removeAllObjects];
//          [_filteredArray addObjectsFromArray:Array_ViewPost];
//       
//    }
//    else
//    {
//        
//        //set boolean flag
//        
//        isFiltered = YES;
//        
//        
//        //alloc and init filtered data
//        
//        _filteredArray = [[NSMutableArray alloc]init];
//        
//        [_filteredArray removeAllObjects];
//        //fast enumeration
//        
//        for (NSDictionary *obj in Array_ViewPost)
//        {
//            NSString *sTemp = [obj valueForKey:@"title"];
//            
//            NSRange titleRange = [sTemp rangeOfString:string options:NSCaseInsensitiveSearch];
//            
//            if (titleRange.location != NSNotFound)
//            {
//                [_filteredArray addObject:obj];
//            }
//            
//            
////            if (titleRange.length > 0)
////            {
////                [_filteredArray addObject:obj];
////
////            }
//
//        }
//        
//        [self.collectionView reloadData];
//        
//    }
//    
//    
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
    [searchTextField resignFirstResponder];
    return YES;
}




- (void)textFieldDidBeginEditing:(UITextField *)textField
{
     isFiltered = YES;
    
    
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
    
    NSString *xyz = [dic_request valueForKey:@"mediatype"];
    
    if([NSNull null] ==[[Array_ViewPost  objectAtIndex:0]valueForKey:@"mediatype"] || [[dic_request valueForKey:@"mediatype"] isEqualToString:@"VIDEO"])
    {
        
        PatternViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
        
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        if([NSNull null] ==[dic_request valueForKey:@"mediathumbnailurl"])
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
        
        
        
        cell.videoImageView.layer.cornerRadius = 10;
        cell.videoImageView.layer.masksToBounds = YES;
        
        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
        cell.bidAmountLabel.text = show;//[dic_request valueForKey:@"showamount"];
        cell.titleLabel.text =  [dic_request valueForKey:@"title"];
        cell.locationLabel.text = [dic_request valueForKey:@"city1"];
        cell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        
        
        return cell;
    }
    else
    {
        
        ImageCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        //        [cell.videoImageView sd_setImageWithURL:url];
        cell.videoImageView.layer.cornerRadius = 10;
        cell.videoImageView.layer.masksToBounds = YES;
        NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
        [cell.videoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]
                                        options:SDWebImageRefreshCached];
        
        cell.locationLabel.text = [dic_request valueForKey:@"city1"];
        cell.timeLabel.text = [dic_request valueForKey:@"createtime"];
        NSString *show = [NSString stringWithFormat:@"$%@",[dic_request valueForKey:@"showamount"]];
        cell.bidAmountLabel.text = show;
        cell.titleLabel.text = [dic_request valueForKey:@"title"];
        
        return cell;
    }
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AllViewSwapeViewController * set1=[mainStoryboard instantiateViewControllerWithIdentifier:@"AllViewSwapeViewController"];
    
    
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
        height = 275.0;
    }
    else
    {
        
        height = 225.0;
        
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
        
       

        
        NSString *city= @"city";
        NSString *cityVal = [defaults valueForKey:@"Cityname"];

        NSString *country= @"country";
        NSString *countryVal = [defaults valueForKey:@"Countryname"];;
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,location,locationVal,city,cityVal,country,countryVal,myposts,mypostsVal];
        
        
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
                                                 
                                                 if ([ResultString isEqualToString:@""])
                                                 {
                                                    
                                                     
                                                     salepointValueLabel.text = @"0";
                                                     
                                                 }
                                                 else //if ([ResultString isEqualToString:@"1"])
                                                 {
                                                     salepointValueLabel.text =ResultString;
                                                     
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
//                                                         Str_profileurl=@"";
//                                                         Str_profileurl=[[array_profilepic objectAtIndex:0]valueForKey:@"profilepic"];
                                                        
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
    _plusButtonsViewMain.hidden = YES;
}



@end
