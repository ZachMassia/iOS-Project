//
//  SLCPauseScene.h
//  GravityRunner
//
//  Created by Student on 2014-04-22.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SLCGameScene;

@interface SLCPauseScene : SKScene

/**
 *  A pointer to the game scene so the state can be kept.
 */
@property (nonatomic, strong) SLCGameScene *otherScene;

@end
