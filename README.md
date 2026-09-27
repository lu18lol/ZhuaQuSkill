# ZhuQuSkill — 短视频脚本创作 + 本地素材解析

一套给内容创作者用的组合包：**装好后自动引导你在本地跑起解析服务，然后就能拉真实对标视频、拆解结构、写脚本。**

---

## 这个包里有啥

```
ZhuQuSkill/
├── README.md              ← 你正在看的文件
├── skill/                 ← 脚本创作 Skill（装进 Hermes/Claude 等 Agent 即用）
│   ├── SKILL.md
│   └── references/
│       ├── 本地部署引导.md          ← 装完自动引导部署
│       ├── douyin-benchmark-playbook.md
│       ├── viral-script-patterns.md
│       └── full-account-shooting-plan.md
├── program/               ← 本地解析服务（抖音/TikTok 视频解析 API）
├── 一键部署.bat            ← Windows 双击就跑
└── 一键部署.command        ← Mac / Linux 跑这个
```

---

## 怎么用（三步）

### 第 1 步：装 Skill
把 `skill/` 整个文件夹丢进你的 Agent 技能目录。
- Hermes：`~/.hermes/skills/ZhuQuSkill/`
- 其他 Agent：放进对应的 skills 目录

装完后跟 Agent 说一句"**装好了，帮我开始**"，它会自动引导你走完下面两步。

### 第 2 步：本地部署解析服务
Windows 双击 `一键部署.bat`；Mac/Linux 终端跑 `./一键部署.command`。

脚本自动建环境、装依赖、检查配置、启动服务。

### 第 3 步：填你自己的 Cookie（必须）
抖音有风控，不填 Cookie 解析不了。30 秒搞定：
1. Chrome 打开 https://www.douyin.com 并登录
2. F12 → Network → 刷新页面 → 点任意请求
3. Request Headers 里找到 `Cookie:` 整行复制
4. 粘进 `program/crawlers/douyin/web/config.yaml` 的 `Cookie: ""` 引号中间
5. 重跑部署脚本

跑起来后访问：**http://127.0.0.1:8000**

---

## 关于 Cookie / 密钥（重要）

- 本包**不含任何他人密钥或 Cookie**，所有配置文件都留空，等你填自己的。
- **Cookie = 你的账号登录凭证**。只放本地，别发给任何人、别提交到 git。
- 服务默认只跑在 `127.0.0.1`（本机），不暴露公网。

---

## 环境要求

- Python 3.10+（Windows 安装时勾选 "Add Python to PATH"）
- 一个能正常访问抖音的网络环境
- 无需服务器，普通电脑即可

---

## 开源署名 / Credits

`program/` 目录下的解析服务基于开源项目 **Douyin_TikTok_Download_API**（作者 Evil0ctal），
采用 Apache License 2.0 授权。本包仅对其做了凭据清空处理，方便安全分发。
原项目地址：https://github.com/Evil0ctal/Douyin_TikTok_Download_API

使用本项目时请遵守原项目许可证及平台相关规定，仅将抓取内容用于学习与创作参考，
不得原样搬运他人作品。

---

## 常见问题

**Q: 双击 bat 闪一下就没了？**
A: 大概率没装 Python 或没勾 PATH。去 python.org 装 3.10+，安装时勾选 "Add Python to PATH"。

**Q: 依赖装不动？**
A: 脚本已用阿里云镜像。网络特别差可改成清华源。

**Q: 服务起了但解析失败？**
A: 九成是 Cookie 没填或过期。抖音 Cookie 有效期有限，失效了就重新抓一次。

**Q: 端口冲突？**
A: 改 `program/config.yaml` 里的 `Host_Port`（默认 8000）。
