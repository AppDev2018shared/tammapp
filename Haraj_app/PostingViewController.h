//
//  PostingViewController.h
//  Haraj_app
//
//  Created by Spiel on 16/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SDAVAssetExportSession.h"
#import <AVFoundation/AVFoundation.h>
#import "Base64.h"
#import "ProductDetailCellCar.h"
#import "ProductDetailCellProperty.h"
#import "MoreDetailCell.h"
#import "AddImageCell.h"
#import "ProductDetailCell.h"



@interface PostingViewController : UIViewController
{
    UIView *transparentView1;
}


@property (nonatomic,retain)NSString *name;

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate;
@property (weak, nonatomic) IBOutlet UIView *NavigationView;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UIButton *backButton;
-(IBAction)OnClick_btn:(id)sender;
-(IBAction)ChangeLocations:(id)sender;

@property (strong,nonatomic)ProductDetailCellCar * Cell_DetailCar;
@property (strong,nonatomic)ProductDetailCellProperty * Cell_DetailProperty;
@property (strong,nonatomic)MoreDetailCell * moreCell;
@property (strong,nonatomic)AddImageCell *imageCell;
@property (strong,nonatomic)ProductDetailCell *detailCell;

@end
