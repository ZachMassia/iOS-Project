//
//  SLCButtonNode.m
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-23.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCButtonNode.h"

@interface SLCButtonNode()

@property (strong, nonatomic, readwrite) SKSpriteNode *texture;

@end

@implementation SLCButtonNode

- (id)initWithImageNamed:(NSString *)name size:(CGSize)size {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.texture = [self createTextureWithImageNamed:name size:size];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchSound) {
        [self runAction:[SKAction playSoundFileNamed:self.touchSound waitForCompletion:NO]];
    }
    [self.onTouch invoke];
}


- (SKSpriteNode *)createTextureWithImageNamed:(NSString *)name
                                         size:(CGSize)size {
    if (!_texture) {
        _texture = [SKSpriteNode spriteNodeWithImageNamed:name];

        _texture.zPosition = 5;

        // Scale to desired size.
        _texture.xScale = size.width  / _texture.size.width;
        _texture.yScale = size.height / _texture.size.height;

        [self addChild:_texture];
    }
    return _texture;
}

@end