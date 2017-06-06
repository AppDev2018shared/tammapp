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
#import "MoreDetailCell.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "UIView+RNActivityView.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>




@interface PostingViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSURLConnectionDelegate>
{
    MoreDetailCell *moreCell;
    AddImageCell *imageCell;
    ProductDetailCell *detailCell;
    NSUserDefaults * defaults;
    UIImage *chosenImage ;
    UIImageView *imageView,*Image_View;
    UIImagePickerController *imagePicker, *cameraUI, *pcker1;
    NSInteger count,imageCount;
    NSMutableArray *imageArray, *array_MediaTypes, *array_VideoUrl,* Array_mediaTypeId, *ImageId;
    
    UILabel *sellingPlaceholder,*hashPlaceholder,*morePlaceholder,*Label_confirm1;
    
    UIView * transperentViewIndicator,*whiteView1,* transperentViewIndicator11,*whiteView111;
    UIActivityIndicatorView *indicatorAlert;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_Create, *Connection_Media;
    NSMutableData *webData_Create, *webData_Media;
    NSMutableArray *Array_Create, *Array_Media,*Array_RemovePicture;
    NSString *postIDValue ,*mediaTypeVal,* ImageNSdata,*ImageNSdataThumb, *encodedImage, *encodedImageThumb, *mediaIdStr, *imageTag, *removeIndexCount;
    
    UIImage *FrameImage;
    NSNumber *Vedio_Height,*Vedio_Width;
    NSData *imageData,*imageDataThumb;
    MPMoviePlayerViewController *movieController ;
    NSInteger indexCount , x;

    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    indexCount = 0;
    imageCount = 0;
    count = 0;
    imageArray = [[NSMutableArray alloc]init];
    array_MediaTypes = [[NSMutableArray alloc]init];
    array_VideoUrl = [[NSMutableArray alloc]init];
    Array_mediaTypeId= [[NSMutableArray alloc]init];
    ImageId = [[NSMutableArray alloc]init];

    Image_View = [[UIImageView alloc]init];
   
    
    defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:@"NO" forKey:@"CallPressed"];
    
    [defaults setObject:@"1" forKey:@"slival"];
    [defaults synchronize];

    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    
   // NSString *nameStr = [NSString stringWithFormat:@"POST YOUR %@",self.name];

    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 8, 50, 30)];
    
    nameLabel.text = [NSString stringWithFormat:@"Post your %@",self.name];
    nameLabel.font = [UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:26];
    [nameLabel sizeToFit];
    nameLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = nameLabel;
    
    // self.navigationItem.title = @"POST YOUR CAR";
    
    
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton =YES;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                                initWithTitle:@""
                                style:UIBarButtonItemStylePlain
                                target:self
                                action:@selector(OnClick_btn:)];
    [btn setImage:[UIImage imageNamed:@"Whitearrow"]];
    
    btn.tintColor= [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = btn;
    
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
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@" date=%@",[dateFormatter stringFromDate:[NSDate date]]);
    postIDValue = [NSString stringWithFormat:@"M%@%@",[dateFormatter stringFromDate:[NSDate date]],randomString];
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
    Label_confirm1.font=[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:16.0];
    Label_confirm1.textColor=[UIColor whiteColor];
    Label_confirm1.textAlignment=NSTextAlignmentCenter;
    
    
    [whiteView1 addSubview:indicatorAlert];
    
    [whiteView1 addSubview:Label_confirm1];
    
    [transperentViewIndicator addSubview:whiteView1];
    
    
    
    
