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

- (IBAction)SearchButton_Action:(id)sender;
- (IBAction)BackButton_Action:(id)sender;


@property (strong,nonatomic)NSMutableArray * Array_Boost;



@end
