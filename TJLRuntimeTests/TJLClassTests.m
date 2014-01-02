//
//  TJLClassTests.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 1/1/14.
//  Copyright (c) 2014 Terry Lewis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TJLRuntime.h"
@interface TJLClassTests : XCTestCase {
    TJLClass *_newClass;
    TJLRuntime *_runtime;
}

@end

@implementation TJLClassTests

- (void)setUp {
    [super setUp];
    _runtime = [TJLRuntime new];
}

- (void)tearDown {
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_new_class_creation {
    _newClass = [_runtime createNewClassWithName:@"TJLRuntimeClass" superClass:Klass(NSObject)];
    XCTAssertNotNil(_newClass, @"Should not be nil");
    [_runtime registerClass:_newClass];
    
    TJLClass *class = [TJLClass classWithName:@"TJLRuntimeClass"];
    XCTAssertNotNil(class, @"Should not be nil");
}

- (void)test_class_add_property {
    _newClass = [_runtime createNewClassWithName:@"TJLRuntimeClassTwo" superClass:[NSObject class]];
    XCTAssertNotNil(_newClass, @"Should not be nil");
    
    BOOL success = [_newClass addPropertyToClassWithIvarAndDefaultPropertiesAndName:@"superProperty" type:ClassString(NSString)];
    XCTAssertTrue(success, @"Should have been a success");
    
    TJLProperty *p = [TJLProperty propertyWithClass:_newClass.klass name:@"superProperty" ivarInstance:[_newClass.klass new]];
    [_runtime registerClass:_newClass];
    [p.ivar setValue:@"added value"];
    
    XCTAssertTrue([p.ivar.value isEqualToString:@"added value"], @"Strings should be equal");
}
@end
