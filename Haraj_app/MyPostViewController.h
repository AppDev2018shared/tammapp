//
//  MyPostViewController.h
//  Haraj_app
//
//  Created by Spiel on 12/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterPrice.h"
#import "DetailTableViewCell.h"
#import "CommentsTableViewCell.h"
@interface MyPostViewController : UIViewController
{
    UIView *transparentView,*transparentView1,*grayView;
}
@property (strong,nonatomic)DetailTableViewCell * detailCell;
@property (strong,nonatomic)CommentsTableViewCell * ComCell;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray * Array_UserInfo;
@property (nonatomic)NSInteger swipeCount;

@property (strong,nonatomic)NSMutableArray * Array_All_UserInfo;
@property (nonatomic, strong) NSArray *MoreImageArray;
@end
