//
//  OnCellClickViewController.h
//  Haraj_app
//
//  Created by Spiel on 08/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoImageOnClickTableViewCell.h"
#import "DetailTableViewCell.h"
#import "DetailCarTableViewCell.h"
#import "DetailPropertyTableViewCell.h"
#import "CommentsTableViewCell.h"
#import "SuggestedTableViewCell.h"
#import "PostHeaderTableViewCell.h"
#import "PostFooterTableViewCell.h"
@interface OnCellClickViewController : UIViewController
{
    UIView *transparentView,*grayView;
}
@property  NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray * Array_UserInfo;
@property (strong,nonatomic)NSMutableArray * Array_All_UserInfo;
@property (nonatomic)NSInteger swipeCount;

@property (strong,nonatomic)TwoImageOnClickTableViewCell * Cell_two;

@property (strong,nonatomic)DetailTableViewCell * detailCell;
@property (strong,nonatomic)DetailCarTableViewCell * detailCellCar;
@property (strong,nonatomic)DetailPropertyTableViewCell * detailCellProperty;



@property (strong,nonatomic)PostHeaderTableViewCell * cell_postcomments;
@property (strong,nonatomic)CommentsTableViewCell * ComCell;
@property (strong,nonatomic)PostFooterTableViewCell * cell_seeallcomments;


@property (strong,nonatomic)SuggestedTableViewCell * SuggestCell;


@property (nonatomic, strong) NSArray *MoreImageArray;
@property (strong, nonatomic) NSURL *videoURL;

@end
