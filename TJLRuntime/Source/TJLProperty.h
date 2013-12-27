//
//  TJLProperty.h
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/25/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "TJLIvar.h"
@interface TJLProperty : NSObject

/**
 * Initialize the class with a single objc_property_t struct
 * and class.
 *
 * @param klass The class that the property is attached to.
 * @param property An objc_property_t struct that represents
 * a single property of a class.
 * @return An object that wraps the info and behaviors of
 * objc_property_t into Foundation objects.
 */
- (instancetype)__attribute__((nonnull(1, 2)))initWithClass:(Class)klass property:(objc_property_t)property;

/**
 * Initialize the class with a single objc_property_t struct
 * and class as well as the object which hold the backing
 * Ivar for the property.
 *
 * @param klass The class that the property is attached to.
 * @param property An objc_property_t struct that represents
 * @param instance An instance of the object that would hold
 * the Ivar that backs this property.
 * a single property of a class.
 * @return An object that wraps the info and behaviors of
 * objc_property_t into Foundation objects.
 */
- (instancetype)__attribute__((nonnull(1, 2)))initWithClass:(Class)klass property:(objc_property_t)property ivarInstance:(id)instance;

/**
 * Looks up a property by name for the given class.
 * If no property was found, returns nil.
 *
 * @param klass The class that the property is attached to.
 * @param name the name of the property.
 * @return An object that wraps the info and behaviors of
 * objc_property_t into Foundation objects. Returns nil if
 * no property was found for the given name on the given class.
 */
+ (instancetype)__attribute__((nonnull(1, 2)))propertyWithClass:(Class)klass name:(NSString *)name;

/**
 * Looks up a property by name for the given class.
 * If no property was found, returns nil. Also stores an
 * instance of the given class for accessing the backing Ivar.
 *
 * @param klass The class that the property is attached to.
 * @param name the name of the property.
 * @param instance An instance of the object that would hold
 * the Ivar that backs this property.
 * @return An object that wraps the info and behaviors of
 * objc_property_t into Foundation objects. Returns nil if
 * no property was found for the given name on the given class.
 */
+ (instancetype)__attribute__((nonnull(1, 2)))propertyWithClass:(Class)klass name:(NSString *)name ivarInstance:(id)instance;

/**
 * The name of the property. A property declared as
 * `@property(strong, nonatomic) NSString *bob;` would
 * return "bob".
 */
@property(strong, nonatomic, readonly) NSString *name;

/**
 * The type of the property. A property declared as
 * `@property(strong, nonatomic) NSString *bob;` would
 * return "NSString".
 */
@property(strong, nonatomic, readonly) NSString *type;

/**
 * The atrribute string of the property. An esoteric representation
 * of the attributes of the property as a NSString object.property declared as
 * `@property(strong, nonatomic) NSString *bob;` would
 * return T@"NSString",&,N,V_bob.
 */
@property(strong, nonatomic, readonly) NSString *attributes;

/**
 * A TJLIvar instance that wraps the Ivar that backs the property
 * held by this class. Use this only if you used the 
 * `initWithClass:property:ivarInstance:` initializer, otherwise
 * this will return nil.
 *
 */
@property(strong, nonatomic, readonly) TJLIvar *ivar;

/**
 * Returns a TJLIvar for an instance of the give class, if there
 * is one. This method is not needed if you call the
 * `initWithClass:property:ivarInstance:` initializer of this class.
 *
 * @param instance An instance of the object that would hold
 * the Ivar that backs this property.
 */
- (TJLIvar *)ivarForInstanceOfClass:(id)instance;

/**
 * The objc_property_t struct that was used to initialize the class.
 */
@property(nonatomic, readonly) objc_property_t property;

/**
 * The class that this property belongs to.
 */
@property(nonatomic, readonly) Class klass;
@end
