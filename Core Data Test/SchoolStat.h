//
//  SchoolStat.h
//  Core Data Test
//
//  Created by Jinyoung Kim on 6/23/12.
//  Copyright (c) 2012 Jinyoung Kim. All rights reserved.
//

@interface SchoolStat : NSManagedObject

@property (strong, nonatomic) NSNumber * aun;
@property (strong, nonatomic) NSString * district;
@property (strong, nonatomic) NSNumber * schoolNumber;
@property (strong, nonatomic) NSString * schoolName;
@property (strong, nonatomic) NSString * schoolNameIndexed;
@property (strong, nonatomic) NSNumber * numberStudentsTested;
@property (strong, nonatomic) NSNumber * verbalAverageScore;
@property (strong, nonatomic) NSNumber * mathAverageScore;
@property (strong, nonatomic) NSNumber * mathAverageScoreIndexed;
@property (strong, nonatomic) NSNumber * writingAverageScore;
@property (strong, nonatomic) NSNumber * year;

@end
