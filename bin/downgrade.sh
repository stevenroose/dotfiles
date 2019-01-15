#!/usr/bin/bash
#
#   downgrade: downgrade packages using pacman's database and system log files
#
#   Copyright (c) 2008 locci <carlocci_at_gmail_dot_com>
#   Copyright (c) 2008-2016 Pacman Development Team <pacman-dev@archlinux.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

shopt -s extglob
shopt -s nullglob

declare -r myname='downgrade'
declare -r myver='5.0.1'
USE_COLOR='y'
pac_arg=''
QUIET=0
LAST_TRANSACTIONS=10

# gettext initialization
export TEXTDOMAIN='pacman'
export TEXTDOMAINDIR='@localedir@'

# Determine whether we have gettext; make it a no-op if we do not
if ! type -p gettext >/dev/null; then
	gettext() {
		printf "%s\n" "$*"
	}
fi

plain() {
	(( QUIET )) && return
	local mesg=$1; shift
	printf "${BOLD}    ${mesg}${ALL_OFF}\n" "$@" >&1
}

msg() {
	(( QUIET )) && return
	local mesg=$1; shift
	printf "${GREEN}==>${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&1
}

msg2() {
	(( QUIET )) && return
	local mesg=$1; shift
	printf "${BLUE}  ->${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&1
}

ask() {
	local mesg=$1; shift
	printf "${BLUE}::${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}" "$@" >&1
}

