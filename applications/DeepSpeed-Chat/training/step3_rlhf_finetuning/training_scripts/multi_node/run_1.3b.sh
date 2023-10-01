#!/bin/bash
# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team
ACTOR_MODEL_PATH=$1
CRITIC_MODEL_PATH=$2
ACTOR_ZERO_STAGE=$3
CRITIC_ZERO_STAGE=$4
OUTPUT=$5
if [ "$OUTPUT" == "" ]; then
    OUTPUT=./output
fi
if [ "$ACTOR_ZERO_STAGE" == "" ]; then
    ACTOR_ZERO_STAGE=3
fi
if [ "$CRITIC_ZERO_STAGE" == "" ]; then
    CRITIC_ZERO_STAGE=3
fi
mkdir -p $OUTPUT

deepspeed --master_port 12346 main.py \
    --data_path Dahoas/rm-static \
    --data_split 2,4,4 \
    --actor_model_name_or_path $ACTOR_MODEL_PATH \
    --critic_model_name_or_path $CRITIC_MODEL_PATH \
    --actor_zero_stage $ACTOR_ZERO_STAGE \
    --critic_zero_stage $CRITIC_ZERO_STAGE \
    --num_padding_at_beginning 1 \
    --per_device_train_batch_size 2 \
    --per_device_mini_train_batch_size 2 \
    --actor_weight_decay 0.1 \
    --critic_weight_decay 0.1 \
    --gradient_accumulation_steps 1 \
    --inference_tp_size 2 \
    --deepspeed \
    --seed 1234 \
    --actor_lora_dim 128 \
    --enable_hybrid_engine \
    --actor_gradient_checkpointing \
    --disable_actor_dropout \
    --output_dir $OUTPUT \
     2>&1 | tee $OUTPUT/training-multi_gpu.log
