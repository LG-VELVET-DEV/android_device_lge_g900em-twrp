#!/sbin/sh

SCRIPTNAME="PatchLevel"
LOGFILE=/tmp/recovery.log
TEMPSYS=/s
BUILDPROP=system/build.prop
DEFAULTPROP=prop.default
syspath="/dev/block/by-name/system$(getprop ro.boot.slot_suffix)"
venbin="vendor/bin"
SETFINGERPRINT=true


log_info() {
    echo "I:$SCRIPTNAME:$1" >> "$LOGFILE"
}

log_error() {
    echo "E:$SCRIPTNAME:$1" >> "$LOGFILE"
}

temp_mount() {
    mkdir "$1"
    if [ -d "$1" ]; then
        log_info "Temporary $2 folder created at $1."
    else
        log_error "Unable to create temporary $2 folder."
        finish_error
    fi
    mount -t ext4 -o ro "$3" "$1"
    if [ -n "$(ls -A "$1" 2>/dev/null)" ]; then
        log_info "$2 mounted at $1."
    else
        log_error "Unable to mount $2 to temporary folder."
        finish_error
    fi
}

finish() {
    umount "$TEMPSYS"
    rmdir "$TEMPSYS"
    setprop patchlevel.done true
    touch /sbin/patchlevel_set
    log_info "Script complete. Device ready for decryption."
    exit 0
}

finish_error() {
    umount "$TEMPSYS"
    rmdir "$TEMPSYS"
    log_error "Script run incomplete. Device not ready for decryption."
    exit 0
}


osver_orig=$(getprop ro.build.version.release_orig)
patchlevel_orig=$(getprop ro.build.version.security_patch_orig)
osver=$(getprop ro.build.version.release)
patchlevel=$(getprop ro.build.version.security_patch)
device=$(getprop ro.product.device)
fingerprint=$(getprop ro.build.fingerprint)
product=$(getprop ro.build.product)

log_info "Running patchlevel pre-decrypt script for TWRP..."

temp_mount "$TEMPSYS" "system" "$syspath"

if [ -f "$TEMPSYS/$BUILDPROP" ]; then
	log_info "Build.prop exists! Setting system properties from build.prop"
	# TODO: It may be better to try to read these from the boot image than from /system
	log_info "Current OS version: $osver"
	osver=$(grep -i 'ro.build.version.release' "$TEMPSYS/$BUILDPROP"  | cut -f2 -d'=' -s)
	if [ -n "$osver" ]; then
		resetprop ro.build.version.release "$osver"
		sed -i "s/ro.build.version.release=.*/ro.build.version.release=""$osver""/g" "/$DEFAULTPROP" ;
		log_info "New OS Version: $osver"
	fi
	log_info "Current security patch level: $patchlevel"
	patchlevel=$(grep -i 'ro.build.version.security_patch' "$TEMPSYS/$BUILDPROP"  | cut -f2 -d'=' -s)
	if [ -n "$patchlevel" ]; then
		resetprop ro.build.version.security_patch "$patchlevel"
		sed -i "s/ro.build.version.security_patch=.*/ro.build.version.security_patch=""$patchlevel""/g" "/$DEFAULTPROP" ;
		log_info "New security patch level: $patchlevel"
	fi
	# Set additional props from build.prop
	# Only needed for some devices, so this section can be removed if your device isn't one of them
	log_info "Current device: $device"
	device=$(grep -i 'ro.product.device' "$TEMPSYS/$BUILDPROP"  | cut -f2 -d'=' -s)
	if [ -n "$device" ]; then
		resetprop ro.product.device "$device"
		sed -i "s/ro.product.device=.*/ro.product.device=""$device""/g" "/$DEFAULTPROP" ;
		log_info "New device: $device"
	fi
	log_info "Current fingerprint: $fingerprint"
	fingerprint=$(grep -i 'ro.build.fingerprint' "$TEMPSYS/$BUILDPROP"  | cut -f2 -d'=' -s)
	if [ -n "$fingerprint" ]; then
		resetprop ro.build.fingerprint "$fingerprint"
		resetprop ro.bootimage.build.fingerprint "$fingerprint"
		sed -i "s/ro.build.fingerprint=.*/ro.build.fingerprint=""$fingerprint""/g" "/$DEFAULTPROP" ;
		log_info "New fingerprint: $fingerprint"
	fi
	log_info "Current product: $product"
	product=$(grep -i 'ro.build.product' "$TEMPSYS/$BUILDPROP"  | cut -f2 -d'=' -s)
	if [ -n "$product" ]; then
		resetprop ro.build.product "$product"
		sed -i "s/ro.build.product=.*/ro.build.product=""$product""/g" "/$DEFAULTPROP" ;
		log_info "New product: $product"
	fi
	finish
else
	# Be sure to increase the PLATFORM_VERSION in build/core/version_defaults.mk to override Google's anti-rollback features to something rather insane
	if [ -n "$osver_orig" ]; then
		log_info "Original OS version: $osver_orig"
		log_info "Current OS version: $osver"
		log_info "Setting OS Version to $osver_orig"
		osver=$osver_orig
		resetprop ro.build.version.release "$osver"
		sed -i "s/ro.build.version.release=.*/ro.build.version.release=""$osver""/g" "/$DEFAULTPROP" ;
	else
		log_info "No Original OS Version found. Proceeding with existing value."
		log_info "Current OS version: $osver"
	fi
	if [ -n "$patchlevel_orig" ]; then
		log_info "Original security patch level: $patchlevel_orig"
		log_info "Current security patch level: $patchlevel"
		log_info "Setting security patch level to $patchlevel_orig"
		patchlevel=$patchlevel_orig
		resetprop ro.build.version.security_patch "$patchlevel"
		sed -i "s/ro.build.version.security_patch=.*/ro.build.version.security_patch=""$patchlevel""/g" "/$DEFAULTPROP" ;
	else
		log_info "No Original security patch level found. Proceeding with existing value."
		log_info "Current security patch level: $patchlevel"
	fi
	finish
fi