warning() {
	local mesg=$1; shift
	printf "${YELLOW}==> $(gettext "WARNING:")${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}

error() {
	local mesg=$1; shift
	printf "${RED}==> $(gettext "ERROR:")${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@" >&2
}

# getopt-like parser
parseopts() {
	local opt= optarg= i= shortopts=$1
	local -a longopts=() unused_argv=()

	shift
	while [[ $1 && $1 != '--' ]]; do
		longopts+=("$1")
		shift
	done
	shift

	longoptmatch() {
		local o longmatch=()
		for o in "${longopts[@]}"; do
			if [[ ${o%:} = "$1" ]]; then
				longmatch=("$o")
				break
			fi
			[[ ${o%:} = "$1"* ]] && longmatch+=("$o")
		done

		case ${#longmatch[*]} in
			1)
				# success, override with opt and return arg req (0 == none, 1 == required)
				opt=${longmatch%:}
				if [[ $longmatch = *: ]]; then
					return 1
				else
					return 0
				fi ;;
			0)
				# fail, no match found
				return 255 ;;
			*)
				# fail, ambiguous match
				printf "downgrade: $(gettext "option '%s' is ambiguous; possibilities:")" "--$1"
				printf " '%s'" "${longmatch[@]%:}"
				printf '\n'
				return 254 ;;
		esac >&2
	}

	while (( $# )); do
		case $1 in
			--) # explicit end of options
				shift
				break
				;;
			-[!-]*) # short option
				for (( i = 1; i < ${#1}; i++ )); do
					opt=${1:i:1}

					# option doesn't exist
					if [[ $shortopts != *$opt* ]]; then
						printf "downgrade: $(gettext "invalid option") -- '%s'\n" "$opt" >&2
						OPTRET=(--)
						return 1
					fi

					OPTRET+=("-$opt")
					# option requires optarg
					if [[ $shortopts = *$opt:* ]]; then
						# if we're not at the end of the option chunk, the rest is the optarg
						if (( i < ${#1} - 1 )); then
							OPTRET+=("${1:i+1}")
							break
						# if we're at the end, grab the the next positional, if it exists
						elif (( i == ${#1} - 1 )) && [[ $2 ]]; then
							OPTRET+=("$2")
							shift
							break
						# parse failure
						else
							printf "downgrade: $(gettext "option requires an argument") -- '%s'\n" "$opt" >&2
							OPTRET=(--)
							return 1
						fi
					fi
				done
				;;
			--?*=*|--?*) # long option
				IFS='=' read -r opt optarg <<< "${1#--}"
				longoptmatch "$opt"
				case $? in
					0)
						# parse failure
						if [[ $optarg ]]; then
							printf "downgrade: $(gettext "option '%s' does not allow an argument")\n" "--$opt" >&2
							OPTRET=(--)
							return 1
						# --longopt
						else
							OPTRET+=("--$opt")
						fi
						;;
					1)
						# --longopt=optarg
						if [[ $optarg ]]; then
							OPTRET+=("--$opt" "$optarg")
						# --longopt optarg
						elif [[ $2 ]]; then
							OPTRET+=("--$opt" "$2" )
							shift
						# parse failure
						else
							printf "downgrade: $(gettext "option '%s' requires an argument")\n" "--$opt" >&2
							OPTRET=(--)
							return 1
						fi
						;;
					254)
						# ambiguous option -- error was reported for us by longoptmatch()
						OPTRET=(--)
						return 1
						;;
					255)
						# parse failure
						printf "downgrade: $(gettext "invalid option") '--%s'\n" "$opt" >&2
						OPTRET=(--)
						return 1
						;;
				esac
				;;
			*) # non-option arg encountered, add it as a parameter
				unused_argv+=("$1")
				;;
		esac
		shift
	done

	# add end-of-opt terminator and any leftover positional parameters
	OPTRET+=('--' "${unused_argv[@]}" "$@")
	unset longoptmatch

	return 0
}


# Print usage information
usage() {
	printf "%s (pacman) %s\n" "$myname" "$myver"
	echo
	printf -- "$(gettext "Downgrade packages using pacman's database and system log files")\n"
	echo
	printf -- "$(gettext "Usage: %s [options] [package(s)]")\n" "$0"
	echo
	printf -- "$(gettext "Options:")\n"
	printf -- "$(gettext "  -h, --help       Show this help message and exit")\n"
	printf -- "$(gettext "  -q, --quiet      Silence most of the status reporting; not suitable for interactive use")\n"
	printf -- "$(gettext "  -m, --nocolor    Disable colorized output messages")\n"
	printf -- "$(gettext "  -n, --number <n> List the last <n> transactions (defaults to %s)")\n" "$LAST_TRANSACTIONS"
	printf -- "$(gettext "  --needed         Do not reinstall the targets that are already up-to-date")\n"
	printf -- "$(gettext "  --noconfirm      Bypass any and all “Are you sure?” messages")\n"
	echo
	printf -- "$(gettext "Examples:")"
	printf -- "    %s --needed\n" "$myname"
	printf -- "    %s linux linux-headers\n" "$myname"
	printf -- "    %s --noconfirm binutils\n" "$myname"
	echo
}

# Print version information
version() {
	printf "%s %s\n" "$myname" "$myver"
	echo 'Copyright (C) 2016 Gordian Edenhofer <gordian.edenhofer@gmail.com>'
	echo 'Copyright (C) 2008-2016 Pacman Development Team <pacman-dev@archlinux.org>'
}


# Printing the usage information takes precedence over every other parameter
for option in "$@"; do
	[[ $option == "-h" || $option == "--help" ]] && usage && exit 0
done

# Parse arguments
OPT_SHORT='qmn:v'
OPT_LONG=('quiet' 'nocolor' 'number:' 'needed' 'noconfirm' 'version')
if ! parseopts "$OPT_SHORT" "${OPT_LONG[@]}" -- "$@"; then
	usage
	exit 1
fi
set -- "${OPTRET[@]}"
unset OPT_SHORT OPT_LONG OPTRET

while :; do
	case "$1" in
		-q|--quiet)
			QUIET=1 ;;
		-m|--nocolor)
			USE_COLOR='n' ;;
		-n|--number)
			LAST_TRANSACTIONS="$2" ;;
		--needed)
			pac_arg="${pac_arg} --needed" ;;
		--noconfirm)
			pac_arg="${pac_arg} --nocofirm" ;;
		-v|--version)
			version
			exit 0 ;;
		--)
			shift
			break 2 ;;
	esac
	shift
done

