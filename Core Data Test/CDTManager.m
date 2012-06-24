//
//  CDTManager.m
//  Core Data Test
//
//  Created by Jinyoung Kim on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDTManager.h"

static CDTManager *sharedMyManager = nil;

@implementation CDTManager

@synthesize context = __context;
@synthesize model = __model;
@synthesize persistentStore = __persistentStore;

#pragma mark - Singleton & init

+ (CDTManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedMyManager == nil) {
            sharedMyManager = [[self alloc] init];
        }
    });
    return sharedMyManager;
}

- (CDTManager *)init {
    if (self = [super init]) {
    }
    return self;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)context {
    if (__context != nil) {
        return __context;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStore];
    if (coordinator != nil) {
        __context = [[NSManagedObjectContext alloc] init];
        [__context setPersistentStoreCoordinator:coordinator];
        [__context setStalenessInterval:0];
    }
    return __context;
}

- (NSPersistentStoreCoordinator *)persistentStore {
    if (__persistentStore != nil) {
        return __persistentStore;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    __persistentStore = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    NSError *error = nil;
    if (![__persistentStore addPersistentStoreWithType:NSSQLiteStoreType configuration:nil 
                                                   URL:storeURL options:options error:&error]) {
        /*
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         */
        NSLog(@"CDTManager addPersistentStoreWithType: %@", error);
    }
    return __persistentStore;
}

- (NSManagedObjectModel *)model {
    if (__model != nil) {
        return __model;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    __model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __model;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveMainContext {
    if ((self.context != nil) && self.context.hasChanges) {
        NSError *error;
        if ([self.context save:&error]) {
            NSLog(@"CDTManager context save.");
        } else {
            NSLog(@"CDTManager context save failed: %@", error);
        }
    }
}

@end
