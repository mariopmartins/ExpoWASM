PROXY_WASM_CPP_SDK=/sdk

all: ExpoFilter.wasm ExpoWorker.wasm

# The following are copied from ${PROXY_WASM_CPP_SDK}/Makefile.base_lite
ifdef NO_CONTEXT
  CPP_CONTEXT_LIB =
else
  CPP_CONTEXT_LIB = ${PROXY_WASM_CPP_SDK}/proxy_wasm_intrinsics.cc
endif

INCLUDE_HEADER = lib/nlohmann/json.hpp

SOURCE_FOLDER = src
BUILD_FOLDER = build

UTIL_LIB = ${SOURCE_FOLDER}/util/*.cc
UTIL_HEADER = ${SOURCE_FOLDER}/util/*.h

%.wasm %.wat: ${SOURCE_FOLDER}/%.cc ${PROXY_WASM_CPP_SDK}/proxy_wasm_intrinsics.h ${PROXY_WASM_CPP_SDK}/proxy_wasm_enums.h ${PROXY_WASM_CPP_SDK}/proxy_wasm_externs.h ${PROXY_WASM_CPP_SDK}/proxy_wasm_api.h ${PROXY_WASM_CPP_SDK}/proxy_wasm_intrinsics.js ${CPP_CONTEXT_LIB} ${UTIL_HEADER} ${INCLUDE_HEADER}
	em++ -s STANDALONE_WASM=1 -s EMIT_EMSCRIPTEN_METADATA=1 -s EXPORTED_FUNCTIONS=['_malloc'] --std=c++17 -O3 -flto -s WASM_OBJECT_FILES=0 --llvm-lto 1 -DPROXY_WASM_PROTOBUF_LITE=1 -I${PROXY_WASM_CPP_SDK} -I/usr/local/include --js-library ${PROXY_WASM_CPP_SDK}/proxy_wasm_intrinsics.js ${SOURCE_FOLDER}/$*.cc ${PROXY_WASM_CPP_SDK}/proxy_wasm_intrinsics_lite.pb.cc ${PROXY_WASM_CPP_SDK}/struct_lite.pb.cc ${CPP_CONTEXT_LIB} ${PROXY_WASM_CPP_SDK}/libprotobuf-lite.a ${UTIL_LIB} -o ${BUILD_FOLDER}/$*.wasm

clean:
	rm ${BUILD_FOLDER}/*.wasm
