//
//  Player.h
//  GravityRunner
//
//  Created by Student on 2014-04-01.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.

#import <SpriteKit/SpriteKit.h>
#import "SLCSpriteSheet.h"

@interface Player : SKSpriteNode
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint velocity;

@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) BOOL upsideDown;
@property (nonatomic, assign) NSInteger gravDir;

@property (nonatomic, strong) SLCSpriteSheet *spriteSheet;

- (void)update:(NSTimeInterval)delta;


- (CGRect)collisionBoundingBox;

/**
 *  Flip the player, reversing the walk animation.
 */
- (void)flip;
@end
