//
//  SearchCollectionViewController.h
//  Haraj_app
//
//  Created by Spiel on 21/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *Button_Back;
@property (weak, nonatomic) IBOutlet UIButton *Button_Cancel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *Img_Search;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *view_line;
- (IBAction)SearchEditing_Action:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *label_JsonResult;


@property (nonatomic,strong) NSMutableDictionary *initialTitles;
@property (nonatomic,retain)NSString *searchTextEnter;
@property (nonatomic,retain)NSString *rowTapCategory;


//@property BOOL isFiltered;


- (IBAction)BackButton_Action:(id)sender;
- (IBAction)CancelButton_Action:(id)sender;


@end
