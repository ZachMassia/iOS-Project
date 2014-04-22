//
//  SLCGameLevel.m
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-18.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCGameLevel.h"

@implementation SLCGameLevel

- (id)initWithLevel:(NSUInteger)level {
    if (self = [super init]) {
        self.level = level;
    }
    return self;
}

- (BOOL)isValidLevel {
    return self.walls && !CGRectIsEmpty(self.spawnLocation) && !CGRectIsEmpty(self.levelCompleteLocation);
}

- (void)addChild:(SKNode *)node {
    [self.map addChild:node];
}

- (JSTileMap *)map {
    if (!_map) {
        _map = [JSTileMap mapNamed:[NSString stringWithFormat:@"level%i.tmx", self.level]];
    }
    return _map;
}

- (TMXLayer *)walls {
    if (!_walls) {
        _walls = [self.map layerNamed:@"walls"];
    }
    return _walls;
}

- (TMXObjectGroup *)objectLayer {
    if (!_objectLayer) {
        if (self.map.objectGroups.count > 0) {
            // Game levels should only have one object layer (for now), so we assume the
            // first one is the one we want.
            _objectLayer = self.map.objectGroups[0];
        }
    }
    return _objectLayer;
}

- (CGRect)spawnLocation {
    if (CGRectIsEmpty(_spawnLocation)) {
        _spawnLocation = [self rectFromObjectDict:[self.objectLayer objectNamed:@"spawn"]];
    }
    return _spawnLocation;
}

- (CGRect)levelCompleteLocation {
    if (CGRectIsEmpty(_levelCompleteLocation)) {
        _levelCompleteLocation = [self rectFromObjectDict:[self.objectLayer objectNamed:@"complete"]];
    }
    return _levelCompleteLocation;
}

- (CGFloat)runSpeed {
    if (!_runSpeed) {
        // Set a default speed.
        _runSpeed = 150.f;

        // Check the map for a speed property.
        if (self.map.properties[@"speed"]) {
            _runSpeed = [self.map.properties[@"speed"] floatValue];
        }
    }
    return _runSpeed;
}

/**
 *  Create a CGRect from an NSDictionary.
 *
 *  @param dict The NSDictionary with x,y,w,h keys.
 *
 *  @return A CGRect with the NSDictionary keys converted to floats.
 */
- (CGRect)rectFromObjectDict:(NSDictionary *)dict {
    return CGRectMake([dict[@"x"] floatValue],
                      [dict[@"y"] floatValue],
                      [dict[@"width"] floatValue],
                      [dict[@"height"] floatValue]);
}

@end
