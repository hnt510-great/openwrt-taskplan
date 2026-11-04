# DDNS-Go feed（taskplan）

**简体中文** | [English](README.en.md)

本仓库是 [hnt510-great/openwrt](https://github.com/hnt510-great/openwrt) 定制主树使用的私有源码 feed。
项目面向 x86_64/glibc、APK、原生 systemd 和 GNOME 桌面；软件选择以主树
保存的完整配置为准。

| 项目 | 值 |
| --- | --- |
| Feed 名称 | `taskplan` |
| 本仓库分支 | `main` |
| 原始上游 | [https://github.com/sirpdboy/luci-app-ddns-go](https://github.com/sirpdboy/luci-app-ddns-go)（`main`） |

`taskplan` 是主树沿用的 feed 名称，本仓库实际提供动态 DNS 服务及其 LuCI
界面，不是主机定时维护框架。

| 配方目录 | 用途 |
| --- | --- |
| `ddns-go/` | 构建 DDNS-Go 服务，更新域名对应的 IPv4/IPv6 地址 |
| `luci-app-ddns-go/` | DDNS-Go 的 LuCI 配置界面，依赖 `ddns-go` |

## 与主树的集成

`ddns-go` 配方使用 `packages` feed 中的 Go 构建工具，LuCI 配方使用 `luci`
feed 的构建规则。完整主树的 feeds 配置已经包含这些依赖。

原生 systemd 的服务验证记录包含 `ddns-go`；这说明其纳入了服务监督检查，
不代表已经验证每一种 DNS 服务商或现网域名。请在设备上单独配置域名、服务商
授权及访问权限，个人配置不应写入源码仓库。

主树的 scheduled maintenance 是另一套主机侧工具，目前保持停用；更新本
feed 不会安装或启用那套维护任务。docs 尚未提供独立的 DDNS 服务商配置与
端到端验收指南，具体应用配置应结合当前配方和上游项目说明。

## 获取与构建

先在构建机登录有权访问全部私有仓库的 GitHub 账号，再获取完整主树：

```sh
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
git clone https://github.com/hnt510-great/openwrt.git
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
```

主树 `feeds.conf.default` 已包含：

```text
src-git taskplan https://github.com/hnt510-great/openwrt-taskplan.git;main
```

在现有主树中只更新本 feed，可执行：

```sh
./scripts/feeds update taskplan
./scripts/feeds install -a -p taskplan
```

先在主树配置中选择所需包并运行 `make defconfig`。单包构建示例：

```sh
make package/feeds/taskplan/luci-app-ddns-go/compile V=s
```

以上命令均从主树根目录运行。保留已有 `.config`；新 checkout 的配置恢复
步骤见 [本地构建指南](https://github.com/hnt510-great/openwrt/blob/main/docs/local-build.md)。`install` 安装的是构建配方链接，
不会在设备上安装软件。完整 `update -a` 还会检查并可能修改主树的 custom 配方。

## 维护与验证

`origin` 指向本私有仓库。新 clone 需要合并原始上游时，先添加一次 `upstream`：

```sh
git -C feeds/taskplan remote add upstream https://github.com/sirpdboy/luci-app-ddns-go.git
git -C feeds/taskplan fetch upstream
git -C feeds/taskplan merge upstream/main
# 审阅、解决冲突并完成相关验证后推送
git -C feeds/taskplan push origin main
```

已有 `upstream` 时跳过添加命令。`scripts/feeds update` 拉取本私有分支，
不会自动合并原始上游。本地集成修改与主树的提交分别管理，保留现有提交、
stash 和未提交文件。主树的 `patches/feeds/` 和功能清单是历史备份，
不要向已经包含修改的 feed 重复应用补丁。

涉及已发布 APK 内容的修改必须产生新包版本，不能覆盖同一包身份。源码
检查、包构建、VM 与物理设备验证应分别记录；本文汇总已有设计和验证记录，
不新增构建或设备验证结论。私有源码托管说明见
[GitHub 源码托管](https://github.com/hnt510-great/openwrt/blob/main/docs/github-source-hosting.md)。

## 设计与验证文档

- [原生服务监督](https://github.com/hnt510-great/openwrt/blob/main/docs/systemd-native-supervision.md)
- [服务监督验证（含 ddns-go）](https://github.com/hnt510-great/openwrt/blob/main/docs/systemd-native-supervision-validation.md)
- [主机定时维护的停用状态](https://github.com/hnt510-great/openwrt/blob/main/docs/scheduled-maintenance.md)

## 许可与上游

保留上游版权和许可。各软件包源码的许可按其配方 `PKG_LICENSE` 及源码声明执行。
仓库许可声明见 [LICENSE](LICENSE)。
