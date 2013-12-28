//
//  TJLClass.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/27/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLRuntime.h"

@interface TJLClass() {
    NSArray *_sublcasses;
    NSString *_className;
    NSString *_superClassName;
    NSArray *_properties;
    NSArray *_instanceMethods;
    Class _superClass;
}

@end
@implementation TJLClass

- (instancetype)initWithClass:(Class)klass {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _klass = klass;
    
    return self;
}

+ (instancetype)classWithName:(NSString *)name {
   Class class = objc_lookUpClass(name.UTF8String);
    if(!class) return nil;
    else return [[self alloc]initWithClass:class];
}

- (BOOL)addPropertyToClass:(TJLProperty *)property {
    unsigned int count;
    objc_property_attribute_t *attr = property_copyAttributeList(property.property, &count);
   BOOL success = class_addProperty(self.klass, property.name.UTF8String, attr, count);
    
    if(success && _properties) _properties = nil; //Invalidate cache since a new property was added.
    
    free(attr);
    return success;
}

- (BOOL)addMethodToClass:(TJLMethod *)method {
    BOOL success = class_addMethod(self.klass, method.selector, class_getMethodImplementation(self.klass, method.selector), method_getTypeEncoding(method.method));
    
    if(success && _instanceMethods) _instanceMethods = nil;  //Invalidate cache since a new method was added.
        
    return success;
}

- (NSString *)name {
    if(!_className) {
        _className = @(class_getName(self.klass));
    }
    return _className;
}

- (NSString *)superClassName {
    if(!_superClassName) {
        _superClassName = @(class_getName(class_getSuperclass(self.klass)));
    }
    return _superClassName;
}

- (NSArray *)subclasses {
    if(!_sublcasses) {
        NSMutableArray *array = [NSMutableArray new];
        
        unsigned int count;
        Class *classes = objc_copyClassList(&count);
        
        for(unsigned int i = 0; i < count; i++) {
            Class superClass = classes[i];
            
            do {
                superClass = class_getSuperclass(superClass);
            } while (superClass && superClass != self.klass);
            
            if(superClass == nil) continue;
            
            [array addObject:[[TJLClass alloc]initWithClass:classes[i]]];
        }
        free(classes);
        _sublcasses = array;
    }
    return _sublcasses;
}

- (NSArray *)properties {
    if(!_properties) {
        _properties = [[[TJLRuntime alloc]init]propertiesForClass:self.klass];
    }
    return [NSArray arrayWithArray:_properties];
}

- (NSArray *)instanceMethods {
    if(!_instanceMethods) {
        _instanceMethods = [[[TJLRuntime alloc]init]methodsForClass:self.klass];
    }
    return [NSArray arrayWithArray:_instanceMethods];
}

- (Class)superKlass {
    if(!_superClass) {
        _superClass = class_getSuperclass(self.klass);
    }
    return _superClass;
}
@end
