//
//  GameBrain.h
//  pingPong
//
//  Created by Igor Chernyshov on 17/11/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HALF_SCREEN_WIDTH SCREEN_WIDTH/2
#define HALF_SCREEN_HEIGHT SCREEN_HEIGHT/2
#define MAX_SCORE 6

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameBrain : NSObject

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) float speed;

- (void)increaseSpeed;

@end

NS_ASSUME_NONNULL_END
