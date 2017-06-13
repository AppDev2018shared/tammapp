//
//  AllViewSwapeViewController.h
//  Haraj_app
//
//  Created by Spiel's Macmini on 6/12/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllViewSwapeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) NSMutableArray * Array_Alldata;

@property (nonatomic,assign) NSInteger tuchedIndex;
@end
