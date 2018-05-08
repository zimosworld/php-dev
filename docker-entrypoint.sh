#!/usr/bin/env bash

################################################################################
# NOTES
################################################################################

# If updating on a Windows machine run "sed -i -e 's/\r$//' docker-entrypoint.sh" after changes to fix line endings.

################################################################################
# VARIABLES
################################################################################

MY_USER="apache"
MY_GROUP="apache"
NEW_UID=""
NEW_GID=""
DEBUG_COMMANDS=0

################################################################################
# FUNCTIONS
################################################################################

run() {
	_cmd="${1}"
	_debug="0"

	_red="\033[0;31m"
	_green="\033[0;32m"
	_reset="\033[0m"
	_user="$(whoami)"


	# If 2nd argument is set and enabled, allow debug command
	if [ "${#}" = "2" ]; then
		_debug="${2}"
	fi

	if [ "${DEBUG_COMMANDS}" -gt "1" ] || [ "${_debug}" -gt "1" ]; then
		printf "${_red}%s \$ ${_green}${_cmd}${_reset}\n" "${_user}"
	fi
	sh -c "LANG=C LC_ALL=C ${_cmd}"
}

log() {
	_lvl="${1}"
	_msg="${2}"

	_clr_ok="\033[0;32m"
	_clr_info="\033[0;34m"
	_clr_warn="\033[0;33m"
	_clr_err="\033[0;31m"
	_clr_rst="\033[0m"

	if [ "${_lvl}" = "ok" ]; then
		printf "${_clr_ok}[OK]   %s${_clr_rst}\n" "${_msg}"
	elif [ "${_lvl}" = "info" ]; then
		printf "${_clr_info}[INFO] %s${_clr_rst}\n" "${_msg}"
	elif [ "${_lvl}" = "warn" ]; then
		printf "${_clr_warn}[WARN] %s${_clr_rst}\n" "${_msg}" 1>&2	# stdout -> stderr
	elif [ "${_lvl}" = "err" ]; then
		printf "${_clr_err}[ERR]  %s${_clr_rst}\n" "${_msg}" 1>&2	# stdout -> stderr
	else
		printf "${_clr_err}[???]  %s${_clr_rst}\n" "${_msg}" 1>&2	# stdout -> stderr
	fi
}

################################################################################
# LOGIC
################################################################################

### Check host environment and set environment variables ###
if [ $HOST_UNAME = "Linux" ]; then

    NEW_UID=1000
    NEW_GID=1000

    if ! [ -z "$HOST_UID" ]; then
        NEW_UID=$HOST_UID
    fi

    if ! [ -z "$HOST_GID" ]; then
        NEW_GID=$HOST_GID
    fi

    export XDEBUG_REMOTE_CONNECT_BACK=true
elif [ $HOST_UNAME = "Windows" ]; then
    export XDEBUG_REMOTE_CONNECT_BACK=false

    if [ -z "$XDEBUG_REMOTE_HOST" ]; then
        # Set environment variable to the default Windows dockerNAT IP
        export XDEBUG_REMOTE_HOST=10.0.75.1
    fi
fi

### Change User ID (UID) for "$MY_USER" ###
if [[ ! "${NEW_UID}" =~ ^-?[0-9]+$ ]]; then
	log "info" "\$NEW_UID not set. Keeping default uid of '${MY_USER}'."
else
    if _user_line="$( getent passwd "${NEW_UID}" )"; then
        _user_name="${_user_line%%:*}"
        if [ "${_user_name}" != "${MY_USER}" ]; then
            log "warn" "User with ${NEW_UID} already exists: ${_user_name}"
            log "info" "Changing UID of ${_user_name} to 9999"
            run "usermod -u 9999 ${_user_name}"
        fi
    fi
    log "info" "Changing user '${MY_USER}' uid to: ${NEW_UID}"
    run "usermod -u ${NEW_UID} ${MY_USER}"
fi

### Change Group ID (GID) for "$MY_GROUP" ###
if [[ ! "${NEW_GID}" =~ ^-?[0-9]+$ ]]; then
	log "info" "\$NEW_GID not set. Keeping default gid of '${MY_GROUP}'."
else
    if _group_line="$( getent group "${NEW_GID}" )"; then
        _group_name="${_group_line%%:*}"
        if [ "${_group_name}" != "${MY_GROUP}" ]; then
            log "warn" "Group with ${NEW_GID} already exists: ${_group_name}"
            log "info" "Changing GID of ${_group_name} to 9999"
            run "groupmod -g 9999 ${_group_name}"
        fi
    fi
    log "info" "Changing group '${MY_GROUP}' gid to: ${NEW_GID}"
    run "groupmod -g ${NEW_GID} ${MY_GROUP}"
fi

### Start Apache ###
/usr/sbin/httpd -D FOREGROUND