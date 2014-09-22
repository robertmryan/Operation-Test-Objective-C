//
//  BadAsynchronousOperation.h
//  OperationTestObjC
//
//  Created by Robert Ryan on 9/22/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Incorrect implementation of NSOperation subclass that does not post the
/// appropriate "isFinished" and "isExecuting" notifications.
///
/// It doesn't matter if this posts "executing" and/or "finished", or posts nothing:
/// Because it fails to post "isFinished" and "isExecuting", this will fail to
/// recognize that the operation finished. Thus, if you use dependencies or
/// if you are relying up "maxConcurrentOperationCount", this will not
/// work properly.
///
/// Note, this failure only manifests itself if (a) this is an asynchronous
/// operation; and (b) that it actually only completes asynchronously.
///
/// Please compare this to GoodAsynchronousOperation

@interface BadAsynchronousOperation : NSOperation

- (instancetype)initWithMessage:(NSString *)message duration:(double)duration completion:(void (^)(void))completion;

@end
