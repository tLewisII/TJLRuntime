//
//  TJLMethod.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/26/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLMethod.h"
@interface TJLMethod() {

}

@end
@implementation TJLMethod

- (instancetype)initWithClass:(Class)klass method:(Method)method {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _klass = klass;
    _method = method;
    
    return self;
}

+ (instancetype)instanceMethodWithClass:(Class)klass selector:(SEL)selector {
    Method instanceMethod = class_getInstanceMethod(klass, selector);
    if(instanceMethod == NULL) return nil;
    else return [[self alloc]initWithClass:klass method:instanceMethod];
}

+ (instancetype)instanceMethodWithClass:(Class)klass name:(NSString *)name {
    Method instanceMethod = class_getInstanceMethod(klass, NSSelectorFromString(name));
    if(instanceMethod == NULL) return nil;
    else return [[self alloc]initWithClass:klass method:instanceMethod];
}

- (void)exchangeMethodImplementationWithMethod:(TJLMethod *)method {
    method_exchangeImplementations(self.method, method.method);
}

- (NSString *)name {
    return NSStringFromSelector(method_getName(self.method));
}

- (NSUInteger)argumentCount {
    return method_getNumberOfArguments(self.method);
}

- (NSString *)returnType {
    char *returnType = method_copyReturnType(self.method);
    NSString *returnValue = getReturnTypeFromCode(returnType);
    
    free(returnType);
    return returnValue;
}

static NSString *getReturnTypeFromCode(char *code) {
    NSString *returnValue;
    
    if(code == nil) {
        returnValue = @"";
    }
    if(strcmp(code, "c") == 0) {
        returnValue = @"char";
    }
    else if(strcmp(code, "i") == 0) {
        returnValue = @"int";
    }
    else if(strcmp(code, "s") == 0) {
        returnValue = @"short";
    }
    else if(strcmp(code, "l") == 0) {
        returnValue = @"long";
    }
    else if(strcmp(code, "q") == 0) {
        returnValue = @"long long";
    }
    else if(strcmp(code, "C") == 0) {
        returnValue = @"unsigned char";
    }
    else if(strcmp(code, "I") == 0) {
        returnValue = @"unsigned int";
    }
    else if(strcmp(code, "S") == 0) {
        returnValue = @"unsigned short";
    }
    else if(strcmp(code, "L") == 0) {
        returnValue = @"unsigned long";
    }
    else if(strcmp(code, "Q") == 0) {
        returnValue = @"unsigned long long";
    }
    else if(strcmp(code, "f") == 0) {
        returnValue = @"float";
    }
    else if(strcmp(code, "d") == 0) {
        returnValue = @"double";
    }
    else if(strcmp(code, "B") == 0) {
        returnValue = @"bool";
    }
    else if(strcmp(code, "*") == 0) {
        returnValue = @"char *";
    }
    else if(strcmp(code, "q") == 0) {
        returnValue = @"long long";
    }
    else if(strcmp(code, "#") == 0) {
        returnValue = @"Class";
    }
    else if(strcmp(code, ":") == 0) {
        returnValue = @"SEL";
    }
    else if(strcmp(code, "?") == 0) {
        returnValue = @"unknown, possibly function pointer";
    }
    else if(strncmp(code, "{", 1) == 0) {
        returnValue = [NSString stringWithUTF8String:code];
    }
    else if(strcmp(code, "@") == 0) {
        returnValue = @"id";
    }
    else if(strcmp(code, "v") == 0) {
        returnValue = @"void";
    }
    else if(strcmp(code, "@?") == 0) {
        returnValue = @"block type";
    }
    else if(strcmp(code, "Vv") == 0) {
        returnValue = @"release method";
    }
    
    return returnValue;
}

@end
