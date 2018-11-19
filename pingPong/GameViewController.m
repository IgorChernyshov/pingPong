//
//  GameViewController.m
//  pingPong
//
//  Created by Igor Chernyshov on 15/11/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HALF_SCREEN_WIDTH SCREEN_WIDTH/2
#define HALF_SCREEN_HEIGHT SCREEN_HEIGHT/2
#define BALL_SIZE_COEFFICIENT 0.05
#define BALL_SIZE 20

#import "GameViewController.h"
#import "GameBrain.h"

@interface GameViewController ()

@property (strong, nonatomic) UIImageView *paddleTop;
@property (strong, nonatomic) UIImageView *paddleBottom;
@property (strong, nonatomic) UIView *netView;
@property (strong, nonatomic) UIView *topBorderView;
@property (strong, nonatomic) UIView *bottomBorderView;
@property (strong, nonatomic) UIView *leftBorderView;
@property (strong, nonatomic) UIView *rightBorderView;
@property (strong, nonatomic) UIView *middleSeparatorView;
@property (strong, nonatomic) UIView *ball;
@property (strong, nonatomic) UITouch *topTouch;
@property (strong, nonatomic) UITouch *bottomTouch;
@property (strong, nonatomic) UILabel *scoreTop;
@property (strong, nonatomic) UILabel *scoreBottom;

@property (nonatomic) NSInteger scoreTopValue;
@property (nonatomic) NSInteger scoreBottomValue;

@property (strong, nonatomic) GameBrain *gameBrain;

@end

@implementation GameViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _gameBrain = [GameBrain new];
  [self prepareUI];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self selectDifficulty];
}

#pragma mark Touches handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    CGPoint point = [touch locationInView:self.view];
    if (_bottomTouch == nil && point.y > HALF_SCREEN_HEIGHT) {
      _bottomTouch = touch;
      _paddleBottom.center = CGPointMake(point.x, point.y);
    }
    else if (_topTouch == nil && point.y < HALF_SCREEN_HEIGHT) {
      _topTouch = touch;
      _paddleTop.center = CGPointMake(point.x, point.y);
    }
  }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    CGPoint point = [touch locationInView:self.view];
    if (touch == _topTouch) {
      if (point.y > HALF_SCREEN_HEIGHT) {
        _paddleTop.center = CGPointMake(point.x, HALF_SCREEN_HEIGHT);
        return;
      }
      _paddleTop.center = point;
    }
    else if (touch == _bottomTouch) {
      if (point.y < HALF_SCREEN_HEIGHT) {
        _paddleBottom.center = CGPointMake(point.x, HALF_SCREEN_HEIGHT);
        return;
      }
      _paddleBottom.center = point;
    }
  }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  for (UITouch *touch in touches) {
    if (touch == _topTouch) {
      _topTouch = nil;
    }
    else if (touch == _bottomTouch) {
      _bottomTouch = nil;
    }
  }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self touchesEnded:touches withEvent:event];
}

# pragma mark Game Brains

// Redefine score setters and getters
- (NSInteger)scoreTopValue {
  return [_scoreTop.text intValue];
}

- (void)setScoreTopValue:(NSInteger)scoreTopValue {
  _scoreTop.text = [NSString stringWithFormat:@"%ld", scoreTopValue];
}

- (NSInteger)scoreBottomValue {
  return [_scoreBottom.text intValue];
}

- (void)setScoreBottomValue:(NSInteger)scoreBottomValue  {
  _scoreBottom.text = [NSString stringWithFormat:@"%ld", scoreBottomValue];
}

// Game controller
- (void)reset {
  [_gameBrain reset];
  _ball.frame = CGRectMake(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, BALL_SIZE, BALL_SIZE);
}

- (void)newGame {
  [self reset];
  
  self.scoreTopValue = 0;
  self.scoreBottomValue = 0;
  
  [self displayMessage:@"Tap OK to start"];
}

