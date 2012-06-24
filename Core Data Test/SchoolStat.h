//
//  SchoolStat.h
//  Core Data Test
//
//  Created by Jinyoung Kim on 6/23/12.
//  Copyright (c) 2012 Jinyoung Kim. All rights reserved.
//

@interface SchoolStat : NSManagedObject

@property (nonatomic, retain) NSNumber * aun;
@property (nonatomic, retain) NSString * district;
@property (nonatomic, retain) NSNumber * schoolNumber;
@property (nonatomic, retain) NSString * schoolName;
@property (nonatomic, retain) NSNumber * numberStudentsTested;
@property (nonatomic, retain) NSNumber * verbalAverageScore;
@property (nonatomic, retain) NSNumber * mathAverageScore;
@property (nonatomic, retain) NSNumber * mathAverageScoreIndexed;
@property (nonatomic, retain) NSNumber * writingAverageScore;
@property (nonatomic, retain) NSNumber * year;

@end
