//
//  TwitterListViewController.h
//  care2Dare
//
//  Created by Spiel's Macmini on 5/17/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitteroneTableViewCell.h"
#import "TwittertwoTableViewCell.h"
@interface TwitterListViewController : UIViewController
@property(strong,nonatomic)IBOutlet UITableView *tableview_twitter;
@property(strong,nonatomic)IBOutlet UILabel *Lable_JSONResult;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *indicator;
@property(strong,nonatomic)TwitteroneTableViewCell *cell_twitter;
@property(strong,nonatomic)TwittertwoTableViewCell *cell_twitter2;
@property(strong,nonatomic)IBOutlet UISearchBar *searchbar;
-(IBAction)Button_Back:(id)sender;
@end
