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
#import "CommentsTableViewCell.h"
#import "SuggestedTableViewCell.h"
#import "PostHeaderTableViewCell.h"
@interface OnCellClickViewController : UIViewController
{
    UIView *transparentView,*grayView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray * Array_UserInfo;
@property (strong,nonatomic)NSMutableArray * Array_All_UserInfo;
@property (nonatomic)NSInteger swipeCount;

@property (strong,nonatomic)TwoImageOnClickTableViewCell * Cell_two;
@property (strong,nonatomic)DetailTableViewCell * detailCell;
@property (strong,nonatomic)CommentsTableViewCell * ComCell;
@property (strong,nonatomic)SuggestedTableViewCell * SuggestCell;

@property (strong,nonatomic)PostHeaderTableViewCell * cell_postcomments;
@property (nonatomic, strong) NSArray *MoreImageArray;
@end
