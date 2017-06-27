//
//  AccountSettViewController.h
//  SprintTags_Pro
//
//  Created by Spiel's Macmini on 8/19/16.
//  Copyright © 2016 Spiel's Macmini. All rights reserved.
//  3-Sz3j1ATQi0T3i-e7BKIA
//DHdeU3toRmKaynOQ2Q5hzQ

#import <UIKit/UIKit.h>
#import "AccOneTableViewCell.h"
#import "AccTwoTableViewCell.h"
#import "AccThreeTableViewCell.h"

@interface AccountSettViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView * TableView_Setting;
}
@property(nonatomic,strong)AccOneTableViewCell *onecell;
@property(nonatomic,strong)AccTwoTableViewCell *Twocell2;
@property(nonatomic,strong)AccThreeTableViewCell *Threecell3;

@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property(nonatomic,strong)IBOutlet UIView * HeadTopView;



- (IBAction)DoneButton:(id)sender;
@end
