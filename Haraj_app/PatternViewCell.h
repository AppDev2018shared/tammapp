//
//  PatternViewCell.h
//  UICollectionViewDemo
//
//  Created by Spiel on 23/09/16.
//  Copyright © 2016 Spiel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatternViewCell : UICollectionViewCell




@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bidImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end
