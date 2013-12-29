//
//  TJLMethodTests.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/28/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TJLRuntime.h"
#import "TJLTestClass.h"
@interface TJLMethodTests : XCTestCase {
    TJLRuntime *_runtime;
    TJLTestClass *_testClass;
    NSArray *_methodNames;
    NSArray *_methodTypes;
    NSArray *_methodReturnValues;
    NSArray *_methodArgumentCounts;
}

@end

@implementation TJLMethodTests

- (void)setUp {
    [super setUp];
    _runtime = [TJLRuntime new];
    _testClass = [[TJLTestClass alloc]initWithName:@"Terry" number:@42];
    _methodNames = @[@"initWithName:number:", @"nameString", @".cxx_destruct", @"setNumber:", @"number", @"setNameString:", @"puppyString"];
    _methodTypes = @[@"id", @"id", @"void", @"void", @"id", @"void", @"id", @"id"];
    _methodArgumentCounts = @[@4, @2, @2, @3, @2, @3, @2];
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_method_names {
    NSArray *methods = [_runtime methodNameArrayForClass:_testClass.class];
    XCTAssertTrue([methods isEqualToArray:_methodNames], @"Should be true");
}

- (void)test_method_return_types {
    NSArray *methods = [_runtime methodsForClass:_testClass.class];
    for(NSInteger i = 0; i < methods.count; i++) {
        XCTAssertTrue([[methods[i] returnType] isEqualToString:_methodTypes[i]], @"Should be true");
    }
}

- (void)test_method_argument_count {
    NSArray *methods = [_runtime methodsForClass:_testClass.class];
    for(NSInteger i = 0; i < methods.count; i++) {
        NSLog(@"%lu", (unsigned long)[methods[i] argumentCount]);
        XCTAssertTrue([@([methods[i] argumentCount]) compare:_methodArgumentCounts[i]] == NSOrderedSame, @"Should be true");
    }
}

- (void)test_void_method_invocation {
    TJLMethod *method = [_runtime instanceMethodForClass:_testClass.class selector:@selector(setNameString:)];
    XCTAssertTrue([_testClass.nameString isEqualToString:@"Terry"], @"Name should be Terry");
    
    [method invokeVoidMethodWithInstanceOfClass:_testClass args:@[@"Bob"]];
    XCTAssertTrue([_testClass.nameString isEqualToString:@"Bob"], @"Name should now be Bob");
}

- (void)test_method_with_return_type_invocation {
    TJLMethod *method = [_runtime instanceMethodForClass:_testClass.class selector:@selector(puppyString)];
    XCTAssertTrue([_testClass.puppyString isEqualToString:@"Wow, much puppy."], @"String should be \"Wow, much puppy.\"");
    
    NSString *string = [method invokeMethodWithInstanceOfClass:_testClass args:nil];
    XCTAssertTrue([string isEqualToString:@"Wow, much puppy."], @"Strings should be equal.");
}

@end
