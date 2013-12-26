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
- (instancetype)initWithClass:(Class)klass method:(Method)method;

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
+ (instancetype)instanceMethodWithClass:(Class)klass selector:(SEL)selector;

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
+ (instancetype)instanceMethodWithClass:(Class)klass name:(NSString *)name;

/**
 * Method swizzling. Exchanges the method implementation of
 * This method with the method implementation of the method that
 * is passed in.
 *
 * @param method The method whose implementation you would like to
 * exchange with the method of this class.
 */
- (void)exchangeMethodImplementationWithMethod:(TJLMethod *)method;

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
 * The Method that was used to initialize this class.
 */
@property(nonatomic, readonly) Method method;
/**
 * The class that this method belongs to.
 */
@property(nonatomic, readonly) Class klass;
@end
