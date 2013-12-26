//
//  TJLRuntime.h
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/25/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJLProperty.h"
#import "TJLMethod.h"
#import <objc/runtime.h>
@interface TJLRuntime : NSObject

/**
 * A NSDictionary of property types and names for the given class.
 *
 * @param klass The class which you want to get a property list for.
 * @return An NSDictionary where the keys are the name of the property and
 * the values are the type of the property.
 */
- (NSDictionary *)__attribute__((nonnull(1)))propertyTypeAndNameDictionaryForClass:(Class)klass;

/**
 * A NSArray of property names for the given class.
 *
 * @param klass The class which you want to get a property list for.
 * @return An NSArray of NSStrings which are the names of the properties
 * of the given class.
 */
- (NSArray *)__attribute__((nonnull(1)))propertyNameArrayForClass:(Class)klass;

/**
 * A NSArray of TJLProperty objects for the given class.
 *
 * @param klass The class which you want to get a property list for.
 * @return An NSArray of TJLProperty objects for the given class.
 */
- (NSArray *)__attribute__((nonnull(1)))propertiesForClass:(Class)klass;

/**
 * A NSArray of TJLProperty objects for the given class.
 *
 * @param klass The class which you want to get a property list for.
 * @param instance An instance of the object that would hold
 * the Ivar that backs the properties for the given class.
 * @return An NSArray of TJLProperty objects for the given class.
 */
- (NSArray *)__attribute__((nonnull(1)))propertiesForClass:(Class)klass withInstance:(id)instance;

/**
 * Gets a property by name for the given class.
 *
 * @param klass The class which you want to get a property from.
 * @param name The name of the property you want to retrieve.
 * @return A TJLProperty object for the given property, or nil
 * if no property was found for the given name in the given class.
 */
- (TJLProperty *)__attribute__((nonnull(1)))propertyForClass:(Class)klass name:(NSString *)name;

/**
 * A NSDictionary of ivar types and names for the given class.
 *
 * @param klass The class which you want to get a property list for.
 * @return An NSDictionary where the keys are the name of the ivar and
 * the values are the type of the ivar.
 */
- (NSDictionary *)__attribute__((nonnull(1)))ivarTypeAndNameDictionaryForClass:(Class)klass;

/**
 * A NSArray of ivar names for the given class.
 *
 * @param klass The class which you want to get a ivar list for.
 * @return An NSArray of NSStrings which are the names of the ivars
 * of the given class.
 */
- (NSArray *)__attribute__((nonnull(1)))ivarNameArrayForClass:(Class)klass;

/**
 * A NSArray of TJLIvar objects for the given class.
 *
 * @param klass The class which you want to get a ivar list for.
 * @return An NSArray of TJLIvar objects for the given class.
 */
- (NSArray *)__attribute__((nonnull(1)))ivarsForClass:(Class)klass;

/**
 * A NSArray of TJLIvar objects for the given class.
 *
 * @param klass The class which you want to get a ivar list for.
 * @param instance An instance of the class that is passed in
 * that would hold the Ivar.
 * @return An NSArray of TJLIvar objects for the given class and instance.
 */
- (NSArray *)__attribute__((nonnull(1)))ivarsForClass:(Class)klass instance:(id)instance;

/**
 * Gets a ivar by name for the given class and instance.
 *
 * @param klass The class which you want to get a ivar from.
 * @param name The name of the ivar you want to retrieve.
 * @return A TJLIvar object for the given ivar, or nil
 * if no ivar was found for the given name in the given class.
 */
- (TJLIvar *)__attribute__((nonnull(1)))ivarForClass:(Class)klass name:(NSString *)name instance:(id)instance;

/**
 * A NSArray of method names for the given class.
 *
 * @param klass The class which you want to get a method list for.
 * @return An NSArray of NSStrings which are the names of the methods
 * of the given class, in a form such that a method 
 * `- (void)doStuff:(id)stuff withThing:(id)thing;` would
 * return "doStuff:withThing:".
 */
- (NSArray *)__attribute__((nonnull(1)))methodNameArrayForClass:(Class)klass;

/**
 * A NSArray of TJLMethod objects for the given class.
 *
 * @param klass The class which you want to get a method list for.
 * @return An NSArray of TJLMethods objects for the given class.
 */
- (NSArray *)__attribute__((nonnull(1)))methodsForClass:(Class)klass;

/**
 * Returns a TJLMethod object for the given selector and class.
 *
 * @param klass The class that the method is declared in.
 * @param selector A selector for the method you want this class
 * to encapsulate. Must be a selector that is an instance method on
 * the given class.
 * @return If the method for `selector` was found in the given class,
 * A TJLMethod object, nil otherwise.
 */
- (TJLMethod *)__attribute__((nonnull(1, 2)))instanceMethodForClass:(Class)klass selector:(SEL)selector;

/**
 * Returns a TJLMethod object for the given selector and name.
 *
 * @param klass The class that the method is declared in.
 * @param name The name of a selector for the method you to search for
 * in the given class. Must be a name of a method that is an 
 * instance method on the given class.
 * @return If the method for `name` was found in the given class,
 * An fully initialized TJLMethod object, nil otherwise.
 */
- (TJLMethod *)__attribute__((nonnull(1, 2)))instanceMethodForClass:(Class)klass name:(NSString *)name;
@end
