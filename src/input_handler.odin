package main

import "vendor:sdl2"

InputState :: enum i8 {
    NONE,
    W,
    S,
    A,
    D,
    SPACE,
}

current_input_state: InputState

process_keys :: proc(event: ^sdl2.Event) {
    if event.type == .KEYDOWN {
        #partial switch event.key.keysym.scancode {
            case .D:
                current_input_state = .D
            case .A:
                current_input_state = .A
            case .S:
                current_input_state = .S
            case .W:
                current_input_state = .W
            case .SPACE:
                current_input_state = .SPACE
        }
    } else if event.type == .KEYUP {
        #partial switch event.key.keysym.scancode {
            case .D:
                if current_input_state == .D do current_input_state = .NONE
            case .A:
                if current_input_state == .A do current_input_state = .NONE
            case .S:
                if current_input_state == .S do current_input_state = .NONE
            case .W:
                if current_input_state == .W do current_input_state = .NONE
            case .SPACE:
                if current_input_state == .SPACE do current_input_state = .NONE
        }
    }
}