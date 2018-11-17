//
//  GameBrain.m
//  pingPong
//
//  Created by Igor Chernyshov on 17/11/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#define MAX_SCORE 6

#import "GameBrain.h"

@implementation GameBrain

- (void)increaseSpeed {
  _speed += 0.5;
  if (_speed > 10) _speed = 10;
}

- (void)reset {
  if ((arc4random() % 2) == 0) {
    _dx = -1;
  } else {
    _dx = 1;
  }
  
  if (_dy != 0) {
    _dy = -_dy;
  } else if ((arc4random() % 2) == 0) {
    _dy = -1;
  } else  {
    _dy = 1;
  }
  _speed = 2;
}

- (void)stop {
  if (_timer) {
    [_timer invalidate];
    _timer = nil;
  }
}

- (NSInteger)isGameOverWithScoresTop:(NSInteger)top
                              bottom:(NSInteger)bottom {
  if (top >= MAX_SCORE) return 1;
  if (bottom >= MAX_SCORE) return 2;
  return 0;
}

@end
