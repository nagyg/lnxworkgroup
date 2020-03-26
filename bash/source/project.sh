#!/bin/bash
#--------------------------------------------------------------------------------------------------////
# Project environment:
#--------------------------------------------------------------------------------------------------////
job () {
if [ "$#" == 0 ]; then
	echo -e "JOB >>> [${blue}${JOB}${nc}]"
else
	local path=`realpath "$1"`
	if [ -d "$1" ]; then
		export JOB="$path"
		edit.profile "export JOB" "$JOB" 2> /dev/null
		job
	else
		echo "bash: $path: directory not found"
	fi
fi
}

mkproj() {
if [ "$#" -ne 1 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	local path=`realpath "$1"`
	if [ ! -d "$1" ]; then
		cp -r ${WGPATH}/project/proj "$path"
		job "$path"
	else
		echo "bash: $path: directory exists"
	fi
fi
}

mkscene() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	builtin cd "$JOB/Scene"
	local i
	for i in "${@}"; do
	local path=`realpath "${i}"`
	if [ ! -d "${i}" ]; then
		cp -r ${WGPATH}/project/scene "$path"
		mkdir "$JOB/Out/${i}"
		echo -e "${i}	>> [${blue}${path}${nc}]"
	else
		echo "bash: $path: directory exists"
	fi
	done
fi
}

mkasset() {
if [ "$#" == 0 ]; then
	echo "bash: [$#]: illegal number of parameters"
else
	builtin cd "$JOB/Asset"
	local i
	for i in "${@}"; do
	local path=`realpath "${i}"`
	if [ ! -d "${i}" ]; then
		cp -r ${WGPATH}/project/asset "$path"
		echo -e "${i}	>> [${blue}${path}${nc}]"
	else
		echo "bash: $path: directory exists"
	fi
	done
fi
}

# some more cd aliases
cdj() { cd "$JOB/$1"; }
cda() { cd "$JOB/Asset/$1"; }
cds() { cd "$JOB/Scene/$1"; }