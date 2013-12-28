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
    
    return self;
}

- (instancetype)initWithClass:(Class)klass property:(objc_property_t)property {
    return [self initWithClass:klass property:property ivarInstance:nil];
}

+ (instancetype)propertyWithClass:(Class)klass name:(NSString *)name {
    objc_property_t property = class_getProperty(klass, name.UTF8String);
    if(property == NULL) return nil;
    else return [[self alloc]initWithClass:klass property:property];
}

+ (instancetype)propertyWithClass:(Class)klass name:(NSString *)name ivarInstance:(id)instance {
    objc_property_t property = class_getProperty(klass, name.UTF8String);
    if(property == NULL) return nil;
    else return [[self alloc]initWithClass:klass property:property ivarInstance:instance];
}

- (NSString *)name {
    if(!_propertyName) {
        _propertyName = @(property_getName(self.property));
    }
    return _propertyName;
}

- (NSString *)type {
    if(!_propertyType ) {
        _propertyType = getPropertyType(self.property);
    }
    return _propertyType;
}

- (NSString *)attributes {
    if(!_propertyAttributes) {
        _propertyAttributes = @(property_getAttributes(self.property));
    }
    return _propertyAttributes;
}

- (TJLIvar *)ivar {
    if(!_ivar && _ivarInstance) {
        _ivar = [TJLIvar ivarForClass:self.klass name:[NSString stringWithFormat:@"_%@", self.name] instance:_ivarInstance];
    }
    return _ivar;
}

- (TJLIvar *)ivarForInstanceOfClass:(id)instance {
    return [TJLIvar ivarForClass:self.klass name:[NSString stringWithFormat:@"_%@", self.name] instance:instance];
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
