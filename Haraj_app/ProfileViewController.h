//
//  ProfileViewController.h
//  Haraj_app
//
//  Created by Spiel on 21/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

{
    UIView *transparentView,*grayView,*transparentView1;
}
@property (weak, nonatomic) IBOutlet UIButton *Button_Back;
@property (weak, nonatomic) IBOutlet UIButton *Button_setting;
@property (weak, nonatomic) IBOutlet UIImageView *Img_Search;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *Button_CircleGreen;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *Label_CircleFrontgreen;
- (IBAction)SearchEditing_Action:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastnameLabel;

@property (weak, nonatomic) IBOutlet UILabel *favoritesValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *favouriteLabel;

@property (weak, nonatomic) IBOutlet UILabel *salepointValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;


@property (weak, nonatomic) IBOutlet UILabel *postValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;

@property (weak, nonatomic) IBOutlet UIImageView *boostImageview;
@property (weak, nonatomic) IBOutlet UILabel *boostLabel;



@property (nonatomic,strong) NSMutableArray *initialCities;
@property (nonatomic,strong) NSMutableArray *filteredArray;
@property BOOL isFiltered;




- (IBAction)CreatePost_Action:(id)sender;

- (IBAction)SettingButton_Action:(id)sender;
- (IBAction)BackButton_Action:(id)sender;

@end
