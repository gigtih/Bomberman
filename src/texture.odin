package main

import sdl_img "vendor:sdl2/image"
import "vendor:sdl2"
import "core:log"
import "core:os"

load_texture :: proc(file: cstring) -> ^sdl2.Texture {
    texture: ^sdl2.Texture
    surface := sdl_img.Load(file)

    if surface == nil {
        log.errorf("sdl_image.Load() failed, error: %v\n", sdl_img.GetError())
        os.exit(1)
    }

    texture = sdl2.CreateTextureFromSurface(ctx.renderer, surface)
    sdl2.FreeSurface(surface)

    return texture
}