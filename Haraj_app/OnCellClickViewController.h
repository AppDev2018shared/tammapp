//
//  OnCellClickViewController.h
//  Haraj_app
//
//  Created by Spiel on 08/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnCellClickViewController : UIViewController
{
    UIView *transparentView,*grayView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic)NSMutableArray * Array_UserInfo;
@property (nonatomic)NSInteger swipeCount;

@end
