//
//  SLCMyScene.h
//  GravityRunner
//

//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

/**
 *  The main gameplay scene.
 */
@interface SLCGameScene : SKScene

/**
 *  Initializes the main gameplay scene with the given level.
 *
 *  @param size  The size of the scene.
 *  @param level The level to load.
 *
 *  @return The initialized scene.
 */
- (id)initWithSize:(CGSize)size level:(NSUInteger)level;
@end
