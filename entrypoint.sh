#!/bin/bash

# 设置默认镜像源列表
MIRRORS=(
    "https://pypi.tuna.tsinghua.edu.cn/simple"
    "https://pypi.mirrors.ustc.edu.cn/simple"
    "https://mirrors.aliyun.com/pypi/simple"
)

# 函数：尝试从多个镜像源安装依赖
install_from_mirrors() {
    local requirements_file="$1"
    echo "正在安装依赖项: $requirements_file"

    for mirror in "${MIRRORS[@]}"; do
        echo "[INFO] 正在尝试镜像源: $mirror"
        pip install -i "$mirror" --trusted-host $(echo $mirror | awk -F/ '{print $3}') -r "$requirements_file" && return 0
    done

    echo "使用所有镜像源安装依赖项失败: $requirements_file"
    return 1
}

# 安装根插件目录下的依赖（如果存在）
root_requirements="/MaiMBot/plugins/requirements.txt"
if [ -f "$root_requirements" ]; then
    if ! install_from_mirrors "$root_requirements"; then
        echo "根目录下的依赖项安装失败: $root_requirements"
        exit 1
    fi
fi

# 遍历插件目录安装依赖
for plugin_dir in /MaiMBot/plugins/*; do
    if [ -d "$plugin_dir" ]; then
        requirements_file="$plugin_dir/requirements.txt"
        if [ -f "$requirements_file" ]; then
            if ! install_from_mirrors "$requirements_file"; then
                echo "插件目录下的依赖项安装失败: $requirements_file"
                exit 1
            fi
        fi
    fi
done

# 启动主程序
cd /MaiMBot || { echo "进入目录 /MaiMBot 失败"; exit 1; }
echo "启动麦麦主程序.....Start Maibot....."
python bot.py
