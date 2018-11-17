//
//  GameBrain.m
//  pingPong
//
//  Created by Igor Chernyshov on 17/11/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#import "GameBrain.h"

@implementation GameBrain

- (void)increaseSpeed {
  _speed += 0.5;
  if (_speed > 10) _speed = 10;
}

@end
