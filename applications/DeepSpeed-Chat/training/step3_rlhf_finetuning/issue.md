### AttributeError: 'NoneType' object has no attribute 'get_tensor_model_parallel_group'

之前發現過的錯誤，須修正原碼 `deepspeed/runtime/hybrid_engine.py` 第 319 行處

```bash
if self.mpu is None:
		...
```

> 注意: 如果 GPU 非多顆，不像 step1, step2 一樣可以照用 multi-node 執行，會報錯 `attribute mp_group not found`；單顆就用 single_gpu script 去跑

~為方便重現，目前有關 LLM training, RLHF 等專案， deepspeed 定版在 `0.9.2` ，將需要修改處直接以 Extension 方式在 local 繼承後 import~

起始點是 `deepspeed.initalize` 有點不太好直接改掉

### Actor model 及 Critic model 的使用

使用沒有微調過的模型當 actor model 及 critic model 時， `rlhf_training` 要設定成 False ；反之，使用 step1 及 step2 訓練過的模型則要把 `rlhf_training` 設定成 True
