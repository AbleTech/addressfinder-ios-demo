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

- (void)textField:(AFAutoComplete *)textField didEndEditingWithSelection:(NSDictionary *)result
{
    // Here you are provided with a dictionary that contains:
    // the full address
    // the pxid of the adddress
    
    // An example of future use could be to call the AddressFinder Address Info API to receive address line data,
    // or x & y coordinates etc. https://addressfinder.nz/docs/address_info_api/
    __block NSDictionary *addressData = @{};
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // sync code
        addressData = [self getAFAddressInfo:[result objectForKey:@"pxid"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            self.postalLine1.text = [addressData objectForKey:@"postal_line_1"];
            self.postalLine2.text = [addressData objectForKey:@"postal_line_2"];
            self.postalLine3.text = [addressData objectForKey:@"postal_line_3"];
            self.meshblock.text = [addressData objectForKey:@"meshblock"];
            
            self.postalLine1.hidden = FALSE;
            self.postalLine2.hidden = FALSE;
            self.postalLine3.hidden = FALSE;
            self.meshblock.hidden = FALSE;
        });
    });

    
}

- (NSDictionary *)getAFAddressInfo:(NSString *)pxid
{
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"AddressFinder" ofType:@"plist"];
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSString *afKey = [plistDict objectForKey:@"addressFinderKey"];
    NSString *afSecret = [plistDict objectForKey:@"addressFinderSecret"];
    
    NSDictionary* data = @{};
    
    // Background work
    NSString *unEncodedUrl = [NSString stringWithFormat:@"%@%@&key=%@&secret=%@", @"https://api.addressfinder.nz/api/address/info?format=json&pxid=", pxid, afKey, afSecret];
    NSString* url = [unEncodedUrl stringByAddingPercentEscapesUsingEncoding:
                     NSUTF8StringEncoding];
    // Send a synchronous request
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSLog(@"<AFAutoComplete calling API %@", url);
    NSData * responseData = [NSURLConnection sendSynchronousRequest:urlRequest
                                                  returningResponse:&response
                                                              error:&error];
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:@[]];
    if (error == nil)
    {
        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parseError];
        NSLog(@"Results were %@", dictionary);
            data = dictionary;
    }

    return data;
}
@end
