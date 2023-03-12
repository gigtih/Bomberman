package main

import "vendor:sdl2"
import "core:fmt"

Bomb :: struct {
    time_to_explode: f64,
    initialize_bomb: proc(bomb: ^Bomb),
    explode_bomb:    proc(bomb: ^Bomb),
    render_bomb:     proc(bomb: ^Bomb),

    pos:             [2]i32,
    tile_pos:        [2]i32,

    can_explode:     bool,
    counter:         f64,
}

bomb := Bomb{
    time_to_explode = 1.0,
    can_explode = false,

    pos = { 0, 0 },
    tile_pos = { 0, 0 },

    initialize_bomb = proc(bomb: ^Bomb) {
        bomb.counter = bomb.time_to_explode
        bomb.can_explode = true
    },
    explode_bomb = proc(bomb: ^Bomb) {
        if bomb.counter == 0 && bomb.can_explode {
            fmt.println("bomb exploded")

            bomb.can_explode = false
        }
    },
    render_bomb = proc(bomb: ^Bomb) {
        
    },
}