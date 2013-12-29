//
//  TJLMethod.h
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/26/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface TJLMethod : NSObject

/**
 * Initialize the class with a single Method
 * and class.
 *
 * @param klass The class that the method is declared in.
 * @param method A method that represents a single method
 * declared in the given class.
 */
- (instancetype)__attribute__((nonnull(1, 2)))initWithClass:(Class)klass method:(Method)method;

/**
 * Initialize the class with a method that is found
 * based on the given selector and class.
 *
 * @param klass The class that the method is declared in.
 * @param selector A selector for the method you want this class
 * to encapsulate. Must be a selector that is an instance method on
 * the given class.
 * @return If the method for `selector` was found in the given class,
 * An object that wraps the info and behaviors of
 * Method into Foundation objects. Otherwise returns nil.
 */
+ (instancetype)__attribute__((nonnull(1, 2)))instanceMethodWithClass:(Class)klass selector:(SEL)selector;

/**
 * Initialize the class with a method that is found
 * based on the given name and class.
 *
 * @param klass The class that the method is declared in.
 * @param name The name of a selector for the method you want this class
 * to encapsulate. Must be a name of a method that is an instance method on
 * the given class.
 * @return If the method for `name` was found in the given class,
 * An object that wraps the info and behaviors of
 * Method into Foundation objects. Otherwise returns nil.
 */
+ (instancetype)__attribute__((nonnull(1, 2)))instanceMethodWithClass:(Class)klass name:(NSString *)name;

/**
 * Method swizzling. Exchanges the method implementation of
 * This method with the method implementation of the method that
 * is passed in.
 *
 * @param method The method whose implementation you would like to
 * exchange with the method of this class.
 */
- (void)__attribute__((nonnull(1)))exchangeMethodImplementationWithMethod:(TJLMethod *)method;

/**
 * Replaces the implementation of this method with the implementation of the given method.
 *
 * @param method The method whose implementation you would like to replace the
 * implementation of this method with.
 */
- (void)__attribute__((nonnull(1)))setMethodImplementationWithMethod:(TJLMethod *)method;

/**
 * Ivokes the method that is wrapped by this class with the given instance and args.
 * Call this method if you know that the method to be invoked has a `void` return type,
 * otherwise call `invokeMethodWithInstanceOfClass:args:`.
 *
 * @param instance The instance of the class that is the target of the method
 * invocation.
 * @param args The arguments, if any, that are passed to the method.
 */
- (void)__attribute__((nonnull(1)))invokeVoidMethodWithInstanceOfClass:(id)instance args:(NSArray *)args;

/**
 * Ivokes the method that is wrapped by this class with the given instance and args.
 * Call this method if you know that the method to be invoked returns a value,
 * otherwise call `invokeVoidMethodWithInstanceOfClass:args:`.
 *
 * @param instance The instance of the class that is the target of the method
 * invocation.
 * @param args The arguments, if any, that are passed to the method.
 */
- (id)__attribute__((nonnull(1)))invokeMethodWithInstanceOfClass:(id)instance args:(NSArray *)args;

/**
 * The name of the method. A method declared as
 * `- (void)doStuff:(id)stuff withThing:(id)thing;` would
 * return "doStuff:withThing:".
 */
@property(strong, nonatomic, readonly) NSString *name;

/**
 * The number of arguments that the method will accept.
 */
@property(nonatomic, readonly) NSUInteger argumentCount;

/**
 * The return type of the method. Note that it is not possible
 * to get the class of any object return types, so any method that
 * returns an object type will simply read as "id";
 */
@property(strong, nonatomic, readonly) NSString *returnType;

/**
 * The selector for this method.
 */
@property(nonatomic, readonly) SEL selector;

/**
 * The Method that was used to initialize this class.
 */
@property(nonatomic, readonly) Method method;
/**
 * The class that this method belongs to.
 */
@property(nonatomic, readonly) Class klass;
@end
