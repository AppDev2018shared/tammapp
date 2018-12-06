//
//  BoostPostViewController.h
//  Haraj_app
//
//  Created by Spiel on 22/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoostPostViewController : UIViewController

{
    UIView *transparentView1;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)InfoButton_Action:(id)sender;
- (IBAction)BackButton_Action:(id)sender;
@property (weak, nonatomic) IBOutlet  UILabel *labelheding;
@property (weak, nonatomic) IBOutlet  UIButton *Button_help;
@property (weak, nonatomic) IBOutlet UIButton *backbutton;
@property (weak, nonatomic) IBOutlet UIView *view_line;

@property (strong,nonatomic)NSMutableArray * Array_Boost;



@end
