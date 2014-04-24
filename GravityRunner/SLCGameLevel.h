//
//  SLCGameLevel.h
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-18.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSTileMap.h"

@class SKNode;

/**
 *  A helper class for  a level.
 */
@interface SLCGameLevel : NSObject

@property (nonatomic, assign) NSUInteger level;

/**
 *  The current map.
 */
@property (nonatomic, strong) JSTileMap *map;

/**
 *  The wall layer of the current map. This is the layer the player collides with.
 */
@property (nonatomic, strong) TMXLayer  *walls;

/**
 *  The trap layer of the current map. This is the layer that kills the player.
 */
@property (nonatomic, strong) TMXLayer *traps;

/**
 *  The object layer of the current map. Used for collectables, spawn points, etc.
 */
@property (nonatomic, strong) TMXObjectGroup *objectLayer;

/**
 *  The player's spawn point.
 */
@property (nonatomic, assign) CGRect spawnLocation;

/**
 *  The level's end point.
 */
@property (nonatomic, assign) CGRect levelCompleteLocation;

/**
 *  The level's run speed. If the level does not specify a speed the default speed of 150 is used.
 */
@property (nonatomic, assign) CGFloat runSpeed;

/**
 *  Initializes a game level and pulls certain layers and objects into their own properties.
 *
 *  @param level Which level to load. Expects a .tmx file with the format 'level%i.tmx' to exist.
 *
 *  @return The initialized game level.
 */
- (id)initWithLevel:(NSUInteger)level;

/**
 *  Checks if the level has the basic layers and objects required.
 *
 *  Due to lazy instantiation of the properties, this also has the side effect of forcing the level to be loaded.
 *
 *  @return The validity of the level.
 */
- (BOOL)isValidLevel;

/**
 *  Convenience method for adding children nodes to the map object.
 *
 *  @param node The node to add.
 */
- (void)addChild:(SKNode *)node;

@end
