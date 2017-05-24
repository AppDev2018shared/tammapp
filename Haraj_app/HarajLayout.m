//
//  HarajLayout.m
//  Haraj_app
//
//  Created by Spiel on 04/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "HarajLayout.h"

@implementation HarajLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
}

- (void)setup
{
    self.sectionInset = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    self.itemSize = CGSizeMake(245.0f, 45.0f);
    self.minimumLineSpacing = 10.0f;
    self.minimumInteritemSpacing = 20.0f;
}

- (CGSize)collectionViewContentSize
{
    CGFloat collectionViewWidth = 550;
    CGFloat topMargin = 10;
    CGFloat bottomMargin = 10;
    CGFloat collectionViewHeight = (self.cellCount * (self.itemSize.height +
                                                      self.minimumLineSpacing*2)) + topMargin + bottomMargin;
    
    //THIS RETURNS A VALID, REASONABLE SIZE, but the collection view frame never gets set with it!
    return CGSizeMake(collectionViewWidth, collectionViewHeight);
}

@end
