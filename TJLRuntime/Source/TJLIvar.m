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
    _ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
    const char *type = ivar_getTypeEncoding(ivar);
    _ivarType = [[NSString alloc]initWithBytes:type + 2 length:strlen(type) - 3 encoding:NSUTF8StringEncoding];
    
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
    return _ivarName;
}

- (NSString *)type {
    return _ivarType;
}

@end
