//
//  CDTViewController.h
//  Core Data Test
//
//  Created by Jinyoung Kim on 6/23/12.
//  Copyright (c) 2012 Jinyoung Kim. All rights reserved.
//

@interface CDTViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberOfFetchesField;
@property (weak, nonatomic) IBOutlet UISwitch *randomizeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *regularTimer;
@property (weak, nonatomic) IBOutlet UILabel *templateTimer;
@property (weak, nonatomic) IBOutlet UILabel *cacheTimer;
@property (weak, nonatomic) IBOutlet UILabel *indexedTimer;
@property (weak, nonatomic) IBOutlet UILabel *templateIndexedTimer;

- (IBAction)reloadData:(id)sender;
- (IBAction)runFetches:(id)sender;

@end
