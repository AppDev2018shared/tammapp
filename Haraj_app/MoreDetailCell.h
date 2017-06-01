//
//  MoreDetailCell.h
//  Haraj_app
//
//  Created by Spiel on 16/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *currentDays_Label;
@property (weak, nonatomic) IBOutlet UITextView *moreTextView;
@property (weak, nonatomic) IBOutlet UILabel *morePlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *callLabel;
@property (weak, nonatomic) IBOutlet UITextField *askingPriceTextField;

@end
