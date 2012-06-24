//
//  CDTViewController.m
//  Core Data Test
//
//  Created by Jinyoung Kim on 6/23/12.
//  Copyright (c) 2012 Jinyoung Kim. All rights reserved.
//

#import "CDTViewController.h"
#import "SchoolStat.h"
#import "SeedLoader.h"
#include <stdlib.h>


@interface CDTViewController ()

@property (strong, nonatomic) NSNumber *numberOfFetches;
@property (strong, nonatomic) NSNumber *randomize;

@end

@implementation CDTViewController

@synthesize numberOfFetches = _numberOfFetches;
@synthesize randomize = _randomize;

@synthesize numberOfFetchesField = _numberOfFetchesField;
@synthesize randomizeSwitch = _randomizeSwitch;
@synthesize regularTimer = _regularTimer;
@synthesize templateTimer = _templateTimer;
@synthesize cacheTimer = _cacheTimer;
@synthesize indexedTimer = _indexedTimer;
@synthesize templateIndexedTimer = _templateIndexedTimer;

- (id)initWithCoder:(NSCoder *)decoder {
    if(self = [super initWithCoder:decoder]) {
        _numberOfFetches = [NSNumber numberWithInt:90];
        _randomize = [NSNumber numberWithBool:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberOfFetchesField.text = [NSString stringWithFormat:@"%@", self.numberOfFetches];
    self.randomizeSwitch.selected = [self.randomize boolValue];
}

- (void)viewDidUnload {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.numberOfFetches = [numberFormatter numberFromString:self.numberOfFetchesField.text];
    self.randomize = [NSNumber numberWithBool:self.randomizeSwitch.on];
    
    [self setNumberOfFetchesField:nil];
    [self setRandomizeSwitch:nil];
    [self setRegularTimer:nil];
    [self setTemplateTimer:nil];
    [self setCacheTimer:nil];
    [self setIndexedTimer:nil];
    [self setTemplateIndexedTimer:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)reloadData:(id)sender {
    [SeedLoader loadSeed:YES];
}

- (void)runFetches:(id)sender {
    [self.numberOfFetchesField resignFirstResponder];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.numberOfFetches = [numberFormatter numberFromString:self.numberOfFetchesField.text];
    self.randomize = [NSNumber numberWithBool:self.randomizeSwitch.on];
    
    self.regularTimer.text = @"calculating...";
    self.templateTimer.text = @"calculating...";
    self.cacheTimer.text = @"calculating...";
    self.indexedTimer.text = @"calculating...";
    self.templateIndexedTimer.text = @"calculating...";
    
    NSOperationQueue *fetchQueue = [[NSOperationQueue alloc] init];
    fetchQueue.name = @"Fetch Queue";
    fetchQueue.maxConcurrentOperationCount = 1;
    
    [fetchQueue addOperationWithBlock:^{
        NSPersistentStoreCoordinator *coordinator = [CDTManager sharedManager].persistentStore;
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
        [context setStalenessInterval:0];

        NSTimeInterval startTime = CFAbsoluteTimeGetCurrent();
        int totalFound = 0;
        for (int i = 0; i < [self.numberOfFetches intValue]; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"SchoolStat" inManagedObjectContext:context]];
            NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:@"schoolName" ascending:YES selector:nil];
            [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortBy]];
            int mathScore = 526;
            if ([self.randomize boolValue]) {
                mathScore = 300 + (arc4random() % 400);
            }
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mathAverageScore = %d", mathScore];
            [fetchRequest setPredicate:predicate];
            NSFetchedResultsController *fetchResultsController = [[NSFetchedResultsController alloc] 
                                                                  initWithFetchRequest:fetchRequest 
                                                                  managedObjectContext:context
                                                                  sectionNameKeyPath:nil 
                                                                  cacheName:nil];
            NSError *error;
            if ([fetchResultsController performFetch:&error]) {
                totalFound += [fetchResultsController.fetchedObjects count];
            } else {
                NSLog(@"error");
            }
        }
        NSTimeInterval duration = CFAbsoluteTimeGetCurrent() - startTime;
        NSLog(@"FETCH    found:%d time:%f", totalFound, duration);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.regularTimer.text = [NSString stringWithFormat:@"%f", duration];
        }];
    }];

    [fetchQueue addOperationWithBlock:^{
        NSPersistentStoreCoordinator *coordinator = [CDTManager sharedManager].persistentStore;
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
        [context setStalenessInterval:0];

        NSTimeInterval startTime = CFAbsoluteTimeGetCurrent();
        int totalFound = 0;
        for (int i = 0; i < [self.numberOfFetches intValue]; i++) {
            NSManagedObjectModel *model = [CDTManager sharedManager].model;
            int mathScore = 526;
            if ([self.randomize boolValue]) {
                mathScore = 300 + (arc4random() % 400);
            }
            NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mathScore], @"MATH_SCORE", nil];
            NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"FindOnMath" substitutionVariables:substitutionDictionary];
            
            NSError *error;
            NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"error");
            } else {
                totalFound += [results count];
            }
        }
        NSTimeInterval duration = CFAbsoluteTimeGetCurrent() - startTime;
        NSLog(@"TEMPLATE found:%d time:%f", totalFound, duration);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.templateTimer.text = [NSString stringWithFormat:@"%f", duration];
        }];
    }];
    
    [fetchQueue addOperationWithBlock:^{
        NSPersistentStoreCoordinator *coordinator = [CDTManager sharedManager].persistentStore;
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
        [context setStalenessInterval:0];

        NSTimeInterval startTime = CFAbsoluteTimeGetCurrent();
        int totalFound = 0;
        for (int i = 0; i < [self.numberOfFetches intValue]; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"SchoolStat" inManagedObjectContext:context]];
            NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:@"schoolName" ascending:YES selector:nil];
            [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortBy]];
            int mathScore = 526;
            if ([self.randomize boolValue]) {
                mathScore = 300 + (arc4random() % 400);
            }
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mathAverageScore = %d", mathScore];
            [fetchRequest setPredicate:predicate];
            NSFetchedResultsController *fetchResultsController = [[NSFetchedResultsController alloc] 
                                                                  initWithFetchRequest:fetchRequest 
                                                                  managedObjectContext:context
                                                                  sectionNameKeyPath:nil 
                                                                  cacheName:@"find526"];
            NSError *error;
            if ([fetchResultsController performFetch:&error]) {
                totalFound += [fetchResultsController.fetchedObjects count];
            } else {
                NSLog(@"error");
            }
        }
        NSTimeInterval duration = CFAbsoluteTimeGetCurrent() - startTime;
        NSLog(@"CACHE    found:%d time:%f", totalFound, duration);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.cacheTimer.text = [NSString stringWithFormat:@"%f", duration];
        }];
    }];

    [fetchQueue addOperationWithBlock:^{
        NSPersistentStoreCoordinator *coordinator = [CDTManager sharedManager].persistentStore;
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
        [context setStalenessInterval:0];
        
        NSTimeInterval startTime = CFAbsoluteTimeGetCurrent();
        int totalFound = 0;
        for (int i = 0; i < [self.numberOfFetches intValue]; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"SchoolStat" inManagedObjectContext:context]];
            NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:@"schoolName" ascending:YES selector:nil];
            [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortBy]];
            int mathScore = 526;
            if ([self.randomize boolValue]) {
                mathScore = 300 + (arc4random() % 400);
            }
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mathAverageScoreIndexed = %d", mathScore];
            [fetchRequest setPredicate:predicate];
            NSFetchedResultsController *fetchResultsController = [[NSFetchedResultsController alloc] 
                                                                  initWithFetchRequest:fetchRequest 
                                                                  managedObjectContext:context
                                                                  sectionNameKeyPath:nil 
                                                                  cacheName:nil];
            NSError *error;
            if ([fetchResultsController performFetch:&error]) {
                totalFound += [fetchResultsController.fetchedObjects count];
            } else {
                NSLog(@"error");
            }
        }
        NSTimeInterval duration = CFAbsoluteTimeGetCurrent() - startTime;
        NSLog(@"INDEXED  found:%d time:%f", totalFound, duration);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.indexedTimer.text = [NSString stringWithFormat:@"%f", duration];
        }];
    }];

    [fetchQueue addOperationWithBlock:^{
        NSPersistentStoreCoordinator *coordinator = [CDTManager sharedManager].persistentStore;
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:coordinator];
        [context setStalenessInterval:0];
        
        NSTimeInterval startTime = CFAbsoluteTimeGetCurrent();
        int totalFound = 0;
        for (int i = 0; i < [self.numberOfFetches intValue]; i++) {
            NSManagedObjectModel *model = [CDTManager sharedManager].model;
            int mathScore = 526;
            if ([self.randomize boolValue]) {
                mathScore = 300 + (arc4random() % 400);
            }
            NSDictionary *substitutionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:mathScore], @"MATH_SCORE", nil];
            NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:@"FindOnMathIndexed" substitutionVariables:substitutionDictionary];
            
            NSError *error;
            NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
            if (error) {
                NSLog(@"error");
            } else {
                totalFound += [results count];
            }
        }
        NSTimeInterval duration = CFAbsoluteTimeGetCurrent() - startTime;
        NSLog(@"TEMPLATE found:%d time:%f", totalFound, duration);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.templateIndexedTimer.text = [NSString stringWithFormat:@"%f", duration];
        }];
    }];
}

@end
