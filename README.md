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

本仓 4 个 skill 均为标准 `SKILL.md` 布局,各工具可直接消费:

**一键软链(Codex + Grok + pi)**

```bash
git clone https://github.com/FlameMida/frontend-standards ~/frontend-standards
bash ~/frontend-standards/scripts/install-other-agents.sh          # 全部三家
bash ~/frontend-standards/scripts/install-other-agents.sh codex pi # 只装指定工具
```

软链共享:每日同步到 GitHub 后,`cd ~/frontend-standards && git pull` 一次,三个工具同时拿到最新。

各工具的发现路径(脚本即按下表软链):

| 工具 | 用户级 skill 目录 | 备注 |
|---|---|---|
| Codex CLI | `~/.codex/skills/` | 亦扫描项目内 `.agents/skills/` |
| Grok Build | `~/.grok/skills/` | **已装 Claude Code 插件时零配置**(Grok 自动读 Claude 插件/skills,无需软链,避免重复发现) |
| pi(pi.dev) | `~/.pi/agent/skills/` | 项目级 `.pi/skills/` 亦可 |

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
