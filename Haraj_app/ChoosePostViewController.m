//
//  ChoosePostViewController.m
//  Haraj_app
//
//  Created by Spiel on 21/06/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "ChoosePostViewController.h"
#import "FavTableViewCell.h"
#import "SBJsonParser.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "EnterPrice.h"
#import "AFNetworking.h"
#import "UIView+RNActivityView.h"

@interface ChoosePostViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    FavTableViewCell *FavouriteCell;
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    NSURLConnection *Connection_ViewPost;
    NSMutableData *webData_ViewPost;
    NSMutableArray *Array_ViewPost, *Array_ItemSold;
    
    EnterPrice *myCustomXIBViewObj;
    
    NSString *paymentmodeStr ,*postIdVal;
    
    UIActivityIndicatorView *activityindicator;
    
    
}

@end

@implementation ChoosePostViewController
@synthesize labelheding,backbutton,Button_help,view_line;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.view.frame.size.width==375 && self.view.frame.size.height==812)
    {
        
         [view_line setFrame:CGRectMake(view_line.frame.origin.x, view_line.frame.origin.y+
                                        6, view_line.frame.size.width, 1)];
        [labelheding setFrame:CGRectMake(labelheding.frame.origin.x, labelheding.frame.origin.y+16, labelheding.frame.size.width, 26)];
        
        [backbutton setFrame:CGRectMake(backbutton.frame.origin.x, backbutton.frame.origin.y+16, backbutton.frame.size.width, 30)];
          [Button_help setFrame:CGRectMake(Button_help.frame.origin.x, Button_help.frame.origin.y+16, Button_help.frame.size.width, 30)];
    }
    
    defaults = [[NSUserDefaults alloc]init];
   
    
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Hide_Popover) name:@"HidePopOver" object:nil];
    
    activityindicator = [[UIActivityIndicatorView alloc]init];
    activityindicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhiteLarge;
    activityindicator.color = [UIColor grayColor] ;
    [activityindicator startAnimating];
    activityindicator.center = self.view.center;
    [self.view addSubview:activityindicator];
    
    
    [self viewPostConnection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return Array_ViewPost.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * str=@"CellFav";
//    FavouriteCell=(FavTableViewCell*)[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
//    
    FavouriteCell = [tableView dequeueReusableCellWithIdentifier:@"CellFav"];
    
    NSDictionary *dic_request=[Array_ViewPost objectAtIndex:indexPath.row];
    
    
    FavouriteCell.postImageView.layer.cornerRadius = 10;
    FavouriteCell.postImageView.layer.masksToBounds = YES;
    
    FavouriteCell.postIdLabel.text = [NSString stringWithFormat:@"%@%@",[dic_request valueForKey:@"postid"],@" :رقم الإعلان"];//POST ID     [NSString stringWithFormat:@"POST ID:%@",[dic_request valueForKey:@"postid"]] ;
    FavouriteCell.durationLabel.text = [dic_request valueForKey:@"postdur"];
    FavouriteCell.titleLabel.text = [dic_request valueForKey:@"title"];
    
    
    NSURL * url=[NSURL URLWithString:[dic_request valueForKey:@"mediathumbnailurl"]];
    [FavouriteCell.postImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultpostimg.jpg"]];
    
    
    
    
    
    
    
    return FavouriteCell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[UIScreen mainScreen]bounds].size.width ==320)
    {
        return 89;
    }
    else if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        return 113;
    }
    else
    {
        return 103;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
      //[[Array_ViewPost  valueForKey:@"postid"]objectAtIndex:indexPath.row]];
    
    transparentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    transparentView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    
    //    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"EnterPrice" owner:self options:nil];
    //    UIView *myView = [nibContents objectAtIndex:0];
    
    myCustomXIBViewObj =[[[NSBundle mainBundle] loadNibNamed:@"EnterPrice" owner:self options:nil]objectAtIndex:0];
    
    myCustomXIBViewObj.frame = CGRectMake((self.view.frame.size.width- myCustomXIBViewObj.frame.size.width)/2,self.view.frame.size.width - 250, myCustomXIBViewObj.frame.size.width, myCustomXIBViewObj.frame.size.height);
    
    
    [self.view addSubview:myCustomXIBViewObj];
    
    [myCustomXIBViewObj.bankButton addTarget:self action:@selector(bankButton_Action:) forControlEvents:UIControlEventTouchUpInside];
    [myCustomXIBViewObj.creditButton addTarget:self action:@selector(creditButton_Action:) forControlEvents:UIControlEventTouchUpInside];
    
    [myCustomXIBViewObj.priceTextField addTarget:self action:@selector(enterInLabel ) forControlEvents:UIControlEventEditingChanged];
    
    myCustomXIBViewObj.priceTextField.delegate = self;
    [myCustomXIBViewObj.priceTextField becomeFirstResponder];
    myCustomXIBViewObj.postIdLabel.text =[NSString stringWithFormat:@"%@%@",[[Array_ViewPost  valueForKey:@"postid"]objectAtIndex:indexPath.row],@" :رقم الإعلان"];//POST ID  [NSString stringWithFormat:@"POST ID: %@",[[Array_ViewPost  valueForKey:@"postid"]objectAtIndex:indexPath.row]];
    
    postIdVal =[[Array_ViewPost  valueForKey:@"postid"]objectAtIndex:indexPath.row];
    
    
    myCustomXIBViewObj.layer.cornerRadius = 10;
    myCustomXIBViewObj.clipsToBounds = YES;
    
    [myCustomXIBViewObj setUserInteractionEnabled:YES];
    UITapGestureRecognizer *viewTapped =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped_Action:)];
    [myCustomXIBViewObj addGestureRecognizer:viewTapped];
    
    [transparentView addSubview:myCustomXIBViewObj];
    [self.view addSubview:transparentView];
    
    
    myCustomXIBViewObj.bankButton.enabled = NO;
    [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
    
    myCustomXIBViewObj.creditButton.enabled = NO;
    [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
    
    if ([[UIScreen mainScreen]bounds].size.width == 414)
    {
        [myCustomXIBViewObj.bankButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -212)];
        [myCustomXIBViewObj.creditButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, -176)];
    }
    else
    {
        
    }

    

}

