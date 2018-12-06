//
//  PostingViewController.m
//  Haraj_app
//
//  Created by Spiel on 16/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "PostingViewController.h"
#import "AddImageCell.h"
#import "ProductDetailCell.h"
#import "ProductDetailCellCar.h"
#import "ProductDetailCellProperty.h"
#import "MoreDetailCell.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "UIView+RNActivityView.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CoreLocation.h>
#import "BoostPost.h"
#import "UIViewController+KeyboardAnimation.h"


@interface PostingViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
{
   // MoreDetailCell *moreCell;
//    AddImageCell *imageCell;
//    ProductDetailCell *detailCell;
    NSUserDefaults * defaults;
    UIImage *chosenImage ;
    UIImageView *imageView,*Image_View;
    UIImagePickerController *imagePicker, *cameraUI, *pcker1;
    NSInteger count,imageCount,x,indexCount_image;
    NSMutableArray *imageArray, *array_MediaTypes, *array_VideoUrl,*ImageId,*Array_ImageMediaId,*Array_ImagesMediaIndex,*Array_RemoveImages;
    // NSMutableArray *imageArray, *array_MediaTypes, *array_VideoUrl,* Array_mediaTypeId, ;
    UILabel *hashPlaceholder,*morePlaceholder,*Label_confirm1,*sellingPlaceholder1,*sellingPlaceholder2,*sellingPlaceholder3;
    
    UIView * transperentViewIndicator,*whiteView1,* transperentViewIndicator11,*whiteView111;
    UIActivityIndicatorView *indicatorAlert;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_Create, *Connection_Media;
    NSMutableData *webData_Create, *webData_Media;
    NSMutableArray *Array_Create, *Array_Media,*Array_RemovePicture;
    NSString * locationName, *cellloop;
    NSString *postIDValue ,*mediaTypeVal,* ImageNSdata,*ImageNSdataThumb, *encodedImage, *encodedImageThumb, *mediaIdStr, *imageTag, *removeIndexCount, *propertyType;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    UIImage *FrameImage;
    NSNumber *Vedio_Height,*Vedio_Width;
    NSData *imageData,*imageDataThumb;
    MPMoviePlayerViewController *movieController ;
    
    UILabel *KMlabel, *Sqmlabel;
    
    int i;
    
    CGFloat Tablevie_height;
  
    CLPlacemark *placemark;
    BOOL location;
    NSString *TEXT,*Str_TxtField_Flag;
    
    BoostPost *myBoostXIBViewObj;
    NSString *boostpackVal,*boostAmountVal, *postIdVal;
    NSMutableArray *Array_Boost;
    
    
    NSArray *pickerArray;
    UIPickerView *carPickerView;
    UIToolbar *toolBar;
    
    UIBarButtonItem *doneButton;
    NSInteger myLastPressed;


    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PostingViewController
@synthesize nameLabel,Cell_DetailCar,Cell_DetailProperty,backButton,moreCell,imageCell,detailCell,NavigationView;

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.view.frame.size.width==375 && self.view.frame.size.height==812)
    {
        
        
         [NavigationView setFrame:CGRectMake(NavigationView.frame.origin.x, NavigationView.frame.origin.y, NavigationView.frame.size.width,80)];
        
        [nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y+20, nameLabel.frame.size.width, 31)];
        
        [backButton setFrame:CGRectMake(backButton.frame.origin.x+2, backButton.frame.origin.y+23, backButton.frame.size.width-8, 31)];
        
        [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y+40, _tableView.frame.size.width,_tableView.frame.size.height-40)];
        
    }
   indexCount_image = 0;
    imageCount = 0;
    count = 0;
    imageArray = [[NSMutableArray alloc]init];
    array_MediaTypes = [[NSMutableArray alloc]init];
    array_VideoUrl = [[NSMutableArray alloc]init];
    Array_RemoveImages=[[NSMutableArray alloc]init];
    Array_ImageMediaId=[[NSMutableArray alloc]init];
    Array_ImagesMediaIndex=[[NSMutableArray alloc]init];
    Tablevie_height=self.tableView.frame.size.height;
   ImageId = [[NSMutableArray alloc]init];

    Image_View = [[UIImageView alloc]init];
    pcker1=[[UIImagePickerController alloc]init];
    pcker1.delegate = self;
    
    defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:@"NO" forKey:@"CallPressed"];
    
    [defaults setObject:@"1" forKey:@"slival"];
    [defaults synchronize];

    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    
   // NSString *nameStr = [NSString stringWithFormat:@"POST YOUR %@",self.name];

    
   
    
   // nameLabel.text = [NSString stringWithFormat:@"Post your %@",self.name];
    nameLabel.text = [NSString stringWithFormat:@"عرض %@",self.name];
    NSLog(@"abc = %@",nameLabel.text);
    
    nameLabel.font = [UIFont fontWithName:@"Cairo-Bold" size:26];
    nameLabel.textColor = [UIColor whiteColor];
   
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(tap:)];
    [self.tableView addGestureRecognizer: tapRec];
    
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
  //---------------------------POST ID Creating ---------------------------------------------------------------
    
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [[NSMutableString alloc]init];
    for (int i=0; i<3; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    NSLog(@" Random String=%@",randomString);
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    
    [NSLocale availableLocaleIdentifiers];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                        [dateFormatter setLocale:locale];
    
    
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@" date=%@",[dateFormatter stringFromDate:[NSDate date]]);
    postIDValue = [NSString stringWithFormat:@"P%@%@",[dateFormatter stringFromDate:[NSDate date]],randomString];
    NSLog(@"postIDValue %@",postIDValue);
    

   
    
    transperentViewIndicator=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transperentViewIndicator.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    whiteView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 110,110)];
    whiteView1.center=transperentViewIndicator.center;
    [whiteView1 setBackgroundColor:[UIColor blackColor]];
    whiteView1.layer.cornerRadius=9;
    indicatorAlert = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorAlert.frame=CGRectMake((whiteView1.frame.size.width/2)-10, (whiteView1.frame.size.height/2)-15, 20, 20);
    [indicatorAlert startAnimating];
    [indicatorAlert setColor:[UIColor whiteColor]];
    
    Label_confirm1=[[UILabel alloc]initWithFrame:CGRectMake(0,(indicatorAlert.frame.size.height+indicatorAlert.frame.origin.y)+5, whiteView1.frame.size.width, 40)];
    
    
    Label_confirm1.text=@"Preparing...";
    Label_confirm1.font=[UIFont fontWithName:@"Cairo-Bold" size:16.0];
    Label_confirm1.textColor=[UIColor whiteColor];
    Label_confirm1.textAlignment=NSTextAlignmentCenter;
    
    
    [whiteView1 addSubview:indicatorAlert];
    
    [whiteView1 addSubview:Label_confirm1];
    
    [transperentViewIndicator addSubview:whiteView1];
    
     transperentViewIndicator11.hidden=YES;
    
    
    NSLocale *abc =[NSLocale currentLocale];
    NSString * xyz = [abc objectForKey:NSLocaleCountryCode];
    NSLog(@" country code%@",xyz);
    
    NSString * xyz1 = [abc displayNameForKey:NSLocaleCountryCode value:xyz];
    NSLog(@" country name %@",xyz1);
    
    float sellingx,hashx;
    
    if ([[UIScreen mainScreen]bounds].size.width == 320)
    {
        sellingx =85.0;
        hashx = 75.0;
        
        [moreCell.morePlaceholder setFrame:CGRectMake(moreCell.morePlaceholder.frame.origin.x, 65, moreCell.morePlaceholder.frame.size.width, moreCell.morePlaceholder.frame.size.height)];
        
    }
    else if([[UIScreen mainScreen]bounds].size.width == 414)
    {
        sellingx = 185.0;
        
    }
    
    else
    {
        sellingx = 140.0;
        hashx = 120.0;
        
        
    }
    
    if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        [backButton setFrame:CGRectMake(358, 17, 40,34)];
        
    }
    
    
    sellingPlaceholder1 = [[UILabel alloc]initWithFrame:(CGRectMake(sellingx, 42, 200, 21))];
    sellingPlaceholder2 = [[UILabel alloc]initWithFrame:(CGRectMake(sellingx, 42, 200, 21))];
    sellingPlaceholder3 = [[UILabel alloc]initWithFrame:(CGRectMake(sellingx, 42, 200, 21))];
    hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(hashx, 35, 225, 21))];
    
    
    
    propertyType = @"RENT";
    [Cell_DetailProperty.rentButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    [Cell_DetailProperty.rentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Cell_DetailProperty.rentButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:28];
    
    [Cell_DetailProperty.saleButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Cell_DetailProperty.saleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Cell_DetailProperty.saleButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:22];

Str_TxtField_Flag=@"no";
    
    
    
//-----------------------------------Keyboard Notification--------------------------------------------
    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
 
    
}

-(void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithTitle:@""
                            style:UIBarButtonItemStylePlain
                            target:self
                            action:@selector(OnClick_btn:)];
    [btn setImage:[UIImage imageNamed:@"Whitearrow"]];
    
    btn.tintColor= [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btn;
    
[self subscribeToKeyboard];
}

-(void)tap:(UITapGestureRecognizer *)tapRec
{
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
    
 [self.tableView setFrame:CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width,Tablevie_height)];
    
    [[self view] endEditing: YES];
    
}

-(void)galleryButtonPressed:(id)sender
{
    
    mediaTypeVal = @"IMAGE";
    NSLog(@"galleryButtonPressed Pressed");

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        picker.allowsEditing = NO;
        [self presentViewController:picker animated:true completion:nil];
    }
}

-(void)videoButtonPressed:(id)sender
{
    
    mediaTypeVal = @"VIDEO";
    NSLog(@"videoButtonPressed Pressed");
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
    
}
-(void)cameraButtonPressed:(id)sender
{
    
    
    mediaTypeVal = @"IMAGE";
    NSLog(@"cameraButtonPressed Pressed");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:true completion:nil];
    }
    
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    // UIImage *flippedImage = [UIImage imageWithCGImage:picture.CGImage scale:picture.scale orientation:UIImageOrientationLeftMirrored];
    
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    // Displays a control that allows the user to choose movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    cameraUI.videoQuality = UIImagePickerControllerQualityType640x480;
    
    cameraUI.showsCameraControls = YES;
    cameraUI.videoMaximumDuration = 15.0f;
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    //    self.videoTimer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
    //    remainingCounts = 60;
    
    [controller presentModalViewController: cameraUI animated: YES];
    
    return YES;
}








-(IBAction)OnClick_btn:(id)sender
{
    if ([[defaults valueForKey:@"PlusButtonPressed"] isEqualToString:@"profilepost"])
    {
        [defaults setObject:@"" forKey:@"PlusButtonPressed"];
        [self communication_cancelPost];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popViewControllerAnimated:YES];
        

    }
    else
    {
        
        [self communication_cancelPost];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popToRootViewControllerAnimated:YES];

        
    }
    
    
}
-(void)communication_cancelPost
{
  
    
    NSString *postid= @"postid";

    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@",postid,postIDValue,userid,useridVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"cancelpost"];;
    url =[NSURL URLWithString:urlStrLivecount];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];//Web API Method
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         
                                         if(data)
                                         {
                                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                             NSInteger statusCode = httpResponse.statusCode;
                                             if(statusCode == 200)
                                             {
                                                 
                                                
                                                                                               
                                             }
                                             
                                             
                                             else
                                             {
                                                 NSLog(@" error login1 ---%ld",(long)statusCode);
                                                 
                                             }
                                             
                                             
                                         }
                                         else if(error)
                                         {
                                             
                                             NSLog(@"error login2.......%@",error.description);
                                         }
                                         
                                         
                                     }];
    [dataTask resume];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
   self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
    
    [super viewWillDisappear:true];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardDidShowNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:UIKeyboardWillHideNotification
