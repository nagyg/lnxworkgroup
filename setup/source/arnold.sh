#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# ARNOLD environment:
#--------------------------------------------------------------------------------------------------////
aversions() {
	source "${ADIR}/arnold/$1/versions.sh"
}

ascan() {
	unset all_aversion
	local d i
	local arnold_dir="${ADIR}/arnold/"
	for d in "${arnold_dir}"* ; do
		if [ -f "$d/versions.sh" ]; then
			all_aversion+=(`echo ${d##${arnold_dir}}`)
		fi
	done
	# sort by version
	all_aversion=($(for i in "${all_aversion[@]}"; do echo "$i"; done | sort -Vr))
}

alist() {
	local count=0
	local i
	ascan
	local format="%s ${blue}%8s${nc} %s %s ${yellow}%s${nc} %9s %s ${yellow}%s${nc} %s\n"
	for i in "${all_aversion[@]}"; do
		local count=$((count+1))
		local htoa_version=$htoa_version
		local support_hversion=$support_hversion
		aversions "${i}"
		printf "$format" "${count})" "${i}" \
		"|| ${support_hversion[@]}" "HTOA" "${htoa_version}"
	done
}

aversion() {
	ascan
if [ ${#all_aversion[@]} != 0 ]; then
	echo ==========================================================================
	echo -e " List exist ${blue}Arnold${nc} in [${ADIR}/arnold] directory."
	echo
	alist
	echo
	createmenu "${all_aversion[@]}"
	echo
	asetenv
	hsetenv 2> /dev/null
	edit.profile "AVERSION" "$AVERSION"
	echo ==========================================================================
else
	local format="${red}%s %31s${nc}\n"
	printf "$format" "Arnold     >" "|| Arnold not found"
fi
}

asetenv() {
if [ -d "${ADIR}/arnold/${AVERSION}" ] && [ -n "${AVERSION}" ]; then

	aversions "${AVERSION}"

	pathremove "${ARNOLD_BINDIR}"
	export ARNOLD_BINDIR="${ADIR}/arnold/${AVERSION}/bin"
	pathadd "${ARNOLD_BINDIR}"

	if [ -z "${HVERSION}" ]; then supphtoa=0; else
		case ${support_hversion[@]} in  *${HVERSION}*) supphtoa=1 ;; *) supphtoa=0 ;; esac
		htoa_path="${ADIR}/htoa/${HVERSION}"
	fi

	local format="%s ${green}%11s${nc} %s ${green}%s${nc}\n"
	printf "$format" "Arnold     >" "${AVERSION}" "||"

else
	supphtoa=0
	aversion
fi
}

aenvironment() {
if [ ${supphtoa} = 1 ]; then
	echo -e "\n"\
	"ARNOLD: ${blue}${AVERSION}${nc}"
	echo -e "\n"\
	$(switch "${supphtoa}" "" " HOUDINI: ${green}${HVERSION}${nc} HTOA: ${green}${htoa_version}${nc}")

	$(switch "${supphtoa}" "" "echo -e \n${blue} HTOA DLL SHADERS\t--> ${nc}$ARNOLD_PLUGIN\n\
	${blue}HTOA DLL PROCEDURAL\t--> ${nc}$ARNOLD_PROCEDURAL")
fi
}

#--------------------------------------------------------------------------------------------------////
# INITIAL:
#--------------------------------------------------------------------------------------------------////
if [ -z "${ADIR}" ]; then
	export ADIR="${WGPATH}/solidangle"
fi

asetenv
