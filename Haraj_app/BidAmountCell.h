//
//  BidAmountCell.h
//  Haraj_app
//
//  Created by Spiel on 09/05/17.
//  Copyright © 2017 udaysinh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidAmountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *makeOfferButton;

- (IBAction)makeOfferAction:(id)sender;

@end
