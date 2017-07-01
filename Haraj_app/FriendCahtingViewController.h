//
//  FriendCahtingViewController.h
//  Play_Date
//
//  Created by Spiel's Macmini on 1/17/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"

@interface FriendCahtingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)IBOutlet UIView * HeadTopView;
@property(nonatomic,strong)IBOutlet UILabel * Label_UserName;
@property(nonatomic,strong)IBOutlet UIImageView * Image_UserProfile;
@property(nonatomic,weak)IBOutlet UITableView * Table_Friend_chat;
//@property(nonatomic,strong)FriendsSecTwoTableViewCell * Cell_Two;
-(IBAction)BackView:(id)sender;

-(void)calculate;
    
   @property (nonatomic, weak) id  delegate;








@property(strong,nonatomic)CustomTableViewCell * Cell_one1;
@property (nonatomic, strong)NSMutableArray *AllDataArray;
@property (nonatomic, strong)NSString * String_payButtonHide;

@property (nonatomic, strong)NSData * ImageData;
@property(weak,nonatomic)IBOutlet UITextView * TextViews;
@property(weak,nonatomic)IBOutlet UIView * BackGround_MainViews;
@property(weak,nonatomic)IBOutlet UIView * BackTextViews;
;


@property(weak,nonatomic)IBOutlet UIButton * Button_Flag_Button;

-(IBAction)FlagButton_Acion:(id)sender;

-(IBAction)Send_Comments:(id)sender;

-(IBAction)ImageGalButtonAct:(id)sender;


@property(nonatomic,strong)IBOutlet UITextView * textOne;
@property(nonatomic,strong)IBOutlet UIView * textOneBlue;
@property(nonatomic,strong)IBOutlet UIView * BlackViewOne;
@property(nonatomic,strong)IBOutlet UITableView * tableOne;
@property (nonatomic, strong)IBOutlet UIButton *sendButton;
@property (nonatomic, strong)IBOutlet UIButton *ImageGalButton;
@property (nonatomic, strong)IBOutlet  UILabel *placeholderLabel;
@property(nonatomic,strong)IBOutlet UIView * ViewTextViewOne;


@property (nonatomic, retain) UIRefreshControl *refreshControl;






@end
