//
//  SearchViewController.m
//  Haraj_app
//
//  Created by Spiel on 21/07/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "SBJsonParser.h"
#import "SearchCollectionViewController.h"
#import "AFNetworking.h"
#import "UIViewController+KeyboardAnimation.h"
@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    SearchTableViewCell *searchCell;
    NSUserDefaults * defaults;
    
    NSDictionary *urlplist;
    
    NSMutableDictionary *dict_Array;
    
    NSMutableArray *Array_1, *Array_2;
    
    UIView *sectionView;
    CGFloat tableview_height;
}

@end

@implementation SearchViewController

@synthesize initialTitles,filteredTitles,Button_Back,Button_Cancel,searchTextField,Img_Search,view_line;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults = [[NSUserDefaults alloc]init];
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"UrlName" ofType:@"plist"];
    urlplist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
   // initialTitles = [[NSMutableArray alloc]initWithObjects:@"Cars",@"Electronics", nil ];
    if (self.view.frame.size.width==375 && self.view.frame.size.height==812)
    {
         [view_line setFrame:CGRectMake(view_line.frame.origin.x, view_line.frame.origin.y+6, view_line.frame.size.width, 1)];
        [searchTextField setFrame:CGRectMake(searchTextField.frame.origin.x, searchTextField.frame.origin.y+17, searchTextField.frame.size.width, 35)];
        [Button_Cancel setFrame:CGRectMake(Button_Cancel.frame.origin.x, Button_Cancel.frame.origin.y+13, Button_Cancel.frame.size.width, 20)];
        [Button_Back setFrame:CGRectMake(Button_Back.frame.origin.x, Button_Back.frame.origin.y+16, Button_Back.frame.size.width, 30)];
        [Img_Search setFrame:CGRectMake(Img_Search.frame.origin.x, Img_Search.frame.origin.y+13, Img_Search.frame.size.width, 22)];
    }
    Button_Cancel.hidden = YES;
   
    tableview_height=self.tableView.frame.size.height;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10,searchTextField.frame.size.height)];
    searchTextField.rightView = paddingView;
    searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,36,22)];
    searchTextField.leftView = paddingView1;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
     searchTextField.delegate=self;
    [self searchCategoriesConnection];
    
    
}
- (void)subscribeToKeyboard
{
    [self an_subscribeKeyboardWithAnimations:^(CGRect keyboardRect, NSTimeInterval duration, BOOL isShowing) {
        if (isShowing)
        {
          
           
                [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, self.view.frame.size.width, tableview_height-keyboardRect.size.height)];
           
            
            
        } else
        {
           
            [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, self.view.frame.size.width,tableview_height)];
        }
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self an_unsubscribeKeyboard];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.hidden = NO;
    [self subscribeToKeyboard];
     [self searchCategoriesConnection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return initialTitles.count;
   
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str=@"SearchCell";
    searchCell =(SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    
    

    searchCell.titleLabel.text=[[initialTitles objectAtIndex:indexPath.row]valueForKey:@"name"];
    
    return searchCell;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchCollectionViewController * searchCollection=[mainStoryboard instantiateViewControllerWithIdentifier:@"SearchCollectionViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
  //  searchCollection.rowTapCategory = [initialTitles objectAtIndex:indexPath.row];
    searchCollection.initialTitles=[initialTitles objectAtIndex:indexPath.row];
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:searchCollection animated:YES];
    
    NSLog(@"Selected Index= %lditem",(long)indexPath.row);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 44;
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];
        [sectionView setBackgroundColor:[UIColor whiteColor]];
        UILabel * Label1=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, self.view.frame.size.width-40, sectionView.frame.size.height-5)];
        Label1.backgroundColor=[UIColor clearColor];
        Label1.textColor=[UIColor lightGrayColor];
        Label1.font=[UIFont fontWithName:@"SanFranciscoDisplay-Medium" size:15.0f];
        Label1.text=@"All Categories";
        Label1.textAlignment = NSTextAlignmentRight;
        [sectionView addSubview:Label1];
        sectionView.tag=section;
        
    }
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
    
    return 45;
    }
    
    return 0;
    
}




- (IBAction)SearchEditing_Action:(id)sender
{
    
    if (searchTextField.text.length == 0)
        
    {
        Button_Cancel.hidden = YES;
        Button_Back.hidden = NO;
        self.tableView.hidden = NO;
        
    }
    
    else
    {
        Button_Cancel.hidden = NO;
        Button_Back.hidden = YES;
        
        self.tableView.hidden = YES;
        
        
        
    }
 

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == searchTextField)
    {
        [searchTextField resignFirstResponder];
    }
    
    Button_Cancel.hidden = YES;
    Button_Back.hidden = NO;
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchCollectionViewController * searchCollection=[mainStoryboard instantiateViewControllerWithIdentifier:@"SearchCollectionViewController"];
   
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    
    searchCollection.searchTextEnter = self.searchTextField.text;
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:searchCollection animated:YES];
    
    
    
    NSLog(@"Search Action");
    
    searchTextField.text = nil;
    
    return YES;
}




- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)searchCategoriesConnection
{
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate: nil delegateQueue: [NSOperationQueue mainQueue]];

    NSURL *url;
    NSString *  urlStrLivecount=[urlplist valueForKey:@"searchcategories"];;
    url =[NSURL URLWithString:urlStrLivecount];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];//Web API Method
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
 
    
    
    
    NSURLSessionDataTask *dataTask =[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                     {
                                         
                                         if(data)
                                         {
                                             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                             NSInteger statusCode = httpResponse.statusCode;
                                             if(statusCode == 200)
                                             {
                                                 
                                                 initialTitles=[[NSMutableArray alloc]init];
                                                 
                                                // NSMutableArray * initialTitles1=[[NSMutableArray alloc]init];
                                                 SBJsonParser *objSBJsonParser = [[SBJsonParser alloc]init];
                                                  initialTitles =[objSBJsonParser objectWithData:data];
                                                 
                                                 //initialTitles1 =[objSBJsonParser objectWithData:data];
                                                 
                                                 
                                                 
                                                 NSString * ResultString=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                 
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                 ResultString = [ResultString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                 
                                                 NSLog(@"initialTitles %@",initialTitles);
                                                 
                                                 
                                                 [self.tableView reloadData];

                                                 
                                                 if ([ResultString isEqualToString:@"done"])
                                                 {
                                                     
                                                     
                                                     
                                                     
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

- (IBAction)CancelButton_Action:(id)sender
{
    [self.view endEditing:YES];
    searchTextField.text = nil;
    Button_Cancel.hidden = YES;
    Button_Back.hidden = NO;
    self.tableView.hidden = NO;
    
}

@end
