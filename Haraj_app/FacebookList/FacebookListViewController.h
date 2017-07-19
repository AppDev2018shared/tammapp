//
//  FacebookListViewController.h
//  care2Dare
//
//  Created by Spiel's Macmini on 5/17/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookoneTableViewCell.h"
@interface FacebookListViewController : UIViewController
@property(strong,nonatomic)IBOutlet UITableView *tableview_facebook;
@property(strong,nonatomic)IBOutlet UILabel *Lable_JSONResult;
@property(strong,nonatomic)IBOutlet UIActivityIndicatorView *indicator;
@property(strong,nonatomic)FacebookoneTableViewCell *cell_fb;
-(IBAction)Button_Back:(id)sender;
@property(strong,nonatomic)IBOutlet UISearchBar *searchbar;
@end
