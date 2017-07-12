//
//  ActivityNextViewController.h
//  Haraj_app
//
//  Created by Spiel on 11/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityNextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *postIdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;



- (IBAction)ProfileButton_Action:(id)sender;
- (IBAction)SearchButton_Action:(id)sender;
- (IBAction)BackButton_Action:(id)sender;


@property (nonatomic, strong)NSMutableArray *AllDataArray;
@property (nonatomic,assign) NSInteger touchedIndex;


@property (nonatomic,retain)NSString *postIdOnTap;




@end
