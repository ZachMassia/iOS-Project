//
//  SLCButtonNode.h
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-23.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void(^TouchHandler)(void);

/**
 *  A simple wrapper around an SKNode which provides a texture and a click handler.
 */
@interface SLCButtonNode : SKNode

/**
 *  This block is ran when the button receives a touch.
 */
@property (copy, nonatomic) TouchHandler onTouch;

/**
 *  The filename of the sound to play when the button receives a touch.
 */
@property (strong, nonatomic) NSString *touchSound;

/**
 *  The button texture.
 */
@property (strong, nonatomic, readonly) SKSpriteNode *texture;

/**
 *  Initialize a button and scale the texture.
 *
 *  @param name The texture name.
 *  @param size The size to scale the texture to.
 *
 *  @return The button node.
 */
- (id)initWithImageNamed:(NSString *)name size:(CGSize)size;

@end
