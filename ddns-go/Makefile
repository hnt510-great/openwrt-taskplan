# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2021-2026 sirpdboy  <herboy2008@gmail.com>
# 

include $(TOPDIR)/rules.mk

PKG_NAME:=ddns-go
PKG_VERSION:=6.17.1
PKG_RELEASE:=5

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/jeessy2/ddns-go/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=05ae7ef07241113ee2cd861be530524f06856fc7368b84846db5137a477277ea

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=sirpdboy <herboy2008@gmail.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/jeessy2/ddns-go/v6
GO_PKG_LDFLAGS_X:=main.Version=$(PKG_VERSION)
GO_PKG_LDFLAGS:=$(GO_PKG_LDFLAGS_X)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

PKG_CONFIG_DEPENDS:=CONFIG_OPENWRT_SYSTEMD

define Package/ddns-go
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Support IPV4 and IPV6 simple and easy-to-use IP binding domain name tool
  URL:=https://github.com/jeessy2/ddns-go
  DEPENDS:=$(GO_ARCH_DEPENDS) +ca-bundle
  USERID:=ddns-go:ddns-go
endef

define Package/ddns-go/description
  A simple and easy-to-use IP binding domain name tool that supports IPV4 and IPV6.
endef

define Package/ddns-go/conffiles
/etc/config/ddns-go
/etc/ddns-go/ddns-go-config.yaml
endef


define Package/ddns-go/install
	$(call GoPackage/Package/Install/Bin,$(1))
	
	$(INSTALL_DIR) $(1)/usr/libexec $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_DATA) $(CURDIR)/files/ddns-go-config.sh $(1)/usr/libexec/ddns-go-config.sh
	$(INSTALL_BIN) $(CURDIR)/files/ddns-go.init $(1)/etc/init.d/ddns-go
	$(INSTALL_CONF) $(CURDIR)/files/ddns-go.conf $(1)/etc/config/ddns-go
	$(if $(CONFIG_OPENWRT_SYSTEMD),$(call Package/ddns-go/install-systemd,$(1)))
endef

define Package/ddns-go/install-systemd
	$(INSTALL_DIR) $(1)/usr/lib/systemd/system $(1)/usr/libexec
	$(INSTALL_DATA) $(CURDIR)/files/ddns-go.service $(CURDIR)/files/ddns-go-config.path \
		$(CURDIR)/files/ddns-go-reconfigure.service $(1)/usr/lib/systemd/system/
	$(INSTALL_BIN) $(CURDIR)/files/ddns-go-systemd $(CURDIR)/files/ddns-go-package $(1)/usr/libexec/
endef

define Package/ddns-go/postinst
#!/bin/sh
[ ! -x "$${IPKG_INSTROOT}/usr/libexec/ddns-go-package" ] || "$${IPKG_INSTROOT}/usr/libexec/ddns-go-package" postinst
endef

define Package/ddns-go/prerm
#!/bin/sh
[ ! -x "$${IPKG_INSTROOT}/usr/libexec/ddns-go-package" ] || "$${IPKG_INSTROOT}/usr/libexec/ddns-go-package" prerm
endef

$(eval $(call GoBinPackage,ddns-go))
$(eval $(call BuildPackage,ddns-go))
