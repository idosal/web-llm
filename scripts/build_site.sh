#!/bin/bash
set -euxo pipefail

if [[ ! -f $1 ]]; then
    echo "cannot find config" $1
fi

MLC_LLM_HOME_SET="${MLC_LLM_HOME:-}"

if [ -z ${MLC_LLM_HOME_SET} ]; then
    export MLC_LLM_HOME="${MLC_LLM_HOME:-mlc-llm}"
fi

rm -rf site/dist
mkdir -p site/dist site/_inlcudes

echo "Copy local configurations.."
cp $1 site/global_config.json
echo "Copy files..."
cp web/llm_chat.html site/_includes
cp web/llm_chat.js site/dist/
cp web/llm_chat.css site/dist/

cp dist/tvmjs_runtime.wasi.js site/dist
cp dist/tvmjs.bundle.js site/dist
cp -r dist/tokenizers-cpp site/dist

if [ -d "$MLC_LLM_HOME/dist/vicuna-v1-7b-q4f32_0/params" ]; then
    mkdir -p site/dist/vicuna-v1-7b-q4f32_0
    cp -rf $MLC_LLM_HOME/dist/vicuna-v1-7b-q4f32_0/tokenizer.model site/dist/vicuna-v1-7b-q4f32_0/
    cp -rf $MLC_LLM_HOME/dist/vicuna-v1-7b-q4f32_0/vicuna-v1-7b-q4f32_0-webgpu.wasm site/dist/vicuna-v1-7b-q4f32_0/
fi
if [ -d "$MLC_LLM_HOME/dist/wizardlm-7b/params" ]; then
    mkdir -p site/dist/wizardlm-7b
    cp -rf $MLC_LLM_HOME/dist/wizardlm-7b/tokenizer.model site/dist/wizardlm-7b/
    cp -rf $MLC_LLM_HOME/dist/wizardlm-7b/wizardlm-7b-webgpu.wasm site/dist/wizardlm-7b/
fi

cd site && jekyll b && cd ..
