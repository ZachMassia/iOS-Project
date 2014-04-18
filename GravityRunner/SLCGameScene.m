//
//  SLCMyScene.m
//  GravityRunner
//
//  Created by Student on 2014-04-01.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.

#import "SKTUtils.h"
#import "SLCGameScene.h"
#import "JSTileMap.h"
#import "SLCPlayer.h"

@interface SLCGameScene()
/**
 *  The main player.
 */
@property (nonatomic, strong) SLCPlayer *player;

/**
 *  The current map.
 */
@property (nonatomic, strong) JSTileMap *map;

/**
 *  The wall layer of the current map. This is the layer the player collides with.
 */
@property (nonatomic, strong) TMXLayer  *walls;

/**
 *  The object layer of the current map. Used for collectables, spawn points, etc.
 */
@property (nonatomic, strong) TMXObjectGroup *objectLayer;

/**
 *  All sound effects and music are stored here. They are all loaded when the dictionary
 *  is accessed for the first time.
 */
@property (nonatomic, strong) NSDictionary *sounds;

/**
 *  The last frames time; Used for calculating the delta time for update methods.
 */
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;

/**
 *  The gravity direction.
 */
@property (nonatomic, assign) NSInteger gravDir;
@end

@implementation SLCGameScene


- (id)initWithSize:(CGSize)size levelNumber:(NSUInteger)level {
    if (self = [super initWithSize:size]) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [SKColor colorWithRed:.823529412 green:.956862745 blue:.968627451 alpha:1.0];

        [self setupMapWithLevel:level];

        // Initialize the player.
        // TODO: Read in the spawn point from the map's object layer.
        self.player = [[SLCPlayer alloc] init];
        self.player.position = CGPointMake(150, 300);
        self.player.velocity = CGPointMake(100, 0);
        self.player.zPosition = 15;
        [self.map addChild:self.player];

        self.gravDir = 1;

        [self runAction:self.sounds[@"Music01"]];
    }
    return self;
}


- (void)update:(NSTimeInterval)currentTime
{
    NSTimeInterval delta = currentTime - self.previousUpdateTime;
    if (delta > 0.02) {
        delta = 0.02;
    }
    self.previousUpdateTime = currentTime;
    [self.player update:delta];
    [self checkForAndResolveCollisionsForPlayer:self.player forLayer:self.walls];
    [self setViewpointCenter:self.player.position];
    self.player.gravDir = self.gravDir;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.player.onGround) {
        self.gravDir *= -1;
        [self.player flip];
    }
}
/**
 *  Initialize the map and grab the needed layers.
 */
- (void)setupMapWithLevel:(NSUInteger)level {
    self.map = [self loadLevel:level];
    [self addChild:self.map];

    self.walls = [self.map layerNamed:@"walls"];

    // Make sure we have an object layer.
    if (!self.map.objectGroups.count) {
        @throw [NSException exceptionWithName:@"BadLevelException"
                                       reason:@"The level does not contain an object layer"
                                     userInfo:nil];
    }

    self.objectLayer = self.map.objectGroups[0];
}

- (void)setViewpointCenter:(CGPoint)position {
    NSInteger x = MAX(position.x, self.size.width / 2);
    NSInteger y = MAX(position.y, self.size.height / 2);
    
    x = MIN(x, (self.map.mapSize.width * self.map.tileSize.width) - self.size.width / 2);
    y = MIN(y, (self.map.mapSize.height * self.map.tileSize.height) - self.size.height / 2);
    
    CGPoint actualPosition = CGPointMake(x, y);
    CGPoint centerOfView = CGPointMake(self.size.width/2, self.size.height/2);
    CGPoint viewPoint = CGPointSubtract(centerOfView, actualPosition);
    self.map.position = viewPoint;
}

- (CGRect)tileRectFromTileCoords:(CGPoint)tileCoords {
    float levelHeightInPixels = self.map.mapSize.height * self.map.tileSize.height;
    
    CGPoint origin = CGPointMake(tileCoords.x * self.map.tileSize.width,
                                 levelHeightInPixels - ((tileCoords.y + 1) * self.map.tileSize.height));
    
    return CGRectMake(origin.x, origin.y, self.map.tileSize.width, self.map.tileSize.height);
}

