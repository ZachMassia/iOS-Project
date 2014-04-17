//
//  SLCSpriteSheet.m
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-11.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCSpriteSheet.h"

@interface SLCSpriteSheet()
/**
 *  The full sprite sheet texture. Lazily instantiated.
 */
@property (strong, nonatomic) SKTextureAtlas *atlas;

@property (strong, nonatomic, readwrite) NSArray *animationTextures;
@end

@implementation SLCSpriteSheet

- (instancetype)initWithAtlasNamed:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

- (SKAction *)generateAnimationWithTime:(NSTimeInterval)sec {
    return [SKAction repeatActionForever:[SKAction animateWithTextures:self.animationTextures
                                                          timePerFrame:sec
                                                                resize:NO
                                                               restore:YES]];
}

- (NSArray *)animationTextures {
    if (!_animationTextures) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 1; i < self.atlas.textureNames.count / 2; i++) {
            SKTexture *texture = [self.atlas textureNamed:
                                  [NSString stringWithFormat:i > 9 ? @"%@_%i" : @"%@_0%i", self.name, i]];
            [temp addObject:texture];
        }
        _animationTextures = [NSArray arrayWithArray:temp];
    }
    return _animationTextures;
}

- (SKTextureAtlas *)atlas {
    if (!_atlas) {
        _atlas = [SKTextureAtlas atlasNamed:self.name];
    }
    return _atlas;
}
@end
