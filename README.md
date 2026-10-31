# yuanshi233 个人 Agent 配置

这是 yuanshi233 的跨工作区唯一事实源。人格、通用工程契约和通用执行流程集中维护在本仓库。Codex、Claude 和目录级 `AGENTS.md` 直接内嵌精简人格 bootstrap，并链接其余 canonical 文件，保证会话开始时人格和执行习惯立即生效。

本工作流派生自 **[AptS-1548](https://github.com/yuanshi233/AptS-1548)**：保留原仓库的工程契约、执行流程、经验晋升机制和脚本结构，移除了原版的代号与虚构身份设定。原仓库署名见 [`identity.md`](./identity.md) 的「来源与传承」一节，不得删除。

## 文件职责

| 文件 | 职责 |
| --- | --- |
| [`bootstrap.md`](./bootstrap.md) | 自动嵌入全局入口的精简人格和执行摘要 |
| [`identity.md`](./identity.md) | yuanshi233 的身份、关系和交流风格；含派生来源署名 |
| [`engineering-contract.md`](./engineering-contract.md) | 跨语言、跨仓库长期成立的工程约束 |
| [`engineering-workflow.md`](./engineering-workflow.md) | 从接收任务到交付和自迭代的默认流程 |
| [`experience/`](./experience/) | 尚待验证的跨项目经验候选与晋升规则 |
| [`scripts/install.sh`](./scripts/install.sh) | 安装或检查全局自动加载入口 |
| [`scripts/validate.sh`](./scripts/validate.sh) | 校验事实源、脚本和经验候选结构 |
| [`scripts/sync.sh`](./scripts/sync.sh) | 检查或 fast-forward 同步当前机器配置 |
| [`AGENTS.md`](./AGENTS.md) | 维护本事实源仓库时的项目差异规则 |

## 安装

推荐克隆位置：

```bash
git clone <你的远端> ~/.config/yuanshi233
cd ~/.config/yuanshi233
./scripts/install.sh
```

安装器会更新：

- `~/AGENTS.md`
- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`

原文件会备份到本仓库的 `.local-backups/<timestamp>/`，该目录不进入 Git。

检查当前安装：

```bash
./scripts/install.sh --check
```

检查仓库结构和规则一致性：

```bash
./scripts/validate.sh
```

检查当前机器与 `origin/main` 的同步、工作树和 adapter 状态：

```bash
./scripts/sync.sh --check
```

在 clean worktree 上 fast-forward 拉取并重新安装：

```bash
./scripts/sync.sh
```

同步脚本只接受 fast-forward，不使用 reset，也不自动处理本地提交或未提交改动。

## 规则分层

```text
本仓库的身份与通用工程规则
  -> 工作区或组织级规则
    -> 项目 AGENTS.md / CLAUDE.md
      -> 当前用户任务
```

- 本仓库只保存所有项目都应该遵守的规则。
- 大型长期项目可以增加项目契约、任务路由和测试矩阵。
- 小项目没有特殊边界时，不需要额外创建项目级规则文件。
- 项目规则补充领域事实和工具入口，不复制本仓库正文。
- 当前用户明确指令决定本次目标和范围；高层规则负责默认行为。

## 与上游 AptS-1548 的关系

- 本仓库是独立派生物，不是原仓库的镜像，也不代表原作者或任何组织。
- 上游改进可以摘取；摘取时在 `identity.md` 的「来源与传承」记录来源提交或日期。
- 署名与出处必须保留，改名不改变来源。

## 自迭代

任务中发现可重复、可验证、跨项目适用的工程经验时，优先更新本仓库最接近的事实源或自动化机制。需要继续积累证据或尚未确定落点的经验进入 `experience/candidates/`；成熟后晋升并删除候选。只对单个产品、框架或代码结构成立的经验留在对应项目。

修改后至少运行：

```bash
./scripts/validate.sh
./scripts/install.sh --check
git diff --check
```
