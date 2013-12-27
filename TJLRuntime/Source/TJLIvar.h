//
//  TJLIvar.h
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/25/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface TJLIvar : NSObject

/**
 * Initializes the class with an Ivar. Note that without an
 * instance of the class that holds the Ivar, you cannot get or
 * set the value of the Ivar.
 *
 * @param Ivar the Ivar that will be wrapped by this class.
 * @return An object that wraps the info and behaviors of
 * Ivar into Foundation objects.
 */
- (instancetype)__attribute__((nonnull(1)))initWithIvar:(Ivar)ivar;

/**
 * Initializes the class with an instance of a class that
 * holds the ivar, as well as the Ivar itself.
 *
 * @param Ivar the Ivar that will be wrapped by this class.
 * @param instance An instance of the object that would hold
 * the Ivar.
 * @return An object that wraps the info and behaviors of
 * Ivar into Foundation objects.
 */
- (instancetype)__attribute__((nonnull(1)))initWithIvar:(Ivar)ivar instance:(id)instance;

/**
 * Looks up a ivar by name for the given class.
 * If no ivar was found, returns nil.
 *
 * @param klass The class that the ivar is attached to.
 * @param name the name of the ivar.
 * @return An object that wraps the info and behaviors of
 * Ivar into Foundation objects. Returns nil if
 * no ivar was found for the given name on the given class.
 */
+ (instancetype)__attribute__((nonnull(1, 2)))ivarForClass:(Class)klass name:(NSString *)name;

/**
 * Looks up a ivar by name for the given class.
 * If no ivar was found, returns nil.
 *
 * @param klass The class that the ivar is attached to.
 * @param name the name of the ivar.
 * @param instance An instance of the object that would hold
 * the Ivar.
 * @return An object that wraps the info and behaviors of
 * Ivar into Foundation objects. Returns nil if
 * no ivar was found for the given name on the given class.
 */
+ (instancetype)__attribute__((nonnull(1, 2)))ivarForClass:(Class)klass name:(NSString *)name instance:(id)instance;

/**
 * The value associated with this Ivar. Is a read/write
 * property.
 */
@property(strong, nonatomic) id value;

/**
 * The name of the Ivar. If Ivar is backing an auto synthesized
 * property, the name will have a leading underscore.
 */
@property(strong, nonatomic, readonly) NSString *name;

/**
 * The type of the Ivar.
 */
@property(strong, nonatomic, readonly) NSString *type;

/**
 * The Ivar that this class wraps.
 */
@property(nonatomic, readonly) Ivar ivar;

/**
 * The instance variable that holds the Ivar that is
 * wrapped by this class.
 */
@property(strong, nonatomic, readonly) id instance;
@end
