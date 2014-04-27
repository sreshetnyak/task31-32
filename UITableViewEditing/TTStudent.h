//
//  TTStudent.h
//  UITableViewEditing
//
//  Created by sergey on 4/24/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTStudent : NSObject

@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (assign,nonatomic) CGFloat averageScore;

+ (TTStudent *)getRandomStudent;

@end
