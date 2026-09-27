#!/usr/bin/env bash
# ============================================================
# ZhuaQuSkill — 本地一键部署脚本 (Local One-Click Setup)
# 在你自己电脑上把抖音/TikTok 解析 API 跑起来
# ============================================================
set -e
cd "$(dirname "$0")"

echo ""
echo "================================================"
echo "  ZhuaQuSkill 本地部署引导"
echo "================================================"
echo ""

# ---- 1. 检查 Python ----
echo "[1/5] 检查 Python 环境..."
if command -v python3 >/dev/null 2>&1; then
    PY=python3
elif command -v python >/dev/null 2>&1; then
    PY=python
else
    echo "  ❌ 没有找到 Python。请先安装 Python 3.10+：https://www.python.org/downloads/"
    echo "     Windows 安装时务必勾选 'Add Python to PATH'"
    exit 1
fi
echo "  ✅ $($PY --version)"

# ---- 2. 建虚拟环境 ----
echo ""
echo "[2/5] 创建虚拟环境 (venv)..."
if [ ! -d "venv" ]; then
    $PY -m venv venv
    echo "  ✅ 已创建 venv/"
else
    echo "  ✅ venv 已存在，跳过"
fi

# ---- 3. 激活 ----
echo ""
echo "[3/5] 激活虚拟环境..."
if [ -f "venv/Scripts/activate" ]; then
    source venv/Scripts/activate       # Windows
elif [ -f "venv/bin/activate" ]; then
    source venv/bin/activate           # Linux / macOS
fi
echo "  ✅ 已激活"

# ---- 4. 装依赖 ----
echo ""
echo "[4/5] 安装依赖（首次约 1-3 分钟）..."
pip install -q -i https://mirrors.aliyun.com/pypi/simple/ -U pip
pip install -q -r requirements.txt
echo "  ✅ 依赖安装完成"

# ---- 5. 检查 Cookie ----
echo ""
echo "[5/5] 检查 Cookie 配置..."
COOKIE_FILE="crawlers/douyin/web/config.yaml"
if grep -q 'Cookie: ""' "$COOKIE_FILE" 2>/dev/null; then
    echo ""
    echo "  ⚠️  检测到你还没填 Cookie！"
    echo ""
    echo "  抖音有风控，必须用你自己账号的 Cookie 才能正常解析。"
    echo "  获取方法（30 秒）："
    echo "    1. 用 Chrome 打开 https://www.douyin.com 并登录"
    echo "    2. 按 F12 -> 切到 Network(网络) 标签"
    echo "    3. 刷新页面，点任意一个请求"
    echo "    4. 在 Request Headers 里找到 Cookie，整行复制"
    echo "    5. 粘贴到：$COOKIE_FILE 里的 Cookie: \"\" 引号中间"
    echo ""
    echo "  填完再重新运行本脚本即可。"
    echo ""
    read -p "  现在就想先启动试试吗？(不会成功解析，但能看界面) [y/N] " ans
    case "$ans" in
        [Yy]*) ;;
        *) echo "  已退出。填好 Cookie 后再运行本脚本。"; exit 0 ;;
    esac
else
    echo "  ✅ Cookie 已配置"
fi

# ---- 启动 ----
echo ""
echo "================================================"
echo "  🚀 启动服务..."
echo "================================================"
echo ""
echo "  启动后浏览器打开： http://127.0.0.1:8000"
echo "  API 文档：        http://127.0.0.1:8000/docs"
echo ""
echo "  停止服务： 在本窗口按 Ctrl+C"
echo ""
sleep 2

$PY start.py
