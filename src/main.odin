package main

import "vendor:sdl2"
import "core:log"

WINDOW_TITLE  :: "Bomberman"
WINDOW_WIDTH  := i32(GRID_X_SIZE * TILE_SIZE + GRID_X_SIZE)
WINDOW_HEIGHT := i32(GRID_Y_SIZE * TILE_SIZE + GRID_Y_SIZE)
WINDOW_POS_X  :: sdl2.WINDOWPOS_UNDEFINED
WINDOW_POS_Y  :: sdl2.WINDOWPOS_UNDEFINED
WINDOW_FLAGS  :: sdl2.WindowFlags{.SHOWN}

CTX :: struct {
    window:      ^sdl2.Window,
	renderer:    ^sdl2.Renderer,

    dt:          f64,
    quit:        bool,

    textures:    map[string]^sdl2.Texture,
}

ctx := CTX{}

init_sdl :: proc() -> (ok: bool) {
    if sdl_res := sdl2.Init(sdl2.INIT_VIDEO); sdl_res < 0 {
        log.errorf("sdl2.init returned %v.", sdl_res)
        return false
    }

    ctx.window = sdl2.CreateWindow(WINDOW_TITLE, WINDOW_POS_X, WINDOW_POS_Y, WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_FLAGS)
    if ctx.window == nil {
        log.errorf("sdl2.CreateWindow failed.")
        return false
    }

    ctx.renderer = sdl2.CreateRenderer(ctx.window, -1, {.ACCELERATED, .PRESENTVSYNC})
	if ctx.renderer == nil {
		log.errorf("sdl2.CreateRenderer failed.")
		return false
	}

    ctx.textures = make(map[string]^sdl2.Texture)

    ctx.textures["ground"] = load_texture("assets/textures/Ground.png")
    ctx.textures["wall"]   = load_texture("assets/textures/Wall.png")
    ctx.textures["player"] = load_texture("assets/textures/Player.png")
    ctx.textures["brick"]  = load_texture("assets/textures/Brick.png")
    
    // TODO: add bomb textures (animations)

    // temp bomb texture
    ctx.textures["bomb"] = load_texture("assets/textures/Bomb.png")

    return true
}

draw :: proc() {
    sdl2.RenderClear(ctx.renderer)

    update_map()
    draw_player()

    sdl2.RenderPresent(ctx.renderer)
}

process_input :: proc() {
    event: sdl2.Event

    for sdl2.PollEvent(&event) {
        #partial switch event.type {
            case .QUIT:
                ctx.quit = true
            case .KEYDOWN:
                #partial switch event.key.keysym.sym {
                    case .W:
                        player.vel.y = -400
                    case .A:
                        player.vel.x = -400
                    case .S:
                        player.vel.y = 400
                    case .D:
                        player.vel.x = 400
                }

            case .KEYUP:
                #partial switch event.key.keysym.sym {
                    case .A, .D:
                        player.vel.x = 0
                    case .W, .S:
                        player.vel.y = 0
                }
        }
    }
}

update :: proc() {
    update_player()
}

main :: proc() {
    context.logger = log.create_console_logger()
    
    ctx.quit = !init_sdl()
    
    now: u64  = sdl2.GetPerformanceCounter()
    last: u64 = 0

    defer sdl2.Quit()
    defer sdl2.DestroyWindow(ctx.window)
    defer sdl2.DestroyRenderer(ctx.renderer)
    defer delete(ctx.textures)
    
    defer for _, texture in ctx.textures do sdl2.DestroyTexture(texture)

    generate_map()

    for !ctx.quit {
        last = now
        now = sdl2.GetPerformanceCounter()

        ctx.dt = f64((now - last)) / f64(sdl2.GetPerformanceFrequency())

        if ctx.dt > 1 do ctx.dt = 0

        process_input()
        update()
        draw()
    }
}
