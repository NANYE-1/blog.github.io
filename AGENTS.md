# 流光拓影 — Hugo 地质学博客

## 项目概览

这是一个基于 **Hugo** 的静态博客，用于发布地质学学习笔记、科研内容和技术分享。使用 **PaperMod** 主题（Git 子模块），部署到 GitHub Pages。

## 快速开始

### 初始化
```bash
git clone --recurse-submodules <repo-url>
# 或已克隆后同步子模块
git submodule update --init --recursive
```

### 本地开发
```bash
hugo server -D              # 启动开发服务器 (http://localhost:1313，包含草稿)
hugo server                 # 不包含草稿
hugo new posts/name.md      # 创建新文章
hugo                        # 构建生成 /public/
```

## 项目结构

```
content/
├── posts/                  # 所有博客文章
│   ├── post-name.md       # 纯文本文章
│   └── post-name/
│       ├── index.md       # 含图片的文章
│       └── image.png      # 同目录图片
├── about.md               # 关于页面
├── archives.md            # 归档页
└── search.md              # 搜索页

static/images/             # 全局静态资源 (头像等)
layouts/                   # 自定义页面布局 (覆盖主题)
themes/PaperMod/           # Git 子模块 - PaperMod 主题
hugo.toml                  # 主配置文件
```

## 技术栈

- **Hugo** — 静态网站生成器
- **Markdown** — 内容编写格式
- **Git** — 版本控制
- **PaperMod** — 主题框架

## 内容约定

### 文章 Frontmatter (YAML)
```yaml
---
title: "文章标题"
date: 2026-06-15
draft: false              # false 发布，true 草稿
tags: ["标签1", "标签2"]
categories: ["分类1"]
---
```

### 发布规则
- `draft: false` 的文章会生成到网站
- 标签和分类自动生成分类页面
- 使用中文 URL 和标题

### 图片处理
- **嵌入式**: 将 post 改为目录，放 `index.md` 和图片在同目录，用相对路径引用
- **全局**: 放在 `static/images/`

## 博客规则

- 所有文章位于 `content/posts/`
- 图片与 Markdown 文件放在同一目录
- 不修改 `themes/` 目录源码
- 优先修改 `hugo.toml` 和 `layouts/`

## 写作规则

- 地质学相关文章使用专业术语
- 优先使用 Markdown 格式
- 图片使用 Hugo Page Bundle 方式引用（见项目结构中的 `post-name/` 示例）

## 配置要点

**hugo.toml** 中关键设置:
- `baseURL = "https://NANYE001.github.io/"` — GitHub Pages 部署地址
- `theme = "PaperMod"` — 主题选择
- `locale = "zh-cn"` — 简体中文
- 搜索: Fuse.js 全文搜索已启用 (客户端运行)
- 代码: GitHub 风格语法高亮，行号，自动识别语言
- 目录: 自动生成 H2-H4 标题的目录
- 所有内容渲染为 HTML, RSS, JSON 格式

## 主题自定义

**PaperMod 特性** (已启用):
- Profile 模式首页 (头像 + 简介 + 导航按钮)
- 深色模式切换
- 阅读时间统计、分享按钮、代码复制按钮
- 面包屑导航、文章导航、TOC

**覆盖主题**:
- 在 `/layouts/` 中创建同名文件即可覆盖主题中的模板
- 参考: https://github.com/adityatelange/hugo-PaperMod/tree/master/layouts

**更新主题**:
```bash
git submodule update --remote themes/PaperMod
```

## 部署

生成的网站在 `/public/` 目录，可直接部署到 GitHub Pages:
```bash
hugo                       # 生成静态文件到 /public/
# 提交到 GitHub Pages 分支
```

## 常见任务

### 发布新文章
1. `hugo new posts/my-topic.md` 或 `hugo new posts/my-topic/index.md`
2. 编辑 frontmatter 和内容
3. `hugo server` 预览
4. 设置 `draft: false` 后提交

### 修改菜单/页面
编辑 `hugo.toml` 中 `[[menu.main]]` 部分

### 添加社交链接
编辑 `hugo.toml` 中 `[[params.socialIcons]]` 部分 (已配置 GitHub)

### 修改页面样式
1. 在 `/layouts/` 中添加自定义 HTML
2. 或编辑 `hugo.toml` 中的 `[params]` 配置

## 注意事项

- **Unsafe HTML**: `hugo.toml` 中启用了 `unsafe = true`，允许在 Markdown 中嵌入原始 HTML
- **子模块**: 主题是 Git 子模块，克隆时需要 `--recurse-submodules` 或手动初始化
- **语言**: 全中文内容，菜单和分类页面已配置中文显示

## AI 助手协作要求

- **使用中文回复** — 所有回复、注释和建议均使用简体中文
- **优先给出具体修改方案** — 遇到问题时直接提供代码改进或配置调整方案
- **修改前说明原因** — 任何文件编辑前解释修改的目的和影响
- **遵循项目约定** — 所有建议都应符合上述博客规则和写作规则
