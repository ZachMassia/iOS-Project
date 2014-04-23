//
//  SLCPauseScene.h
//  GravityRunner
//
//  Created by Student on 2014-04-22.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SLCPauseMenu : SKNode

/**
 *  True when the pause menu is being displayed on screen.
 */
@property (assign, nonatomic, readonly) BOOL isVisible;

- (id)initWithParentNode:(SKNode *)parent;

/**
 *  Hide the menu by fading it out.
 *
 *  @param sec The fade animation duration in seconds.
 */
- (void)hideWithFadeDuration:(NSTimeInterval)sec;

/**
 *  Show the meny by fading it in.
 *
 *  @param sec The fade animation duration in seconds.
 */
- (void)showWithFadeDuration:(NSTimeInterval)sec;

@end
