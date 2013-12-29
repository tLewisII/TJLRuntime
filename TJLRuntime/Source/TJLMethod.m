//
//  TJLMethod.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/26/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLMethod.h"
@interface TJLMethod() {
    NSString *_methodName;
    NSString *_methodReturnType;
    NSUInteger _methodArgumentCount;
    SEL _methodSelector;
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
    _methodArgumentCount = -1;
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

-(void)setMethodImplementationWithMethod:(TJLMethod *)method {
    method_setImplementation(_method, class_getMethodImplementation(self.klass, NSSelectorFromString(method.name)));
}

- (void)invokeVoidMethodWithInstanceOfClass:(id)instance args:(NSArray *)args {
    [self invokeMethodWithInstanceOfClass:instance args:args];
}

- (id)invokeMethodWithInstanceOfClass:(id)instance args:(NSArray *)args {
    NSMethodSignature *methodSignature = [instance methodSignatureForSelector:self.selector];
    NSCAssert(args.count == methodSignature.numberOfArguments - 2, @"Number of supplied arguments (%lu), does not match the number expected by the signature (%lu)", (unsigned long)args.count, (unsigned long)methodSignature.numberOfArguments - 2);
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    invocation.selector = self.selector;
    
    NSInteger index = 2;
    for(NSInteger i = 0; i < args.count; i++) {
        id object = args[i];
        [invocation setArgument:&object atIndex:index++];
    }
    
    [invocation invokeWithTarget:instance];
    return [self returnValueForMethodSignature:methodSignature withInvocation:invocation];
}

- (NSString *)name {
    if(!_methodName) {
        _methodName = NSStringFromSelector(method_getName(self.method));
    }
    return _methodName;
}

- (NSUInteger)argumentCount {
    if(_methodArgumentCount == -1) {
       _methodArgumentCount = method_getNumberOfArguments(self.method);
    }
    return _methodArgumentCount;
}

- (NSString *)returnType {
    if(!_methodReturnType) {
        char *returnType = method_copyReturnType(self.method);
        _methodReturnType = getReturnTypeFromCode(returnType);
        free(returnType);
    }
    return _methodReturnType;
}

- (SEL)selector {
    if(!_methodSelector) {
        _methodSelector = method_getName(self.method);
    }
    return _methodSelector;
}

static NSString *getReturnTypeFromCode(char *code) {
    NSString *returnValue;
    
    if(code == nil) {
        returnValue = @"";
    }
    // Skip const type qualifier.
    else if(code[0] == 'r') {
        code++;
    }
    else if(strcmp(code, @encode(char)) == 0) {
        returnValue = @"char";
    }
    else if(strcmp(code, @encode(int)) == 0) {
        returnValue = @"int";
    }
    else if(strcmp(code, @encode(short)) == 0) {
        returnValue = @"short";
    }
    else if(strcmp(code, @encode(long)) == 0) {
        returnValue = @"long";
    }
    else if(strcmp(code, @encode(long long)) == 0) {
        returnValue = @"long long";
    }
    else if(strcmp(code, @encode(unsigned char)) == 0) {
        returnValue = @"unsigned char";
    }
    else if(strcmp(code, @encode(unsigned int)) == 0) {
        returnValue = @"unsigned int";
    }
    else if(strcmp(code, @encode(unsigned short)) == 0) {
        returnValue = @"unsigned short";
    }
    else if(strcmp(code, @encode(unsigned long)) == 0) {
        returnValue = @"unsigned long";
    }
    else if(strcmp(code, @encode(unsigned long long)) == 0) {
        returnValue = @"unsigned long long";
    }
    else if(strcmp(code, @encode(float)) == 0) {
        returnValue = @"float";
    }
    else if(strcmp(code, @encode(double)) == 0) {
        returnValue = @"double";
    }
    else if(strcmp(code, @encode(BOOL)) == 0) {
        returnValue = @"bool";
    }
    else if(strcmp(code, @encode(char *)) == 0) {
        returnValue = @"char *";
    }
    else if(strcmp(code, @encode(Class)) == 0) {
        returnValue = @"Class";
    }
    else if(strcmp(code, @encode(SEL)) == 0) {
        returnValue = @"SEL";
    }
    else if(strcmp(code, "?") == 0) {
        returnValue = @"unknown, possibly function pointer";
    }
    else if(strncmp(code, "{", 1) == 0) {
        returnValue = [NSString stringWithUTF8String:code];
    }
    else if(strcmp(code, @encode(id)) == 0) {
        returnValue = @"id";
    }
    else if(strcmp(code, @encode(void)) == 0) {
        returnValue = @"void";
    }
    else if(strcmp(code, @encode(void (^)(void))) == 0) {
        returnValue = @"block type";
    }
    else if(strcmp(code, "Vv") == 0) {
        returnValue = @"oneway void";
    }
    
    return returnValue;
}

-(id)returnValueForMethodSignature:(NSMethodSignature *)methodSignature withInvocation:(NSInvocation *)invocation {
#define WRAP_AND_RETURN(type) \
do { \
type val = 0; \
[invocation getReturnValue:&val]; \
return @(val); \
} while (0)
    
	const char *returnType = methodSignature.methodReturnType;
	// Skip const type qualifier.
	if (returnType[0] == 'r') {
		returnType++;
	}
    
	if (strcmp(returnType, @encode(id)) == 0 || strcmp(returnType, @encode(Class)) == 0 || strcmp(returnType, @encode(void (^)(void))) == 0) {
		__autoreleasing id returnObj;
		[invocation getReturnValue:&returnObj];
		return returnObj;
	} else if (strcmp(returnType, @encode(char)) == 0) {
		WRAP_AND_RETURN(char);
	} else if (strcmp(returnType, @encode(int)) == 0) {
		WRAP_AND_RETURN(int);
	} else if (strcmp(returnType, @encode(short)) == 0) {
		WRAP_AND_RETURN(short);
	} else if (strcmp(returnType, @encode(long)) == 0) {
		WRAP_AND_RETURN(long);
	} else if (strcmp(returnType, @encode(long long)) == 0) {
		WRAP_AND_RETURN(long long);
	} else if (strcmp(returnType, @encode(unsigned char)) == 0) {
		WRAP_AND_RETURN(unsigned char);
	} else if (strcmp(returnType, @encode(unsigned int)) == 0) {
		WRAP_AND_RETURN(unsigned int);
	} else if (strcmp(returnType, @encode(unsigned short)) == 0) {
		WRAP_AND_RETURN(unsigned short);
	} else if (strcmp(returnType, @encode(unsigned long)) == 0) {
		WRAP_AND_RETURN(unsigned long);
	} else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
		WRAP_AND_RETURN(unsigned long long);
	} else if (strcmp(returnType, @encode(float)) == 0) {
		WRAP_AND_RETURN(float);
	} else if (strcmp(returnType, @encode(double)) == 0) {
		WRAP_AND_RETURN(double);
	} else if (strcmp(returnType, @encode(BOOL)) == 0) {
		WRAP_AND_RETURN(BOOL);
	} else if (strcmp(returnType, @encode(char *)) == 0) {
		WRAP_AND_RETURN(const char *);
	} else if (strcmp(returnType, @encode(void)) == 0) {
		return nil;
	} else {
		NSUInteger valueSize = 0;
		NSGetSizeAndAlignment(returnType, &valueSize, NULL);
        
		unsigned char valueBytes[valueSize];
		[invocation getReturnValue:valueBytes];
        
		return [NSValue valueWithBytes:valueBytes objCType:returnType];
	}
    
	return nil;
    
#undef WRAP_AND_RETURN
    
}

@end
