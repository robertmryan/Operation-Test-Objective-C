//
//  GoodAsynchronousOperation.h
//  OperationTestObjC
//
//  Created by Robert Ryan on 9/22/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Correct implementation of "NSOperation" subclass that does post the
/// appropriate "isFinished" and "isExecuting" notification
///
/// Because this posts "isFinished" and "isExecuting", this will succeed in
/// recognizing that the operation finished. Thus, if you use dependencies or
/// if you are relying up "maxConcurrentOperationCount", this will
/// work properly.
///
/// Please compare this to BadAsynchronousOperation

@interface GoodAsynchronousOperation : NSOperation

- (instancetype)initWithMessage:(NSString *)message duration:(double)duration completion:(void (^)(void))completion;

@end
