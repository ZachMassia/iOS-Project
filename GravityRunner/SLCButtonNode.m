//
//  SLCButtonNode.m
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-23.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCButtonNode.h"

@interface SLCButtonNode()

@property (strong, nonatomic) NSString *textureName;
@property (assign, nonatomic) CGSize textureSize;

/**
 *  The button texture.
 */
@property (strong, nonatomic) SKSpriteNode *texture;

/**
 *  The button text.
 */
@property (strong, nonatomic) SKLabelNode *label;

@end

@implementation SLCButtonNode

- (id)initWithImageNamed:(NSString *)name size:(CGSize)size text:(NSString *)text {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.textureName = name;
        self.textureSize = size;
        self.label.text = text;
        self.label.position = CGPointMake(CGRectGetMidX(self.texture.frame),
                                          CGRectGetMidY(self.texture.frame) - (self.label.frame.size.height / 2));
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchSound) {
        [self runAction:[SKAction playSoundFileNamed:self.touchSound waitForCompletion:NO]];
    }
    [self.onTouch invoke];
}


- (SKSpriteNode *)texture {
    if (!_texture) {
        _texture = [SKSpriteNode spriteNodeWithImageNamed:self.textureName];

        _texture.zPosition = 5;

        // Scale to desired size.
        _texture.xScale = self.textureSize.width  / _texture.size.width;
        _texture.yScale = self.textureSize.height / _texture.size.height;

        [self addChild:_texture];
    }
    return _texture;
}

- (SKLabelNode *)label {
    if (!_label) {
        _label = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
        _label.fontSize = self.textureSize.height / 2;
        _label.fontColor = [SKColor blackColor];
        _label.zPosition = 10;

        [self addChild:_label];
    }
    return _label;
}

@end
