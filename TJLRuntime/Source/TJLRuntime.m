//
//  TJLRuntime.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/25/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import "TJLRuntime.h"

@implementation TJLRuntime
-(NSDictionary *)propertyTypeAndNameDictionaryForClass:(Class)klass {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(klass, &count);
    for(unsigned int i = 0; i < count; i++) {
        TJLProperty *property = [[TJLProperty alloc]initWithClass:klass property:properties[i]];
        dictionary[property.type] = property.name;
    }
    free(properties);
    
    return dictionary;
}

- (NSArray *)propertyNameArrayForClass:(Class)klass {
    NSMutableArray *array = [NSMutableArray new];
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(klass, &count);
    for(unsigned int i = 0; i < count; i++) {        
        array[i] = [NSString stringWithUTF8String:property_getName(properties[i])];
    }
    free(properties);
    
    return array;
}

- (NSArray *)propertiesForClass:(Class)klass {
    return [self propertiesForClass:klass withInstance:nil];
}

- (NSArray *)propertiesForClass:(Class)klass withInstance:(id)instance {
    NSMutableArray *array = [NSMutableArray new];
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(klass, &count);
    for(unsigned int i = 0; i < count; i++) {
        array[i] = [[TJLProperty alloc]initWithClass:klass property:properties[i] ivarInstance:instance];
    }
    free(properties);
    
    return array;
}

- (TJLProperty *)propertyForClass:(Class)klass name:(NSString *)name {
   objc_property_t property = class_getProperty(klass, name.UTF8String);
    if(property == NULL) return nil;
    else return [[TJLProperty alloc]initWithClass:klass property:property];
}

- (NSDictionary *)ivarTypeAndNameDictionaryForClass:(Class)klass {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    unsigned int count;
    
    Ivar *ivars = class_copyIvarList(klass, &count);
    for(unsigned int i = 0; i < count; i++) {
        TJLIvar *ivar = [[TJLIvar alloc]initWithIvar:ivars[i] instance:nil];
        dictionary[ivar.type] = ivar.name;
    }
    free(ivars);
    
    return dictionary;
}

- (NSArray *)ivarNameArrayForClass:(Class)klass {
    NSMutableArray *array = [NSMutableArray new];
    unsigned int count;
    
    Ivar *ivars = class_copyIvarList(klass, &count);
    for(unsigned int i = 0; i < count; i++) {
        array[i] = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
    }
    free(ivars);
    
    return array;
}

- (NSArray *)ivarsForClass:(Class)klass {
    return [self ivarsForClass:klass instance:nil];
}

- (NSArray *)ivarsForClass:(Class)klass instance:(id)instance {
    NSMutableArray *array = [NSMutableArray new];
    unsigned int count;
    
    Ivar *ivars = class_copyIvarList(klass, &count);
    for(unsigned int i = 0; i < count; i++) {
        array[i] = [[TJLIvar alloc]initWithIvar:ivars[i] instance:instance];
    }
    free(ivars);
    
    return array;
}

- (TJLIvar *)ivarForClass:(Class)klass name:(NSString *)name instance:(id)instance {
    Ivar ivar = class_getInstanceVariable(klass, name.UTF8String);
    if(ivar == NULL) return nil;
    else return [[TJLIvar alloc]initWithIvar:ivar instance:instance];
}
@end
