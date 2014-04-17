//
//  Player.h
//  GravityRunner
//
//  Created by Student on 2014-04-01.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.

#import <SpriteKit/SpriteKit.h>
#import "SLCSpriteSheet.h"

/**
 *  The main player.
 */
@interface SLCPlayer : SKSpriteNode
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint velocity;

/**
 *  True when the player is in contact with a horizontal surface.
 */
@property (nonatomic, assign) BOOL onGround;

/**
 *  True when the player is running on the top surface.
 */
@property (nonatomic, assign) BOOL upsideDown;

/**
 *  The gravity direction.
 */
@property (nonatomic, assign) NSInteger gravDir;

/**
 *  Holds all the textures from the player's animation atlas.
 */
@property (nonatomic, strong) SLCSpriteSheet *spriteSheet;

/**
 *  Update the player's position and perform any collision checks.
 *
 *  @param delta Time since last frame.
 */
- (void)update:(NSTimeInterval)delta;

/**
 *  The player's bounding box, taking in to account any blank areas from the texture.
 *
 *  @return The bounding box as a CGRect.
 */
- (CGRect)collisionBoundingBox;

/**
 *  Flip the player, reversing the walk animation.
 */
- (void)flip;
@end
