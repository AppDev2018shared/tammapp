//
//  FirstImageViewCell.h
//  Haraj_app
//
//  Created by Spiel on 09/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstImageViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_thumbnails;
@property (weak, nonatomic) IBOutlet UIImageView *image_play;
@property (weak, nonatomic) IBOutlet UIButton  *button_threedots;
@property (weak, nonatomic) IBOutlet UIButton  *button_favourite;
@property (weak, nonatomic) IBOutlet UIButton  *button_back;

@end
