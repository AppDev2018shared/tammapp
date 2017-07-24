//
//  SearchViewController.h
//  Haraj_app
//
//  Created by Spiel on 21/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *Button_Back;
@property (weak, nonatomic) IBOutlet UIButton *Button_Cancel;


@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
- (IBAction)SearchEditing_Action:(id)sender;



@property (nonatomic,strong) NSMutableArray *initialTitles;
@property (nonatomic,strong) NSMutableArray *filteredTitles;
//@property BOOL isFiltered;


- (IBAction)BackButton_Action:(id)sender;
- (IBAction)CancelButton_Action:(id)sender;

@end
