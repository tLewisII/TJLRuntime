//
//  TJLIvarTests.m
//  TJLRuntime
//
//  Created by Terry Lewis II on 12/28/13.
//  Copyright (c) 2013 Terry Lewis. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TJLRuntime.h"
#import "TJLTestClass.h"
@interface TJLIvarTests : XCTestCase {
    TJLRuntime *_runtime;
    TJLTestClass *_testClass;
    NSArray *_ivarNames;
    NSArray *_ivarTypes;
    NSArray *_ivarValues;

}

@end

@implementation TJLIvarTests

- (void)setUp
{
    [super setUp];
    _testClass = [[TJLTestClass alloc]initWithName:@"Terry" number:@42];
    _runtime = [[TJLRuntime alloc]init];
    _ivarNames = @[@"_ivarArray", @"_ivarDict", @"_nameString", @"_number"]; //Also includes ivars for synthesized properties.
    _ivarTypes = @[@"NSArray", @"NSMutableDictionary", @"NSString", @"NSNumber"];
    _ivarValues = @[@[@"array"], [NSMutableDictionary dictionaryWithDictionary:@{@"bob" : @"uncle"}], @"Terry", @42];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_ivar_names {
    NSArray *ivars = [_runtime ivarNameArrayForClass:_testClass.class];
    
    XCTAssertTrue(ivars.count == _ivarNames.count, @"Counts should be equal");
    for(NSInteger i = 0; i < ivars.count; i++) {
        NSString *runtimeName = ivars[i];
        NSString *staticName = _ivarNames[i];
        XCTAssertTrue([runtimeName isEqualToString:staticName], @"Names should be equal");
    }
}

- (void)test_ivar_types {
    NSArray *ivars = [_runtime ivarsForClass:_testClass.class];
    XCTAssertTrue(ivars.count == _ivarTypes.count, @"Count should be the same");
    
    for(NSInteger i = 0; i < ivars.count; i++) {
        TJLIvar *runtimeIvar = ivars[i];
        NSString *staticType = _ivarTypes[i];
        XCTAssertTrue([runtimeIvar.type isEqualToString:staticType], @"Types should be equal");
    }
}

- (void)test_ivar_dictionary {
    NSDictionary *dictionary = [_runtime ivarTypeAndNameDictionaryForClass:_testClass.class];
    NSDictionary *ivarNamesAndTypes = [NSDictionary dictionaryWithObjects:_ivarTypes forKeys:_ivarNames];
    
    XCTAssertTrue([dictionary isEqualToDictionary:ivarNamesAndTypes], @"Should be equal");
    
}

- (void)test_ivar_values {
    NSArray *ivars = [_runtime ivarsForClass:_testClass.class instance:_testClass];
    XCTAssertTrue(ivars.count == _ivarValues.count, @"Count should be the same");
    
    for(NSInteger i = 0; i < ivars.count; i++) {
        TJLIvar *ivar = ivars[i];
        if([ivar.value isKindOfClass:[NSArray class]]) {
            NSArray *value = _ivarValues[i];
            XCTAssertTrue([value isEqualToArray:ivar.value], @"Should be true");
        }
        else if([ivar.value isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableDictionary *dict = ivar.value;
            XCTAssertTrue([dict isEqualToDictionary:ivar.value], @"Should be equal");
        }
        else {
            XCTAssertTrue([ivar.value compare:_ivarValues[i]] == NSOrderedSame, @"Should be equal");
        }
    }
}
@end
