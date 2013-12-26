//
//  TJLRuntimeTests.m
//  TJLRuntimeTests
//
//  Created by Terry Lewis II on 12/25/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TJLRuntime.h"
#import "TJLTestClass.h"

@interface TJLRuntimeTests : XCTestCase {
    TJLRuntime *_runtime;
    TJLTestClass *_testClass;
    NSArray *_propertyNames;
    NSArray *_propertyTypes;
}

@end

@implementation TJLRuntimeTests

- (void)setUp {
    [super setUp];
    _testClass = [[TJLTestClass alloc]initWithName:@"Terry" number:@42];
    _runtime = [[TJLRuntime alloc]init];
    _propertyNames = @[@"nameString", @"number"];
    _propertyTypes = @[@"NSString", @"NSNumber"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_property_names {
    NSArray *properties = [_runtime propertyNameArrayForClass:_testClass.class];
    XCTAssertTrue(properties.count == _propertyNames.count, @"Count should be the same");
    
    for(NSInteger i = 0; i < properties.count; i++) {
        NSString *runtimeName = properties[i];
        NSString *staticName = _propertyNames[i];
        XCTAssertTrue([runtimeName isEqualToString:staticName], @"Names should be equal");
    }
        
}

- (void)test_property_types {
    NSArray *properties = [_runtime propertiesForClass:_testClass.class];
    XCTAssertTrue(properties.count == _propertyTypes.count, @"Count should be the same");
    
    for(NSInteger i = 0; i < properties.count; i++) {
        TJLProperty *runtimeProperty = properties[i];
        NSString *staticType = _propertyTypes[i];
        XCTAssertTrue([runtimeProperty.type isEqualToString:staticType], @"Types should be equal");
    }
}
@end
