//
//  GoodAsynchronousOperation.m
//  OperationTestObjC
//
//  Created by Robert Ryan on 9/22/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//

#import "GoodAsynchronousOperation.h"

@interface GoodAsynchronousOperation ()

@property (nonatomic, copy) void (^completion)(void);
@property (nonatomic)       double duration;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, readwrite, getter = isFinished)  BOOL finished;
@property (nonatomic, readwrite, getter = isExecuting) BOOL executing;

@end

@implementation GoodAsynchronousOperation

@synthesize finished  = _finished;
@synthesize executing = _executing;

- (instancetype)initWithMessage:(NSString *)message duration:(double)duration completion:(void (^)(void))completion
{
    self = [super init];
    if (self) {
        self.message = message;
        self.duration = duration;
        self.completion = completion;
    }
    return self;
}

- (void)main
{
    NSLog(@"starting %@", self.message);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.duration * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"finishing %@", self.message);

        if (self.completion) {
            self.completion();
        }

        [self completeOperation];
    });
}

#pragma mark - NSOperation methods

- (void)start
{
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }

    self.executing = YES;

    [self main];
}

- (void)completeOperation
{
    self.executing = NO;
    self.finished = YES;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isAsynchronous
{
    return YES;
}

- (void)setExecuting:(BOOL)executing
{
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)setFinished:(BOOL)finished
{
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

@end
