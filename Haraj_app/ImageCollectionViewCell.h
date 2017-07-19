//
//  ImageCollectionViewCell.h
//  Haraj_app
//
//  Created by Spiel on 03/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bidImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


//----------------profile screen button-----------------------

@property (weak, nonatomic) IBOutlet UIButton *Button_ItemSold;



@end
