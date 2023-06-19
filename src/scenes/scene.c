#include "scene.h"
#include <stdlib.h>

void scene_init(struct scene_s *scene, struct engine_s *engine) {
	scene->load = NULL;
	scene->destroy = NULL;
	scene->update = NULL;
	scene->draw = NULL;
}

void scene_destroy(struct scene_s *scene, struct engine_s *engine) {
}

void scene_load(struct scene_s *scene, struct engine_s *engine) {
	if (scene->load != NULL) {
		scene->load(scene, engine);
	}
}

void scene_update(struct scene_s *scene, struct engine_s *engine, float dt) {
	if (scene->update != NULL) {
		scene->update(scene, engine, dt);
	}
}

void scene_draw(struct scene_s *scene, struct engine_s *engine) {
	if (scene->draw != NULL) {
		scene->draw(scene, engine);
	}
}