# Configure colored output
# check if messages are to be printed using color
unset ALL_OFF BOLD BLUE GREEN RED YELLOW
if [[ -t 2 && ! $USE_COLOR = "n" ]]; then
	# prefer terminal safe colored and bold text when tput is supported
	if tput setaf 0 &>/dev/null; then
		ALL_OFF="$(tput sgr0)"
		BOLD="$(tput bold)"
		BLUE="${BOLD}$(tput setaf 4)"
		GREEN="${BOLD}$(tput setaf 2)"
		RED="${BOLD}$(tput setaf 1)"
		YELLOW="${BOLD}$(tput setaf 3)"
	else
		ALL_OFF="\e[1;0m"
		BOLD="\e[1;1m"
		BLUE="${BOLD}\e[1;34m"
		GREEN="${BOLD}\e[1;32m"
		RED="${BOLD}\e[1;31m"
		YELLOW="${BOLD}\e[1;33m"
	fi
fi
readonly ALL_OFF BOLD BLUE GREEN RED YELLOW


# Source environmental variables and specify fallbacks
if [[ ! -r /etc/pacman.conf ]]; then
	error "unable to read /etc/pacman.conf"
	exit 1
fi
eval $(awk '/LogFile/ {print $1$2$3}' /etc/pacman.conf)
pac_LogFile="${LogFile:-"/var/log/pacman.log"}"
eval $(awk '/CacheDir/ {print $1$2$3}' /etc/pacman.conf)
pac_CacheDir="${LogFile:-"/var/cache/pacman/pkg"}"
if [[ ! -r /etc/makepkg.conf ]]; then
	error "unable to read /etc/makepkg.conf"
	exit 1
fi
source "/etc/makepkg.conf"
if [[ -r ~/.makepkg.conf ]]; then
	source ~/.makepkg.conf
fi

