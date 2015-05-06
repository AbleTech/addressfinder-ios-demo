//
//  MainViewController.m
//  AFAutoCompleteDemo
//
//  Created by Sean Arnold on 5/05/15.
//  Copyright (c) 2015 Abletech. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.afTextField setDelegate:self];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)textField:(AFAutoComplete *)textField didEndEditingWithSelection:(NSDictionary *)result {
    // Here you are provided with a dictionary that contains:
    // the full address
    // the pxid of the adddress
    
    // An example of future use could be to call the AddressFinder Address Info API to receive address line data,
    // or x & y coordinates etc. https://addressfinder.nz/docs/address_info_api/
    
}
@end
