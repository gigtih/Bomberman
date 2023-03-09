package main

import "vendor:sdl2"
import "core:fmt"

@(private="file")
Player :: struct {
    vel: [2]f32,
    pos: [2]i32,
}

player := Player{
    vel = {
        0,
        0,
    },
    pos = {
        GRID_X_SIZE + TILE_SIZE * 7,
        GRID_Y_SIZE + TILE_SIZE * 7,
    },
}

draw_player :: proc() {
    sdl2.RenderCopy(ctx.renderer, ctx.textures["player"], nil, &sdl2.Rect{player.pos.x, player.pos.y, TILE_SIZE, TILE_SIZE})
}

update_player :: proc() {
    dt := cast(f32)ctx.dt

    player.pos.x += i32(player.vel.x * dt)
    player.pos.y += i32(player.vel.y * dt)
}
