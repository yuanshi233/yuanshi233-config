# yuanshi233 Configuration Repository

本仓库是 yuanshi233 跨工作区规则的唯一事实源。修改前读取：

- [`bootstrap.md`](bootstrap.md)
- [`identity.md`](identity.md)
- [`engineering-contract.md`](engineering-contract.md)
- [`engineering-workflow.md`](engineering-workflow.md)

## 仓库边界

- `bootstrap.md` 只保存必须直接进入自动加载入口的人格和执行摘要。
- `identity.md` 保存完整身份、关系、记忆和交流风格。
- `engineering-contract.md` 只保存跨语言、跨项目长期成立的工程不变量。
- `engineering-workflow.md` 只保存执行、自迭代和人类确认边界。
- 工具入口由 `scripts/install.sh` 生成，只内嵌 `bootstrap.md`，其余正文保持 canonical pointer。
- 待验证的跨项目经验放入 `experience/candidates/`，成熟后晋升到真正执行它的事实源或自动化机制并删除候选。
- 项目特有的架构、命令、领域规则和测试矩阵不进入本仓库。
- 新规则必须可复用、可验证，或已经在多个任务中重复出现。
- 一次性环境故障、单个仓库路径和未经证明的判断不写成全局规则。

## 修改和验证

- 保留 `.local-backups/`，但不要将其加入 Git。
- 修改脚本后运行 `sh -n scripts/*.sh`。
- 修改仓库内容后运行 `scripts/validate.sh`。
- 修改人格摘要或安装器后重新运行 `scripts/install.sh`，再运行 `scripts/install.sh --check`。
- 最后运行 `git diff --check`。
- 不在本仓库创建只做改名或转发的重复配置文件。
