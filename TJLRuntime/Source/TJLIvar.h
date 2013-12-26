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
 * Initializes the class with an instance of a class that
 * holds the ivar, as well as the Ivar itself.
 *
 * @param instance An instance of the object that would hold
 * the Ivar.
 * @param Ivar the Ivar that will be wrapped by this class.
 * @return An object that wraps the info and behaviors of
 * Ivar into Foundation objects.
 */
- (instancetype)initWithInstance:(id)instance ivar:(Ivar)ivar;

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
@property(nonatomic, assign, readonly) Ivar ivar;

/**
 * The instance variable that holds the Ivar that is
 * wrapped by this class.
 */
@property(nonatomic, assign, readonly) id instance;
@end
