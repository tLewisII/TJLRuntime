//
//  TJLPropertiesTests.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/28/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TJLRuntime.h"
#import "TJLTestClass.h"
@interface TJLPropertiesTests : XCTestCase {
    TJLRuntime *_runtime;
    TJLTestClass *_testClass;
    NSArray *_propertyNames;
    NSArray *_propertyTypes;
    NSArray *_propertyIvarValues;
}

@end

@implementation TJLPropertiesTests

- (void)setUp
{
    [super setUp];
    _testClass = [[TJLTestClass alloc]initWithName:@"Terry" number:@42];
    _runtime = [[TJLRuntime alloc]init];
    _propertyNames = @[@"nameString", @"number"];
    _propertyTypes = @[@"NSString", @"NSNumber"];
    _propertyIvarValues = @[@"Terry", @42];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_property_names {
    NSArray *properties = [_runtime propertyNameArrayForClass:_testClass.class];
    XCTAssertTrue(properties.count == _propertyNames.count, @"Count should be the same");
    
    XCTAssertTrue([properties isEqualToArray:_propertyNames], @"Should be equal");
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

- (void)test_property_dictionary {
    NSDictionary *dictionary = [_runtime propertyTypeAndNameDictionaryForClass:_testClass.class];
    NSDictionary *propertyNamesAndTypes = [NSDictionary dictionaryWithObjects:_propertyTypes forKeys:_propertyNames];
    
    XCTAssertTrue([dictionary isEqualToDictionary:propertyNamesAndTypes], @"Should be equal");
}

- (void)test_property_ivar_value {
    NSArray *properties = [_runtime propertiesForClass:_testClass.class withInstance:_testClass];
    XCTAssertTrue(properties.count == _propertyIvarValues.count, @"Count should be the same");
    
    TJLProperty *stringProperty = properties.firstObject;
    TJLProperty *numberProperty = properties.lastObject;
    
    XCTAssertNotNil(stringProperty.ivar, @"Should not be nil");
    XCTAssertNotNil(numberProperty.ivar, @"Should not be nil");
    
    XCTAssertTrue(stringProperty.ivar.instance == _testClass, @"Should be pointer equal");
    XCTAssertTrue(numberProperty.ivar.instance == _testClass, @"Should be pointer equal");
    
    XCTAssertTrue([stringProperty.ivar.value compare:_propertyIvarValues.firstObject] == NSOrderedSame, @"Strings should be the same");
    XCTAssertTrue([numberProperty.ivar.value compare:_propertyIvarValues.lastObject] == NSOrderedSame, @"Numbers should be the same");
}
@end
