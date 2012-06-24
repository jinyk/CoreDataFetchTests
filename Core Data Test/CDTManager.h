//
//  CDTManager.h
//  Core Data Test
//
//  Created by Jinyoung Kim on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface CDTManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStore;

+ (CDTManager *)sharedManager;
- (CDTManager *)init;
- (void)saveMainContext;

@end
