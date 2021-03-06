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

- (instancetype)initWithIvar:(Ivar)ivar {
    return [self initWithIvar:ivar instance:nil];
}

- (instancetype)initWithIvar:(Ivar)ivar instance:(id)instance {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _instance = instance;
    _ivar = ivar;
    
    return self;
}

+ (instancetype)ivarForClass:(Class)klass name:(NSString *)name {
    Ivar ivar = class_getInstanceVariable(klass, name.UTF8String);
    if(ivar == NULL) return nil;
    else return [[self alloc]initWithIvar:ivar instance:nil];
}

+ (instancetype)ivarForClass:(Class)klass name:(NSString *)name instance:(id)instance {
    Ivar ivar = class_getInstanceVariable(klass, name.UTF8String);
    if(ivar == NULL) return nil;
    else return [[self alloc]initWithIvar:ivar instance:instance];
}

- (id)value {
    if(!self.instance) return nil;
    else return object_getIvar(self.instance, self.ivar);
}

- (void)setValue:(id)value {
    if(self.instance)
        object_setIvar(self.instance, self.ivar, value);
}

- (NSString *)name {
    if(!_ivarName) {
        _ivarName = @(ivar_getName(self.ivar));
    }
    return _ivarName;
}

- (NSString *)type {
    if(!_ivarType) {
        const char *type = ivar_getTypeEncoding(self.ivar);
        if(strlen(type) == 1) _ivarType = @(type);
        else _ivarType = [[NSString alloc]initWithBytes:type + 2 length:strlen(type) - 3 encoding:NSUTF8StringEncoding];
    }
    return _ivarType;
}

@end
