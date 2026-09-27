@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo ================================================
echo   ZhuQuSkill 本地部署引导 (Windows)
echo ================================================
echo.

where python >nul 2>nul
if errorlevel 1 (
    echo   [X] 没有找到 Python。
    echo       请先安装 Python 3.10+: https://www.python.org/downloads/
    echo       安装时务必勾选 "Add Python to PATH"
    pause
    exit /b 1
)
echo [1/5] Python 环境 OK
python --version

echo.
echo [2/5] 创建虚拟环境...
if not exist "venv" (
    python -m venv venv
) else (
    echo   venv 已存在，跳过
)

echo.
echo [3/5] 安装依赖（首次 1-3 分钟）...
call venv\Scripts\activate.bat
pip install -q -i https://mirrors.aliyun.com/pypi/simple/ -U pip
pip install -q -r requirements.txt
echo   依赖安装完成

echo.
echo [4/5] 检查 Cookie 配置...
findstr /C:"Cookie: \"\"" "crawlers\douyin\web\config.yaml" >nul 2>nul
if not errorlevel 1 (
    echo.
    echo   [!] 你还没填 Cookie！
    echo.
    echo   抖音有风控，必须用你自己账号的 Cookie。
    echo   获取方法（30 秒）:
    echo     1. Chrome 打开 https://www.douyin.com 并登录
    echo     2. 按 F12 - 切到 Network 标签
    echo     3. 刷新页面，点任意请求
    echo     4. Request Headers 里找到 Cookie，整行复制
    echo     5. 粘贴到 crawlers\douyin\web\config.yaml 的 Cookie: "" 引号中间
    echo.
    pause
) else (
    echo   Cookie 已配置
)

echo.
echo [5/5] 启动服务...
echo.
echo ================================================
echo   启动后浏览器打开: http://127.0.0.1:8000
echo   API 文档:        http://127.0.0.1:8000/docs
echo   停止服务: 本窗口按 Ctrl+C
echo ================================================
echo.
timeout /t 2 >nul
python start.py

pause
