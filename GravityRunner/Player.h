//
//  Player.h
//  GravityRunner
//
//  Created by Student on 2014-04-01.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint velocity;

@property (nonatomic, assign) BOOL onGround;

@property (nonatomic, assign) BOOL moveForwardIntent;
@property (nonatomic, assign) BOOL jumpIntent;

@property (nonatomic, assign) NSInteger gravDir;

- (void)update:(NSTimeInterval)delta;
- (CGRect)collisionBoundingBox;
@end