-(void)enterInLabel
{
//    NSString *askingpriceValString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
//    askingpriceValString = [askingpriceValString substringFromIndex:1];
    
    NSString *askingpriceValString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
    askingpriceValString = [askingpriceValString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];
    
    float j = [askingpriceValString floatValue];
    
    float k = ((1*j)/100); //0.75 instead of 1
    
    myCustomXIBViewObj.caculatedAmountLabel.text =[NSString stringWithFormat:@"ر.س %0.2f",k]; //[NSString stringWithFormat:@"$ %@",askingpriceValString];//$
    
    if ([myCustomXIBViewObj.priceTextField.text isEqualToString:@"ر.س"])//$
    {
        
        myCustomXIBViewObj.bankButton.enabled = NO;
        [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
        myCustomXIBViewObj.creditButton.enabled = NO;
        [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
        
    }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (myCustomXIBViewObj.priceTextField.text.length == 0)
    {
        myCustomXIBViewObj.priceTextField.text = @"ر.س";//$
        
    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [myCustomXIBViewObj.priceTextField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![newText hasPrefix:@"ر.س"])//$
    {
        
        myCustomXIBViewObj.bankButton.enabled = NO;
        [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor grayColor]];
        myCustomXIBViewObj.creditButton.enabled = NO;
        [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor grayColor]];
        
        
        return NO;
    }
    
    myCustomXIBViewObj.bankButton.enabled = YES;
    [myCustomXIBViewObj.bankButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    myCustomXIBViewObj.creditButton.enabled = YES;
    [myCustomXIBViewObj.creditButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:144/255.0 blue:48/255.0 alpha:1]];
    
    
    
    // Default:
    
    NSLog(@"%lu",textField.text.length);
    
    return YES;
    
}

-(void)bankButton_Action:(id)sender
{
    paymentmodeStr = @"BANK";
    
   // [self ItemSold_Connection];
    NSLog(@"Bank button Pressed");
    [self.view endEditing:YES];
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Bank Details" message:@"Please transfer the amount to the below bank details:\n\nBank name: ABC Bank\nBank branch: JVPD\nIFSC Code : 123ABC\nAccount No.:7894123415487\n\nPlease mail us the reference no. to support@tammapp.com once you have made the payment.\n\nAre you sure you wish to make payment?"preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                {
                                    [self.view showActivityViewWithLabel:@"Making payment..."];
                                    [self ItemSold_Connection];
                                  //  [defaults setObject:@"yes" forKey:@"refreshView"];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                   
                                   
                               }];
    
    
    [alert addAction:yesButton];
    [alert addAction:noButton];

    [self presentViewController:alert animated:YES completion:nil];
    
    
}
-(void)creditButton_Action:(id)sender
{
   // [defaults setObject:@"yes" forKey:@"refreshView"];
    [self.view showActivityViewWithLabel:@"Making payment..."];
    [self.view endEditing:YES];
    paymentmodeStr = @"CARD";
    [self ItemSold_Connection];
    NSLog(@"creditButton_Action Pressed");
    
}

