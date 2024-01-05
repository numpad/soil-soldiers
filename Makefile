
CC = clang
CFLAGS = -std=gnu99 -fPIC -Wall -Wextra -pedantic \
		 -D_GNU_SOURCE \
		 -Wfloat-equal -Wshadow -Wno-unused-parameter -Wl,--export-dynamic \
		 -Wswitch-enum -Wcast-qual -Wnull-dereference -Wunused-result \
		 -DFLECS_CUSTOM_BUILD -DFLECS_SYSTEM -DFLECS_MODULE -DFLECS_PIPELINE -DFLECS_TIMER -DFLECS_HTTP -DFLECS_SNAPSHOT -DFLECS_PARSER -DFLECS_APP -DFLECS_OS_API_IMPL \
		 -DNK_INCLUDE_DEFAULT_ALLOCATOR -DNK_INCLUDE_DEFAULT_FONT -DNK_INCLUDE_FONT_BAKING -DNK_INCLUDE_FIXED_TYPES -DNK_INCLUDE_STANDARD_IO -DNK_INCLUDE_STANDARD_VARARGS -DNK_INCLUDE_VERTEX_BUFFER_OUTPUT -DNK_NO_STB_TRUETYPE_IMPLEMENTATION -DNK_NO_STB_RECT_PACK_IMPLEMENTATION \
		 # flecs needs gnu99
INCLUDES = -I src/ -isystem /usr/include/SDL2 -isystem lib/nanovg/src -isystem lib/stb -isystem lib/cglm/include -isystem lib/flecs -isystem lib/cJSON -isystem lib/nuklear -isystem lib/box2c/include/ -isystem lib/box2c/extern/simde/
LIBS = -lm -lGL -lSDL2 -lSDL2_mixer -lSDL2_net # -lSDL2_ttf

BIN = bin/native/
TARGET = soil_soldiers

# when compiling with emscripten, add some specific flags
ifeq ($(CC), emcc)
	# TODO: dont add everything to cflags, some flags should be used only during linking
	# TODO: Check if needed/better: -sASYNCIFY -sWEBSOCKET_SUBPROTOCOL="binary" -sMAX_WEBGL_VERSION=2
	# TODO: Add in release? -sWEBSOCKET_URL="wss://"
	CFLAGS += -sWASM=1 \
			  -sUSE_SDL=2 -sUSE_SDL_NET=2 -sUSE_SDL_MIXER=2 -sUSE_SDL_IMAGE=0 -sUSE_SDL_TTF=0 -sFULL_ES2=1 \
			  -sALLOW_MEMORY_GROWTH=1 \
			  -sINITIAL_MEMORY=128MB -sTOTAL_STACK=64MB \
			  -sEXPORTED_RUNTIME_METHODS=cwrap \
			  -sEXPORTED_FUNCTIONS=_main,_on_siggoback \
			  -sMODULARIZE=1 -sEXPORT_NAME="MyApp" \
			  --preload-file res \
			  --shell-file src/web/shell_start_on_click.html
	TARGET = soil_soldiers.html
	BIN = bin/emcc/
endif

SCENES = src/scenes/game.c src/scenes/intro.c src/scenes/menu.c src/scenes/scene_battle.c src/scenes/experiments.c
SRC = main.c src/engine.c src/platform.c \
	  src/ecs/components.c \
	  src/gui/console.c src/gui/ugui.c \
	  src/game/background.c src/game/terrain.c src/game/isoterrain.c src/game/cards.c \
	  src/util/easing.c src/util/fs.c src/util/util.c \
	  src/gl/shader.c src/gl/texture.c src/gl/vbuffer.c \
	  src/net/message.c \
	  src/scenes/scene.c \
	  lib/nanovg/src/nanovg.c \
	  lib/stb/stb_ds.c lib/stb/stb_perlin.c lib/stb/stb_image.c lib/stb/stb_rect_pack.c lib/stb/stb_truetype.c \
	  $(wildcard lib/cglm/src/*.c) \
	  $(wildcard lib/box2c/src/*.c) \
	  lib/cJSON/cJSON.c \
	  lib/flecs/flecs.c \
	  lib/nuklear/nuklear.c \
	  $(SCENES) 
OBJ = $(addprefix $(BIN),$(SRC:.c=.o))

.PHONY: all clean scenes server

all: $(TARGET)

server:
	$(MAKE) -f src/server/Makefile

# debug-specific
debug: CFLAGS += -DDEBUG -ggdb -O0
debug: LIBS += -ldl
debug: $(TARGET)
# release-specific
release: CFLAGS += -O2
release: $(TARGET)

$(BIN)lib/%.o: CFLAGS += -w

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $^ $(LIBS)

$(BIN)%.o: %.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

scenes: CFLAGS += -DDEBUG -ggdb -O0
scenes: LIBS += -ldl
scenes:
	$(CC) $(CFLAGS) -shared -o scene_game.so $(INCLUDES) $(LIBS) src/scenes/menu.c src/gui/ugui.c

clean:
	rm -rf $(BIN) $(TARGET) "$(TARGET).data" "$(TARGET).html" "$(TARGET).js" "$(TARGET).wasm"