//                                                  object:nil];
     [self an_unsubscribeKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource and Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else if (section == 2)
    {
        return 1;
    }
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_ImageCell = @"ImageCell";
    static NSString *cell_detailcar=@"CellCar";
    static NSString *cell_detailproperty=@"CellProperty";
    static NSString *cell_detail=@"ProductCell";
    static NSString *cell_more=@"MoreCell";
    

    
    
    switch (indexPath.section)
    {
        case 0:
        {
            imageCell = [tableView dequeueReusableCellWithIdentifier:cell_ImageCell];
            if (imageCell == nil)
            {
               // imageCell = [tableView dequeueReusableCellWithIdentifier:cell_ImageCell];
                imageCell = [[AddImageCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_ImageCell];
                
            }
            
            
            
            [imageCell.galleryButton  addTarget:self action:@selector(galleryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [imageCell.videoButton  addTarget:self action:@selector(videoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [imageCell.cameraButton  addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect workingFrame =  imageCell.scrollView.frame;
            workingFrame.origin.x = 0;
             x = (imageArray.count *110) - 100;
            [imageCell.scrollView setContentOffset:CGPointMake((imageArray.count *110)-375, 0)];
            [imageCell.scrollView setContentSize:CGSizeMake((imageArray.count *110), workingFrame.size.height)];
            if(x<=339)
            {
                x=imageCell.scrollView.frame.size.width-110;
                [imageCell.scrollView setContentOffset:CGPointMake((3 *100)-375, 0)];
                [imageCell.scrollView setContentSize:CGSizeMake((3 *100), workingFrame.size.height)];
            }
           
            
            [imageCell.scrollView setPagingEnabled:YES];
          
            
            if (imageArray.count>3)
            {
                imageCell.scrollView.scrollEnabled = YES;
            }
            else
            {
                imageCell.scrollView.scrollEnabled = NO;
            }
            for(UIImageView* view in imageCell.scrollView.subviews)
            {
                
                [view removeFromSuperview];
                
            }

            
            for (i=0; i<imageArray.count; i++)
                
            {
                
                NSString * Str_booleanVal=@"no";
                imageView=[[UIImageView alloc]init];
                imageView.frame=CGRectMake(x,0, 100, imageCell.scrollView.frame.size.height);
                [imageView setTag:[[ImageId objectAtIndex:i]integerValue]];
                imageView.userInteractionEnabled=YES;
                imageView.image=[imageArray objectAtIndex:i];
                
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.clipsToBounds = YES;
                
                

                
                UIImageView *playButton = [[UIImageView alloc]initWithFrame:CGRectMake((imageView.frame.size.width / 2) - 20, (imageView.frame.size.height / 2) - 20, 40, 40)];
                playButton.backgroundColor = [UIColor clearColor];
                [playButton setImage:[UIImage imageNamed:@"Play"]];

                playButton.tag = i;
                [imageView addSubview:playButton];
                
              
                
                
                [imageCell.scrollView addSubview:imageView];
                [imageCell.contentView bringSubviewToFront:imageView];
                if ([[array_MediaTypes objectAtIndex:i] isEqualToString:@"VIDEO"])
                {
                    playButton.hidden = NO;
                }
                else
                {
                    playButton.hidden = YES;
                    
                }
                
                
                
               
                for (int j = 0; j < Array_ImagesMediaIndex.count; j++)
                   {
                       if ([[ImageId objectAtIndex:i] isEqualToString:[Array_ImagesMediaIndex objectAtIndex:j]])
                       {
                         Str_booleanVal=@"yes";
                           break;
                       }
                                               
                                               
                     }
                if ([Str_booleanVal isEqualToString:@"yes"])
                {
                     imageView.alpha = 1;
                    
        UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                            action:@selector(ImageTapped:)];
            [imageView addGestureRecognizer:ImageTap];
           UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapped:)];
        [playButton addGestureRecognizer:ImageTap1];
                    
                    
                    
                }
                else
                {
                    
        UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
        action:@selector(ImageTappedRemove:)];
    [imageView addGestureRecognizer:ImageTap];
                    
    UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self
    action:@selector(ImageTappedRemove:)];
    [playButton addGestureRecognizer:ImageTap1];
                     imageView.alpha = 0.5;
                }
                
                
          
                x -= 110;

            }
            x=0;
           
          return imageCell;
            
        }
            break;
        case 1:
            
            
            if ([self.name isEqualToString:@"سيارات"])//car
            {
                
                
                
                {
                    
                    
                    Cell_DetailCar = [tableView dequeueReusableCellWithIdentifier:cell_detailcar];
                    
                    if (Cell_DetailCar == nil)
                    {
                        
                        Cell_DetailCar = [[[NSBundle mainBundle]loadNibNamed:@"ProductDetailCellCar" owner:self options:nil] objectAtIndex:0];
                    }
                    
                    Cell_DetailCar.profileImageView.layer.cornerRadius = Cell_DetailCar.profileImageView.frame.size.height / 2;
                    Cell_DetailCar.profileImageView.clipsToBounds = YES;
                    
                    NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
                    
                    [Cell_DetailCar.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
                    
                    Cell_DetailCar.usernameLabel.text = [defaults valueForKey:@"UserName"];
                    
                    NSString *locationstr = [NSString stringWithFormat:@"%@, %@",[defaults valueForKey:@"Cityname"],[defaults valueForKey:@"Countryname"]];
                    
                    
                    Cell_DetailCar.locationLabel.text = locationstr;
                    
                    [Cell_DetailCar.locationChangeButton addTarget:self action:@selector(ChangeLocations:) forControlEvents:UIControlEventTouchUpInside];
                    
                    Cell_DetailCar.DownArrowImageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer * DownImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(DownArrowImageTapped:)];
                    [Cell_DetailCar.DownArrowImageView addGestureRecognizer:DownImageTap];
                    
                    
                    if ([Cell_DetailCar.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailCar.sellingTextview.text isEqualToString:@""] )//What are you selling?
                    {
                        Cell_DetailCar.sellingTextview.text = @"ماذا ترغب في البيع؟";//what are you selling
                        Cell_DetailCar.sellingTextview.textColor = [UIColor blackColor];
                        sellingPlaceholder1.hidden = NO;
                        
                        moreCell.createButton.enabled = NO;
                        moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                    }
                    
                    [Cell_DetailCar.carMakeTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    [Cell_DetailCar.modelTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    [Cell_DetailCar.mileageTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    
                  
                    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                    Cell_DetailCar.carMakeTextField.inputView = dummyView;
                    


                    
                    [Cell_DetailCar.sellingTextview setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
      //            sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
                    sellingPlaceholder1.text = @"هذا عنوان إعلانك";//@"This is your post headline";
                    sellingPlaceholder1.font = [UIFont fontWithName:@"Cairo-Bold" size:17];
                    sellingPlaceholder1.textColor = [UIColor lightGrayColor];
                    sellingPlaceholder1.textAlignment = NSTextAlignmentRight;
                    [Cell_DetailCar.sellingTextview addSubview:sellingPlaceholder1];
                    [Cell_DetailCar.contentView bringSubviewToFront:sellingPlaceholder1];
                   
                    
                    Cell_DetailCar.hashTextView.delegate=self;
                    
                    if ([Cell_DetailCar.hashTextView.text isEqualToString:@"Add some #Hashtags"] || [Cell_DetailCar.hashTextView.text isEqualToString:@""] )
                    {
                        
                        
                        Cell_DetailCar.hashTextView.text = @"Add some #Hashtags";
                        Cell_DetailCar.hashTextView.textColor = [UIColor blackColor];
                    }
                    Cell_DetailCar.sellingTextview.tag = 2;
                    [Cell_DetailCar.hashTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
                    //           hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
                    hashPlaceholder.text = @"i.e. #retro#car#gold#classic";
                    hashPlaceholder.textColor = [UIColor lightGrayColor];
                    hashPlaceholder.textAlignment = NSTextAlignmentRight;
                    [Cell_DetailCar.hashTextView addSubview:hashPlaceholder];
                    [Cell_DetailCar.contentView bringSubviewToFront:hashPlaceholder];
                    
                    
                    return Cell_DetailCar;
                }
                
            }
            
            
            if ([self.name isEqualToString:@"عقار"])//property
            {
                
                
                {
                    
                    Cell_DetailProperty = [tableView dequeueReusableCellWithIdentifier:cell_detailproperty];
                    
                    if (Cell_DetailProperty == nil)
                    {
                        
                        Cell_DetailProperty = [[[NSBundle mainBundle]loadNibNamed:@"ProductDetailCellProperty" owner:self options:nil] objectAtIndex:0];
                    }
                    
//                    Cell_DetailProperty = [[[NSBundle mainBundle]loadNibNamed:@"ProductDetailCellProperty" owner:self options:nil] objectAtIndex:0];
//                
//                    
//                    if (Cell_DetailProperty == nil)
//                    {
//                        
//                        Cell_DetailProperty = [[ProductDetailCellProperty alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_detailproperty];
//                    }
                    
                    
                    Cell_DetailProperty.profileImageView.layer.cornerRadius = Cell_DetailProperty.profileImageView.frame.size.height / 2;
                    Cell_DetailProperty.profileImageView.clipsToBounds = YES;
                    
                    NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
                    
                    [Cell_DetailProperty.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
                    
                    Cell_DetailProperty.usernameLabel.text = [defaults valueForKey:@"UserName"];
                    
                    NSString *locationstr = [NSString stringWithFormat:@"%@, %@",[defaults valueForKey:@"Cityname"],[defaults valueForKey:@"Countryname"]];
                    
                    
                    Cell_DetailProperty.locationLabel.text = locationstr;
                    [Cell_DetailProperty.locationChangeButton addTarget:self action:@selector(ChangeLocations:) forControlEvents:UIControlEventTouchUpInside];
    
                    
                    if ([Cell_DetailProperty.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailProperty.sellingTextview.text isEqualToString:@""] )//What are you selling?
                    {
                        Cell_DetailProperty.sellingTextview.text = @"ماذا ترغب في البيع؟";//what are you selling?
                        Cell_DetailProperty.sellingTextview.textColor = [UIColor blackColor];
                        sellingPlaceholder2.hidden = NO;
                        
                        moreCell.createButton.enabled = NO;
                        moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                    }
                    
                    
                    [Cell_DetailProperty.sellingTextview setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
                    //            sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
                    sellingPlaceholder2.text = @"هذا عنوان إعلانك";//@"This is your post headline";
                    sellingPlaceholder2.font = [UIFont fontWithName:@"Cairo-Bold" size:17];
                    sellingPlaceholder2.textColor = [UIColor lightGrayColor];
                    sellingPlaceholder2.textAlignment = NSTextAlignmentRight;
                    [Cell_DetailProperty.sellingTextview addSubview:sellingPlaceholder2];
                    [Cell_DetailProperty.contentView bringSubviewToFront:sellingPlaceholder2];
                    
                    
                    Cell_DetailProperty.hashTextView.delegate=self;
                    
                    if ([Cell_DetailProperty.hashTextView.text isEqualToString:@"Add some #Hashtags"] || [Cell_DetailCar.hashTextView.text isEqualToString:@""] )
                    {
                        
                        
                        Cell_DetailProperty.hashTextView.text = @"Add some #Hashtags";
                        Cell_DetailProperty.hashTextView.textColor = [UIColor blackColor];
                    }
                    Cell_DetailProperty.sellingTextview.tag = 2;
                    [Cell_DetailProperty.hashTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
       //           hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
                    hashPlaceholder.text = @"i.e. #retro#car#gold#classic";
                    hashPlaceholder.textColor = [UIColor lightGrayColor];
                    hashPlaceholder.textAlignment = NSTextAlignmentRight;
                    [Cell_DetailProperty.hashTextView addSubview:hashPlaceholder];
                    [Cell_DetailProperty.contentView bringSubviewToFront:hashPlaceholder];
                    
                    [Cell_DetailProperty.rentButton  addTarget:self action:@selector(rentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [Cell_DetailProperty.saleButton  addTarget:self action:@selector(saleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    
                    Cell_DetailProperty.propertySizeTextField.delegate = self;
                    Cell_DetailProperty.noOfBedroomTextField.delegate = self;
                    
                    [Cell_DetailProperty .propertySizeTextField bringSubviewToFront:Cell_DetailProperty];
                    
                    
                    [Cell_DetailProperty.propertySizeTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    [Cell_DetailProperty.noOfBedroomTextField addTarget:self action:@selector(textField_Action:) forControlEvents:UIControlEventEditingChanged];
                    
                    
                    return Cell_DetailProperty;
                }
            }
            
            else
            {
                
                {
                    detailCell = [tableView dequeueReusableCellWithIdentifier:cell_detail];
                    if (detailCell == nil)
                    {
                       // detailCell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
                        detailCell = [[ProductDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_detail];

                    }
                    
                    
                    detailCell.profileImageView.layer.cornerRadius = detailCell.profileImageView.frame.size.height / 2;
                    detailCell.profileImageView.clipsToBounds = YES;
                    
                    NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
                    
                    [detailCell.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"]];
                    
                    detailCell.usernameLabel.text = [defaults valueForKey:@"name"];
                    
                    NSString *locationstr = [NSString stringWithFormat:@"%@, %@",[defaults valueForKey:@"Cityname"],[defaults valueForKey:@"Countryname"]];
                    
                    
                    detailCell.locationLabel.text = locationstr;
                    [detailCell.locationChangeButton addTarget:self action:@selector(ChangeLocations:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([detailCell.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [detailCell.sellingTextview.text isEqualToString:@""] )//What are you selling?
                    {
                        detailCell.sellingTextview.text = @"ماذا ترغب في البيع؟";//What are you selling?
                        detailCell.sellingTextview.textColor = [UIColor blackColor];
                        sellingPlaceholder3.hidden = NO;
                        
                        moreCell.createButton.enabled = NO;
                        moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
                    }
                    
                    
                    [detailCell.sellingTextview setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
      //            sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
                    sellingPlaceholder3.text = @"هذا عنوان إعلانك";//@"This is your post headline";
                    sellingPlaceholder3.font = [UIFont fontWithName:@"Cairo-Bold" size:17];
                    sellingPlaceholder3.textColor = [UIColor lightGrayColor];
                    sellingPlaceholder3.textAlignment = NSTextAlignmentRight;
                    [detailCell.sellingTextview addSubview:sellingPlaceholder3];
                    [detailCell.contentView bringSubviewToFront:sellingPlaceholder3];
                    
                    
                    detailCell.hashTextView.delegate=self;
                    
                    if ([detailCell.hashTextView.text isEqualToString:@"Add some #Hashtags"] || [detailCell.hashTextView.text isEqualToString:@""] )
                    {
                        
                        
                        detailCell.hashTextView.text = @"Add some #Hashtags";
                        detailCell.hashTextView.textColor = [UIColor blackColor];
                    }
                    detailCell.sellingTextview.tag = 2;
                    [detailCell.hashTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
                    
       //           hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
                    hashPlaceholder.text = @"i.e. #retro#car#gold#classic";
                    hashPlaceholder.textColor = [UIColor lightGrayColor];
                    hashPlaceholder.textAlignment = NSTextAlignmentRight;
                    [detailCell.hashTextView addSubview:hashPlaceholder];
                    [detailCell.contentView bringSubviewToFront:hashPlaceholder];
                    
                    
                    return detailCell;
                    
                }
            }
            break;
            
        case 2:
        {
            moreCell = [tableView dequeueReusableCellWithIdentifier:cell_more];
            
            if (moreCell == nil)
            {
                //moreCell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
                 moreCell = [[MoreDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_more];

            }
            
            if ([self.name isEqualToString:@"سيارات"])//car
            {
                
            }
            else  if ([self.name isEqualToString:@"عقار"])//property
            {
                moreCell.morePlaceholder.text = @"مثل: مساحته، عدد الغرف، مسبح، حديقة مجاورة، الخ.";
                
            }
            else  if ([self.name isEqualToString:@"إلكترونيات"])//electronics
            {
                moreCell.morePlaceholder.text = @"مثل: موديله، ضمان متوفر من الوكيل، الخ.";
            }
            else  if ([self.name isEqualToString:@"حيوانات أليفة"])//pets
            {
                moreCell.morePlaceholder.text = @"مثل: اصله، شهادة تطعيم، الخ.";
            }
            else  if ([self.name isEqualToString:@"أثاث"])//furniture
            {
                moreCell.morePlaceholder.text = @"مثل: جديد، لونه، قماشه، الخ.";
            }
            else  if ([self.name isEqualToString:@"خدمات"])//services
            {
                moreCell.morePlaceholder.text = @"مثل: شرح وافي للخدمة المطلوبة.";
            }
            else  if ([self.name isEqualToString:@"أخرى"])//others
            {
                moreCell.morePlaceholder.text = @"مثل: شرح وافي للمنتج او الخدمة المعروضة.";
            }
            

            
            
            
            
//            moreCell.currentDays_Label.text =[NSString stringWithFormat:@"%.f",moreCell.slider.value];
//
//            moreCell.slider.maximumValue = 30;
//            moreCell.slider.minimumValue = 1;
//            moreCell.slider.continuous = TRUE;
//            [moreCell.slider  addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
//            moreCell.slider.tag = 1;
            
            moreCell.moreTextView.delegate =self;
            
            if ([moreCell.moreTextView.text isEqualToString:@"أخبرنا أكثر عن منتجك"] || [moreCell.moreTextView.text isEqualToString:@""] )//Tell us more about the product
            {
                

            moreCell.moreTextView.text = @"أخبرنا أكثر عن منتجك";//@"Tell us more about the product";
            moreCell.moreTextView.textColor = [UIColor blackColor];
            }
            
            
            
            if ([[UIScreen mainScreen]bounds].size.width == 320)
            {
                [moreCell.morePlaceholder setFrame:CGRectMake(moreCell.morePlaceholder.frame.origin.x - 5, 65, moreCell.morePlaceholder.frame.size.width, moreCell.morePlaceholder.frame.size.height)];
            }
            else
            {
                
            }
            //[detailCell.hashTextView setAutocorrectionType:UITextAutocorrectionTypeNo];

            [moreCell.createButton  addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [moreCell.callButton  addTarget:self action:@selector(callButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
           
            
           
            
            
            return moreCell;
        }
            break;
            
    }
    return nil;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 271;
    }
    else if (indexPath.section == 1)
    {
        
        if ([self.name isEqualToString:@"سيارات"])//car
        {
            return 311;//378;
        }
        else  if ([self.name isEqualToString:@"عقار"])//property
        {
            return 364;//422;
        }
        else
        {
            return 196;//253;
        }
    }
    else if (indexPath.section == 2)
    {
        return 366;
    }
    
    
    return 0;
    
}


-(void)textField_Action:(id)sender
{
    if ([self.name isEqualToString:@"سيارات"])//car
    {
        if (([Cell_DetailCar.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailCar.sellingTextview.text isEqualToString:@""]) || Cell_DetailCar.mileageTextField.text.length ==0 || Cell_DetailCar.modelTextField.text.length ==0 || Cell_DetailCar.carMakeTextField.text.length ==0 )
        {
            
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
            
            
            
            
        }

//        if (Cell_DetailCar.modelTextField.text.length == 0 || Cell_DetailCar.mileageTextField.text.length == 0)
//            
//        {
//            
//            moreCell.createButton.enabled = NO;
//            moreCell .createButton.backgroundColor = [UIColor lightGrayColor];
//            
//            
//        }
//        else
//        {
//            moreCell.createButton.enabled =YES;
//            moreCell .createButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
//            
//        }
//        
        
        
    }
    
    else if ([self.name isEqualToString:@"عقار"])//property
    {
        if (([Cell_DetailProperty.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailProperty.sellingTextview.text isEqualToString:@""]) || Cell_DetailProperty.propertySizeTextField.text.length ==0 || Cell_DetailProperty.noOfBedroomTextField.text.length ==0 )
        {
            
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
            
            
        }

        
    }
    
}


-(void)rentButtonPressed:(id)sender
{
    
    propertyType = @"RENT";
    [Cell_DetailProperty.rentButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    [Cell_DetailProperty.rentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Cell_DetailProperty.rentButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:22];
    
    [Cell_DetailProperty.saleButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Cell_DetailProperty.saleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Cell_DetailProperty.saleButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:22];

    
}
-(void)saleButtonPressed:(id)sender
{
     propertyType = @"SALE";
    
    [Cell_DetailProperty.saleButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    [Cell_DetailProperty.saleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Cell_DetailProperty.saleButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:22];
    
    
    [Cell_DetailProperty.rentButton setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [Cell_DetailProperty.rentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    Cell_DetailProperty.rentButton.titleLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:22];

}



#pragma mark - UITextView and UITextField Delegates
- (void)textViewDidChange:(UITextView *)textView
{
    
   
    
    
    if ([self.name isEqualToString:@"سيارات"])//car
    {
        if ([textView.text isEqual:Cell_DetailCar.sellingTextview])//What are you selling?
        {
        if ([textView.text isEqualToString:@"ماذا ترغب في البيع؟"] || [textView.text isEqualToString:@""])//What are you selling?
        {
            textView.text = @"";
            sellingPlaceholder1.hidden = NO;
           
            
        }
            
        }
        if ([textView.text isEqual:moreCell.moreTextView])//What are you selling?
        {
            if ([textView.text isEqualToString:@""])
            {
                moreCell.morePlaceholder.hidden=NO;
            }
            else
            {
               moreCell.morePlaceholder.hidden=YES;
            }
            
            
        }
      
        
    if (([Cell_DetailCar.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailCar.sellingTextview.text isEqualToString:@""]) || Cell_DetailCar.mileageTextField.text.length ==0 || Cell_DetailCar.modelTextField.text.length ==0 || Cell_DetailCar.carMakeTextField.text.length ==0 )
        {
          
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
           
            
            
         
        }
        
       
    }
    
    else if([self.name isEqualToString:@"عقار"])//property
    {
        
        
        
    
        if ([textView.text isEqual:Cell_DetailProperty.sellingTextview])//What are you selling?
        {

        
        if ([textView.text isEqualToString:@"ماذا ترغب في البيع؟"] || [textView.text isEqualToString:@""])//What are you selling?
        {
            textView.text = @"";
            sellingPlaceholder2.hidden = NO;
            
            
        }
        
    }
    if ([textView.text isEqual:moreCell.moreTextView])//What are you selling?
    {
        if ([textView.text isEqualToString:@""])
        {
            moreCell.morePlaceholder.hidden=NO;
        }
        else
        {
            moreCell.morePlaceholder.hidden=YES;
        }
        
        
    }
        
       
   
    
    if (([Cell_DetailProperty.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailProperty.sellingTextview.text isEqualToString:@""]) || Cell_DetailProperty.propertySizeTextField.text.length ==0 || Cell_DetailProperty.noOfBedroomTextField.text.length ==0 )
    {
        
        moreCell.createButton.enabled = NO;
        [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    else
    {
        moreCell.createButton.enabled = YES;
        [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        
        
    }
  
    
    
    
    
    
    
    
    
    
    
    
    }
    else
    {
        if ([textView.text isEqual:detailCell.sellingTextview])//What are you selling?
        {
        if ([textView.text isEqualToString:@"ماذا ترغب في البيع؟"] || [textView.text isEqualToString:@""])//What are you selling?
        {
            textView.text = @"";
            sellingPlaceholder3.hidden = NO;
            
            
        }
        
            
            
            
            
        }

        
        if ([detailCell.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [detailCell.sellingTextview.text isEqualToString:@""] )
        {
            
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
            
            
        }
        
        
        
        
    }

    
    
    
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
     Str_TxtField_Flag=@"no";
    carPickerView.hidden=YES;
    
    toolBar.hidden=YES;
    [carPickerView removeFromSuperview];
    if ([self.name isEqualToString:@"سيارات"])//car
    {
        
        carPickerView.hidden=YES;
        toolBar.hidden=YES;
        [carPickerView removeFromSuperview];
        
        
        if ([textView isEqual: Cell_DetailCar.sellingTextview])
        {
            if ([[UIScreen mainScreen]bounds].size.width == 320)
            {
                
                    self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 20);
                    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                // self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y - 40, self.tableView.frame.size.width, self.tableView.frame.size.height);
                
                
            }
            else
            {
                
            }
            
            if ([textView.text isEqualToString:@"ماذا ترغب في البيع؟"] || [textView.text isEqualToString:@""])//What are you selling?
            {
                textView.text = @"";
                sellingPlaceholder1.hidden = YES;
               
               
                
            }
           
            
            
        }
        
        else if ([textView isEqual: Cell_DetailCar.hashTextView])
        {
            if ([textView.text isEqualToString:@"Add some #Hashtags"] )
            {
                textView.text = @"";
                hashPlaceholder.hidden = YES;
                textView.textColor = [UIColor grayColor];
                
                
            }
        }
        
        if (([Cell_DetailCar.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailCar.sellingTextview.text isEqualToString:@""]) || Cell_DetailCar.mileageTextField.text.length ==0 || Cell_DetailCar.modelTextField.text.length ==0 || Cell_DetailCar.carMakeTextField.text.length ==0 )
        {
            
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
            
            
            
            
        }
 
        
    }
    else if ([self.name isEqualToString:@"عقار"])//property
    {
        if ([textView isEqual: Cell_DetailProperty.sellingTextview])
        {
            if ([textView.text isEqualToString:@"ماذا ترغب في البيع؟"] || [textView.text isEqualToString:@""])//What are you selling?
            {
                textView.text = @"";
                sellingPlaceholder2.hidden = YES;
               
                

                
            }
            else
            {
                sellingPlaceholder2.hidden = YES;
              
               
            }
            
            
        }
        
        else if ([textView isEqual: Cell_DetailProperty.hashTextView])
        {
            if ([textView.text isEqualToString:@"Add some #Hashtags"] )
            {
                textView.text = @"";
                hashPlaceholder.hidden = YES;
                textView.textColor = [UIColor grayColor];
            }
        }
        if (([Cell_DetailProperty.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailProperty.sellingTextview.text isEqualToString:@""]) || Cell_DetailProperty.propertySizeTextField.text.length ==0 || Cell_DetailProperty.noOfBedroomTextField.text.length ==0 )
        {
            
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
            
            
        }
 
        
    }
    
    else
    {
        
        
        if ([textView isEqual: detailCell.sellingTextview])
        {
            if ([textView.text isEqualToString:@"ماذا ترغب في البيع؟"] || [textView.text isEqualToString:@""])//What are you selling?
            {
                textView.text = @"";
                sellingPlaceholder3.hidden = YES;
               
                

                
            }
            else
            {
                sellingPlaceholder3.hidden = YES;
               
                

            }
            
            
        }
        
        else if ([textView isEqual: detailCell.hashTextView])
        {
            if ([textView.text isEqualToString:@"Add some #Hashtags"] )
            {
                textView.text = @"";
                hashPlaceholder.hidden = YES;
                textView.textColor = [UIColor grayColor];
            }
        }
        
    }
    
    
    if ([textView isEqual: moreCell.moreTextView])
    {
        
        if ([textView.text isEqualToString:@"أخبرنا أكثر عن منتجك"] )//Tell us more about the product
        {
            textView.text = @"";
            moreCell.morePlaceholder.hidden = YES;
        }
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
     Str_TxtField_Flag=@"no";
    carPickerView.hidden=YES;
    
    toolBar.hidden=YES;
    [carPickerView removeFromSuperview];
    if ([self.name isEqualToString:@"سيارات"])//car
    {
        
        
        
        if ([textView isEqual: Cell_DetailCar.sellingTextview])
        {
            if ([[UIScreen mainScreen]bounds].size.width == 320)
            {
                
                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 20);
                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
//                self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 40, self.tableView.frame.size.width, self.tableView.frame.size.height);
                
                
            }

            
            if ([textView.text isEqualToString:@""])
            {
                textView.text = @"ماذا ترغب في البيع؟";//@"What are you selling?";
                sellingPlaceholder1.hidden = NO;
               
                

            }
        }
        
        else if ([textView isEqual: Cell_DetailCar.hashTextView])
        {
            
            if ([textView.text isEqualToString:@""] )
            {
                textView.text = @"Add some #Hashtags";
                textView.textColor = [UIColor blackColor];
                hashPlaceholder.hidden = NO;
            }
        }
        if (([Cell_DetailCar.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailCar.sellingTextview.text isEqualToString:@""]) || Cell_DetailCar.mileageTextField.text.length ==0 || Cell_DetailCar.modelTextField.text.length ==0 || Cell_DetailCar.carMakeTextField.text.length ==0 )
        {
            
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
            
            
            
            
        }
  
    }
    else if ([self.name isEqualToString:@"عقار"])//property
    {
        
        
        
        if ([textView isEqual: Cell_DetailProperty.sellingTextview])
        {
            if ([textView.text isEqualToString:@""])
            {
                textView.text = @"ماذا ترغب في البيع؟";//@"What are you selling?";
                sellingPlaceholder2.hidden = NO;
               
                
            }
        }
        
        else if ([textView isEqual: Cell_DetailProperty.hashTextView])
        {
            
            if ([textView.text isEqualToString:@""] )
            {
                textView.text = @"Add some #Hashtags";
                textView.textColor = [UIColor blackColor];
                hashPlaceholder.hidden = NO;
            }
        }
        if (([Cell_DetailProperty.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailProperty.sellingTextview.text isEqualToString:@""]) || Cell_DetailProperty.propertySizeTextField.text.length ==0 || Cell_DetailProperty.noOfBedroomTextField.text.length ==0 )
        {
            
            moreCell.createButton.enabled = NO;
            [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
            
        }
        else
        {
            moreCell.createButton.enabled = YES;
            [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
            
            
        }
 
    }
    else
    {
        
        
        if ([textView isEqual: detailCell.sellingTextview])
        {
            if ([textView.text isEqualToString:@""])
            {
                textView.text = @"ماذا ترغب في البيع؟";//@"What are you selling?";
                sellingPlaceholder3.hidden = NO;
                
                
            }
        }
        
        else if ([textView isEqual: detailCell.hashTextView])
        {
            
            if ([textView.text isEqualToString:@""] )
            {
                textView.text = @"Add some #Hashtags";
                textView.textColor = [UIColor blackColor];
                hashPlaceholder.hidden = NO;
            }
        }

        
    }

      if ([textView isEqual: moreCell.moreTextView])
    {
        
        if ([textView.text isEqualToString:@""] )
        {
            textView.text = @"أخبرنا أكثر عن منتجك";//@"Tell us more about the product";
            moreCell.morePlaceholder.hidden = NO;
        }
        
//        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//        self.tableView.contentInset = contentInsets;
//        self.tableView.scrollIndicatorInsets = contentInsets;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    

   if ([text length] == 0)
   {
    
    if([text isEqualToString:@"\n"])
    {
        
        [textView resignFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
       
   }
    else if([[textView text] length] >= 40 )
    {
        if ([textView tag ]==2)
        {
           return NO;
        }
      
    }
       return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if  ([textField isEqual:Cell_DetailCar.mileageTextField])
    {
       // Cell_DetailCar.mileageTextField.text =@"";
        KMlabel.frame = CGRectMake(0, 0, 0, 0);
        KMlabel.hidden = YES;
       
    }
    
    if  ([textField isEqual:Cell_DetailProperty.propertySizeTextField])
    {
      //  Cell_DetailProperty.propertySizeTextField.text =@"";
        Sqmlabel.frame = CGRectMake(0, 0, 0, 0);
        Sqmlabel.hidden = YES;
        
    }
    
    
    if  ([textField isEqual:moreCell.askingPriceTextField])
    {
//    self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 220 -40);
//    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:2];
//    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        
    }
    
    return YES;

    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if  ([textField isEqual:moreCell.askingPriceTextField])
    {
//        self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 220);
//        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:2];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:Cell_DetailCar.carMakeTextField])
    {
        Str_TxtField_Flag=@"yes";
        Cell_DetailCar.DownArrowImageView.userInteractionEnabled = NO;
        
        if ([[UIScreen mainScreen]bounds].size.width == 320)
        {
        
        
        self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 14);
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        else
        {
        }
        
        [self addPickerView];
    }
    else
    {
         Str_TxtField_Flag=@"no";
        carPickerView.hidden=YES;
        
        toolBar.hidden=YES;
        [carPickerView removeFromSuperview];
    }
    
    
    
    
    if (moreCell.askingPriceTextField.text.length  == 0)
    {
        moreCell.askingPriceTextField.text = @"ر.س";//@"$";
    }
   
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    if ([Cell_DetailCar.mileageTextField.text isEqualToString:@""])
    {
        KMlabel.frame = CGRectMake(0, 0, 0, 0);
        KMlabel.hidden = YES;
    }
    else
    {
    
    KMlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    KMlabel.text = @" KM";
    KMlabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    Cell_DetailCar.mileageTextField.rightViewMode = UITextFieldViewModeAlways;
        Cell_DetailCar.mileageTextField.rightView = KMlabel;
        
    }
    
    if ([Cell_DetailProperty.propertySizeTextField.text isEqualToString:@""])
    {
        Sqmlabel.frame = CGRectMake(0, 0, 0, 0);
        Sqmlabel.hidden = YES;
        
    }
    else
    {
        
        Sqmlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 50)];
        Sqmlabel.text = @" (Sqm)";
        Sqmlabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        Cell_DetailProperty.propertySizeTextField.rightViewMode = UITextFieldViewModeAlways;
        Cell_DetailProperty.propertySizeTextField.rightView = Sqmlabel;
    
    }

    
}

    
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.name isEqualToString: @"سيارات"])//car
    {
        if ([textField isEqual:moreCell.askingPriceTextField])
        {
            NSString *newText = [moreCell.askingPriceTextField.text stringByReplacingCharactersInRange:range withString:string];
            
            if (![newText hasPrefix:@"ر.س"])//$
            {
                return NO;
            }
 
        }
        else
        {
            
        }
        
        
        
        
    }
    else if ([self.name isEqualToString:@"عقار"])//property
    {
        if ([textField isEqual:moreCell.askingPriceTextField])
        {
            NSString *newText = [moreCell.askingPriceTextField.text stringByReplacingCharactersInRange:range withString:string];
            
            if (![newText hasPrefix:@"ر.س"])//$
            {
                return NO;
            }
            
        }
        else
        {
            
        }
        
        
        
    }
    
    else
    {
    
    NSString *newText = [moreCell.askingPriceTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![newText hasPrefix:@"ر.س"])//$
    {
        return NO;
    }
        
    }
    
    // Default:
    return YES;
}

-(void)DownArrowImageTapped:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    Cell_DetailCar.DownArrowImageView.userInteractionEnabled = NO;
    Cell_DetailCar.carMakeTextField.enabled = NO;
    
    if ([[UIScreen mainScreen]bounds].size.width == 320)
    {
        
        
        self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 14);
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    

    
    [self addPickerView];
    
}

#pragma mark - Image Tapped Functionality

-(void)ImageTapped:(UITapGestureRecognizer *)sender
{
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;

    UIImageView *imageView1 = (UIImageView *)recognizer.view;
    
     NSLog(@"Imageview tap==:==%ld", (long)imageView1.tag);
    
    NSInteger indexImagetap=[ImageId indexOfObject:[NSString stringWithFormat:@"%ld",(long)imageView1.tag]];
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Yes button Pressed");
                        NSInteger indexmediaids=[Array_ImagesMediaIndex indexOfObject:[NSString stringWithFormat:@"%ld",(long)imageView1.tag]];
                                    mediaIdStr=[Array_ImageMediaId objectAtIndex:indexmediaids];
                                    removeIndexCount=[NSString stringWithFormat:@"%ld",(long)imageView1.tag];
                                    [self removePictureConnection];
                                    
//                                    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
//                                    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
//                                    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
//                                    [self.tableView endUpdates];
                                    
                                    
                                }];
    
    [alert addAction:yesAction];
    
    UIAlertAction *playAlert;
    
   if ([[array_MediaTypes objectAtIndex:indexImagetap] isEqualToString:@"IMAGE"])
    {


       playAlert =[UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                   
                              {
                                 [self displayImage:Image_View withImage:imageView1.image];
                                  
                                 
                                NSLog(@"playAlert button Pressed");
                                  
                              }];
    }
    else
    {
       
        playAlert =[UIAlertAction actionWithTitle:@"Play" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                   
                                   {
                    movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:[array_VideoUrl objectAtIndex:indexImagetap ]];
                                       
                                       
                                       [self presentMoviePlayerViewControllerAnimated:movieController];
                                       [movieController.moviePlayer prepareToPlay];
                                       [movieController.moviePlayer play];
                                       
                                       NSLog(@"playAlert button Pressed");
                                       
                                   }];
    
    }
    
    [alert addAction:playAlert];
    
    
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                              
                              {
                                  
                                  NSLog(@"No button Pressed");
                                  
                              }];
    
    [alert addAction:cancelAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)ImageTappedRemove:(UITapGestureRecognizer *)sender
{
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;
    
    UIImageView *imageView1 = (UIImageView *)recognizer.view;
    
    NSLog(@"Imageview tap==:==%ld", (long)imageView1.tag);
    
    NSString * Str_RemoveId=[NSString stringWithFormat:@"%ld",(long)imageView1.tag];
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Yes button Pressed");
                                    
                                    
                                    
                                    if ([ImageId containsObject:Str_RemoveId])
                                    {
                                      NSInteger indexValser1=[ImageId indexOfObject:Str_RemoveId];
                                        [ImageId removeObjectAtIndex:indexValser1];
                                        [array_MediaTypes removeObjectAtIndex:indexValser1];
                                        [array_VideoUrl removeObjectAtIndex:indexValser1];
                                        [imageArray removeObjectAtIndex:indexValser1];
                                    }
                                    [Array_RemoveImages addObject:Str_RemoveId];
                                   

                                    
                                    
                                    


#pragma mark- tableview reload comment
                                
                                    [self.tableView beginUpdates];
                                    
                                    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
                                    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                                    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    
                                    
                                }];
    
    [alert addAction:yesAction];
    UIAlertAction *cancelAction =[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                  
                                  {
                                      
                                      NSLog(@"No button Pressed");
                                      
                                  }];
    
    [alert addAction:cancelAction];
        
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image
{
    [Image_View setImage:image];
    [Image_View setupImageViewer1];
   
}

#pragma mark - Slider Functionality for days

-(void)sliderChanged:(UISlider*)sender{
   
    if (sender.tag == 1)
    {
        moreCell.currentDays_Label.text =[NSString stringWithFormat:@"%.f",sender.value];
        NSLog(@"%.f",sender.value);
        
        CGRect trackRect = [moreCell.slider trackRectForBounds:moreCell.slider.bounds];
        CGRect thumbRect = [moreCell.slider thumbRectForBounds:moreCell.slider.bounds
                                                 trackRect:trackRect
                                                     value:moreCell.slider.value];
        moreCell.currentDays_Label.center = CGPointMake(thumbRect.origin.x + moreCell.slider.frame.origin.x + 14,  moreCell.slider.frame.origin.y - 10);
        
        [defaults setObject:moreCell.currentDays_Label.text forKey:@"slival"];
        [defaults synchronize];

    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    
    if ([mediaTypeVal isEqualToString:@"VIDEO"])
    {
       
        
        self.videoURL = info[UIImagePickerControllerMediaURL];
        
        
        
        mediaTypeVal=@"VIDEO";
        self.videoURL = info[UIImagePickerControllerMediaURL];
        
        [array_VideoUrl addObject:self.videoURL];
        
        NSData* videoData = [NSData dataWithContentsOfFile:[self.videoURL path]];
        
        int videoSize = [videoData length]/1024/1024;
        
        
        NSLog(@"data size==%d",videoSize);
        
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
        
        
        AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generateImg.appliesPreferredTrackTransform = YES;
        NSError *error = NULL;
        CMTime time = CMTimeMake(1, 7);
        CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
        NSLog(@"error==%@, Refimage==%@", error, refImg);
        
        [array_MediaTypes addObject:mediaTypeVal];
        FrameImage= [[UIImage alloc] initWithCGImage:refImg];
        
        [imageArray addObject:FrameImage];
        indexCount_image=indexCount_image+1;
        [ImageId addObject:[NSString stringWithFormat:@"%ld",(long)indexCount_image]];
        
        
        NSLog(@"FrameImage height size==%f",FrameImage.size.height);
        NSLog(@"FrameImage width %fze==%f",FrameImage.size.width);
        
        
        
        if (FrameImage.size.height > FrameImage.size.width)
        {
            Vedio_Height=@960;
            Vedio_Width=@540;
        }
        else
        {
            Vedio_Height=@540;
            Vedio_Width=@960;
        }
        
        
        
        pcker1=picker;
        
        [self RecordingVediosImagepicker];
        
        
        
    }
    else
    {
        
        [array_VideoUrl addObject:@""];
        
        //chosenImage = info[UIImagePickerControllerEditedImage];
        chosenImage = info[UIImagePickerControllerOriginalImage];
        
        [imageArray addObject:chosenImage];
        [array_MediaTypes addObject:mediaTypeVal];
        

#pragma mark- image compression code
        
        float actualHeight = chosenImage.size.height;
        
        float actualWidth = chosenImage.size.width;
        
        float maxHeight = 1000.0;
        
        float maxWidth = 1000.0;
        
        float imgRatio = actualWidth/actualHeight;
        
        float maxRatio = maxWidth/maxHeight;
        
        float compressionQuality = 0.7;
        
        
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            
            if(imgRatio < maxRatio){
                
                
                
                imgRatio = maxHeight / actualHeight;
                
                actualWidth = imgRatio * actualWidth;
                
                actualHeight = maxHeight;
                
            }
            
            else if(imgRatio > maxRatio){
                
                //adjust height according to maxWidth
                
                imgRatio = maxWidth / actualWidth;
                
                actualHeight = imgRatio * actualHeight;
                
                actualWidth = maxWidth;
                
            }
            
            else{
                
                actualHeight = maxHeight;
                
                actualWidth = maxWidth;
                
            }
            
        }
        
        NSLog(@"Actual height : %f and Width : %f",actualHeight,actualWidth);
        
        CGRect rect1 = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        
        UIGraphicsBeginImageContext(rect1.size);
        
        [chosenImage  drawInRect:rect1];
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        imageData = UIImageJPEGRepresentation(img, compressionQuality);
        
        UIGraphicsEndImageContext();
          NSLog(@"size of image in KB: %f ", imageData.length/1024.0);
        
        
        
        float maxHeight1 = 500.0;
        
        float maxWidth1 = 500.0;
        
        float imgRatio1 = actualWidth/actualHeight;
        
        float maxRatio1 = maxWidth1/maxHeight1;
        
        float compressionQuality1 = 0.3;
        
        
        
        if (actualHeight > maxHeight1 || actualWidth > maxWidth1){
            
            if(imgRatio1 < maxRatio1){
                
                
                
                imgRatio1 = maxHeight1 / actualHeight;
                
                actualWidth = imgRatio1 * actualWidth;
                
                actualHeight = maxHeight1;
                
            }
            
            else if(imgRatio1 > maxRatio1){
                
                //adjust height according to maxWidth
                
                imgRatio1 = maxWidth1 / actualWidth;
                
                actualHeight = imgRatio1 * actualHeight;
                
                actualWidth = maxWidth1;
                
            }
            
            else{
                
                actualHeight = maxHeight1;
                
                actualWidth = maxWidth1;
                
            }
            
        }
        
        NSLog(@"Actual height : %f and Width : %f",actualHeight,actualWidth);
        
        CGRect rect11 = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        
        UIGraphicsBeginImageContext(rect11.size);
        
        [chosenImage  drawInRect:rect11];
        
        UIImage *img1 = UIGraphicsGetImageFromCurrentImageContext();
        
       NSData * imageData1 = UIImageJPEGRepresentation(img1, compressionQuality1);
        
        UIGraphicsEndImageContext();
        NSLog(@"size of image in KB: %f ", imageData1.length/1024.0);

        
 //-----------------------------------------------------------------------------------------------------
        
        
        //  NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
        
     //   imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
        
        // ImageNSdata = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        ImageNSdata = [Base64 encode:imageData];
       NSString *ImageNSdata1 = [Base64 encode:imageData1];
        
        encodedImageThumb = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdata1,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        
        
        encodedImage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdata,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        
        
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
        [picker dismissViewControllerAnimated:YES completion:NULL];
       
        indexCount_image=indexCount_image+1;
        [ImageId addObject:[NSString stringWithFormat:@"%ld",(long)indexCount_image]];
        [self postMediaConnection];
        
    }
   
    
    
    
   //  [self.tableView reloadData];
    
    
    [self.tableView beginUpdates];
    
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
}

-(void)RecordingVediosImagepicker
{
    [pcker1.view addSubview:transperentViewIndicator];
    
    NSString *finalVideoURLString = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    finalVideoURLString = [finalVideoURLString stringByAppendingPathComponent:@"compressedVideo.mp4"];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:finalVideoURLString withIntermediateDirectories:YES attributes:nil error:nil];
    [manager removeItemAtPath:finalVideoURLString error:nil];
    
    NSURL *outputVideoUrl = ([[NSURL URLWithString:finalVideoURLString] isFileURL] == 1)?([NSURL URLWithString:finalVideoURLString]):([NSURL fileURLWithPath:finalVideoURLString]); // Url Should be a file Url, so here we check and convert it into a file Url
    
    
    
    SDAVAssetExportSession *compressionEncoder = [SDAVAssetExportSession.alloc initWithAsset:[AVAsset assetWithURL:_videoURL]]; // provide inputVideo Url Here
    compressionEncoder.outputFileType = AVFileTypeMPEG4;
    compressionEncoder.outputURL = outputVideoUrl;
    compressionEncoder.shouldOptimizeForNetworkUse = YES;//Provide output video Url here
    compressionEncoder.videoSettings = @
    
    {
    AVVideoCodecKey: AVVideoCodecH264,
    AVVideoWidthKey: Vedio_Width,   //Set your resolution width here
    AVVideoHeightKey: Vedio_Height,  //set your resolution height here
    AVVideoCompressionPropertiesKey: @
        {
        AVVideoAverageBitRateKey: @2000000, // Give your bitrate here for lower size give low values
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40,
        },
    };
    compressionEncoder.audioSettings = @
    {
    AVFormatIDKey: @(kAudioFormatMPEG4AAC),
    AVNumberOfChannelsKey: @2,
    AVSampleRateKey: @44100,
    AVEncoderBitRateKey: @128000,
    };
    
    [compressionEncoder exportAsynchronouslyWithCompletionHandler:^
     {
         if (compressionEncoder.status == AVAssetExportSessionStatusCompleted)
         {
             NSLog(@"Compression Export Completed Successfully");
             
             NSData* videoData = [NSData dataWithContentsOfFile:[outputVideoUrl path]];
             int videoSize = [videoData length]/1024/1024;
             
             // [self.videoURL path]
             NSLog(@"data size path==%d",videoSize);
             
             imageData=[NSData dataWithContentsOfFile:[outputVideoUrl path]];
             // ImageNSdata = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
             
             ImageNSdata = [Base64 encode:imageData];
             
             encodedImage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdata,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
             
             
             self.videoController = [[MPMoviePlayerController alloc] init];
             
             [self.videoController setContentURL:outputVideoUrl];
             
             
             
             [self.videoController setScalingMode:MPMovieScalingModeAspectFill];
             _videoController.fullscreen=YES;
             _videoController.allowsAirPlay=NO;
             _videoController.shouldAutoplay=YES;
             
             
             
             imageDataThumb = UIImageJPEGRepresentation(FrameImage, 1.0);
             
             
             ImageNSdataThumb = [Base64 encode:imageDataThumb];
             
             
             encodedImageThumb = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdataThumb,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
             
             
             [pcker1.view hideActivityViewWithAfterDelay:1];
             
             
             
             [pcker1 dismissViewControllerAnimated:YES completion:nil];
             [self postMediaConnection];
             
         }
         else if (compressionEncoder.status == AVAssetExportSessionStatusCancelled)
         {
             NSLog(@"Compression Export Canceled");
             
             NSLog(@"Compression Failed==%@",compressionEncoder.error);
             UIAlertController * alert=[UIAlertController
                                        
                                        alertControllerWithTitle:@"Compression Canceled" message:@"Compression Export Canceled. Please try again." preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"ReCompress"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [self.view hideActivityViewWithAfterDelay:0];
                                             [self RecordingVediosImagepicker];
                                             
                                         }];
             UIAlertAction* noButton = [UIAlertAction
                                        actionWithTitle:@"Cancel"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [self.view hideActivityViewWithAfterDelay:0];
                                            [self dismissModalViewControllerAnimated:YES];
                                            //[pcker1 dismissViewControllerAnimated:YES completion:NULL];
                                            
                                        }];
             
             [alert addAction:yesButton];
             [alert addAction:noButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         }
         else
         {
             NSLog(@"Compression Failed==%@",compressionEncoder.error);
             UIAlertController * alert=[UIAlertController
                                        
                                        alertControllerWithTitle:@"Compression Error" message:@"Could not compress your video. Please try again." preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"ReCompress"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [self.view hideActivityViewWithAfterDelay:0];
                                             [self RecordingVediosImagepicker];
                                             
                                         }];
             UIAlertAction* noButton = [UIAlertAction
                                        actionWithTitle:@"Cancel"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [self.view hideActivityViewWithAfterDelay:0];
                                            [pcker1 dismissViewControllerAnimated:YES completion:NULL];
                                            
                                        }];
             
             [alert addAction:yesButton];
             [alert addAction:noButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         }
     }];
    
    [self dismissModalViewControllerAnimated:YES];


    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)createButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    [defaults setObject:@"yes" forKey:@"refreshView"];
    
    if ([self.name isEqualToString:@"سيارات"])//car
    {
        
        
        if (Cell_DetailCar.carMakeTextField.text.length == 0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Choose Car Make" message:@"Please enter Car Make and try again" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        else
        {
            [self createPostConnection];
        }
        
    }
    
    else
    {
        
        [self createPostConnection];
        
    }
    
    
    
    
}


-(void)createPostConnection
{
    
    [detailCell.hashTextView resignFirstResponder];
    
    [self.view showActivityViewWithLabel:@"Creating post..."];
    
    
    NSLog(@"createButtonPressed");
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
    }
    else
    {
        
        NSURL *url;//=[NSURL URLWithString:[urlplist valueForKey:@"singup"]];
        NSString *  urlStr=[urlplist valueForKey:@"createpost"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *postid= @"postid";
        NSString *postidVal = postIDValue;    //[defaults valueForKey:@"postid"];
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        
        NSString *title;
        NSString *titleVal;
        NSString *hashtags;
        NSString *hashtagsVal;
        
        
        
        
        
        
        
        if ([self.name isEqualToString:@"سيارات"])//car
        {
            
            
            if ([Cell_DetailCar.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"])//What are you selling?
            {
                title= @"title";
                titleVal = @"";
            }
            else
            {
                
                title= @"title";
                titleVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)Cell_DetailCar.sellingTextview.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;
            }
            
            
            
            if ([Cell_DetailCar.hashTextView.text isEqualToString:@"Add some #Hashtags"])
            {
                hashtags= @"hashtags";
                hashtagsVal = @"";
                
            }
            else
            {
                hashtags= @"hashtags";
                hashtagsVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)Cell_DetailCar.hashTextView.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
                
            }
            
        }
        else if ([self.name isEqualToString:@"عقار"])//property
        {
            //            title= @"title";
            //            titleVal =Cell_DetailProperty.sellingTextview.text;// [defaults valueForKey:@"title"];
            
            if ([Cell_DetailProperty.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"])//What are you selling?
            {
                title= @"title";
                titleVal = @"";
            }
            else
            {
                
                title= @"title";
                titleVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)Cell_DetailProperty.sellingTextview.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;
            }
            
            
            
            
            if ([Cell_DetailProperty.hashTextView.text isEqualToString:@"Add some #Hashtags"])
            {
                hashtags= @"hashtags";
                hashtagsVal = @"";
                
            }
            else
            {
                hashtags= @"hashtags";
                hashtagsVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)Cell_DetailProperty.hashTextView.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;
                
            }
            
        }
        else
        {
            
            //            title= @"title";
            //            titleVal =detailCell.sellingTextview.text;// [defaults valueForKey:@"title"];
            
            if ([detailCell.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"])//What are you selling
            {
                title= @"title";
                titleVal = @"";
            }
            else
            {
                
                title= @"title";
                titleVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)detailCell.sellingTextview.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;
            }
            
            
            if ([detailCell.hashTextView.text isEqualToString:@"Add some #Hashtags"])
            {
                hashtags= @"hashtags";
                hashtagsVal = @"";
                
            }
            else
            {
                hashtags= @"hashtags";
                hashtagsVal = detailCell.hashTextView.text;
                
            }
            
            
            
        }
        
        NSString *carmake = @"carmake";
        NSString *carmakeVal = Cell_DetailCar.carMakeTextField.text;
        
        
       
        
        
        NSString *propertytype = @"propertytype";
        NSString *propertytypeVal = propertyType;
        
        NSString *propertysize = @"propertysize";
        
        NSString *noofrooms = @"noofrooms";
       
        long propertysizeVals=[ Cell_DetailProperty.propertySizeTextField.text longLongValue];
        long noofroomsVals=[Cell_DetailProperty.noOfBedroomTextField.text longLongValue];
        NSString *propertysizeVal = [NSString stringWithFormat:@"%ld",propertysizeVals];
        NSString *noofroomsVal =[NSString stringWithFormat:@"%ld",noofroomsVals]; ;
        
        NSString *allowcalls= @"allowcalls";
        NSString *allowcallsVal = [defaults valueForKey:@"CallPressed"];
        
        
        NSString *askingprice;
        NSString *askingpriceVal;
        if ([moreCell.askingPriceTextField.text isEqualToString:@""])
        {
            askingprice= @"askingprice";
            askingpriceVal = @"0" ;
        }
        else
        {
            NSString *askingpriceValString = [NSString stringWithFormat:@"%@",moreCell.askingPriceTextField.text];
            askingpriceValString = [askingpriceValString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];//[askingpriceValString substringFromIndex:1];
            askingprice= @"askingprice";
            
            NSInteger number = [askingpriceValString intValue];
            askingpriceVal = [NSString stringWithFormat:@"%ld",(long)number];//(long)number;
        }
        
        NSString *description;
        NSString *descriptionVal;
        if ([ moreCell.moreTextView.text isEqualToString:@"أخبرنا أكثر عن منتجك"] )//Tell us more about the product
        {
            description= @"description";
            descriptionVal = @"";
            
        }
        else
        {
            description= @"description";
            descriptionVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)moreCell.moreTextView.text,NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;;
        }
        
        
        NSString *city= @"city";
        NSString *cityVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Cityname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;;
        NSString *country= @"country";
        NSString *countryVal =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[defaults valueForKey:@"Countryname"],NULL,(CFStringRef)@"!*\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));;;
        NSString *category= @"category";
        
         NSString *categoryVal ;
        
        if ([self.name isEqualToString:@"سيارات"])
        {
            
            
            categoryVal = @"car";
            
           
        }
         else if([self.name isEqualToString:@"عقار"])
        {
            
        categoryVal=@"property";
        }
        else if ([self.name isEqualToString:@"إلكترونيات"])
        {
            categoryVal=@"electronics";
        }
        else if([self.name isEqualToString:@"حيوانات أليفة"])
        {
            
            categoryVal=@"pets";
        }
        else if([self.name isEqualToString:@"أثاث"])
            
        {
    
          categoryVal=@"furniture";
        }
        else if([self.name isEqualToString:@"خدمات"])
        {
            categoryVal=@"services";
            
        }
       else if([self.name isEqualToString:@"أخرى"])
        {
            
            categoryVal=@"others";
        }
        else
        {
            categoryVal=self.name;
        }
        
        
        NSString *carmodel = @"carmodel";
       
        NSString *carmileage = @"carmileage";
     
        
        
        NSUInteger carmilegesvals=[Cell_DetailCar.mileageTextField.text integerValue];
        NSUInteger carmodelsvals=[Cell_DetailCar.modelTextField.text integerValue];
        NSString *carmodelVal = [NSString stringWithFormat:@"%ld",carmodelsvals];
           NSString *carmileageVal =[NSString stringWithFormat:@"%ld",carmilegesvals]; ;
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,title,titleVal,allowcalls,allowcallsVal,askingprice,askingpriceVal,description,descriptionVal,hashtags,hashtagsVal,city,cityVal,country,countryVal,category,categoryVal,carmake,carmakeVal,carmodel,carmodelVal,carmileage,carmileageVal,propertytype,propertytypeVal,propertysize,propertysizeVal,noofrooms,noofroomsVal,@"dummy",@"dummyyyyyyyyyy"];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_Create = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_Create)
            {
                webData_Create =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }

    
}




-(void)callButtonPressed:(id)sender
{
    NSLog(@"callButtonPressed");
    
    if ([[defaults valueForKey:@"CallPressed"] isEqualToString:@"NO"])
    {
        [moreCell.callButton setImage:[UIImage imageNamed:@"Callsgreen"] forState:UIControlStateNormal];
        moreCell.callLabel.text = @"نعم";
        moreCell.callLabel.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        [defaults setObject:@"YES" forKey:@"CallPressed"];
    }
    else
    {
        [moreCell.callButton setImage:[UIImage imageNamed:@"Callsgrey"] forState:UIControlStateNormal];
        moreCell.callLabel.text = @"لا";
        moreCell.callLabel.textColor = [UIColor lightGrayColor];
        [defaults setObject:@"NO" forKey:@"CallPressed"];
    }
    
}

#pragma mark - NSURL CONNECTION

-(void)postMediaConnection
{
    
    NSLog(@"createButtonPressed");
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
    }
    else
    {
#pragma mark - swipe sesion
        
        NSString *postid= @"postid";
                NSString *postidVal = postIDValue;
        
                NSString *userid= @"userid";
                NSString *useridVal =[defaults valueForKey:@"userid"];
        
                NSString *indexid= @"indexid";
                NSString *indexidVal =[NSString stringWithFormat:@"%ld",(long)indexCount_image];
        
        
                NSString *media= @"media";
                NSString *mediaVal =encodedImage;
        
                NSString *mediathumbnail= @"mediathumbnail";
                NSString *mediathumbnailVal = encodedImageThumb;
        
                NSString *mediatype= @"mediatype";
                NSString *mediatypeVal = mediaTypeVal;
        
                NSString *height= @"height";
                NSString *heightVal =[NSString stringWithFormat:@"%@",Vedio_Height];
                NSString *width= @"width";
                NSString *widthVal = [NSString stringWithFormat:@"%@",Vedio_Width];;
        
        
                NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,indexid,indexidVal,media,mediaVal,mediathumbnail,mediathumbnailVal,mediatype,mediatypeVal,height,heightVal,width,widthVal];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"uploadpostmedia"];;
        url =[NSURL URLWithString:urlStrLivecount];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                         {
                                             if(data)
                                             {
                                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                 NSInteger statusCode = httpResponse.statusCode;
                                                 if(statusCode == 200)
                                                 {
                                                     
                                                     Array_Media=[[NSMutableArray alloc]init];
                                                     SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                     Array_Media=[objSBJsonParser objectWithData:data];
                                                     NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     
                                                     NSLog(@"Array_Media %@",Array_Media);
                                                     
                                                     NSLog(@"Array_Media_ResultString %@",ResultString);
                                                     if (Array_Media != 0)
                                                     {
                                                         
                                      [Array_ImageMediaId addObject:[[Array_Media objectAtIndex:0] valueForKey:@"mediaid"]];
                                        
                                        [Array_ImagesMediaIndex addObject:[[Array_Media objectAtIndex:0] valueForKey:@"indexid"]];
                                                         
                                                         
                                            NSLog(@"Array_ImagesMediaIndex==%@",Array_ImagesMediaIndex);
                                            NSLog(@"Array_ImageMediaId==%@",Array_ImageMediaId);
              
                                                        
                                                         
                                                         NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
                                                         NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                                                         [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                                         [self.tableView endUpdates];
                                                         
                                                         
                                                         
                                                         
                                                         
                                                     }
                                                     
                                                     
                                                     else if ([ResultString isEqualToString:@"nouserid"])
                                                     {
                                                         
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"nouserid" message:@"User account has been deleted or has been deactivated. Please contact our team at support@tammapp.com" preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault
                                                                                                          handler:nil];
                                                         [alertController addAction:actionOk];
                                                         
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                     }
                                                     else if ([ResultString isEqualToString:@"nomedia"])
                                                     {
                                                         
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"nomedia" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault
                                                                                                          handler:nil];
                                                         [alertController addAction:actionOk];
                                                         
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                     }
                                                     
                                                     else if ([ResultString isEqualToString:@"imageerror"])
                                                     {
                                                         
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"imageerror" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault
                                                                                                          handler:nil];
                                                         [alertController addAction:actionOk];
                                                         
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                     }
                                                     
                                                     else if ([ResultString isEqualToString:@"error"])
                                                     {
                                                         
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Server Error" message:@"There was an error in creating your post. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault
                                                                                                          handler:nil];
                                                         [alertController addAction:actionOk];
                                                         
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                     }
                                                     else
                                                     {
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Server Error" message:@"There was an error in creating your post. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault
                                                                                                          handler:nil];
                                                         [alertController addAction:actionOk];
                                                         
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                     }
                                for (int k=0; k<Array_RemoveImages.count; k++)
                                        {
                    if ([Array_ImagesMediaIndex containsObject:[Array_RemoveImages objectAtIndex:k]])
                        {
                    NSInteger indexmediaids=[Array_ImagesMediaIndex indexOfObject:[NSString stringWithFormat:@"%@",[Array_RemoveImages objectAtIndex:k]]];
                                                             
                    mediaIdStr=[Array_ImageMediaId objectAtIndex:indexmediaids];
                    removeIndexCount=[NSString stringWithFormat:@"%@",[Array_RemoveImages objectAtIndex:k]];
                                                             [self removePictureConnection];
                                                         }
                                                     }
                                            
                                                 
                                                 }
                                                 
                                                 else
                                                 {
                                                     NSLog(@" error login1 ---%ld",(long)statusCode);
                                                     
                                                 }
                                                 
                                             }
                                             else if(error)
                                             {
                                                 
                                                 NSLog(@"error login2.......%@",error.description);
                                                 
                                             }
                                         }];
    
        [dataTask resume];
        
    }
//    {
//        
//        NSURL *url;//=[NSURL URLWithString:[urlplist valueForKey:@"singup"]];
//        NSString *  urlStr=[urlplist valueForKey:@"uploadpostmedia"];
//        url =[NSURL URLWithString:urlStr];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//        
//        [request setHTTPMethod:@"POST"];//Web API Method
//        
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        
//        
//        NSString *postid= @"postid";
//        NSString *postidVal = postIDValue;
//        
//        NSString *userid= @"userid";
//        NSString *useridVal =[defaults valueForKey:@"userid"];
//        
//        NSString *indexid= @"indexid";
//        NSString *indexidVal =[NSString stringWithFormat:@"%ld",(long)indexCount];
//        
//        
//        NSString *media= @"media";
//        NSString *mediaVal =encodedImage;
//        
//        NSString *mediathumbnail= @"mediathumbnail";
//        NSString *mediathumbnailVal = encodedImageThumb;
//        
//        NSString *mediatype= @"mediatype";
//        NSString *mediatypeVal = mediaTypeVal;
//        
//        NSString *height= @"height";
//        NSString *heightVal =[NSString stringWithFormat:@"%@",Vedio_Height];
//        NSString *width= @"width";
//        NSString *widthVal = [NSString stringWithFormat:@"%@",Vedio_Width];;
//        
//        
//        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,indexid,indexidVal,media,mediaVal,mediathumbnail,mediathumbnailVal,mediatype,mediatypeVal,height,heightVal,width,widthVal];
//        
//        
//        //converting  string into data bytes and finding the lenght of the string.
//        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
//        [request setHTTPBody: requestData];
//        
//        Connection_Media = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//        {
//            if( Connection_Media)
//            {
//                webData_Media =[[NSMutableData alloc]init];
//                
//                
//            }
//            else
//            {
//                NSLog(@"theConnection is NULL");
//            }
//        }
//        
//    }

    
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error)
    {
        
        
        [self.view hideActivityViewWithAfterDelay:0];
        NSLog(@"errorr===%@",error);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Server Error" message:@"Error in creating post. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        [alertController addAction:actionOk];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    
    if(connection==Connection_Create)
    {
        [webData_Create setLength:0];
        
        
    }
    if(connection==Connection_Media)
    {
        [webData_Media setLength:0];
        
        
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_Create)
    {
        [webData_Create appendData:data];
    }
    if(connection==Connection_Media)
    {
        [webData_Media appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_Create)
    {
        
        Array_Create=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_Create=[objSBJsonParser objectWithData:webData_Create];
        NSString * ResultString=[[NSString alloc]initWithData:webData_Create encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_Create);
        NSLog(@"registration_status %@",[[Array_Create objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
         [self.view hideActivityViewWithAfterDelay:0];
        if ([ResultString isEqualToString:@"done"])
        {
            
            
            
#pragma mark - Boost
            
            
            transparentView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            transparentView1.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
            
            myBoostXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"BoostPost" owner:self options:nil]objectAtIndex:0];
            
            myBoostXIBViewObj.frame = CGRectMake((self.view.frame.size.width- myBoostXIBViewObj.frame.size.width)/2,self.view.frame.size.width - 250, myBoostXIBViewObj.frame.size.width, myBoostXIBViewObj.frame.size.height);
            
            
            [self.view addSubview:myBoostXIBViewObj];
        // POST ID=:رقم الإعلان
            myBoostXIBViewObj.postIdLabel.text =[NSString stringWithFormat:@"%@%@",postIDValue,@" :رقم الإعلان"];
  
            
            myBoostXIBViewObj.layer.cornerRadius = 10;
            myBoostXIBViewObj.clipsToBounds = YES;
            
            myBoostXIBViewObj.boostTextLabel.text = @"روِّج إعلانك لزيادة مستوى رؤيته من قِبل الآخرون! إعلانك  سوف يظهر في أعلى الفئة المختارة لمدة محددة من الوقت.";//@"Your post has been successfully created! You can also Boost your post to increase your visibility and it will be displayed at the top of your chosen category for limited time.";
            
            [myBoostXIBViewObj.imageViewButton1 setUserInteractionEnabled:YES];
            UITapGestureRecognizer *viewTapped1 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton1_Action:)];
            
            [myBoostXIBViewObj.imageViewButton1 addGestureRecognizer:viewTapped1];
            
            [myBoostXIBViewObj.imageViewButton2 setUserInteractionEnabled:YES];
            UITapGestureRecognizer *viewTapped2 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton2_Action:)];
            [myBoostXIBViewObj.imageViewButton2 addGestureRecognizer:viewTapped2];
            
            [myBoostXIBViewObj.imageViewButton3 setUserInteractionEnabled:YES];
            UITapGestureRecognizer *viewTapped3 =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewButton3_Action:)];
            [myBoostXIBViewObj.imageViewButton3 addGestureRecognizer:viewTapped3];
            
            
            [myBoostXIBViewObj.closeButton addTarget:self action:@selector(boostCloseAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            [transparentView1 addSubview:myBoostXIBViewObj];
            [self.view addSubview:transparentView1];
            
            
            
            
            
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Your post has been successfully created and posted on the platform. Thank-you!" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction *action)
//                                       {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
//                                           CATransition *transition = [CATransition animation];
//                                           transition.duration = 0.3;
//                                           transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                                           transition.type = kCATransitionPush;
//                                           transition.subtype = kCATransitionFromRight;
//                                           
//                                           [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//                                           
//                                           [self.navigationController popViewControllerAnimated:YES];
//                                           
//                                           
//                                       }];
//
//            
//            
//            [alertController addAction:actionOk];
//            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        if ([ResultString isEqualToString:@"nullerror"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Title of your post is mandatory. Please fill all details and try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
            
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        if ([ResultString isEqualToString:@"nouserid"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your account does not exist or seems to have been deactivated. Please contact support@tammapp.com" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                       
                                       }];
            
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        if ([ResultString isEqualToString:@"inserterror"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Error in creating your posts. Please check your details and try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
            
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    if (connection==Connection_Media)
    {
        
        Array_Media=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_Media=[objSBJsonParser objectWithData:webData_Media];
        NSString * ResultString=[[NSString alloc]initWithData:webData_Media encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"Array_Media %@",Array_Media);
     
        NSLog(@"Array_Media_ResultString %@",ResultString);
        if (Array_Media != 0)
        {
            
            
    
                
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"done" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                                   style:UIAlertActionStyleDefault
//                                                                 handler:nil];
//                [alertController addAction:actionOk];
            
           //     [self presentViewController:alertController animated:YES completion:nil];
            
            
            
            
            
           // [self.tableView reloadData];
            
            NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
            [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];

            
                
        
            
        }
        

        else if ([ResultString isEqualToString:@"nouserid"])
        {
            
           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"nouserid" message:@"User account has been deleted or has been deactivated. Please contact our team at support@tammapp.com" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
       }
        else if ([ResultString isEqualToString:@"nomedia"])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"nomedia" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }

         else if ([ResultString isEqualToString:@"imageerror"])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"imageerror" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }

        else if ([ResultString isEqualToString:@"error"])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Server Error" message:@"There was an error in creating your post. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Server Error" message:@"There was an error in creating your post. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
       
    }

}

-(void)removePictureConnection
{
    [self.view endEditing:YES];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please make sure you have internet connectivity in order to access Tamm App." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                   {
                                       exit(0);
                                   }];
        
        [alertController addAction:actionOk];
        
        UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else
    {
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *postid= @"postid";
        NSString *postidVal =postIDValue;//[defaults valueForKey:@"postid"];
        
        NSString *media= @"mediaid";
        NSString *mediaVal =mediaIdStr;
        
        NSString *indexid= @"indexid";
        


        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,postid,postidVal,media,mediaVal,indexid,removeIndexCount];
        
        
        
#pragma mark - swipe sesion
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL *url;
        NSString *  urlStrLivecount=[urlplist valueForKey:@"removepicture"];;
        url =[NSURL URLWithString:urlStrLivecount];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
        
        
        
        NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                         {
                                             if(data)
                                             {
                                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                 NSInteger statusCode = httpResponse.statusCode;
                                                 if(statusCode == 200)
                                                 {
                                                     
                                                     Array_RemovePicture=[[NSMutableArray alloc]init];
                                                     SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                     Array_RemovePicture=[objSBJsonParser objectWithData:data];
                                                     
                                                     NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                     
                                                     //Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_Swipe options:kNilOptions error:nil];
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                     
                                                     ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                     
                                                     NSLog(@"Array_AllData %@",Array_RemovePicture);
                                                     
                                                     
                                                     NSLog(@"Array_AllData ResultString %@",ResultString);
                                                     
                                                     NSLog(@"sddg=%lu",(unsigned long)Array_RemovePicture.count);
                                                     
                                                     if (Array_RemovePicture.count !=0)
                                                     {
                                        NSString * serverid = [[Array_RemovePicture objectAtIndex:0]valueForKey:@"indexid"] ;
                                                         if ([ImageId containsObject:serverid] && [Array_ImagesMediaIndex containsObject:serverid] )
                                                         {
                                                             NSInteger indexValser1=[ImageId indexOfObject:serverid];
                                                             NSInteger indexValser2=[Array_ImagesMediaIndex indexOfObject:serverid];
                                                             [ImageId removeObjectAtIndex:indexValser1];
                                                             [array_MediaTypes removeObjectAtIndex:indexValser1];
                                                             [array_VideoUrl removeObjectAtIndex:indexValser1];
                                                             [imageArray removeObjectAtIndex:indexValser1];
                                                             [Array_ImagesMediaIndex removeObjectAtIndex:indexValser2];
                                                             [Array_ImageMediaId removeObjectAtIndex:indexValser2];
                                                         }
                                                         else
                                                         {
                                                             if ([Array_ImagesMediaIndex containsObject:serverid] )
                                                             {
                                                    NSInteger indexValser1=[Array_RemoveImages indexOfObject:serverid];
                                                        NSInteger indexValser2=[Array_ImagesMediaIndex indexOfObject:serverid];
                                                        [Array_RemoveImages removeObjectAtIndex:indexValser1];
                                                    [Array_ImagesMediaIndex removeObjectAtIndex:indexValser2];
                                                    [Array_ImageMediaId removeObjectAtIndex:indexValser2];
                                                             }
  
                                                         }
                                
                                                         
                                                         
                                                        
#pragma mark - tableview reloaddata comment
                                                        // [self.tableView reloadData];
                                                         
                                                         [self.tableView beginUpdates];
                                                         
                                                         NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
                                                         NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                                                         [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                                         [self.tableView endUpdates];
                                                         
                                                         

                                                     }
                                                     
                                                     if ([ResultString isEqualToString:@"nouserid"])
                                                     {
                                                   
                                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Your account does not exist or seems to have been suspended. Please contact admin." preferredStyle:UIAlertControllerStyleAlert];
                                                         
                                                         UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                            style:UIAlertActionStyleDefault handler:nil];
                                                         [alertController addAction:actionOk];
                                                         [self presentViewController:alertController animated:YES completion:nil];
                                                         
                                                         
                                                     }
                                                 }
                                                 
                                                 else
                                                 {
                                                     NSLog(@" error login1 ---%ld",(long)statusCode);
                                                     
                                                 }
                                                 
                                             }
                                             else if(error)
                                             {
                                                 
                                                 NSLog(@"error login2.......%@",error.description);
                                                 
                                             }
                                         }];
        [dataTask resume];
    }
    
}
-(IBAction)ChangeLocations:(id)sender
{
    locationManager = [[CLLocationManager alloc] init] ;
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy =kCLLocationAccuracyThreeKilometers; //kCLLocationAccuracyNearestTenMeters;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0) {
             placemark = [placemarks lastObject];
             NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
             NSLog(@"placemark.country %@",placemark.country);
             NSLog(@"placemark.postalCode %@",placemark.postalCode);
             NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
             NSLog(@"placemark.locality %@",placemark.locality);
             NSLog(@"placemark.subLocality %@",placemark.subLocality);
             NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
             
             
             NSLog(@"placemark.subThoroughfare %@",[defaults valueForKey:@"Cityname"]);
             
             
             if (placemark.locality !=nil && placemark.country !=nil)
             {
                 
                 
                 [defaults setObject:placemark.locality forKey:@"Cityname"];
                 [defaults setObject:placemark.country forKey:@"Countryname"];
                 
                 locationName = placemark.locality ;
                 
                 
                 
                 [locationManager stopUpdatingLocation];
                 
                 
             }
             
             
         }
         else
         {
             NSLog(@"%@", error.debugDescription);
         }
     } ];
    
    [_tableView reloadData];
    
}


#pragma mark - Boost Post

-(void)boostCloseAction:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
    transparentView1.hidden = YES;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:YES];

    
    
    
}
-(void)imageViewButton1_Action:(UIGestureRecognizer *)reconizer
{
    NSLog(@"imageViewButton1_Action");
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    
    boostpackVal = @"24H";
    boostAmountVal = @"4";
    [self boostConnection];
    
    
}



-(void)imageViewButton2_Action:(UIGestureRecognizer *)reconizer
{
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    boostpackVal = @"48H";
    boostAmountVal = @"6";
    NSLog(@"imageViewButton2_Action");
    [self boostConnection];
    
}


-(void)imageViewButton3_Action:(UIGestureRecognizer *)reconizer
{
    [self.view showActivityViewWithLabel:@"Boosting post..."];
    NSLog(@"imageViewButton3_Action");
    boostpackVal = @"72H";
    boostAmountVal = @"10";
    [self boostConnection];
    
}

-(void)boostConnection
{
    NSString *postid= @"postid";
    
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    NSString *boostpack= @"boostpack";
    
    
    NSString *boostamount= @"boostamount";
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",postid,postIDValue,userid,useridVal,boostpack,boostpackVal,boostamount,boostAmountVal];
    
    
    
#pragma mark - swipe sesion
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"boostpost"];;
    url =[NSURL URLWithString:urlStrLivecount];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];//Web API Method
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPBody = [reqStringFUll dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         
                                         if(data)
                                         {
                                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                             NSInteger statusCode = httpResponse.statusCode;
                                             if(statusCode == 200)
                                             {
                                                 
                                                 Array_Boost=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_Boost =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_Boost %@",Array_Boost);
                                                 
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                //- Boosted
                                            // Thank you for your payment, your post has been successfully boosted!
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"تم الترويج!" message:@"شكراً لتسديدك المبلغ! إعلانك تم ترويجه بنجاح!" preferredStyle:UIAlertControllerStyleAlert];
                                                     
//                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
//                                                                                                        style:UIAlertActionStyleDefault
//                                                                                                      handler:nil];
//                                                     [alertController addAction:actionOk];
//                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"حسنا" //OK
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:^(UIAlertAction *action)
                                                                                {
                                                                                    
                                                                                    
                                                                                    
                                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
                                                                                    CATransition *transition = [CATransition animation];
                                                                                    transition.duration = 0.3;
                                                                                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                                    transition.type = kCATransitionPush;
                                                                                    transition.subtype = kCATransitionFromRight;
                                                                                    
                                                                                    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                                                                                    
                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                    
                                                                                    
                                                                                }];
                                                     
                                                     
                                                     
                                                     [alertController addAction:actionOk];
                                                      [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                  
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"alreadyboosted"])
                                                 {
                                                     
 
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                     //- Oops
                                                     //Your post is already boosted. Please try again when boost time is up.
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"تنبيه!" message:@"إعلانك قد تم ترويجه. الرجاء المحاولة مرة أخرى عند انتهاء الوقت." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"We encountered an error in boosting your post. Please try again or contact support." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"nopostid"])
                                                 {
                                                     transparentView1.hidden = YES;
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This item is no more available and cannot be boosted." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 
                                                 
                                                 [self.view hideActivityViewWithAfterDelay:0];
                                                 
                                             }
                                             
                                             
                                             else
                                             {
                                                 NSLog(@" error login1 ---%ld",(long)statusCode);
                                                 
                                             }
                                             
                                             
                                         }
                                         else if(error)
                                         {
                                             
                                             NSLog(@"error login2.......%@",error.description);
                                         }
                                         
                                         
                                     }];
    [dataTask resume];
    
    
    
    
    
}