- (void)Hide_Popover
{
    transparentView.hidden= YES;
}

-(void)viewTapped_Action:(UIGestureRecognizer *)reconizer
{
    [self.view endEditing:YES];
}

#pragma mark - ItemSold Connection
-(void)ItemSold_Connection
{
    
    NSString *postid= @"postid";
   // NSString *postidVal =;
    
    NSString *userid= @"userid";
    NSString *useridVal =[defaults valueForKey:@"userid"];
    
    
    
//    NSString *enterPriceString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
//    enterPriceString = [enterPriceString substringFromIndex:1];
    NSString *enterPriceString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.priceTextField.text];
    enterPriceString = [enterPriceString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];
    
    NSInteger number = [enterPriceString intValue];
    
    NSString *price= @"sellprice";
    NSString *priceVal = [NSString stringWithFormat:@"%ld",number];
    
    
//    NSString *transactionString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.caculatedAmountLabel.text];
//    transactionString = [transactionString substringFromIndex:1];
    NSString *transactionString = [NSString stringWithFormat:@"%@",myCustomXIBViewObj.caculatedAmountLabel.text];
    transactionString = [transactionString stringByReplacingOccurrencesOfString:@"ر.س" withString:@""];
    
    NSString *transaction= @"commission";
    NSString *transactionVal = transactionString;
    
    NSString *paymentmode= @"paymentmode";
    NSString *paymentmodeVal = paymentmodeStr;
    
    
    
    
    NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",postid,postIdVal,userid,useridVal,price,priceVal,transaction,transactionVal,paymentmode,paymentmodeVal];
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"payfee"];
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
                                                 
                                                 Array_ItemSold=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                 Array_ItemSold =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"Array_ItemSold %@",Array_ItemSold);
                                                 
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
//                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerData" object:self userInfo:nil];
                                                     
                                                     [self.view endEditing:YES];
                                                     transparentView.hidden= YES;
                                                     
                                                     [self viewPostConnection];
                                                     
                                                     
//                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewEnable" object:self userInfo:nil];
                                                     
