# DDNS-Go feed (taskplan)

[简体中文](README.md) | **English**

This private source feed is used by the customized
[hnt510-great/openwrt](https://github.com/hnt510-great/openwrt) main tree.
The project targets x86_64/glibc, APK, native systemd and GNOME. Package
selection follows the main tree's saved configuration.

| Item | Value |
| --- | --- |
| Feed name | `taskplan` |
| Repository branch | `main` |
| Original upstream | [https://github.com/sirpdboy/luci-app-ddns-go](https://github.com/sirpdboy/luci-app-ddns-go) (`main`) |

`taskplan` is the feed name retained by the main tree. This repository
actually supplies dynamic DNS and its LuCI interface; it is separate from the
host's scheduled-maintenance framework.

| Recipe directory | Purpose |
| --- | --- |
| `ddns-go/` | Builds the DDNS-Go service to update domain IPv4/IPv6 addresses |
| `luci-app-ddns-go/` | LuCI interface depending on `ddns-go` |

## Main-tree integration

The service recipe uses Go build tools from `packages`; its LuCI recipe uses
build rules from `luci`. The complete main tree already configures those feeds.

Native service validation includes `ddns-go`. This establishes its inclusion
in supervision checks, not acceptance of every DNS provider or production
domain. Configure domains, provider authorization and access on the device;
keep personal configuration out of source repositories.

The main tree's scheduled maintenance is a separate host-side tool and remains
disabled. Updating this feed does not install or enable that workflow. The
project docs have no separate DNS-provider setup or end-to-end acceptance
guide; consult the current recipes and original upstream project for those
application details.

## Get the source and build

Authenticate on the build machine with an account that can read every private
repository, then obtain the complete main tree:

```sh
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
git clone https://github.com/hnt510-great/openwrt.git
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
```

The main tree's `feeds.conf.default` already contains:

```text
src-git taskplan https://github.com/hnt510-great/openwrt-taskplan.git;main
```

To update only this feed in an existing main tree:

```sh
./scripts/feeds update taskplan
./scripts/feeds install -a -p taskplan
```

Select the desired package in the main configuration and run `make defconfig`.
Example individual package build:

```sh
make package/feeds/taskplan/luci-app-ddns-go/compile V=s
```

Run these commands from the main-tree root. Preserve an existing `.config`;
see [local build](https://github.com/hnt510-great/openwrt/blob/main/docs/local-build.md) for setup in a new checkout.
`install` creates build-recipe links rather than installing software on a
device. The full `update -a` also checks and can modify main-tree custom recipes.

## Maintenance and validation

`origin` points to this private repository. To merge original upstream changes
in a new clone, add `upstream` once:

```sh
git -C feeds/taskplan remote add upstream https://github.com/sirpdboy/luci-app-ddns-go.git
git -C feeds/taskplan fetch upstream
git -C feeds/taskplan merge upstream/main
# Review, resolve conflicts and validate before pushing
git -C feeds/taskplan push origin main
```

Skip the add command if `upstream` already exists. `scripts/feeds update` pulls
the private branch; it does not merge original upstream automatically. Feed
integration and main-tree commits are separate. Preserve existing commits,
stashes and uncommitted work. Main-tree `patches/feeds/` files and feature
manifests are historical backups; do not reapply changes already present.

Changes to published APK contents require a new package version, preserving
immutable package identities. Record source checks, package builds, VM tests
and physical-device validation separately. This page summarizes existing
design and evidence without claiming new build or device results. See
[private GitHub hosting](https://github.com/hnt510-great/openwrt/blob/main/docs/github-source-hosting.md).

## Design and validation documents

- [Native service supervision](https://github.com/hnt510-great/openwrt/blob/main/docs/systemd-native-supervision.md)
- [Supervision validation including ddns-go](https://github.com/hnt510-great/openwrt/blob/main/docs/systemd-native-supervision-validation.md)
- [Disabled host scheduled maintenance](https://github.com/hnt510-great/openwrt/blob/main/docs/scheduled-maintenance.md)

## License and upstream

Retain upstream copyrights and licenses. Each package's source follows its
recipe's `PKG_LICENSE` and source declarations.
See the repository [LICENSE](LICENSE).
