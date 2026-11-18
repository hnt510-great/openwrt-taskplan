#!/bin/sh
# Shared configuration helper for ddns-go.

DDNS_GO_CONFDIR=/etc/ddns-go
DDNS_GO_CONF=$DDNS_GO_CONFDIR/ddns-go-config.yaml

ddns_go_init_yaml() {
	[ -d "$DDNS_GO_CONFDIR" ] || mkdir -p "$DDNS_GO_CONFDIR"
	chown -R ddns-go:ddns-go "$DDNS_GO_CONFDIR"
	chmod 755 "$DDNS_GO_CONFDIR"
	[ -f "$DDNS_GO_CONF" ] && chmod 644 "$DDNS_GO_CONF" || :
}

ddns_go_build_args() {
	local cfg="$1"
	local args="-c $DDNS_GO_CONF"
	local port time ctimes dns noweb skipverify

	config_get port "$cfg" port '9876'
	case "$port" in
		*:*) args="$args -l $port" ;;
		*) args="$args -l :$port" ;;
	esac

	config_get time "$cfg" time '300'
	[ -n "$time" ] && args="$args -f $time"

	config_get ctimes "$cfg" ctimes '5'
	[ -n "$ctimes" ] && args="$args -cacheTimes $ctimes"

	config_get dns "$cfg" dns '223.5.5.5'
	[ -n "$dns" ] && args="$args -dns $dns"

	config_get_bool noweb "$cfg" noweb 0
	[ "$noweb" -eq 1 ] && args="$args -noweb"

	config_get_bool skipverify "$cfg" skipverify 0
	[ "$skipverify" -eq 1 ] && args="$args -skipVerify"

	echo "$args"
}

ddns_go_read_section() {
	local cfg="$1"
	local enabled

	[ -z "$DDNS_GO_SELECTED_CFG" ] || return 0
	config_get_bool enabled "$cfg" enabled 0
	[ "$enabled" -eq 1 ] || return 0
	DDNS_GO_SELECTED_CFG="$cfg"
	config_get DDNS_GO_DELAY "$cfg" delay 0
	DDNS_GO_ARGS="$(ddns_go_build_args "$cfg")"
}

ddns_go_load() {
	. /lib/functions.sh
	DDNS_GO_SELECTED_CFG=""
	DDNS_GO_DELAY=0
	DDNS_GO_ARGS=""
	config_load ddns-go
	config_foreach ddns_go_read_section basic
	[ -n "$DDNS_GO_SELECTED_CFG" ]
}
