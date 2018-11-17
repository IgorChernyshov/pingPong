//
//  GameBrain.h
//  pingPong
//
//  Created by Igor Chernyshov on 17/11/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameBrain : NSObject

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) float speed;
@property (nonatomic) float dx;
@property (nonatomic) float dy;

- (void)increaseSpeed;
- (void)reset;
- (void)stop;
- (NSInteger)isGameOverWithScoresTop:(NSInteger)top
                              bottom:(NSInteger)bottom;

@end

NS_ASSUME_NONNULL_END
