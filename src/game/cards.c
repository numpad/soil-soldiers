#include "cards.h"

#include "gl/shader.h"
#include "gl/texture.h"
#include "gl/vbuffer.h"

void cardrenderer_init(struct cardrenderer_s *renderer, const char *tileset) {
	renderer->tileset = texture_from_image(tileset, NULL);
	renderer->shader = shader_from_directory("res/shader/card");
	vbuffer_init(&renderer->vbo);

	GLfloat vertices[] = {
		-0.5f, -1.0f,  0.0f, 0.0f,
		 0.5f, -1.0f,  1.0f, 0.0f,
		-0.5f,  1.0f,  0.0f, 1.0f,
		-0.5f,  1.0f,  0.0f, 1.0f,
		 0.5f, -1.0f,  1.0f, 0.0f,
		 0.5f,  1.0f,  1.0f, 1.0f,
	};
	vbuffer_set_data(&renderer->vbo, sizeof(vertices), vertices);
	vbuffer_set_attrib(&renderer->vbo, renderer->shader, "a_position", 2, GL_FLOAT, 4 * sizeof(float), 0);
	vbuffer_set_attrib(&renderer->vbo, renderer->shader, "a_texcoord", 2, GL_FLOAT, 4 * sizeof(float), (void*)(2 * sizeof(float)));
}

void cardrenderer_destroy(struct cardrenderer_s *renderer) {
	glDeleteTextures(1, &renderer->tileset);
	glDeleteProgram(renderer->shader);
	vbuffer_destroy(&renderer->vbo);
}

