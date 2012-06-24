//
//  SeedLoader.m
//  Core Data Test
//
//  Created by Jinyoung Kim on 6/23/12.
//  Copyright (c) 2012 Jinyoung Kim. All rights reserved.
//

#import "SeedLoader.h"
#import "SchoolStat.h"

@implementation SeedLoader

+ (void)loadSeed:(BOOL)forceLoad {
    if (!forceLoad) {
        NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
        NSNumber *seedDownloaded = [userPrefs objectForKey:@"seedDownloaded"];
        NSLog(@"seedDownloaded: %@", seedDownloaded);
        if (seedDownloaded == nil) {
            forceLoad = YES;
            [userPrefs setObject:[NSNumber numberWithBool:YES] forKey:@"seedDownloaded"];
            [userPrefs synchronize];
        }
    }
    
    if (forceLoad) {
        NSError *error;
        id satData = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data_2011" ofType:@"json"]] options:0 error:&error];
        if (error) {
            NSLog(@"NSJSONSerialization JSONObjectWithData: %@", error);
        }
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        SchoolStat *schoolStat;
        for (NSDictionary *curSchool in (NSArray *)satData) {
            schoolStat = [NSEntityDescription insertNewObjectForEntityForName:@"SchoolStat" inManagedObjectContext:[CDTManager sharedManager].context];
            schoolStat.aun = [numberFormatter numberFromString:[curSchool objectForKey:@"AUN"]];
            schoolStat.district = [curSchool objectForKey:@"DISTRICT"];
            schoolStat.schoolNumber = [numberFormatter numberFromString:[curSchool objectForKey:@"SCHOOL_NUMBER"]];
            schoolStat.schoolName = [curSchool objectForKey:@"SCHOOL_NAME"];
            schoolStat.numberStudentsTested = [numberFormatter numberFromString:[curSchool objectForKey:@"NUMBER_STUDENTS_TESTED"]];
            schoolStat.verbalAverageScore = [numberFormatter numberFromString:[curSchool objectForKey:@"VERBAL_AVERAGE_SCORE"]];
            schoolStat.mathAverageScore = [numberFormatter numberFromString:[curSchool objectForKey:@"MATH_AVERAGE_SCORE"]];
            schoolStat.mathAverageScoreIndexed = [numberFormatter numberFromString:[curSchool objectForKey:@"MATH_AVERAGE_SCORE"]];
            schoolStat.writingAverageScore = [numberFormatter numberFromString:[curSchool objectForKey:@"WRITING_AVERAGE_SCORE"]];
            schoolStat.year = [NSNumber numberWithInt:2011];
        }
        [[CDTManager sharedManager] saveMainContext];
    } else {
        NSLog(@"Already loaded seed JSON data.");
    }

}

@end
