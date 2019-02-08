//
//  EGBDummyTableViewController.m
//  33_34FileManagerTest
//
//  Created by Eduard Galchenko on 2/7/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBDummyTableViewController.h"

@interface EGBDummyTableViewController ()

@end

@implementation EGBDummyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"prepareForSegue: %@", segue.identifier);
}


@end
