//
//  Player.m
//  GravityRunner
//
//  Created by Student on 2014-04-01.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "Player.h"
#import "SKTUtils.h"

@interface Player()
@property (nonatomic, strong) NSMutableArray *playerWalkTextures;

@property (nonatomic, strong) SKAction *forwardWalk;
@property (nonatomic, strong) SKAction *backwardWalk;
@property (nonatomic, strong) SKAction *flipAnimation;
@end

@implementation Player
- (instancetype)init {
    // Load the sprite sheet first so that we can init the SKSpriteNode with the first animation frame.
    SLCSpriteSheet *spriteSheet = [[SLCSpriteSheet alloc] initWithAtlasNamed:@"walk_anim"];

    if (spriteSheet && self == [super initWithTexture:spriteSheet.animationTextures[0]]) {
        self.gravDir = 1;
        self.velocity = CGPointMake(0.0, 0.0);
        self.spriteSheet = spriteSheet;
        self.upsideDown = NO;

        self.forwardWalk = [self.spriteSheet generateAnimationWithTime:0.1f];
        self.backwardWalk = [self.forwardWalk reversedAction];
        self.flipAnimation = [SKAction rotateByAngle:180.0f * (M_PI / 180.0f) duration:0.5];

        self.xScale = 0.5;
        self.yScale = 0.5;

        [self runAction:self.forwardWalk withKey:@"walk_animation"];
    }

    return self;
}

- (void)update:(NSTimeInterval)delta {
    CGPoint gravity = CGPointMake(0.0, -450.0);
    CGPoint gravityStep = CGPointMultiplyScalar(gravity, delta * self.gravDir);
    self.velocity = CGPointAdd(self.velocity, gravityStep);
    
    static const CGPoint minMovement = { 0.0, -450.0 };
    static const CGPoint maxMovement = { 120.0, 450.0 };
    
    self.velocity = CGPointMake(Clamp(self.velocity.x, minMovement.x, maxMovement.x),
                                Clamp(self.velocity.y, minMovement.y, maxMovement.y));
    
    CGPoint velocityStep = CGPointMultiplyScalar(self.velocity, delta);
    
    self.desiredPosition = CGPointAdd(self.position, velocityStep);
}

- (CGRect)collisionBoundingBox {
    CGRect boundingbox = CGRectInset(self.frame, 0, 0); // TODO: Fix height glitch
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    return CGRectOffset(boundingbox, diff.x, diff.y);
}

- (void)flip {
    // TODO: Mirror the character (he's facing the wrong way)
    [self runAction:self.flipAnimation withKey:@"flip_animation"];
    [self removeActionForKey:@"walk_animation"];
    self.velocity = CGPointMake(self.velocity.x, self.velocity.y * -1);

    if (self.upsideDown) {
        self.upsideDown = NO;
        [self runAction:self.forwardWalk withKey:@"walk_animation"];
        self.xScale = 0.5;
    } else {
        self.upsideDown = YES;
       [self runAction:self.backwardWalk withKey:@"walk_animation"];
        self.xScale = -0.5;
    }
}

- (NSMutableArray *)playerWalkTextures {
    if (!_playerWalkTextures) {
        _playerWalkTextures = [NSMutableArray array];
        
        // Load the texture atlas
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"p1_walk"];
        NSInteger frameCount = atlas.textureNames.count / 2;

        for (int i = 1; i <= frameCount; i++) {
            // Grab the current frame from the atlas.
            SKTexture *frame = [atlas textureNamed:[NSString stringWithFormat:i > 9 ? @"%@_%d" : @"%@_0%d",
                                                    self.name, i]];
            
            [_playerWalkTextures addObject:frame];
        }
    }
    return _playerWalkTextures;
}

@end
