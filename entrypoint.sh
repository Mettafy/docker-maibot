#!/bin/bash

# 设置默认镜像源列表
MIRRORS=(
    "https://pypi.tuna.tsinghua.edu.cn/simple"
    "https://pypi.mirrors.ustc.edu.cn/simple"
    "https://mirrors.aliyun.com/pypi/simple"
)

# 遍历插件目录安装依赖
for plugin_dir in /MaiMBot/plugins/*; do
    if [ -d "$plugin_dir" ]; then
        requirements_file="$plugin_dir/requirements.txt"
        if [ -f "$requirements_file" ]; then
            echo "Installing dependencies for plugin in $plugin_dir"

            # 尝试多个镜像源安装
            installed=0
            for mirror in "${MIRRORS[@]}"; do
                echo "[INFO] Trying mirror: $mirror"
                pip install -i "$mirror" --trusted-host $(echo $mirror | awk -F/ '{print $3}') -r "$requirements_file" && {
                    installed=1
                    break
                }
            done

            if [ $installed -ne 1 ]; then
                echo "Failed to install dependencies from $requirements_file using all mirrors"
                exit 1
            fi
        fi
    fi
done

# 启动主程序
cd /MaiMBot || { echo "Failed to enter directory /MaiMBot"; exit 1; }
echo "Starting bot..."
python bot.py
