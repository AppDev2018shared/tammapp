//
//  MoreImageScrollViewController.h
//  Haraj_app
//
//  Created by Spiel's Macmini on 6/14/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreImageScrollViewController : UIViewController
@property(nonatomic,strong)IBOutlet UIScrollView * scrollview;
@property(nonatomic,strong)IBOutlet UIImageView * images_Scroll;
@property(nonatomic,strong)IBOutlet UIPageControl * pagecontrol_index;
@property(nonatomic,strong)IBOutlet UIButton * Button_Threedots;
@property(nonatomic,strong)IBOutlet UIButton * Button_Favourite;
@property(nonatomic,strong)IBOutlet UIButton * Button_Back;
-(IBAction)Button_BackAction:(id)sender;
-(IBAction)Button_ThreedotsAction:(id)sender;
-(IBAction)Button_FavouriteAction:(id)sender;
@end
