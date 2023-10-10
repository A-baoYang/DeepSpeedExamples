### Can't pip install deepspeed

(install後應該要加""但還是有先報錯是與安裝deepspeed相關的)
```bash
$ pip install deepspeed>=0.9.0
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'NewConnectionError('<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7fa210279b80>: Failed to establish a new connection: [Errno -3] Temporary failure in name resolution')': /simple/deepspeed/
  error: subprocess-exited-with-error
  
  × python setup.py egg_info did not run successfully.
  │ exit code: 1
  ╰─> [8 lines of output]
      Traceback (most recent call last):
        File "<string>", line 2, in <module>
        File "<pip-setuptools-caller>", line 34, in <module>
        File "/tmp/pip-install-yp1zn8gp/deepspeed_7745fa5e0c4b470a9203b902c950009a/setup.py", line 100, in <module>
          cuda_major_ver, cuda_minor_ver = installed_cuda_version()
        File "/tmp/pip-install-yp1zn8gp/deepspeed_7745fa5e0c4b470a9203b902c950009a/op_builder/builder.py", line 41, in installed_cuda_version
          assert cuda_home is not None, "CUDA_HOME does not exist, unable to compile CUDA op(s)"
      AssertionError: CUDA_HOME does not exist, unable to compile CUDA op(s)
      [end of output]
  
  note: This error originates from a subprocess, and is likely not a problem with pip.
error: metadata-generation-failed

× Encountered error while generating package metadata.
╰─> See above for output.

note: This is an issue with the package mentioned above, not pip.
hint: See above for details.
```

以下表示 CUDA 尚未安裝
```bash
AssertionError: CUDA_HOME does not exist, unable to compile CUDA op(s)
```
運行
```bash
nvcc --version
```

得到 
```bash
Command 'nvcc' not found
```

因此需先安裝 CUDAToolkit under WSL-Ubuntu 

經查詢
```bash
conda list | grep cuda
```

版本需求為 11.7
```bash
cudatoolkit               11.7.0              hd8887f6_10    nvidia
nvidia-cuda-cupti-cu11    11.7.101                 pypi_0    pypi
nvidia-cuda-nvrtc-cu11    11.7.99                  pypi_0    pypi
nvidia-cuda-runtime-cu11  11.7.99                  pypi_0    pypi
```

運行以下安裝 CUDAToolkit 11.7
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-wsl-ubuntu-11-7-local_11.7.0-1_amd64.deb
sudo dpkg -i cuda-repo-wsl-ubuntu-11-7-local_11.7.0-1_amd64.deb
sudo cp /var/cuda-repo-wsl-ubuntu-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
```

完成後指定
```bash
export CUDA_HOME=/usr/local/cuda-11.7 # your cuda installed path
```
再重新安裝就OK了
```bash
pip install deepspeed==0.9.2
```

References
- [CUDA_HOME does not exist, unable to compile CUDA op(s)](https://github.com/microsoft/DeepSpeed/issues/2772)
- [WSL2 安裝 CUDA Toolkit、cuDNN](https://hackmd.io/@Kailyn/HkSTXL9xK)
- [CUDA Toolkit 11.7 Downloads](https://developer.nvidia.com/cuda-11-7-0-download-archive?target_os=Linux&target_arch=x86_64&Distribution=WSL-Ubuntu&target_version=2.0&target_type=deb_local)
- [CUDA Support for WSL2](https://docs.nvidia.com/cuda/wsl-user-guide/index.html#cuda-support-for-wsl-2)