//    
//    transperentViewIndicator11=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    transperentViewIndicator11.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
//    
//    whiteView111=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150,150)];
//    whiteView111.center=transperentViewIndicator11.center;
//    [whiteView111 setBackgroundColor:[UIColor blackColor]];
//    whiteView111.layer.cornerRadius=9;
//    //   indicatorAlert = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    //    indicatorAlert.frame=CGRectMake(40, 40, 20, 20);
//    //    [indicatorAlert startAnimating];
//    //    [indicatorAlert setColor:[UIColor whiteColor]];
//    
//    Label_confirm11=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, 150, 40)];
//    
//    [Label_confirm11 setFont:[UIFont systemFontOfSize:12]];
//    Label_confirm11.text=@"0 %";
//    Label_confirm11.font=[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:40.0];
//    Label_confirm11.textColor=[UIColor whiteColor];
//    Label_confirm11.textAlignment=NSTextAlignmentCenter;
//    
//    Label_confirm=[[UILabel alloc]initWithFrame:CGRectMake(0, 110, 150, 28)];
//    
//    [Label_confirm setFont:[UIFont systemFontOfSize:12]];
//    Label_confirm.text=@"Creating...";
//    Label_confirm.font=[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:20.0];
//    Label_confirm.textColor=[UIColor whiteColor];
//    Label_confirm.textAlignment=NSTextAlignmentCenter;
//    
//    Button_close=[[UIButton alloc]initWithFrame:CGRectMake(whiteView111.frame.size.width-23, -4, 28,28)];
//    Button_close.layer.cornerRadius=Button_close.frame.size.height/2;
//    
//    Button_close.backgroundColor=[UIColor whiteColor];
//    [Button_close setTitle:@"X" forState:UIControlStateNormal];
//    [Button_close setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
//    Button_close.titleLabel.font=[UIFont fontWithName:@"SanFranciscoDisplay-Bold" size:14.0];
//    [Button_close addTarget:self action:@selector(UploadinView_Close:) forControlEvents:UIControlEventTouchUpInside];
//    [whiteView111 addSubview:Button_close];
//    [whiteView111 addSubview:Label_confirm];
//    [whiteView111 addSubview:Label_confirm11];
//    
//    [transperentViewIndicator11 addSubview:whiteView111];
//    
//    [self.view addSubview:transperentViewIndicator11];
//    
    transperentViewIndicator11.hidden=YES;
    
    
    NSLocale *abc =[NSLocale currentLocale];
    NSString * xyz = [abc objectForKey:NSLocaleCountryCode];
    NSLog(@" country code%@",xyz);
    
    NSString * xyz1 = [abc displayNameForKey:NSLocaleCountryCode value:xyz];
    NSLog(@" country name %@",xyz1);
    

    
    
}

-(void)tap:(UITapGestureRecognizer *)tapRec
{
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
    cameraUI.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    
    cameraUI.showsCameraControls = YES;
    cameraUI.videoMaximumDuration = 60.0f;
    
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    //    self.videoTimer =  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeValue) userInfo:nil repeats:YES];
    //    remainingCounts = 60;
    
    [controller presentModalViewController: cameraUI animated: YES];
    
    return YES;
}








