#!/bin/bash

# 确保脚本可以执行
chmod +x /opt/entrypoint.sh

# 遍历插件目录
for plugin_dir in /MaiMBot/plugins/*; do
    if [ -d "$plugin_dir" ]; then
        # 检查插件目录下是否存在requirements.txt文件
        requirements_file="$plugin_dir/requirements.txt"
        if [ -f "$requirements_file" ]; then
            echo "Installing dependencies for plugin in $plugin_dir"
            
            # 使用uv安装依赖
	    uv pip install -i https://mirrors.aliyun.com/pypi/simple --system -r "$requirements_file" --upgrade
            
            # 检查安装是否成功
            if [ $? -ne 0 ]; then
                echo "Failed to install dependencies from $requirements_file"
                exit 1
            fi
        fi
    fi
done

# 进入主程序目录并运行bot.py
cd /MaiMBot || { echo "Failed to enter directory /MaiMBot"; exit 1; }
python bot.py
