//
//  HarajLayout.h
//  Haraj_app
//
//  Created by Spiel on 04/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HarajLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) NSInteger cellCount;
@property (nonatomic) UIEdgeInsets sectionInset;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@end
