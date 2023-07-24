#include "game.h"
#include <stdlib.h>
#include <SDL.h>
#include <stb_ds.h>
#include "scenes/scene.h"
#include "game/terrain.h"

static void game_load(struct game_s *game, struct engine_s *engine) {
	terrain_init(&game->terrain, 25, 45);
}

static void game_destroy(struct game_s *game, struct engine_s *engine) {
	terrain_destroy(&game->terrain);

}

static void game_update(struct game_s *game, struct engine_s *engine, float dt) {
	int mx, my;
	const Uint32 mstate = SDL_GetMouseState(&mx, &my);

	if (mstate & SDL_BUTTON(1)) {
		const int mxg = (int)(mx / game->terrain.x_scale);
		const int myg = (int)(my / game->terrain.y_scale);

		unsigned char *density = terrain_density_at(&game->terrain, mxg, myg);
		if (density != NULL && *density < 250) {
			if (*density < game->terrain.isovalue) {
				*density = game->terrain.isovalue;
			}

			*density = *density + 5;
		}

		stbds_arrfree(game->terrain.polygon_edges);
		game->terrain.polygon_edges = NULL;
		terrain_polygonize(&game->terrain);
	}

}

static void game_draw(struct game_s *game, struct engine_s *engine) {
	terrain_draw(&game->terrain, engine);
}

void game_init(struct game_s *game, struct engine_s *engine, int w, int h) {
	scene_init((struct scene_s *)game, engine);

	game->base.load = (scene_load_fn)game_load;
	game->base.destroy = (scene_destroy_fn)game_destroy;
	game->base.update = (scene_update_fn)game_update;
	game->base.draw = (scene_draw_fn)game_draw;

}

