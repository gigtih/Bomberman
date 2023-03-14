package main

import "vendor:sdl2"
import "core:log"
import "core:fmt"

WINDOW_TITLE  :: "Bomberman"
WINDOW_WIDTH  := i32(GRID_X_SIZE * TILE_SIZE)
WINDOW_HEIGHT := i32(GRID_Y_SIZE * TILE_SIZE)
WINDOW_POS_X  :: sdl2.WINDOWPOS_UNDEFINED
WINDOW_POS_Y  :: sdl2.WINDOWPOS_UNDEFINED
WINDOW_FLAGS  :: sdl2.WindowFlags{.SHOWN}

CTX :: struct {
    window:      ^sdl2.Window,
    renderer:    ^sdl2.Renderer,

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

    ctx.textures["explosion"]  = load_texture("assets/textures/Explosion.png")
    ctx.textures["bomb_anim0"] = load_texture("assets/textures/Bomb_animations/sprite_bomb0.png")
    ctx.textures["bomb_anim1"] = load_texture("assets/textures/Bomb_animations/sprite_bomb1.png")

    return true
}

render :: proc() {
    sdl2.RenderClear(ctx.renderer)

    render_map()
    render_player()

    bomb->render()

    sdl2.RenderPresent(ctx.renderer)
}

process_input :: proc() {
    event: sdl2.Event

    if !sdl2.PollEvent(&event) do return

    if event.type == .QUIT do ctx.quit = true

    process_keys(&event)
    process_player_input()
}

update :: proc() {
    if can_player_move(&player) {
        player->start_moving()
    } else {
        cancel_moving(&player)
    }

    update_player()
}

main :: proc() {
    context.logger = log.create_console_logger()

    ctx.quit = !init_sdl()

    now: u64  = sdl2.GetPerformanceCounter()
    last: u64 = 0
    dt: f64

    defer sdl2.Quit()
    defer sdl2.DestroyWindow(ctx.window)
    defer sdl2.DestroyRenderer(ctx.renderer)
    defer delete(ctx.textures)

    defer for _, texture in ctx.textures do sdl2.DestroyTexture(texture)

    generate_map()

    player->construct()

    for !ctx.quit {
        last = now
        now = sdl2.GetPerformanceCounter()

        dt = f64((now - last)) / f64(sdl2.GetPerformanceFrequency())

        if dt > 1 do dt = 0
        if bomb.counter < 0 do bomb.counter = 0

        process_input()
        update()
        render()

        bomb->explode()

        bomb.counter -= dt
    }
}
