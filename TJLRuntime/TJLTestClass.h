//
//  TJLTestClass.h
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/26/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJLTestClass : NSObject {
    NSArray *_ivarArray;
    NSMutableDictionary *_ivarDict;
}

- (instancetype)initWithName:(NSString *)name number:(NSNumber *)number;
@property(strong, nonatomic) NSString *nameString;
@property(strong, nonatomic) NSNumber *number;
@end
