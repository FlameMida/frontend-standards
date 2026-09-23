# frontend-standards

自组装的前端工程规范 [Claude Code](https://code.claude.com) 插件:**4 个 skill 每日自动同步自官方上游**,零组件库绑定,覆盖 React 编码规范、组件组合(组件化)、Feature-Sliced Design 目录架构与 Turborepo monorepo 治理。

## 内容与来源

| Skill | 内容 | 上游(每日同步) | 许可证 |
|---|---|---|---|
| `vercel-react-best-practices` | React/Next.js 编码与性能规范,71 条规则带 impact 分级与正误代码对照 | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) `skills/react-best-practices` | MIT |
| `vercel-composition-patterns` | 组件组合规范:boolean props 反模式、复合组件、context 接口设计、状态上提 | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) `skills/composition-patterns` | MIT |
| `feature-sliced-design` | FSD v2.1 官方目录架构:层规则、放置决策树、9 篇参考 | [feature-sliced/skills](https://github.com/feature-sliced/skills) 仓根 `feature-sliced-design` | MIT |
| `turborepo` | Turborepo 官方 monorepo 治理:任务管线、缓存、CI、边界,随发版同步 | [vercel/turborepo](https://github.com/vercel/turborepo) `skills/turborepo` | MIT |

## 安装

```bash
claude plugin marketplace add FlameMida/frontend-standards
claude plugin install frontend-standards@flame-standards
```

## 更新

```bash
claude plugin marketplace update flame-standards
claude plugin update frontend-standards
```

上游改动最迟 24 小时内经由 GitHub Actions 同步到本仓(每日 UTC 19:23,有变化才 commit,commit message 携带各上游 HEAD sha,可在 [UPSTREAM.lock](./UPSTREAM.lock) 查看当前锁定的版本)。

## 其他编码 agent(Codex / Grok / pi / Cursor 等)

本仓 4 个 skill 均为标准 `SKILL.md` 布局,Codex 与 Grok 均以**原生 plugin 形态**安装:

**Codex CLI**(自带 plugin 系统)

```bash
codex plugin marketplace add FlameMida/frontend-standards
codex plugin add frontend-standards@flame-standards
# 更新:codex plugin marketplace upgrade 后重跑 add
```

**Grok Build**(自带 plugin 系统;也会自动读取已装的 Claude Code 插件)

```bash
grok plugin install https://github.com/FlameMida/frontend-standards.git --trust
# 更新:grok plugin update
```

> Grok 的 `plugin marketplace add` 对本仓 marketplace.json 的解析存在兼容问题(报 "No marketplace plugin named"),URL 直装方式已验证可用;待上游修复后可改用 marketplace 流程。

**pi(pi.dev)**(软链方式)

```bash
git clone https://github.com/FlameMida/frontend-standards ~/frontend-standards
bash ~/frontend-standards/scripts/install-other-agents.sh   # 默认装 pi
```

软链共享:每日同步到 GitHub 后,`cd ~/frontend-standards && git pull` 一次即更新。

**skills.sh 生态(Cursor / OpenCode / Droid / Amp 等 75+)**

```bash
npx skills add FlameMida/frontend-standards
```

## 同步机制

- 定时任务:[.github/workflows/sync.yml](./.github/workflows/sync.yml),也可 `gh workflow run sync.yml` 手动触发
- 同步脚本:[scripts/sync.sh](./scripts/sync.sh),`rsync --delete` 镜像语义,本地可随时幂等重跑
- `skills/` 目录完全由上游决定,**勿手改**(会被下一次同步覆盖);定制需求请提 issue 而不是改文件
- 上游若移动/重命名 skill 路径,同步会显式失败而非静默清空,修复方式:更新 `sync.sh` 内 `UPSTREAMS` 映射

## 归属

所有 skill 内容版权归各上游作者所有,本仓库仅为同步组装,不对内容做任何修改。
