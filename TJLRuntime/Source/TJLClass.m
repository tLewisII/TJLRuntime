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

- (BOOL)addPropertyToClassWithIvarAndDefaultPropertiesAndName:(NSString *)name type:(NSString *)type {
    NSString *ivarName = [NSString stringWithFormat:@"_%@", name];

    objc_property_attribute_t pType = {"T", [NSString stringWithFormat:@"@\"%@%@", type, @"\""].UTF8String};
    objc_property_attribute_t pProps = {"N", ""};
    objc_property_attribute_t pStrong = {"&", ""};
    objc_property_attribute_t ivar = {"V", ivarName.UTF8String};
    objc_property_attribute_t attrs[] = {pType, pStrong, pProps, ivar};
    
    BOOL ivarSuccess = NO;
    BOOL propertySuccess = class_addProperty(self.klass, name.UTF8String, attrs, 4);
    if(propertySuccess && _properties) _properties = nil; //Invalidate cache since a new property was added.
    if(propertySuccess) {
      ivarSuccess = [self addIvarToClassWithName:ivarName type:type];
    }
    return propertySuccess && ivarSuccess;
}

- (BOOL)addIvarToClassWithName:(NSString *)name type:(NSString *)type {
    const char *charType = type.UTF8String;
    size_t size = sizeForType(charType);
    BOOL success = class_addIvar(self.klass, name.UTF8String, size, log2(size), charType);
    
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

size_t sizeForType(const char *returnType) {
#define WRAP_AND_RETURN(type) \
do { \
return sizeof(type); \
} while (0)
    
	
	// Skip const type qualifier.
	if (returnType[0] == 'r') {
		returnType++;
	}
    
	if (strcmp(returnType, @encode(char)) == 0) {
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
	} else {
        WRAP_AND_RETURN(id);
    }
    
#undef WRAP_AND_RETURN
    
}

@end
