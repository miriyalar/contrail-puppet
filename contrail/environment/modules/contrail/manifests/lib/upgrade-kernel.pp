define contrail::lib::upgrade-kernel(
    $contrail_kernel_upgrade,
    $contrail_kernel_version,
    $contrail_logoutput = false,
) {

    if ($operatingsystem == "Ubuntu" and $contrail_kernel_upgrade == "yes")
    {
        if ($lsbdistrelease == "14.04") {
            if ($contrail_kernel_version == "" ) {
                $contrail_dist_kernel_version = "3.13.0-40"
            } else {
                $contrail_dist_kernel_version = $contrail_kernel_version
            }

            $headers = "linux-headers-${contrail_dist_kernel_version}"
            $headers_generic = "linux-headers-${contrail_dist_kernel_version}-generic"
            $image = "linux-image-${contrail_dist_kernel_version}-generic"
            $image_extra = "linux-image-extra-${contrail_dist_kernel_version}-generic"

            package { $headers : ensure => present, }
            ->
            package { $headers_generic : ensure => present, }
            ->
            package { $image : ensure => present, }
            ->
            package { $image_extra : ensure => present, }
            ->
	    reboot { 'after':
	      apply => "immediately",
	      timeout => 0,
	      subscribe       => Package[$image_extra],
	    }
        } else {
            if ($contrail_kernel_version == "" ) {
                $contrail_dist_kernel_version = "3.13.0-34"
            } else {
                $contrail_dist_kernel_version = $contrail_kernel_version
            }

            $headers = "linux-headers-${contrail_dist_kernel_version}"
            $headers_generic = "linux-headers-${contrail_dist_kernel_version}-generic"
            $image = "linux-image-${contrail_dist_kernel_version}-generic"
            $image_extra = "linux-image-extra-${contrail_dist_kernel_version}-generic"

            package { 'apparmor' : ensure => '2.7.102-0ubuntu3.10',}
            ->
            package { $headers : ensure => present, }
            ->
            package { $headers_generic : ensure => present, }
            ->
            package { $image : ensure => present, }
            ->
	    reboot { 'after':
	      subscribe       => Package[$image],
	      apply => "immediately",
	      timeout => 0,
	    }
        }
    } else {
        #TODO for other flavours do nothing
    }

}
#end of upgrade-kernel
