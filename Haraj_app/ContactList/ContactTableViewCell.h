//
//  ContactTableViewCell.h
//  contactList
//
//  Created by Spiel's Macmini on 5/17/17.
//  Copyright © 2017 Spiel's Macmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel * label_one;
@property(nonatomic,strong)IBOutlet UILabel * label_two;
@property(nonatomic,strong)IBOutlet UILabel * label_three;
@property(nonatomic,strong)IBOutlet UIButton * button_invite;
@end
