//
//  TJLClass.h
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/27/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TJLClass : NSObject

/**
 *  Initialize the class with the given class.
 *
 * @param klass the class that will be wrapped by this object.
 * @return A TJLClass object that wraps the methods on `Class` into foundation objects.
 */
- (instancetype)__attribute__((nonnull(1)))initWithClass:(Class)klass;

/**
 *  Initialize the class with the given name.
 *
 * @param name The name of the class you wish to search for, such as `NSObject`.
 * @return A TJLClass object that wraps the methods on `Class` into foundation objects.
 */
+ (instancetype)__attribute__((nonnull(1)))classWithName:(NSString *)name;

/**
 * Adds the given property to the class if it does not already exist on the class.
 *
 * @param property The property you wish to add to this class at runtime.
 * @return A BOOL indicating success or failure. Returns YES if the property was added,
 * NO if it already exists on the class or a failure occured.
 */
- (BOOL)__attribute__((nonnull(1)))addPropertyToClass:(TJLProperty *)property;

/**
 * Adds a property to the class, as well as its backing ivar, for the given name and type
 * if it does not already exist on the class. Uses default property attributes, so the property
 * would look like @property(nonatomic, strong) type *name;
 *
 * @param name The name of the property you wish to add to this class at runtime.
 * @param type The type of the property. For instance, if you want an NSArray, pass @"NSArray".
 * @return A BOOL indicating success or failure. Returns YES if the property was added,
 * NO if it already exists on the class or a failure occured.
 */
- (BOOL)__attribute__((nonnull(1)))addPropertyToClassWithIvarAndDefaultPropertiesAndName:(NSString *)name type:(NSString *)type;

/**
 * Adds an ivar with the given name and type to the class if it does not already exist on the class.
 *
 * @param name The name of ivar you wish to add to this class at runtime.
 * @param type The type of the ivar. For instance, if you want an NSArray pass @"NSArray".
 * @return A BOOL indicating success or failure. Returns YES if the ivar was added,
 * NO if it already exists on the class or a failure occured.
 */
- (BOOL)__attribute__((nonnull(1)))addIvarToClassWithName:(NSString *)name type:(NSString *)type;

/**
 * Adds the given method to the class if it does not already exist on the class.
 *
 * @param method The method you wish to add to this class at runtime.
 * @return A BOOL indicating success or failure. Returns YES if the method was added,
 * NO if it already exists on the class or a failure occured.
 */
- (BOOL)__attribute__((nonnull(1)))addMethodToClass:(TJLMethod *)method;

/**
 * The name of this class.
 */
@property(strong, nonatomic, readonly) NSString *name;

/**
 * The name of the superclass of this class.
 */
@property(strong, nonatomic, readonly) NSString *superClassName;

/**
 * An array of subclasses, as TJLClass objects, of this class. Note that accessing this
 * property is not performant as it must search through all of the
 * registered classes to find the subclasses. The array of subclasses
 * is however cached after the first access, so subsequent accesses are faster.
 */
@property(strong, nonatomic, readonly) NSArray *subclasses;

/**
 * The superclass of this class
 */
@property(nonatomic, readonly) Class superKlass;

/**
 * An array of TJLProperty objects for this class.
 */
@property(strong, nonatomic, readonly) NSArray *properties;

/**
 * An array of TJLMethod objects for this class.
 */
@property(strong, nonatomic, readonly) NSArray *instanceMethods;

/**
 * The Class that is wrapped by the instance of this TJLClass class.
 */
@property(nonatomic, readonly) Class klass;
@end
