package main

import "vendor:sdl2"

input_state :: enum i8 {
    NONE,
    UP,
    DOWN,
    LEFT,
    RIGHT,
}

current_input_state: input_state

process_keys :: proc(event: ^sdl2.Event) {
    if event.type == .KEYDOWN {
        #partial switch event.key.keysym.scancode {
            case .D:
                current_input_state = .RIGHT
            case .A:
                current_input_state = .LEFT
            case .S:
                current_input_state = .DOWN
            case .W:
                current_input_state = .UP
        }
    } else if event.type == .KEYUP {
        #partial switch event.key.keysym.scancode {
            case .D:
                if current_input_state == .RIGHT do current_input_state = .NONE
            case .A:
                if current_input_state == .LEFT do current_input_state = .NONE
            case .S:
                if current_input_state == .DOWN do current_input_state = .NONE
            case .W:
                if current_input_state == .UP do current_input_state = .NONE
        }
    }
}