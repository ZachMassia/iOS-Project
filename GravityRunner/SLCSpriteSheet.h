//
//  SLCSpriteSheet.h
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-11.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SLCSpriteSheet : NSObject
/**
 *  The atlas name.
 */
@property (strong, nonatomic) NSString *name;

/**
 *  The individual animation frames from the atlas.
 */
@property (strong, nonatomic, readonly) NSArray *animationTextures;

/**
 *  A helper for creating animations from an atlas.
 *
 *  @param name The atlas name.
 */
- (instancetype)initWithAtlasNamed:(NSString *)name;

/**
 *  Create an action which animates forever.
 *
 *  @param sec Seconds between each animation frame.
 *
 *  @return The animation action repeated forever.
 */
- (SKAction *)generateAnimationWithTime:(NSTimeInterval)sec;
@end
