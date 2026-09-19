# 流光拓影 — 地质学博客

[![Hugo](https://img.shields.io/badge/Hugo-0.140%2B-FF4088?logo=hugo)](https://gohugo.io/)
[![Theme](https://img.shields.io/badge/Theme-PaperMod-0077B5)](https://github.com/adityatelange/hugo-PaperMod)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

基于 [Hugo](https://gohugo.io/) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) 构建的个人博客，记录地质学学习笔记、科研过程与技术分享。

🔗 **线上地址**: [https://NANYE001.github.io/](https://NANYE001.github.io/)

## ✨ 特性

- **Profile 模式首页** — 头像 + 简介 + 快捷导航按钮
- **全文搜索** — 基于 Fuse.js 的客户端搜索，支持标题、标签、分类、正文检索
- **深色模式** — 自动 / 手动切换
- **霞鹜文楷字体** — 优化中文阅读体验
- **Canvas Nest 动态背景** — 交互式连线动画
- **自动生成目录** — H2-H4 标题自动生成 TOC
- **GitHub 风格代码高亮** — 带行号，自动识别语言
- **阅读时间 / 字数统计** — 每篇文章自动显示
- **标签 & 分类系统** — 自动生成分类页面
- **RSS 订阅支持**
- **代码一键复制** — 便捷的代码块复制按钮

## 🚀 快速开始

### 环境要求

- [Hugo](https://gohugo.io/installation/) ≥ 0.140 (Extended 版)
- [Git](https://git-scm.com/)

### 克隆项目

```bash
# 克隆仓库（含主题子模块）
git clone --recurse-submodules https://github.com/NANYE001/NANYE001.github.io.git geology-blog
cd geology-blog

# 如果已经克隆但缺少子模块
git submodule update --init --recursive
```

### 本地开发

```bash
# 启动开发服务器（包含草稿）
hugo server -D

# 启动开发服务器（仅已发布文章）
hugo server

# 创建新文章
hugo new posts/my-topic.md
# 或创建带图片的文章
hugo new posts/my-topic/index.md
```

访问 `http://localhost:1313` 预览站点。

### 构建

```bash
hugo
```

生成的静态文件位于 `/public/` 目录，可直接部署到任意静态托管服务。

## 📁 项目结构

```
geology-blog/
├── content/
│   ├── posts/                  # 博客文章
│   │   ├── post-name.md       # 纯文本文章
│   │   └── post-name/         # 含图片的文章（Page Bundle）
│   │       ├── index.md
│   │       └── image.png
│   ├── about.md               # 关于页面
│   ├── archives.md            # 归档页
│   └── search.md              # 搜索页
├── static/images/             # 全局静态资源（头像等）
├── assets/css/                # 自定义样式
├── layouts/                   # 自定义页面布局（覆盖 PaperMod 主题）
│   ├── _default/single.html   # 文章页布局
│   ├── _partials/             # 局部模板（footer 等）
│   ├── index.json             # Fuse.js 搜索索引模板
│   ├── search.html            # 搜索页面
│   └── single.html            # 单页面布局
├── themes/PaperMod/           # Git 子模块 — PaperMod 主题
├── hugo.toml                  # Hugo 配置文件
└── CLAUDE.md                  # AI 协作指引
```

## 📝 文章格式

每篇文章使用 YAML frontmatter：

```yaml
---
title: "文章标题"
date: 2026-06-15
draft: false              # false = 发布，true = 草稿
tags: ["标签1", "标签2"]
categories: ["分类1"]
---
```

### 图片引用

推荐使用 Hugo Page Bundle 方式：将文章创建为目录，图片与 `index.md` 放在同一目录下，使用相对路径引用。

```markdown
![图片描述](image.png)
```

## 🎨 自定义

### 菜单配置

编辑 `hugo.toml` 中 `[[menu.main]]` 部分添加或修改导航菜单项。

### 社交链接

编辑 `hugo.toml` 中 `[[params.socialIcons]]` 添加社交图标。

### 覆盖主题模板

在 `/layouts/` 目录创建与 PaperMod 主题相同路径的文件即可覆盖。参考 [PaperMod 模板目录](https://github.com/adityatelange/hugo-PaperMod/tree/master/layouts)。

## 📦 部署

本项目部署在 [GitHub Pages](https://pages.github.com/)：

```bash
hugo                                     # 构建
# public/ 目录即为可部署的静态站点
```

## 🔧 维护

### 更新 PaperMod 主题

```bash
git submodule update --remote themes/PaperMod
```

## 📄 许可

MIT License © NANYE001

---

*在地质学的时空中，每个人都是一道光，留下属于自己的影迹。* 🌍
