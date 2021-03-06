# ExpoWASM

We first need to build the image of the SDK from its repository on the `envoy-release/v1.15` branch:

```bash
git clone git@github.com:proxy-wasm/proxy-wasm-cpp-sdk.git
cd proxy-wasm-cpp-sdk
git checkout envoy-release/v1.15
docker build -t wasmsdk:v2 -f Dockerfile-sdk .
```

Then from the root of this repository, build the WASM module with:

```bash
docker run -v $PWD:/work -w /work wasmsdk:v2 /build_wasm.sh
```

```bash
docker run \
-v ${PWD}/envoy.yaml:/etc/envoy.yaml \
-v ${PWD}/build/ExpoFilter.wasm:/etc/ExpoFilter.wasm \
-v ${PWD}/build/ExpoWorker.wasm:/etc/ExpoWorker.wasm \
-p 8000:8000 \
--entrypoint /usr/local/bin/envoy \
istio/proxyv2:1.7.0 -l info -c /etc/envoy.yaml --bootstrap-version 3
```
