package main

import "vendor:sdl2"
import "core:fmt"

@(private="file")
Player :: struct {
    vel:          [2]i32,
    pos:          [2]i32,

    tile_pos:     [2]i32,
    target_pos:   [2]i32,

    moving:       bool,

    construct:    proc(player: ^Player),
    move_up:      proc(player: ^Player),
    move_left:    proc(player: ^Player),
    move_right:   proc(player: ^Player),
    move_down:    proc(player: ^Player),
    start_moving: proc(player: ^Player),
}

player := Player{
    vel = {
        0,
        0,
    },
    pos = {
        TILE_SIZE * 7,
        TILE_SIZE * 7,
    },
    tile_pos = {
        0,
        0,
    },
    target_pos = {
        0,
        0,
    },

    moving = false,

    construct = proc(player: ^Player) {
        player.tile_pos.x = player.pos.x / TILE_SIZE
        player.tile_pos.y = player.pos.y / TILE_SIZE

        player.target_pos = player.tile_pos
    },
    move_up = proc(player: ^Player) {
        if player.moving do return
        player.target_pos.y = player.tile_pos.y - 1
        player.moving = true
    },
    move_left = proc(player: ^Player) {
        if player.moving do return
        player.target_pos.x = player.tile_pos.x - 1
        player.moving = true
    },
    move_right = proc(player: ^Player) {
        if player.moving do return
        player.target_pos.x = player.tile_pos.x + 1
        player.moving = true
    },
    move_down = proc(player: ^Player) {
        if player.moving do return
        player.target_pos.y = player.tile_pos.y + 1
        player.moving = true
    },
    start_moving = proc(player: ^Player) {
        if !player.moving do return

        if player.tile_pos.y > player.target_pos.y do player.vel.y = -2
        if player.tile_pos.y < player.target_pos.y do player.vel.y = 2

        if player.tile_pos.x > player.target_pos.x do player.vel.x = -2
        if player.tile_pos.x < player.target_pos.x do player.vel.x = 2
    },
}

draw_player :: proc() {
    sdl2.RenderCopy(ctx.renderer, ctx.textures["player"], nil, &sdl2.Rect{player.pos.x, player.pos.y, TILE_SIZE, TILE_SIZE})
}

convert_from_tile :: proc(tile_pos: [2]i32) -> [2]i32 {
    return TILE_SIZE * tile_pos
}

process_player_input :: proc() {
    #partial switch current_input_state {
        case .DOWN:
            player->move_down()
        case .LEFT:
            player->move_left()
        case .RIGHT:
            player->move_right()
        case .UP:
            player->move_up()
    }
}

update_player :: proc() {
    if player.pos == convert_from_tile(player.target_pos) {
        player.tile_pos.x = player.target_pos.x
        player.tile_pos.y = player.target_pos.y

        player.vel.xy = 0

        player.moving = false
    }

    player.pos.x += player.vel.x
    player.pos.y += player.vel.y
}