//
//  WSCollectionCell.m
//  瀑布流
//
//  Created by iMac on 16/12/26.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "WSCollectionCell.h"
#import "UIImageView+WebCache.h"

@implementation WSCollectionCell




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatSubView];
        
    }
    return self;
}

- (void)creatSubView {
    
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.tag = 10;
    [self addSubview:imgV];
    
    
    UIVisualEffectView *visulEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//    UIVisualEffectView *visulEffectView = [[UIVisualEffectView alloc]init];
//    visulEffectView.backgroundColor = [UIColor whiteColor];
    visulEffectView.tag = 20;
    [self addSubview:visulEffectView];
    
    UILabel *label = [[UILabel alloc]init];
    label.tag = 30;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [visulEffectView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.tag = 40;
    label1.font = [UIFont systemFontOfSize:10];
    label1.textColor = [UIColor greenColor];
    label1.textAlignment = NSTextAlignmentLeft;
    [visulEffectView addSubview:label1];
    
    UIImageView * bidImage = [[UIImageView alloc]init];
    bidImage.tag = 50;
    bidImage.backgroundColor = [UIColor grayColor];
    [visulEffectView addSubview:bidImage];
    
    UIImageView * timeImage = [[UIImageView alloc]init];
    timeImage.tag = 60;
    timeImage.backgroundColor = [UIColor grayColor];
    [visulEffectView addSubview:timeImage];
    
    UILabel *bidAmountLabel = [[UILabel alloc]init];
    bidAmountLabel.tag = 51;
    bidAmountLabel.font = [UIFont systemFontOfSize:10];
    bidAmountLabel.textColor = [UIColor blackColor];
    bidAmountLabel.textAlignment = NSTextAlignmentCenter;
    [visulEffectView addSubview:bidAmountLabel];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.tag = 61;
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [visulEffectView addSubview:timeLabel];

}


-(void)setModel:(CellModel *)model {
    _model = model;
    UIImageView *imgV = (UIImageView *)[self viewWithTag:10];
    UIVisualEffectView *visulEffectView = (UIVisualEffectView *)[self viewWithTag:20];
    UILabel *label = (UILabel *)[self viewWithTag:30];
    
    //-------------------------uday------------------------------------------------------
    
    UILabel *label1 = (UILabel *)[self viewWithTag:40];
    UIImageView *bidImage = (UIImageView *)[self viewWithTag:50];
    UILabel *bidAmountLabel = (UILabel *)[self viewWithTag:51];
    
    UIImageView *timeImage = (UIImageView *)[self viewWithTag:60];
    UILabel *timeLabel = (UILabel *)[self viewWithTag:61];
    
    imgV.frame = self.bounds;
    visulEffectView.frame = CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 100);//16
    label.frame = CGRectMake(0, 45, CGRectGetWidth(visulEffectView.frame), 10);//3
    label1.frame = CGRectMake(0, 3, CGRectGetWidth(visulEffectView.frame), 10);

    bidImage.frame = CGRectMake( CGRectGetWidth(visulEffectView.frame)-22, 3, 20, 20);
    bidAmountLabel.frame = CGRectMake( CGRectGetWidth(visulEffectView.frame)-42, 22,40, 20);

    
    timeImage.frame = CGRectMake( CGRectGetWidth(visulEffectView.frame)/2 - 10, 3, 20, 20);
    timeLabel.frame = CGRectMake( CGRectGetWidth(visulEffectView.frame)/2 - 15, 22, 30, 20);

    
    
    
    
    
    [imgV sd_setImageWithURL:[NSURL URLWithString:_model.imgURL]];
    label.text = _model.title;
    label1.text = @"Jeedah";
    timeLabel.text = @"23:00";
    bidAmountLabel.text = @"$20000";

    
}

@end
