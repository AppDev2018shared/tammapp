//
//  SalePointsViewController.h
//  Haraj_app
//
//  Created by Spiel on 23/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalePointsViewController : UIViewController

- (IBAction)InfoButton_Action:(id)sender;
- (IBAction)BackButton_Action:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;

@property (weak, nonatomic) IBOutlet  UILabel *labelheding;
@property (weak, nonatomic) IBOutlet  UIButton *Button_help;
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property (weak, nonatomic) IBOutlet UIView *view_line;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