- (void)selectDifficulty {
  UIAlertController *__block alertController = [UIAlertController alertControllerWithTitle:@"Ping Pong" message:@"Select difficulty" preferredStyle:(UIAlertControllerStyleAlert)];
  UIAlertAction *easy = [UIAlertAction actionWithTitle:@"Easy" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    self.gameBrain.difficulty = 3;
    [self newGame];
  }];
  UIAlertAction *medium = [UIAlertAction actionWithTitle:@"Medium" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    self.gameBrain.difficulty = 5;
    [self newGame];
  }];
  UIAlertAction *hard = [UIAlertAction actionWithTitle:@"Hard" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    self.gameBrain.difficulty = 10;
    [self newGame];
  }];
  [alertController addAction:easy];
  [alertController addAction:medium];
  [alertController addAction:hard];
  [self presentViewController:alertController animated:true completion:nil];
}

- (void)start {
  _ball.center = CGPointMake(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT);
  if (!_gameBrain.timer) {
    _gameBrain.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
  }
  _ball.hidden = NO;
}

- (void)stop {
  [_gameBrain stop];
  _ball.hidden = YES;
}

- (void)displayMessage:(NSString *)message {
  [self stop];
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ping Pong" message:message preferredStyle:(UIAlertControllerStyleAlert)];
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    if ([self gameOver]) {
      [self newGame];
      return;
    }
    [self reset];
    [self start];
  }];
  [alertController addAction:action];
  [self presentViewController:alertController animated:YES completion:nil];
}

- (void)animateBall {
  if (CGRectIntersectsRect(_ball.frame, _netView.frame)) {
    // If ball crosses the net - set it size to initial values
    _ball.frame = CGRectMake(_ball.frame.origin.x, _ball.frame.origin.y, BALL_SIZE, BALL_SIZE);
  } else if (((_gameBrain.dy > 0) && (_ball.center.y < HALF_SCREEN_HEIGHT)) || ((_gameBrain.dy < 0) && (_ball.center.y > HALF_SCREEN_HEIGHT))) {
    // If ball is approaching the net - increase it size
    _ball.frame = CGRectMake(_ball.frame.origin.x, _ball.frame.origin.y, _ball.frame.size.height + BALL_SIZE_COEFFICIENT, _ball.frame.size.width + BALL_SIZE_COEFFICIENT);
  } else if (((_gameBrain.dy > 0) && (_ball.center.y > HALF_SCREEN_HEIGHT)) || ((_gameBrain.dy < 0) && (_ball.center.y < HALF_SCREEN_HEIGHT))) {
    // If ball is flying away from the net - decrease it size
    _ball.frame = CGRectMake(_ball.frame.origin.x, _ball.frame.origin.y, _ball.frame.size.height - BALL_SIZE_COEFFICIENT, _ball.frame.size.width - BALL_SIZE_COEFFICIENT);
  }
  // Calculate new corner radius and then finally move the ball into right direction
  _ball.layer.cornerRadius = _ball.frame.size.height / 2;
  _ball.center = CGPointMake(_ball.center.x + _gameBrain.dx * _gameBrain.speed, _ball.center.y + _gameBrain.dy * _gameBrain.speed);
}

- (void)moveAI {
  // If top paddle is more then "difficulty" pixels away from the ball - move it towards the ball
  if ((_paddleTop.center.x < _ball.center.x) && (_paddleTop.center.x + self.gameBrain.difficulty < _ball.center.x)) {
    _paddleTop.center = CGPointMake(_paddleTop.center.x + self.gameBrain.difficulty, _paddleTop.center.y);
  } else if ((_paddleTop.center.x > _ball.center.x) && (_paddleTop.center.x - self.gameBrain.difficulty > _ball.center.x)) {
    _paddleTop.center = CGPointMake(_paddleTop.center.x - self.gameBrain.difficulty, _paddleTop.center.y);
  }
}

- (BOOL)checkCollision: (CGRect)rect X:(float)x Y:(float)y {
  if (CGRectIntersectsRect(_ball.frame, rect)) {
    [_gameBrain processCollisionAtX:x andY:y];
    return YES;
  }
  return NO;
}

- (BOOL)goal
{
  if (_ball.center.y < 0 || _ball.center.y >= SCREEN_HEIGHT) {
    if (_ball.center.y < 0) ++self.scoreBottomValue; else ++self.scoreTopValue;
    NSInteger gameOver = [self gameOver];
    if (gameOver) {
      [self displayMessage:[NSString stringWithFormat:@"Player %li won!", gameOver]];
    } else {
      [self reset];
    }
    
    return YES;
  }
  return NO;
}

- (void)animate {
  [self animateBall];
  [self moveAI];
  
  [self checkCollision:_leftBorderView.frame X:fabs(_gameBrain.dx) Y:0];
  [self checkCollision:_rightBorderView.frame X:-fabs(_gameBrain.dx) Y:0];
  if ([self checkCollision:_paddleTop.frame X:(_ball.center.x - _paddleTop.center.x) / 32.0 Y:1]) {
    [_gameBrain increaseSpeed];
  }
  if ([self checkCollision:_paddleBottom.frame X:(_ball.center.x - _paddleBottom.center.x) / 32.0 Y:-1]) {
    [_gameBrain increaseSpeed];
  }
  [self goal];
}

- (NSInteger)gameOver {
  return [_gameBrain isGameOverWithScoresTop:self.scoreTopValue bottom:self.scoreBottomValue];
}


#pragma mark Prepare UI

- (void)prepareUI {
  [self createTable];
  [self createPaddles];
  [self createBall];
  [self createScores];
}

- (void)createTable {
  // Table
  self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:135.0/255.0 blue:191.0/255.0 alpha:1.0];
  
  // Borders
  _topBorderView = [[UIView alloc] initWithFrame:CGRectMake(4, 0, SCREEN_WIDTH - 8, 4)];
  _topBorderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
  [self.view addSubview:_topBorderView];
  
  _bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(4, SCREEN_HEIGHT - 4, SCREEN_WIDTH - 8, 4)];
  _bottomBorderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
  [self.view addSubview:_bottomBorderView];
  
  _leftBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, SCREEN_HEIGHT)];
  _leftBorderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
  [self.view addSubview:_leftBorderView];
  
  _rightBorderView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 4, 0, 4, SCREEN_HEIGHT)];
  _rightBorderView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
  [self.view addSubview:_rightBorderView];
  
  _middleSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(HALF_SCREEN_WIDTH - 2, 4, 4, SCREEN_HEIGHT - 8)];
  _middleSeparatorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
  [self.view addSubview:_middleSeparatorView];
  
  // Net
  _netView = [[UIView alloc] initWithFrame:CGRectMake(4, HALF_SCREEN_HEIGHT - 2, SCREEN_WIDTH - 8, 4)];
  _netView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:_netView];
}

- (void)createPaddles {
  // Paddles
  _paddleTop = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, 90, 60)];
  _paddleTop.image = [UIImage imageNamed:@"paddleTop"];
  _paddleTop.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:_paddleTop];
  
  _paddleBottom = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT - 90, 90, 60)];
  _paddleBottom.image = [UIImage imageNamed:@"paddleBottom"];
  _paddleBottom.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:_paddleBottom];
}

- (void)createBall {
  // Ball
  _ball = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - BALL_SIZE / 2, self.view.center.y - BALL_SIZE / 2, BALL_SIZE, BALL_SIZE)];
  _ball.backgroundColor = [UIColor whiteColor];
  _ball.layer.cornerRadius = _ball.frame.size.height / 2;
  _ball.hidden = YES;
  [self.view addSubview:_ball];
}

- (void)createScores {
  // Scores
  _scoreTop = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, HALF_SCREEN_HEIGHT - 70, 50, 50)];
  _scoreTop.textColor = [UIColor whiteColor];
  _scoreTop.text = @"0";
  _scoreTop.font = [UIFont systemFontOfSize:40.0 weight:UIFontWeightLight];
  _scoreTop.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:_scoreTop];
  
  _scoreBottom = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, HALF_SCREEN_HEIGHT + 20, 50, 50)];
  _scoreBottom.textColor = [UIColor whiteColor];
  _scoreBottom.text = @"0";
  _scoreBottom.font = [UIFont systemFontOfSize:40.0 weight:UIFontWeightLight];
  _scoreBottom.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:_scoreBottom];
}

@end