-(void)OnClick_btn:(UIBarButtonItem *)button
{
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)viewWillDisappear:(BOOL)animated
{
  // self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    
    switch (indexPath.section)
    {
        case 0:
        {
            imageCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
            
            [imageCell.galleryButton  addTarget:self action:@selector(galleryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [imageCell.videoButton  addTarget:self action:@selector(videoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [imageCell.cameraButton  addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect workingFrame =  imageCell.scrollView.frame;
            workingFrame.origin.x = 0;
            x = (imageArray.count *110) - 100;
            
            [imageCell.scrollView setPagingEnabled:YES];
            [imageCell.scrollView setContentOffset:CGPointMake((imageArray.count *110)-375, 0)];
            [imageCell.scrollView setContentSize:CGSizeMake((imageArray.count *110), workingFrame.size.height)];
            
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

            
            for (int i=0; i<imageArray.count; i++)
                
            {
                
                imageView=[[UIImageView alloc]init];
                imageView.frame=CGRectMake(x,0, 100, imageCell.scrollView.frame.size.height);
                [imageView setTag:i];
                imageView.userInteractionEnabled=YES;
                imageView.image=[imageArray objectAtIndex:i];
                
                
                
                
                
//                UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                           action:@selector(ImageTapped:)];
//                [imageView addGestureRecognizer:ImageTap];
                
                UIImageView *playButton = [[UIImageView alloc]initWithFrame:CGRectMake((imageView.frame.size.width / 2) - 20, (imageView.frame.size.height / 2) - 20, 40, 40)];
                playButton.backgroundColor = [UIColor clearColor];
                [playButton setImage:[UIImage imageNamed:@"Play"]];
//                UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                action:@selector(ImageTapped:)];
//                [playButton addGestureRecognizer:ImageTap1];
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
                
                
                NSLog(@"INDEXC OF image arrsy=%d",i);
                for (int j = 0; j < Array_mediaTypeId.count; j++)
                    {
                        NSLog(@"INDEXC OF image arrsy=%d",j);
                        NSLog(@"INDEXC OF imageiii arrsy=%d",i);
                        NSLog(@"Array_mediaTypeId OF values arrsy=%@",[[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"]);
                         NSLog(@"ImageId OF values ImageId=%@",[ImageId objectAtIndex:i]);

                        if ([[ImageId objectAtIndex:i] isEqualToString:[[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"]])
                        {
                            NSLog(@"INDEXC OF image arrsy11111=%d",j);
                            NSLog(@"INDEXC OF imageiii arrsy1111=%d",i);
                            NSLog(@"Array_mediaTypeId OF values1111 arrsy1111=%@",[[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"]);
                            NSLog(@"ImageId OF values ImageId111111=%@",[ImageId objectAtIndex:i]);

                            UITapGestureRecognizer * ImageTap =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                       action:@selector(ImageTapped:)];
                            [imageView addGestureRecognizer:ImageTap];
                            
                                            UITapGestureRecognizer * ImageTap1 =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                                            action:@selector(ImageTapped:)];
                                            [playButton addGestureRecognizer:ImageTap1];


                            imageView.alpha = 1;
                            break;
                            
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
                        
                }

                x -= 110;

            }
            
           
          return imageCell;
            
        }
            break;
        case 1:
        {
            detailCell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell"];
            
            detailCell.profileImageView.layer.cornerRadius = detailCell.profileImageView.frame.size.height / 2;
            detailCell.profileImageView.clipsToBounds = YES;
            
            NSURL *url=[NSURL URLWithString:[defaults valueForKey:@"profileimage"]];
            
            [detailCell.profileImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultimg.jpg"] options:SDWebImageRefreshCached];
            
            detailCell.usernameLabel.text = [defaults valueForKey:@"UserName"];
            
            NSString *locationstr = [NSString stringWithFormat:@"%@,%@",[defaults valueForKey:@"Cityname"],[defaults valueForKey:@"Countryname"]];
            
            
            detailCell.locationLabel.text = locationstr;
            
           

          
            
            
            //Selling textview
            
            detailCell.sellingTextview.delegate=self;
            detailCell.sellingTextview.text = @"What are you selling?";
            detailCell.sellingTextview.textColor = [UIColor blackColor];
            
            
            sellingPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(140, 42, 200, 21))];
            sellingPlaceholder.text = @"This is your post headline";
            sellingPlaceholder.textColor = [UIColor lightGrayColor];
            sellingPlaceholder.textAlignment = NSTextAlignmentRight;
            [detailCell.sellingTextview addSubview:sellingPlaceholder];
            [detailCell.contentView bringSubviewToFront:sellingPlaceholder];
            
            
            detailCell.hashTextView.delegate=self;
            detailCell.hashTextView.text = @"Add some #Hashtags";
            detailCell.hashTextView.textColor = [UIColor blackColor];
            detailCell.sellingTextview.tag = 2;
            
            hashPlaceholder = [[UILabel alloc]initWithFrame:(CGRectMake(120, 35, 225, 21))];
            hashPlaceholder.text = @"i.e. #retro#car#gold#classic";
            hashPlaceholder.textColor = [UIColor lightGrayColor];
            hashPlaceholder.textAlignment = NSTextAlignmentRight;
            [detailCell.hashTextView addSubview:hashPlaceholder];
            [detailCell.contentView bringSubviewToFront:hashPlaceholder];

            
            return detailCell;
        }
            break;
            
        case 2:
        {
            moreCell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
            
            moreCell.currentDays_Label.text =[NSString stringWithFormat:@"%.f",moreCell.slider.value];

            moreCell.slider.maximumValue = 30;
            moreCell.slider.minimumValue = 1;
            moreCell.slider.continuous = TRUE;
            [moreCell.slider  addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            moreCell.slider.tag = 1;
            
            moreCell.moreTextView.delegate =self;
            moreCell.moreTextView.text = @"Tell us more about the product";
            moreCell.moreTextView.textColor = [UIColor blackColor];
            
            [moreCell.createButton  addTarget:self action:@selector(createButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [moreCell.callButton  addTarget:self action:@selector(callButtonPressed:) forControlEvents:UIControlEventTouchUpInside];


            
            return moreCell;
        }
            break;
            
    }
    return nil;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView isEqual: detailCell.sellingTextview])
    {
         if ([textView.text isEqualToString:@"What are you selling?"])
         {
             textView.text = @"";
             sellingPlaceholder.hidden = YES;
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
    else if ([textView isEqual: moreCell.moreTextView])
    {
        
        if ([textView.text isEqualToString:@"Tell us more about the product"] )
        {
            textView.text = @"";
            moreCell.morePlaceholder.hidden = YES;
        }
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView isEqual: detailCell.sellingTextview])
    {
        if ([textView.text isEqualToString:@""])
        {
            textView.text = @"What are you selling?";
            sellingPlaceholder.hidden = NO;
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
    
    else if ([textView isEqual: moreCell.moreTextView])
    {
        
        if ([textView.text isEqualToString:@""] )
        {
            textView.text = @"Tell us more about the product";
            moreCell.morePlaceholder.hidden = NO;
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)ImageTapped:(UITapGestureRecognizer *)sender
{
    
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*)sender;

    UIImageView *imageView1 = (UIImageView *)recognizer.view;
    
     NSLog(@"Imageview tap==:==%ld", (long)imageView1.tag);
    
    Image_View = imageView1;
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Yes button Pressed");
                                    
//                                    [imageArray removeObjectAtIndex:(long)imageView1.tag];
//                                    [array_MediaTypes removeObjectAtIndex:(long)imageView1.tag];
//                                    [array_VideoUrl removeObjectAtIndex:(long)imageView1.tag];
                                  //  NSString *indexStr = [NSString stringWithFormat:@"%d",imageView1.tag];
                                    
//                                    for (int i =0 ; i < ImageId.count; i++)
//                                    {
                                        for (int j=0; j < Array_mediaTypeId.count; j++)
                                        {
                                            if ([[[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"] isEqualToString:[ImageId objectAtIndex:imageView1.tag]])
                                            {
                                                mediaIdStr = [[Array_mediaTypeId objectAtIndex:j] valueForKey:@"indexid"];
                                                
                                                [Array_mediaTypeId removeObjectAtIndex:j];
                                                [imageArray removeObjectAtIndex:(long)imageView1.tag];
                                                [array_MediaTypes removeObjectAtIndex:(long)imageView1.tag];
                                                [array_VideoUrl removeObjectAtIndex:(long)imageView1.tag];
                                                [ImageId removeObjectAtIndex:(long)imageView1.tag];


                                                [self removePictureConnection];
                                                break;
                                            }
                                       // }
                                        
                                        
                                        
                                    }
                
                                    [self.tableView reloadData];
                                    
                                    
                                }];
    
    [alert addAction:yesAction];
    
    UIAlertAction *playAlert;
    
    if ([[array_MediaTypes objectAtIndex:imageView1.tag] isEqualToString:@"IMAGE"])
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
                                       movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:[array_VideoUrl objectAtIndex:imageView1.tag ]];
                                       
                                       
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
    
    Image_View = imageView1;
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                {
                                    NSLog(@"Yes button Pressed");
                                    
                                    //                                    [imageArray removeObjectAtIndex:(long)imageView1.tag];
                                    //                                    [array_MediaTypes removeObjectAtIndex:(long)imageView1.tag];
                                    //                                    [array_VideoUrl removeObjectAtIndex:(long)imageView1.tag];
                                    //  NSString *indexStr = [NSString stringWithFormat:@"%d",imageView1.tag];
                                    
                                    //                                    for (int i =0 ; i < ImageId.count; i++)
                                    //                                    {
                                   
                                            [imageArray removeObjectAtIndex:(long)imageView1.tag];
                                            [array_MediaTypes removeObjectAtIndex:(long)imageView1.tag];
                                            [array_VideoUrl removeObjectAtIndex:(long)imageView1.tag];
                                            [ImageId removeObjectAtIndex:(long)imageView1.tag];
                                    
                                            removeIndexCount =  [ImageId objectAtIndex:(long)imageView1.tag];

                                    
                                    [self.tableView reloadData];
                                    
                                    
                                }];
    
    [alert addAction:yesAction];
    
        
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (void) displayImage:(UIImageView*)imageView withImage:(UIImage*)image
{
    [Image_View setImage:image];
    [Image_View setupImageViewer1];
   
}


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 271;
    }
    else if (indexPath.section == 1)
    {
        return 243;
    }
    else if (indexPath.section == 2)
    {
        return 520;
    }
    
    
    return 0;
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
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
        
        
        FrameImage= [[UIImage alloc] initWithCGImage:refImg];
        [imageArray addObject:FrameImage];
        [array_MediaTypes addObject:mediaTypeVal];
        
        
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
      //  NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
        
        imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
        
        // ImageNSdata = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        ImageNSdata = [Base64 encode:imageData];
        
        
        encodedImage = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)ImageNSdata,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
        
        
        [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        
        //[self viewImgCrop];
        // [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    }
    
    indexCount +=1;
    [ImageId addObject:[NSString stringWithFormat:@"%d",indexCount]];
    
    
     [self.tableView reloadData];
    [self postMediaConnection];
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
             
             [pcker1 dismissViewControllerAnimated:YES completion:NULL];
             
             
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
                                            [pcker1 dismissViewControllerAnimated:YES completion:NULL];
                                            
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
    
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)createButtonPressed:(id)sender
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
        NSString *title= @"title";
        NSString *titleVal =detailCell.sellingTextview.text;// [defaults valueForKey:@"title"];
        NSString *allowcalls= @"allowcalls";
        NSString *allowcallsVal = [defaults valueForKey:@"CallPressed"];
        
        NSString *enddays= @"enddays";
        NSString *enddaysVal = [defaults valueForKey:@"slival"];
        
        
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
            askingpriceValString = [askingpriceValString substringFromIndex:1];
            askingprice= @"askingprice";
            askingpriceVal =askingpriceValString;
        }
        NSString *description= @"description";
        NSString *descriptionVal = moreCell.moreTextView.text;//[defaults valueForKey:@"description"];
        NSString *hashtags= @"hashtags";
        NSString *hashtagsVal = detailCell.hashTextView.text;//[defaults valueForKey:@"hashtags"];
        NSString *city= @"city";
        NSString *cityVal = @"mumbai";//[defaults valueForKey:@"city"];
        NSString *country= @"country";
        NSString *countryVal = @"India";//[defaults valueForKey:@"country"];
        NSString *category= @"category";
        NSString *categoryVal = self.name;//[defaults valueForKey:@"category"];

        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postidVal,userid,useridVal,title,titleVal,allowcalls,allowcallsVal,enddays,enddaysVal,askingprice,askingpriceVal,description,descriptionVal,hashtags,hashtagsVal,city,cityVal,country,countryVal,category,categoryVal];
        
        
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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    moreCell.askingPriceTextField.text = @"$";//[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

-(void)callButtonPressed:(id)sender
{
    NSLog(@"callButtonPressed");
    
    if ([[defaults valueForKey:@"CallPressed"] isEqualToString:@"NO"])
    {
        [moreCell.callButton setImage:[UIImage imageNamed:@"Callsgreen"] forState:UIControlStateNormal];
        moreCell.callLabel.text = @"YES";
        moreCell.callLabel.textColor = [UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1];
        [defaults setObject:@"YES" forKey:@"CallPressed"];
    }
    else
    {
        [moreCell.callButton setImage:[UIImage imageNamed:@"Callsgrey"] forState:UIControlStateNormal];
        moreCell.callLabel.text = @"NO";
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
        
        NSURL *url;//=[NSURL URLWithString:[urlplist valueForKey:@"singup"]];
        NSString *  urlStr=[urlplist valueForKey:@"savepicture"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *postid= @"postid";
        NSString *postidVal = postIDValue;
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *indexid= @"indexid";
        NSString *indexidVal =[NSString stringWithFormat:@"%d",indexCount];
        
        
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
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_Media = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_Media)
            {
                webData_Media =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }

    
    
}




-(void)CreatePostConnection
{
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error)
    {
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
        if ([ResultString isEqualToString:@"done"])
        {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Your post has been successfully created and posted on the platform. Thank-you!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                           
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
                [Array_mediaTypeId addObject:[Array_Media objectAtIndex:0]];
            
            
            
            [self.tableView reloadData];
            
                
        
            
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
        NSString *postidVal =[defaults valueForKey:@"postid"];
        
        NSString *media= @"media";
        NSString *mediaVal =encodedImage;
        
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
                                                     
                                                     
                                                     if (Array_RemovePicture.count !=0)
                                                     {
                                                         NSInteger serverid = [[[Array_RemovePicture objectAtIndex:0]valueForKey:@"indexid"] integerValue];
                                                         [ImageId removeObjectAtIndex:serverid];
                                                         [self.tableView reloadData];

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

@end

/*
 case 0:
 {
 imageCell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
 
 [imageCell.galleryButton  addTarget:self action:@selector(galleryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
 
 
 CGRect workingFrame =  imageCell.scrollView.frame;
 workingFrame.origin.x = 0;
 x =880;
 
 //[imageCell.scrollView setPagingEnabled:YES];
 [imageCell.scrollView setContentOffset:CGPointMake(1000-375, 0)];
 [imageCell.scrollView setContentSize:CGSizeMake(1000, workingFrame.size.height)];
 for (int i=1; i<=count; i++)
 {
 
 imageView=[[UIImageView alloc]init];
 imageView.frame=CGRectMake(x,0, 100, imageCell.scrollView.frame.size.height);
 //                imageView.image = chosenImage;
 // [imageView setContentMode:UIViewContentModeScaleAspectFit];
 [imageCell.scrollView addSubview:imageView];
 // [imageCell.contentView addSubview:imageView];
 [imageCell.contentView bringSubviewToFront:imageView];
 
 x -= 110;
 
 }
 imageView.image = chosenImage;
 //            UIImageView *imageView=[[UIImageView alloc]init];
 //            imageView.frame=workingFrame; //CGRectMake(375-100,0, 100, imageCell.scrollView.frame.size.height);
 //            imageView.image = chosenImage;
 //           // [imageView setContentMode:UIViewContentModeScaleAspectFit];
 //
 //            [imageCell.scrollView addSubview:imageView];
 //           // [imageCell.contentView addSubview:imageView];
 //            [imageCell.contentView bringSubviewToFront:imageView];
 
 
 return imageCell;
 }
 break;
 
 //            NSInteger sliderVal=[[NSString stringWithFormat:@"%@",[defaults valueForKey:@"slival"]]integerValue];
 //            moreCell.slider.value = sliderVal;
 //            moreCell.currentDays_Label.text = [defaults valueForKey:@"slival"];
 //            CGRect trackRect = [moreCell.slider trackRectForBounds:moreCell.slider.bounds];
 //            CGRect thumbRect = [moreCell.slider thumbRectForBounds:moreCell.slider.bounds
 //                                                         trackRect:trackRect
 //                                                             value:moreCell.slider.value];
 //            moreCell.currentDays_Label.center = CGPointMake(thumbRect.origin.x + moreCell.slider.frame.origin.x + 14,  moreCell.slider.frame.origin.y - 10);
 
 // Get the data for the image
 NSData* imageData = UIImageJPEGRepresentation(chosenImage, 1.0);
 
 
 // Give a name to the file
 NSString* incrementedImgStr = [NSString stringWithFormat: @"UserCustomPotraitPic%ld.jpg", (long)count];
 
 
 NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString* documentsDirectory = [paths objectAtIndex:0];
 
 // Now we get the full path to the file
 NSString* fullPathToFile2 = [documentsDirectory stringByAppendingPathComponent:incrementedImgStr];
 
 // and then we write it out
 [imageData writeToFile:fullPathToFile2 atomically:YES];
 
 
 
 
 //finding unique string
	$characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
	$string = '';
	$max = strlen($characters) - 1;
	for ($i = 0; $i <4; $i++) {
 $string.= $characters[mt_rand(0, $max)];
 }
 
 $postid = "M".date('Y').date('m').date('d').date('H').date('i').date('s').$string;
 //echo $userid;
 
 When a user creates a post, create a unique postid which remains with him till he presses the cancel button.
 
 If he creates another post, a new postid is generated which is used to send to php server.
 
 You can use above code in obj-c to create unique postid..
 

 */
