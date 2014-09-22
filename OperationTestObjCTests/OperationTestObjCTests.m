//
//  OperationTestObjCTests.m
//  OperationTestObjCTests
//
//  Created by Robert Ryan on 9/22/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GoodAsynchronousOperation.h"
#import "BadAsynchronousOperation.h"

@interface OperationTestObjCTests : XCTestCase

@end

@implementation OperationTestObjCTests

- (void)testGoodOperation {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"first expectation"];
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"second expectation"];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    NSOperation *op1 = [[GoodAsynchronousOperation alloc] initWithMessage:@"first" duration:2.0 completion:^{
        [expectation1 fulfill];
    }];
    NSOperation *op2 = [[GoodAsynchronousOperation alloc] initWithMessage:@"second" duration:2.0 completion:^{
        [expectation2 fulfill];
    }];
    [op2 addDependency:op1];
    [queue addOperations:@[op1, op2] waitUntilFinished:NO];

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testBadOperation {
    XCTestExpectation *expectation1 = [self expectationWithDescription:@"first expectation"];
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"second expectation"];

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    NSOperation *op1 = [[BadAsynchronousOperation alloc] initWithMessage:@"first" duration:2.0 completion:^{
        [expectation1 fulfill];
    }];

    // note, because `BadAsynchronousOperation` doesn't do the appropriate KVO,
    // this second operation will never fire, thus the second expectation will
    // never be fulfilled, and the `waitForExpectationsWithTimeout` below will fail.

    NSOperation *op2 = [[BadAsynchronousOperation alloc] initWithMessage:@"second" duration:2.0 completion:^{
        [expectation2 fulfill];
    }];
    [op2 addDependency:op1];

    [queue addOperation:op1];
    [queue addOperation:op2];

    // let's wait five seconds for those two operations to complete and fulfill the two expectations

    [self waitForExpectationsWithTimeout:5.0 handler:nil];

    // Given this second operation would not have fired, we probably should cancel it when we clean up

    [queue cancelAllOperations];
}

@end
