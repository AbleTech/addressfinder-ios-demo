//
//  AFAutoComplete.m
//  AFAutoCompleteDemo
//
//  Created by Sean Arnold on 5/05/15.
//  Copyright (c) 2015 Abletech. All rights reserved.
//

#import "AFAutoComplete.h"

@implementation AFAutoComplete

//Private declaration of UITableViewController that will present the results in a popover depending on the search query typed by the user.
UITableViewController *results;
UITableViewController *tableViewController;
NSString *afKey;
NSString *afSecret;
NSString *pxid;

//Private declaration of NSArray that will hold the data supplied by the user for showing results in search popover.
NSArray *data;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"AddressFinder" ofType:@"plist"];
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        afKey = [plistDict objectForKey:@"addressFinderKey"];
        afSecret = [plistDict objectForKey:@"addressFinderSecret"];
    }
    return self;
}

- (void)initialize
{
    self.borderStyle = UITextBorderStyleRoundedRect;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeWithNotification:)
                                                 name:UITextFieldTextDidChangeNotification object:self];
}

- (void)textFieldDidChangeWithNotification:(NSNotification *)aNotification
{
    if(aNotification.object == self){
        [self reloadData];
    }
}

- (void)reloadData
{
    if (self.text.length > 0 && self.isFirstResponder) {
        //User entered some text in the textfield. Check if the delegate has implemented the required method of the protocol. Create a popover and show it around the AFAutoComplete.
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Background work
            NSString *txt = self.text;
            NSString *unEncodedUrl = [NSString stringWithFormat:@"%@%@&key=%@&secret=%@", @"https://api.addressfinder.nz/api/address?format=json&q=", txt, afKey, afSecret];
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
                NSArray *completions = [dictionary valueForKey:@"completions"];
                for (NSDictionary *result in completions) {
                    NSDictionary *autoComResult = nil;
                    autoComResult = @{
                                      @"DisplayText" :[result valueForKey:@"a"],
                                      @"DisplaySubText":[result valueForKey:@"pxid"]
                                      };
                    [results addObject:autoComResult];
                }
                
            }
            data = results;
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update UI
                [self provideSuggestions];
            });
        });
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.text.length > 0 && self.isFirstResponder) {
    }
    else{
        //No text entered in the textfield. If -textFieldShouldSelect is YES, select the first row from results using -handleExit method.tableView and set the displayText on the text field. Check if suggestions view is visible and dismiss it.
        if ([tableViewController.tableView superview] != nil) {
            [tableViewController.tableView removeFromSuperview];
        }
    }
}

//Override UITextField -resignFirstResponder method to ensure the 'exit' is handled properly.
- (BOOL)resignFirstResponder
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         [tableViewController.tableView setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                         [tableViewController.tableView removeFromSuperview];
                         tableViewController = nil;
                     }];
    [self handleExit];
    return [super resignFirstResponder];
}

//This method checks if a selection needs to be made from the suggestions box using the delegate method -textFieldShouldSelect. If a user doesn't tap any search suggestion, the textfield automatically selects the top result. If there is no result available and the delegate method is set to return YES, the textfield will wrap the entered the text in a NSDictionary and send it back to the delegate with 'CustomObject' key set to 'NEW'
- (void)handleExit
{
    [tableViewController.tableView removeFromSuperview];
    if (self.text.length > 0){
        //Make sure that delegate method is not called if no text is present in the text field.
        if ([[self delegate] respondsToSelector:@selector(textField:didEndEditingWithSelection:)]) {
            [[self delegate] textField:self didEndEditingWithSelection:[NSDictionary dictionaryWithObjectsAndKeys:self.text,@"address",pxid,@"pxid", nil]];
        }
        else{
            NSLog(@"<AFAutoComplete> WARNING: You have not implemented a method from AFAutoCompleteDelegate that is called back when the user selects a search suggestion.");
        }
    }

}


#pragma mark UITableView DataSource & Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [data count];
    if (count == 0) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             [tableViewController.tableView setAlpha:0.0];
                         }
                         completion:^(BOOL finished){
                             [tableViewController.tableView removeFromSuperview];
                             tableViewController = nil;
                         }];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AFAutoCompleteResultsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dataForRowAtIndexPath = [data objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor clearColor]];
    [[cell textLabel] setText:[dataForRowAtIndexPath objectForKey:@"DisplayText"]];
    if ([dataForRowAtIndexPath objectForKey:@"DisplaySubText"] != nil) {
//        [[cell detailTextLabel] setText:[dataForRowAtIndexPath objectForKey:@"DisplaySubText"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.text = [[data objectAtIndex:indexPath.row] objectForKey:@"DisplayText"];
    pxid = [[data objectAtIndex:indexPath.row] objectForKey:@"DisplaySubText"];
    [self resignFirstResponder];
}

#pragma mark Popover Method(s)

- (void)provideSuggestions
{
    // Reset pxid to nil
    pxid = nil;
    //Providing suggestions
    if (tableViewController.tableView.superview == nil && [data count] > 0) {
        //Add a tap gesture recogniser to dismiss the suggestions view when the user taps outside the suggestions view
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [tapRecognizer setCancelsTouchesInView:NO];
        [tapRecognizer setDelegate:self];
        [self.superview addGestureRecognizer:tapRecognizer];
        
        tableViewController = [[UITableViewController alloc] init];
        [tableViewController.tableView setDelegate:self];
        [tableViewController.tableView setDataSource:self];
        if (self.backgroundColor == nil) {
            //Background color has not been set by the user. Use default color instead.
            [tableViewController.tableView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
        }
        else{
            [tableViewController.tableView setBackgroundColor:self.backgroundColor];
        }
        
        [tableViewController.tableView setSeparatorColor:self.seperatorColor];
        if (self.popoverSize.size.height == 0.0) {
            //PopoverSize frame has not been set. Use default parameters instead.
            CGRect frameForPresentation = [self frame];
            frameForPresentation.origin.y += self.frame.size.height;
            frameForPresentation.size.height = 200;
            [tableViewController.tableView setFrame:frameForPresentation];
        }
        else{
            [tableViewController.tableView setFrame:self.popoverSize];
        }
        [[self superview] addSubview:tableViewController.tableView];
        tableViewController.tableView.alpha = 0.0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             [tableViewController.tableView setAlpha:1.0];
                         }
                         completion:^(BOOL finished){
                             
                         }];
        
        
    }
    else{
        [tableViewController.tableView reloadData];
    }
}

- (void)tapped:(UIGestureRecognizer *)gesture
{
    [super resignFirstResponder];
}


@end