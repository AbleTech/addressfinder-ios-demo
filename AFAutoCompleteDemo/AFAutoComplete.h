//
//  AFAutoComplete.h
//  AFAutoCompleteDemo
//
//  Created by Sean Arnold on 5/05/15.
//  Copyright (c) 2015 Abletech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFAutoCompleteDelegate;

@interface AFAutoComplete : UITextField <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id <AFAutoCompleteDelegate, UITextFieldDelegate> delegate;

//Set this to override the default color of suggestions popover. The default color is [UIColor colorWithWhite:0.8 alpha:0.9]
@property (nonatomic) UIColor *backgroundColor;

//Set this to override the default frame of the suggestions popover that will contain the suggestions pertaining to the search query. The default frame will be of the same width as textfield, of height 200px and be just below the textfield.
@property (nonatomic) CGRect popoverSize;

//Set this to override the default seperator color for tableView in search results. The default color is light gray.
@property (nonatomic) UIColor *seperatorColor;

@end


@protocol MPGTextFieldDelegate <NSObject>

@optional

//If mandatory selection needs to be made (asked via delegate), this method. It can have the following return values:
//1. If user taps on a row in the search results, it will return the selected NSDictionary object
//2. If the user doesn't tap a row, it will return the first NSDictionary object from the results
//3. If the user doesn't tap a row and there is no search result, it will return a NEW NSDictionary object containing the text entered by the user and the value of 'Custom object' will be set to 'NEW'

- (void)textField:(AFAutoComplete *)textField didEndEditingWithSelection:(NSDictionary *)result;

@end