package main

import "vendor:sdl2"
import "core:fmt"

Bomb :: struct {
    time_to_explode: f64,
    place:           proc(bomb: ^Bomb),
    explode:         proc(bomb: ^Bomb),
    render:          proc(bomb: ^Bomb),

    pos:             [2]i32,
    tile_pos:        [2]i32,
    placed:          bool,

    counter:         f64,
}

convert_to_tile :: proc(pos: [2]i32) -> [2]i32 {
    return pos / TILE_SIZE
}

bomb := Bomb{
    time_to_explode = 1.0,
    placed = false,

    pos = { 0, 0 },
    tile_pos = { 0, 0 },

    place = proc(using bomb: ^Bomb) {
        if placed do return 

        counter = time_to_explode

        pos = convert_to_pos(player.tile_pos)
        tile_pos = convert_to_tile(pos)
    },
    explode = proc(using bomb: ^Bomb) {
        if counter == 0 && placed {
            fmt.println("bomb exploded")

            placed = false
        }
    },
    render = proc(using bomb: ^Bomb) {
        if placed {
            sdl2.RenderCopy(ctx.renderer, ctx.textures["bomb_anim0"], nil, &sdl2.Rect{pos.x, pos.y, TILE_SIZE, TILE_SIZE})
        }
    },
}