//                                                     CATransition *transition = [CATransition animation];
//                                                     transition.duration = 0.3;
//                                                     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//                                                     transition.type = kCATransitionPush;
//                                                     transition.subtype = kCATransitionFromRight;
//                                                     [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//                                                     
//                                                     [self.navigationController popToRootViewControllerAnimated:YES];
//                                                     
                                                     
                                                     
                                                     
                                                 }
                                                 if ([ResultString isEqualToString:@"inserterror"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"The server encountered some error, please try again." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"nopostid"])
                                                 {
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"This item is no more available and has probably been sold by the seller." preferredStyle:UIAlertControllerStyleAlert];
                                                     
                                                     UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:nil];
                                                     [alertController addAction:actionOk];
                                                     [self presentViewController:alertController animated:YES completion:nil];
                                                     
                                                     
                                                     
                                                 }
                                                 
                                                 if ([ResultString isEqualToString:@"nullerror"])
                                                 {
                                                     
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Please enter the price at which the item has been sold." preferredStyle:UIAlertControllerStyleAlert];
                                                     
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







//---------------------------------------------&&&&&&&&&&&&&&&&&&&&&___------------------------------------------------
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0)
    {
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
}

-(void)viewPostConnection
{
    
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
        NSString *  urlStr=[urlplist valueForKey:@"viewpost"];
        url =[NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];//Web API Method
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        
        
        NSString *userid= @"userid";
        NSString *useridVal =[defaults valueForKey:@"userid"];
        
        NSString *location= @"location";
        NSString *locationVal = @"OFF";
        
        NSString *myposts= @"myposts";
        NSString *mypostsVal = @"FEE";
        
        
        NSString *city= @"city";
        NSString *cityVal = [defaults valueForKey:@"Cityname"];
        
        NSString *country= @"country";
        NSString *countryVal = [defaults valueForKey:@"Countryname"];;
        
        NSString *reqStringFUll=[NSString stringWithFormat:@"%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",userid,useridVal,location,locationVal,city,cityVal,country,countryVal,myposts,mypostsVal];
        
        
        //converting  string into data bytes and finding the lenght of the string.
        NSData *requestData = [NSData dataWithBytes:[reqStringFUll UTF8String] length:[reqStringFUll length]];
        [request setHTTPBody: requestData];
        
        Connection_ViewPost = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        {
            if( Connection_ViewPost)
            {
                webData_ViewPost =[[NSMutableData alloc]init];
                
                
            }
            else
            {
                NSLog(@"theConnection is NULL");
            }
        }
        
    }
    
}

#pragma mark - NSURL CONNECTION Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"connnnnnnnnnnnnnn=%@",connection);
    
    if(connection==Connection_ViewPost)
    {
        [webData_ViewPost setLength:0];
        
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(connection==Connection_ViewPost)
    {
        [webData_ViewPost appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection==Connection_ViewPost)
    {
        
        Array_ViewPost=[[NSMutableArray alloc]init];
        SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
        Array_ViewPost=[objSBJsonParser objectWithData:webData_ViewPost];
        NSString * ResultString=[[NSString alloc]initWithData:webData_ViewPost encoding:NSUTF8StringEncoding];
        //  Array_LodingPro=[NSJSONSerialization JSONObjectWithData:webData_LodingPro options:kNilOptions error:nil];
        
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSLog(@"cc %@",Array_ViewPost);
        NSLog(@"count= %lu",(unsigned long)Array_ViewPost.count);
        NSLog(@"registration_status %@",[[Array_ViewPost objectAtIndex:0]valueForKey:@"registration_status"]);
        NSLog(@"ResultString %@",ResultString);
        
        if ([ResultString isEqualToString:@"done"])
        {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Successfully Posted Post" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil];
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
        activityindicator.hidden = YES;
        [activityindicator stopAnimating];
        
        
        
    }
    
    [self.tableView reloadData];
}






- (IBAction)InfoButton_Action:(id)sender
{
    
    NSLog(@"InfoButton_Action Pressed");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"دفع الرسوم" message:@"بمجرد بيع سلعتك عن طريق تطبيق تم، الرجاء دفع ١٪‏ رسوم البيع من قيمة السلعة لتطبيق تم عن طريق بطاقة الائتمان او التحويل البنكي." preferredStyle:UIAlertControllerStyleAlert];

//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pay Fee" message:@"Once you sucessfully sell your item to a buyer, please pay a nominal 1% transaction fee to Tamm via Credit card or Bank Transfer." preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)BackButton_Action:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
