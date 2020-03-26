#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# URL repo:
#--------------------------------------------------------------------------------------------------////
repo.archive() {
local d
local in=`realpath .`
local archive_dir="${WGPATH}/"

function tar.archive {
tar -zcvf "${WGPATH}/tmp/${archive}.tar.gz" -X .repoignore .
	if [ $? -eq 0 ]; then
		echo -e "[${green}${WGPATH}/tmp/${archive}.zip${nc}]\n"
	else
		echo -e "[${red}${WGPATH}/tmp/${archive}.zip${nc}]\n"
	fi
}

if [ "$#" == 0 ]; then
	for d in "${archive_dir}"* ; do
		local archive=${d##${archive_dir}}
		if [ -f "$d/.repoignore" ]; then
			builtin cd "$d"
			tar.archive
		fi
	done
else
	for d in "${@}"; do
		local archive=$d
		if [ -f "${WGPATH}/$d/.repoignore" ]; then
			builtin cd "${WGPATH}/$d"
			tar.archive
		else
			echo -e "[${red}${WGPATH}/$d${nc}]	>> .repoignore file not found"
		fi
	done
builtin cd "$in"
fi
}

update() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local i
	local in=`realpath .`
	local ext=tar.gz

	local url0="http://nagyg.ddns.net:17600/workgroup/lnx"

	for i in "${@}"; do
		wget  -q --spider $url0/${i}.${ext}
		if [ $? -eq 0 ]; then
			local path=`realpath "${WGPATH}/${i}"`
			if [ -d "$path" ]; then
				builtin cd "$path"
			else
				mkdir "$path"
				builtin cd "$path"
			fi
			wget $url0/${i}.${ext}
			extract ${i}.${ext} && rm ${i}.${ext}
				if [ $? -eq 0 ]; then
					echo -e "[${green}$url0/${i}.${ext}${nc}]	${green}>> ${i}${nc}\n"
				else
					echo -e "[${red}$url0/${i}.${ext}${nc}]\n"
				fi
		else
			echo -e "[${red}$url0/${i}.${ext}${nc}]\n"
		fi
	done
	builtin cd "$in"
fi
}

#------------------////
# alias:
#------------------////
alias update.ffmpeg='update ffmpeg'
alias update.project='update project'
alias update.sidefx='update sidefx'
alias update.solidangle='update solidangle'

alias update.all='update ffmpeg project sidefx solidangle'