# Retrieve the list of packages to be assembled and break if none was specified
pkg_list=($*)
if [[ ${#pkg_list[@]} == 0 ]]; then
	msg "Select one of the following transactions:"

	# Read in log file as array
	mapfile -t lines <"${pac_LogFile}"

	# Query the date to which to downgrade to
	transaction_count=0
	transaction_line=("${#lines[@]}")
	for (( idx=${#lines[@]}-1; idx>=0; idx-- )); do
		# Print transaction list with their id
		if [[ "${lines[idx]}" =~ "[ALPM] transaction started" ]]; then
			for (( n=${transaction_line[-1]}; n>=idx; n-- )); do
				# Skip transactions which do not qualify as upgrade or downgrade
				if [[ "${lines[n]}" =~ "[ALPM] "(upgraded|downgraded)" " ]]; then
					((transaction_count++))
					transaction_line[transaction_count]="${idx}"
					QUIET=0 msg2 "${transaction_count}\t: date $(echo "${lines[idx]}" | awk '{ print $1 " " $2 }')\tline ${transaction_line[transaction_count]}"
					break
				fi
			done
		fi
		(( "${transaction_count}" == "${LAST_TRANSACTIONS}" )) && break
	done
	ask "Transaction number: "
	read user_input
	if [[ -z "${user_input##*[!0-9]*}" ]] || (( user_input > LAST_TRANSACTIONS || user_input == 0 )); then
		error "'${user_input}' is not a valid choice..."
		exit 1
	fi

	# Assemble a list of packages to downgrade
	downgrade_pkgname=()
	downgrade_pkgver=()
	downgrade_pkgfile=()
	for (( idx=${#lines[@]}-1; idx>=0; idx-- )); do
		if (( idx == ${transaction_line[user_input]} )); then
			break
		elif [[ "${lines[idx]}" =~ "[ALPM] "(upgraded|downgraded)" " ]]; then
			# Append package to list
			downgrade_pkgname+=("$(echo "${lines[idx]}" | awk '{ print $5 }')")
			downgrade_pkgver+=("$(echo "${lines[idx]}" | awk '{ print substr($6,2) }')")
			if [[ -f "$(find "${pac_CacheDir}" -maxdepth 1 -type f -name "${downgrade_pkgname[-1]}-${downgrade_pkgver[-1]}-*" -print -quit)" ]]; then
				downgrade_pkgfile+=("$(find "${pac_CacheDir}" -maxdepth 1 -type f -name "${downgrade_pkgname[-1]}-${downgrade_pkgver[-1]}-*" -print -quit)")
			elif [[ -n "${PKGDEST}" && -f "$(find "${PKGDEST}" -maxdepth 1 -type f -name "${downgrade_pkgname[-1]}-${downgrade_pkgver[-1]}-*" -print -quit)" ]]; then
				downgrade_pkgfile+=("$(find "${PKGDEST}" -maxdepth 1 -type f -name "${downgrade_pkgname[-1]}-${downgrade_pkgver[-1]}-*" -print -quit)")
			else
				downgrade_pkgfile+=("")
			fi
		fi
	done

	# Safely set duplicates to null in package lists
	for (( idx=${#downgrade_pkgname[@]}-1; idx>=0; idx-- )); do
		for (( n=0; n<idx; n++ )); do
			if [[ "${downgrade_pkgname[n]}" == "${downgrade_pkgname[idx]}" ]]; then
				downgrade_pkgname[${n}]=""
				downgrade_pkgver[${n}]=""
				downgrade_pkgfile[${n}]=""
			fi
		done
	done
else
	# Loop over given packages and ask for a version
	for pkgname in "${pkg_list[@]}"; do
		# Scan system for available package versions and skip if none were found
		if [[ -n "${PKGDEST}" ]]; then
			mapfile -t pkg_versions < <(find "${pac_CacheDir}" "${PKGDEST}" -maxdepth 1 -type f -regextype sed -regex ".*/${pkgname}-[^-]\+-[^-]\+-[^-]\+\.pkg\.tar.*" -print)
		else
			mapfile -t pkg_versions < <(find "${pac_CacheDir}" -maxdepth 1 -type f -regextype sed -regex ".*/${pkgname}-[^-]\+-[^-]\+-[^-]\+\.pkg\.tar.*" -print)
		fi
		if [[ "${#pkg_versions[@]}" -eq 0 ]]; then
			error "No package baring the name '${pkgname}' was found... skipping"
			continue
		fi
		# TODO: Add ArchLinuxArchive support

		# Sort the version array
		pkg_versions=($(printf '%s\n' "${pkg_versions[@]}" | sort))

		# Query the version to which to downgrade
		msg "Select one of the following versions for ${pkgname}:"
		pkg_count=0
		for pkgfile in "${!pkg_versions[@]}"; do
			msg2 "$((pkg_count+1))\t: $(basename "${pkg_versions[pkg_count]}" | sed 's/-[^-]*.pkg.tar..*//g')\tfile ${pkg_versions[pkg_count]}"
			((pkg_count++))
		done
		ask "Item number: "
		read user_input
		if [[ -z "${user_input##*[!0-9]*}" ]] || (( user_input > pkg_count || user_input == 0 )); then
			error "'${user_input}' is not a valid choice..."
			continue
		fi
		downgrade_pkgfile+=("${pkg_versions[$((user_input-1))]}")
	done
fi

# Strip null elements from file array
for i in "${!downgrade_pkgfile[@]}"; do
	[[ -z "${downgrade_pkgfile[i]}" ]] && unset "downgrade_pkgfile[$i]"
done

# Invoke pacman if matches were found
if [[ -z "${downgrade_pkgfile[@]}" ]]; then
	msg "Nothing to downgrade..."
else
	msg "Starting pacman..."

	# Gain privileges using sudo if not running as root
	if [[ $EUID -eq 0 ]]; then
		pacman -U ${pac_arg} "${downgrade_pkgfile[@]}"
	else
		if ! which sudo &>/dev/null ; then
			error "Cannot find the sudo binary!"
			error "${myname} requires root privileges. Either install \"sudo\" or run as root."
			exit 1
		else
			sudo pacman -U ${pac_arg} "${downgrade_pkgfile[@]}"
		fi
	fi
fi
msg "Done."

exit 0

# vim: set noet: