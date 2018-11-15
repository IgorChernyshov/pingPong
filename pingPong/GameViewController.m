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
#define MAX_SCORE 6

#import "GameViewController.h"

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
@property (strong, nonatomic) NSTimer * timer;
@property (nonatomic) float dx;
@property (nonatomic) float dy;
@property (nonatomic) float speed;
@property (strong, nonatomic) UILabel *scoreTop;
@property (strong, nonatomic) UILabel *scoreBottom;

@end

@implementation GameViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self config];
}

- (void)config {
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
  
  // Paddles
  _paddleTop = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, 90, 60)];
  _paddleTop.image = [UIImage imageNamed:@"paddleTop"];
  _paddleTop.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:_paddleTop];
  
  _paddleBottom = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120, SCREEN_HEIGHT - 90, 90, 60)];
  _paddleBottom.image = [UIImage imageNamed:@"paddleBottom"];
  _paddleBottom.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:_paddleBottom];
  
  // Ball
  _ball = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x - 10, self.view.center.y - 10, 20, 20)];
  _ball.backgroundColor = [UIColor whiteColor];
  _ball.layer.cornerRadius = 10;
  _ball.hidden = YES;
  [self.view addSubview:_ball];
  
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
