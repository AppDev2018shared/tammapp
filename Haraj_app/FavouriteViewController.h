//
//  FavouriteViewController.h
//  Haraj_app
//
//  Created by Spiel on 21/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;




- (IBAction)SearchButton_Action:(id)sender;
- (IBAction)BackButton_Action:(id)sender;

@end