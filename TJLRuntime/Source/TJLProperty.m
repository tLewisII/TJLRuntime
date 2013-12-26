//
//  TJLProperty.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/25/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLProperty.h"
@interface TJLProperty() {
    NSString *_propertyName;
    NSString *_propertyType;
    NSString *_propertyAttributes;
    TJLIvar *_ivar;
    id _ivarInstance;
}

@end

@implementation TJLProperty

- (instancetype)initWithClass:(Class)klass property:(objc_property_t)property ivarInstance:(id)instance {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _ivarInstance = instance;
    _klass = klass;
    _property = property;
    _propertyName = [NSString stringWithUTF8String:property_getName(property)];
    _propertyType = getPropertyType(property);
    _propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
    
    return self;
}

- (instancetype)initWithClass:(Class)klass property:(objc_property_t)property {
    return [self initWithClass:klass property:property ivarInstance:nil];
}

- (NSString *)name {
    return _propertyName;
}

- (NSString *)type {
    return _propertyType;
}

- (NSString *)attributes {
    return _propertyAttributes;
}

- (TJLIvar *)ivar {
    if(_ivarInstance) {
        const char * ivarName = [NSString stringWithFormat:@"_%@", self.name].UTF8String;
        return [[TJLIvar alloc]initWithInstance:_ivarInstance ivar:class_getInstanceVariable(self.klass, ivarName)];
    }
    else
        return nil;
}
- (TJLIvar *)ivarForInstanceOfClass:(id)instance {
    const char * ivarName = [NSString stringWithFormat:@"_%@", self.name].UTF8String;
    _ivar = [[TJLIvar alloc]initWithInstance:instance ivar:class_getInstanceVariable(self.klass, ivarName)];
    return _ivar;
}

static NSString *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return name;
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return @"id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return name;
        }
    }
    return @"";
}

@end