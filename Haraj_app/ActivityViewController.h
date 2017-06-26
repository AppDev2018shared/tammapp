//
//  ActivityViewController.h
//  Haraj_app
//
//  Created by Spiel on 26/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


- (IBAction)segmentedControl_Action:(id)sender;
- (IBAction)ProfileButton_Action:(id)sender;
- (IBAction)SearchButton_Action:(id)sender;
- (IBAction)BackButton_Action:(id)sender;


@end
