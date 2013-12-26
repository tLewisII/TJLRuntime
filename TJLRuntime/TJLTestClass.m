//
//  TJLTestClass.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/26/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLTestClass.h"

@implementation TJLTestClass

- (instancetype)initWithName:(NSString *)name number:(NSNumber *)number {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _nameString = name;
    _number = number;
    
    return self;
}
@end