#pragma marks - PickerView
-(void)addPickerView
{
    [Cell_DetailCar.modelTextField resignFirstResponder] ;
    pickerArray = [[NSArray alloc]initWithObjects:@"Alfa Romeo",@"Aston Martin",@"Audi",@"Bentley",@"Bmw",@"Bugatti",@"Cadillac",@"Chevrolet",@"Chrysler",@"Citroen",@"Corvette",@"Dodge",@"Ferrari",@"Fiat",@"Ford",@"GMC",@"Honda",@"Hummer",@"Hyundai",@"Infiniti",@"Jaguar",@"Jeep",@"Lamborghini",@"Land Rover",@"Lexus",@"Lincoln",@"Maserati",@"Maybach",@"Mazda",@"Mclaren",@"Mercedes Benz",@"Mini",@"Mitsubishi",@"Mustang",@"Nissan",@"Peugeot",@"Porsche",@"Renault",@"Rolls Royce",@"SAAB",@"Skoda",@"Subaru",@"Tesla",@"Toyota",@"Volkswagen",@"Volvo",nil] ;
    
    
    
    
    carPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200)];
    carPickerView.dataSource = self;
    carPickerView.delegate = self;
    carPickerView.showsSelectionIndicator = YES;
    carPickerView.backgroundColor=[UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    [carPickerView selectRow:myLastPressed inComponent:0 animated:YES];
    
    
    doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(done:)];
    doneButton.tintColor = [UIColor lightGrayColor];
    toolBar = [[UIToolbar alloc]initWithFrame:
               CGRectMake(0, self.view.frame.size.height-
                          carPickerView.frame.size.height - 50,self.view.frame.size.width, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    [toolBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    
    doneButton.enabled = NO;
    
    
    [self.view addSubview:carPickerView];
    //    countryTextField.inputView = countryPickerView;
    [self.view addSubview:toolBar];
    
     [ self.tableView setFrame :CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width, Tablevie_height-250)];
    
}



#pragma mark - Picker View Data source

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [pickerArray count];
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSInteger currentSelectedIndex;
    
    
    currentSelectedIndex = row;
    myLastPressed = currentSelectedIndex;
   
    
    
    [Cell_DetailCar.carMakeTextField setText:[pickerArray objectAtIndex:row]];
    
    Cell_DetailCar.carMakeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",Cell_DetailCar.carMakeTextField.text]];
    
//    if ([Cell_DetailCar.carMakeTextField.text isEqualToString:@""])
//    {
//        doneButton.enabled = NO;
//        doneButton.tintColor = [UIColor grayColor];
//    }
//    else
//    {
        doneButton.enabled = YES;
        doneButton.tintColor = [UIColor whiteColor];
 
//    }
    
    
    if (([Cell_DetailCar.sellingTextview.text isEqualToString:@"ماذا ترغب في البيع؟"] || [Cell_DetailCar.sellingTextview.text isEqualToString:@""]) || Cell_DetailCar.mileageTextField.text.length ==0 || Cell_DetailCar.modelTextField.text.length ==0 || Cell_DetailCar.carMakeTextField.text.length ==0 )
    {
        
        moreCell.createButton.enabled = NO;
        [moreCell.createButton setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    else
    {
        moreCell.createButton.enabled = YES;
        [moreCell.createButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
        
        
        
        
    }

   
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
   
    
    if ([Cell_DetailCar.carMakeTextField.text isEqualToString:@""])
    {
        doneButton.enabled = NO;
        doneButton.tintColor = [UIColor grayColor];
    }
    else
    {
        doneButton.enabled = YES;
        doneButton.tintColor = [UIColor whiteColor];
        
    }
    
     return [pickerArray objectAtIndex:row];
    
}

-(void)done:(UIBarButtonItem *)button
{
   Cell_DetailCar.DownArrowImageView.userInteractionEnabled = YES;
   Cell_DetailCar.carMakeTextField.enabled = YES;
    carPickerView.hidden=YES;
    
    toolBar.hidden=YES;
    [carPickerView removeFromSuperview];
    [Cell_DetailCar.carMakeTextField endEditing:YES];
    
    if ([[UIScreen mainScreen]bounds].size.width == 320)
    {
            self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height + 14);
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
 [self.tableView setFrame:CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width,Tablevie_height)];
    
}


#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    

    
    NSDictionary* info = [notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your application might not need or want this behavior.
//    
//    CGRect aRect = self.tableView.frame;
//    aRect.size.height -= kbSize.height +5;

    
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
}
- (void)subscribeToKeyboard {
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing)
        {
            
            
            [ self.tableView setFrame :CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width, Tablevie_height-keyboardRect.size.height)];
        
            
        } else
        {
            
            
               [self.tableView setFrame:CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width,Tablevie_height)];
           
            if ([Str_TxtField_Flag isEqualToString:@"yes"])
            {
                [self.tableView setFrame:CGRectMake(0,self.tableView.frame.origin.y, self.tableView.frame.size.width,Tablevie_height-250)];
            }
     
            
        }
        [self.view layoutIfNeeded];
    } completion:nil];}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}