- (NSInteger)tileGIDAtTileCoord:(CGPoint)coord forLayer:(TMXLayer *)layer {
    return [layer.layerInfo tileGidAtCoord:coord];
}

- (void)checkForAndResolveCollisionsForPlayer:(SLCPlayer *)player forLayer:(TMXLayer *)layer {
    NSInteger indicies[8] = {7, 1, 3, 5, 0, 2, 6, 8};
    player.onGround = NO;
    for (NSUInteger i = 0; i < 8; i++) {
        NSInteger tileIndex = indicies[i];
        
        CGRect playerRect = [player collisionBoundingBox];
        
        CGPoint playerCoord = [layer coordForPoint:player.desiredPosition];
        
        NSInteger tileColumn = tileIndex % 3;
        NSInteger tileRow = tileIndex / 3;
        
        CGPoint tileCoord = CGPointMake(playerCoord.x + (tileColumn - 1), playerCoord.y + (tileRow - 1));
        
        NSInteger gid = [self tileGIDAtTileCoord:tileCoord forLayer:layer];
        if (gid) {
            CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
            
            if (CGRectIntersectsRect(playerRect, tileRect)) {
                CGRect intersection = CGRectIntersection(playerRect, tileRect);
                switch (tileIndex) {
                    case 7: // Below
                        player.desiredPosition = CGPointMake(player.desiredPosition.x,
                                                             player.desiredPosition.y + intersection.size.height);
                        player.onGround = YES;
                        break;
                        
                    case 1: // Above
                        player.desiredPosition = CGPointMake(player.desiredPosition.x,
                                                             player.desiredPosition.y - intersection.size.height);
                        player.onGround = YES;
                        break;
                        
                    case 3: // Left
                        player.desiredPosition = CGPointMake(player.desiredPosition.x + intersection.size.width,
                                                             player.desiredPosition.y);
                        break;
                        
                    case 5: // Right
                        player.desiredPosition = CGPointMake(player.desiredPosition.x - intersection.size.width,
                                                             player.desiredPosition.y);
                        break;
                        
                    default:
                        if (intersection.size.width > intersection.size.height) {
                            // Tile is diagonal, but resolving collision vertically
                            player.velocity = CGPointMake(player.velocity.x, 0.0);
                            float intersectionHeight;
                            if (tileIndex > 4) {
                                intersectionHeight = intersection.size.height;
                                player.onGround = YES;
                            } else {
                                intersectionHeight = -intersection.size.height;
                            }
                            player.desiredPosition = CGPointMake(player.desiredPosition.x,
                                                                 player.desiredPosition.y + intersection.size.height);
                        } else {
                            // Tile is diagonal, but resolving horizontally
                            float intersectionWidth;
                            if (tileIndex == 6 || tileIndex == 0) {
                                intersectionWidth = intersection.size.width;
                            } else {
                                intersectionWidth = -intersection.size.width;
                            }
                            player.desiredPosition = CGPointMake(player.desiredPosition.x + intersectionWidth,
                                                                 player.desiredPosition.y);
                        }
                        break;
                }
            }
        }
    }
    player.position = player.desiredPosition;
}

- (NSDictionary *)sounds{
    if(!_sounds){
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        NSArray *sounds = @[@"Music01.caf", @"button-fwd.caf", @"button-back.caf", @"grav-down.caf", @"grav-up.caf"];

        // Load all the sounds as actions and use the file names without extensions as keys.
        for (NSString *sound in sounds) {
            SKAction *action = [SKAction playSoundFileNamed:sound waitForCompletion:YES];
            NSString *name = [sound stringByDeletingPathExtension];
            [temp setValue:action forKey:name];
        }
        _sounds = [NSDictionary dictionaryWithDictionary:temp];
    }

    return _sounds;
}

- (JSTileMap *)loadLevel:(NSUInteger)level {
    return [JSTileMap mapNamed:[NSString stringWithFormat:@"level%i.tmx", level]];
}

@end
