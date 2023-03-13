package main

import "vendor:sdl2"
import "core:fmt"

Bomb :: struct {
    time_to_explode: f64,
    initialize:      proc(bomb: ^Bomb),
    // explode:         proc(bomb: ^Bomb),
    render:          proc(bomb: ^Bomb),

    pos:             [2]i32,
    tile_pos:        [2]i32,
    place:           bool,

    can_explode:     bool,
    counter:         f64,
}

bomb := Bomb{
    time_to_explode = 1.0,
    can_explode = false,

    pos = { 0, 0 },
    tile_pos = { 0, 0 },

    initialize = proc(bomb: ^Bomb) {
        bomb.counter = bomb.time_to_explode
        bomb.can_explode = true
    },
    // explode = proc(bomb: ^Bomb) {
    //     if bomb.counter == 0 && bomb.can_explode {
    //         fmt.println("bomb exploded")

    //         bomb.can_explode = false
    //     }
    // },
    render = proc(bomb: ^Bomb) {
        bomb.pos = player.pos
        bomb.tile_pos = convert_from_tile(player.pos)
    },
}