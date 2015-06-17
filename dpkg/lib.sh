abreqexe dpkg dpkg-deb dpkg-query

PM_ROOT=/

PM_ROOTPARAM=""

pm_whoprov(){
	dpkg-query --admindir=$PM_ROOT/var/lib/dpkg -S $1 2> /dev/null | awk '{ print $1 }' | rev | cut -b 2- | rev
	# This just give a nice list of formatted dependencies.
}

pm_getver(){
	dpkg-query --admindir=$PM_ROOT/var/lib/dpkg -f '${Version}' -W $1 2>/dev/null
}

pm_exist(){
	dpkg --admindir=$PM_ROOT/var/lib/dpkg -l $1 2>/dev/null 1>&2
}

pm_checkdep(){
	for i
	do
		sat=false
		if echo $i | grep \| 2>/dev/null 1>&2
		then
			while echo $i | grep \| 2>/dev/null 1>&2
			do
				pm_exist "`echo $i | cut -d \| -f 1`" && (sat=true;break)
				i="`echo $i| cut -d \| -f 2-`"
			done
		fi
		if bool sat
		then
			true
		else
			pm_exist "`echo $i | cut -d \| -f 1`" || return 1
		fi
	done
}

pm_repoupdate(){
	apt-get update
}

pm_repoinstall(){
	apt-get install $* --yes
}
pm_chroot(){
	export PM_ROOT=$1
	export PM_ROOTPARAM="--root=$1 --admindir=$1/var/lib/dpkg --force-architecture" 
}