@end


//UIImageView * imageBackround=[[UIImageView alloc]initWithImage:chosenImage];
//
//
//
//float actualHeight = chosenImage.size.height;
//
//float actualWidth = chosenImage.size.width;
//
//float maxHeight = 1000.0;
//
//float maxWidth = 1000.0;
//
//float imgRatio = actualWidth/actualHeight;
//
//float maxRatio = maxWidth/maxHeight;
//
//float compressionQuality = 0.7;
//
//
//
//if (actualHeight > maxHeight || actualWidth > maxWidth){
//    
//    if(imgRatio < maxRatio){
//        
//        
//        
//        imgRatio = maxHeight / actualHeight;
//        
//        actualWidth = imgRatio * actualWidth;
//        
//        actualHeight = maxHeight;
//        
//    }
//    
//    else if(imgRatio > maxRatio){
//        
//        //adjust height according to maxWidth
//        
//        imgRatio = maxWidth / actualWidth;
//        
//        actualHeight = imgRatio * actualHeight;
//        
//        actualWidth = maxWidth;
//        
//    }
//    
//    else{
//        
//        actualHeight = maxHeight;
//        
//        actualWidth = maxWidth;
//        
//    }
//    
//}
//
//NSLog(@"Actual height : %f and Width : %f",actualHeight,actualWidth);
//
//CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
//
//UIGraphicsBeginImageContext(rect.size);
//
//[imageBackround.image drawInRect:rect];
//
//UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//
//NSData *imageDataback = UIImageJPEGRepresentation(img, compressionQuality);
//
//UIGraphicsEndImageContext();
//
//
//
//NSLog(@"size of image in KB: %f ", imageDataback.length/1024.0);




