#ifndef SHADER_H
#define SHADER_H

#include <SDL_opengles2.h>

//
// forward decls
//
typedef struct texture_s texture_t;

//
// typedefs, structs & enums
//

typedef struct shader_s shader_t;
struct shader_s {
	GLuint program;
};


//
// public api
//

// init & destroy
void shader_init         (shader_t *, const char *vert_path, const char *frag_path);
void shader_init_from_dir(shader_t *, const char *dir_path);
void shader_destroy      (shader_t *);

// uniform setters
void shader_set_uniform_texture(shader_t *, const char *uniform_name, GLenum texture_unit, texture_t *texture);
void shader_set_uniform_vec4   (shader_t *, const char *uniform_name, float[4]);
void shader_set_uniform_mat4   (shader_t *, const char *uniform_name, float[16]);

#endif

