//
//  MainViewController.h
//  AFAutoCompleteDemo
//
//  Created by Sean Arnold on 5/05/15.
//  Copyright (c) 2015 Abletech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAutoComplete.h"

@interface MainViewController : UIViewController <AFAutoCompleteDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet AFAutoComplete *afTextField;

@property (weak, nonatomic) IBOutlet UILabel *postalLine1;
@property (weak, nonatomic) IBOutlet UILabel *postalLine2;
@property (weak, nonatomic) IBOutlet UILabel *postalLine3;
@property (weak, nonatomic) IBOutlet UILabel *meshblock;
@end
