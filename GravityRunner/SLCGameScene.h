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
 *  All sound effects and music are stored here. They are all loaded when the dictionary
 *  is accessed for the first time.
 */
@property (nonatomic, strong, readonly) NSDictionary *sounds;

/**
 *  Initializes the main gameplay scene with the given level.
 *
 *  @param size  The size of the scene.
 *  @param level The level to load.
 *
 *  @return The initialized scene.
 */
- (id)initWithSize:(CGSize)size level:(NSUInteger)level;

/**
 *  Stops the background music if it is playing.
 */
- (void)stopBackgroundMusic;
@end
