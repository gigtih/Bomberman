package main

import "vendor:sdl2"
import "core:fmt"

/*
    TileType > 0, Can collide.
    TileType == 0, Ground.
*/
TileType :: enum i8 {
    GROUND = 0,
    WALL   = 1,
    BRICK  = 2,
}

TILE_SIZE   :: i32(40)
GRID_X_SIZE :: i32(15)
GRID_Y_SIZE :: i32(15)

game_map: [GRID_X_SIZE][GRID_Y_SIZE]TileType

generate_map :: proc() {
    for i in 0..<GRID_X_SIZE {
        game_map[GRID_X_SIZE - 1][i] = .WALL
        game_map[i][GRID_Y_SIZE - 1] = .WALL

        game_map[i][0] = .WALL
        game_map[0][i] = .WALL
    }

    for row, row_index in game_map {
        for col, col_index in row {
            if row_index % 2 == 0 && col_index % 2 == 0 do game_map[row_index][col_index] = .WALL
        }
    }
}

is_out_of_bounds :: proc(tile_pos: [2]i32) -> bool {
    return ((tile_pos.x < 0 ) || (tile_pos.x >= GRID_X_SIZE) || (tile_pos.y < 0) || (tile_pos.y >= GRID_Y_SIZE))
}

render_map :: proc() {
    for row, row_index in game_map {
        y := TILE_SIZE * i32(row_index)

        for col, col_index in row {
            x := TILE_SIZE * i32(col_index)

            #partial switch col {
                case .WALL:
                    sdl2.RenderCopy(ctx.renderer, ctx.textures["wall"], nil, &sdl2.Rect{ i32(x), i32(y), TILE_SIZE, TILE_SIZE})
                case .BRICK:
                    sdl2.RenderCopy(ctx.renderer, ctx.textures["brick"], nil, &sdl2.Rect{ i32(x), i32(y), TILE_SIZE, TILE_SIZE})
                case .GROUND:
                    sdl2.RenderCopy(ctx.renderer, ctx.textures["ground"], nil, &sdl2.Rect{ i32(x), i32(y), TILE_SIZE, TILE_SIZE})
            }
        }
    }
}
