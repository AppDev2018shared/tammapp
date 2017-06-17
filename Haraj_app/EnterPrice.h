//
//  EnterPrice.h
//  Haraj_app
//
//  Created by Spiel on 12/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnterPrice : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *postIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *caculatedAmountLabel;

@property (weak, nonatomic) IBOutlet UIButton *creditButton;
@property (weak, nonatomic) IBOutlet UIButton *bankButton;

@end
