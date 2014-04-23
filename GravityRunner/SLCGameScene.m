//
//  SLCMyScene.m
//  GravityRunner
//
//  Created by Student on 2014-04-01.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.

#import "SLCGameScene.h"
#import "SKTUtils.h"
#import "SLCGameLevel.h"
#import "SLCPlayer.h"
#import "SLCPauseMenu.h"

@interface SLCGameScene()
/**
 *  The main player.
 */
@property (nonatomic, strong) SLCPlayer *player;

/**
 *  The current level.
 */
@property (nonatomic, strong) SLCGameLevel *level;

@property (nonatomic, strong, readwrite) NSDictionary *sounds;

/**
 *  The last frames time; Used for calculating the delta time for update methods.
 */
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;

/**
 *  The gravity direction.
 */
@property (nonatomic, assign) NSInteger gravDir;

/**
 *  The data manager. Used for saving game progress.
 */
@property (nonatomic, weak) SLCDataManager *dataMgr;

/**
 *  The pause menu node.
 */
@property (nonatomic, strong) SLCPauseMenu *pauseMenu;

@end

@implementation SLCGameScene

- (id)initWithSize:(CGSize)size level:(NSUInteger)level {
    if (self = [super initWithSize:size]) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [SKColor colorWithRed:.823529412 green:.956862745 blue:.968627451 alpha:1.0];

        self.level = [[SLCGameLevel alloc] initWithLevel:level];
        if (![self.level isValidLevel]) {
            @throw [NSException exceptionWithName:@"InvalidLevel"
                                           reason:@"The level is missing key layers or objects."
                                         userInfo:nil];
        }

        [self addChild:self.level.map];

        [self createPauseButton];
        [self createJumpButton];

        // Initialize the player.
        self.player = [[SLCPlayer alloc] init];
        self.player.velocity = CGPointMake(self.level.runSpeed, 0);
        self.player.zPosition = 15;
        self.player.position = self.level.spawnLocation.origin;
        [self.level addChild:self.player];

        self.gravDir = 1;

        // Update the current level in the data store.
        [self.dataMgr.data setValue:[NSNumber numberWithUnsignedInteger:level] forKey:@"current-level"];

        [self runAction:self.sounds[[NSString stringWithFormat:@"Music0%i", self.level.level]]];
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

    // Pause the map and any children when the pause menu is showing.
    self.level.map.paused = self.pauseMenu.isVisible;

    if (!self.pauseMenu.isVisible) {
        [self.player update:delta];
        [self checkForAndResolveCollisionsForPlayer:self.player forLayer:self.level.walls];
        [self setViewpointCenter:self.player.position];
        self.player.gravDir = self.gravDir;

        if ([self isPlayerIntersectingLevelEnd]) {
            [self handleLevelComplete];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];

    if (!self.pauseMenu.isVisible) {
        if ([node.name isEqualToString:@"Pause_BTN"]) {
            [self runAction:self.sounds[@"button-fwd"]];
            [self.pauseMenu showWithFadeDuration:0.45];
        }
        else if (self.player.onGround && [node.name isEqualToString:@"Jump_BTN"]) {
            self.gravDir *= -1;
            [self.player flip];
            [self runAction:self.sounds[self.player.upsideDown ? @"grav-up" : @"grav-down"]];
            [node runAction:[SKAction rotateByAngle:180.0f * (M_PI / 180.0f) duration:0.25]];
        }
    }
}

/**
 *  Ran once when the player completes the level.
 */
- (void)handleLevelComplete {
    SKLabelNode *finishLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    finishLabel.text = @"Level Complete!";
    finishLabel.fontSize = 50;
    finishLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:finishLabel];
}

/**
 *  Checks whether the player intersects with the level end object.
 *
 *  @return true if the player is intersecting with the level end, false otherwise.
 */
- (BOOL)isPlayerIntersectingLevelEnd {
    return CGRectIntersectsRect([self.player collisionBoundingBox], self.level.levelCompleteLocation);
}

- (BOOL)isPlayerOutOfBounds:(SLCPlayer *)player forLayer:(TMXLayer *)layer {
    CGPoint playerCoord = [layer coordForPoint:player.desiredPosition];
    return playerCoord.y >= self.level.map.mapSize.height - 1 || playerCoord.y <= 0;
}

- (void)setViewpointCenter:(CGPoint)position {
    NSInteger x = MAX(position.x, self.size.width / 2);
    NSInteger y = MAX(position.y, self.size.height / 2);
    
    x = MIN(x, (self.level.map.mapSize.width * self.level.map.tileSize.width) - self.size.width / 2);
    y = MIN(y, (self.level.map.mapSize.height * self.level.map.tileSize.height) - self.size.height / 2);
    
    CGPoint actualPosition = CGPointMake(x, y);
    CGPoint centerOfView = CGPointMake(self.size.width/2, self.size.height/2);
    CGPoint viewPoint = CGPointSubtract(centerOfView, actualPosition);
    self.level.map.position = viewPoint;
}

- (CGRect)tileRectFromTileCoords:(CGPoint)tileCoords {
    float levelHeightInPixels = self.level.map.mapSize.height * self.level.map.tileSize.height;
    
    CGPoint origin = CGPointMake(tileCoords.x * self.level.map.tileSize.width,
                                 levelHeightInPixels - ((tileCoords.y + 1) * self.level.map.tileSize.height));
    
    return CGRectMake(origin.x, origin.y, self.level.map.tileSize.width, self.level.map.tileSize.height);
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

        if ([self isPlayerOutOfBounds:player forLayer:layer]) {
            player.position = self.level.spawnLocation.origin;
            player.velocity = CGPointMake(player.velocity.x, 0);
            [player runAction:[SKAction rotateToAngle:0 duration:0]];
            player.onGround = YES;
            return;
        }
        
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

/**
 *  Initialize the pause button node and add it to the scene.
 */
- (void)createPauseButton {
    NSUInteger offset = 10;

    SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:@"pause_btn"];
    button.name = @"Pause_BTN";
    button.position = CGPointMake(button.size.width + offset, self.frame.size.height - button.size.height - offset);
    [self addChild:button];
}

- (SLCPauseMenu *)pauseMenu {
    if (!_pauseMenu) {
        _pauseMenu = [[SLCPauseMenu alloc] initWithParentNode:self];
        _pauseMenu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _pauseMenu.zPosition = 20;
        _pauseMenu.alpha = 0;
        _pauseMenu.uiElementsToHide = (NSMutableArray *)@[[self childNodeWithName:@"Pause_BTN"],
                                                          [self childNodeWithName:@"Jump_BTN"]];
        [self addChild:_pauseMenu];
    }
    return _pauseMenu;
}

/**
 *  Initialize the jump button node and add it to the scene.
 */
- (void)createJumpButton {
    NSUInteger offset = 10;

    SKSpriteNode *button = [SKSpriteNode spriteNodeWithImageNamed:@"jump_btn"];
    button.name = @"Jump_BTN";
    button.position = CGPointMake(self.frame.size.width - button.size.width - offset,
                                  button.size.height + offset);
    [self addChild:button];
}

- (SLCDataManager *)dataMgr {
    if (!_dataMgr) {
        _dataMgr = [SLCDataManager sharedInstance];
    }
    return _dataMgr;
}

- (NSDictionary *)sounds{
    if(!_sounds){
        NSMutableDictionary *temp = [NSMutableDictionary dictionary];
        NSArray *sounds = @[[NSString stringWithFormat:@"Music0%i.caf", self.level.level],
                            @"button-fwd.caf", @"button-back.caf", @"grav-down.caf", @"grav-up.caf"];

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


@end
