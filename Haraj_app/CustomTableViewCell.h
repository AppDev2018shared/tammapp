//
//  CustomTableViewCell.h
//  BubbleChat
//
//  Created by Spiel's Macmini on 10/14/16.
//  Copyright © 2016 Spiel's Macmini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UILabel * Label;
@property(strong,nonatomic)IBOutlet UIImageView * Img1;
@property(strong,nonatomic)IBOutlet UIImageView * ProfileImg;
@property(strong,nonatomic)IBOutlet UIView * CellBackView;

@end
