//
//  TJLIvar.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/25/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLIvar.h"
@interface TJLIvar() {
    NSString *_ivarName;
    NSString *_ivarType;
}

@end
@implementation TJLIvar
- (instancetype)initWithInstance:(id)instance ivar:(Ivar)ivar {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _instance = instance;
    _ivar = ivar;
    _ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    const char *type = ivar_getTypeEncoding(ivar);
    _ivarType = [[NSString alloc]initWithBytes:type + 2 length:strlen(type) - 3 encoding:NSUTF8StringEncoding];
    
    return self;
}

- (id)value {
    return object_getIvar(self.instance, self.ivar);
}

- (void)setValue:(id)value {
    object_setIvar(self.instance, self.ivar, value);
}

- (NSString *)name {
    return _ivarName;
}

- (NSString *)type {
    return _ivarType;
}

@end
