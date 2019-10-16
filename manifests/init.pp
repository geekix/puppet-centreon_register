# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include centreon_register
#
# [*centreon_webapi_host*]
# URL of centreon Central server
#
# [*centreon_webapi_port*]
# Port number for centreon URL
#
# [*centreon_login*]
# Login to use for API authentification
#
# [*centreon_password*]
# Password to use for API authentification
#
# [*host_alias*]
# Optional host alias to use for this host
#
# [*host_template*]
# host template to use for this host
#
# [*host_pooler*]
# Which pooler should be use for this host
#
# [*host_state*]
# Can be enabled or disabled. Disabled host won't be monitoring
#
# [*host_group*]
# Optional - Which host_group this host should be part of
#
# [*script_path_linux*]
# Where on the system we should deploy the script on Linux system
#
# [*script_path_windows*]
# Where on the system we should deploy the script on Windows system
#
# [*curl_opts_linux*]
# Add optional parameters to curl command for linux script
#
# [*curl_opts_windows*]
# Add optional parameters to curl command for windows script

class centreon_register (
  String $centreon_webapi_host     = 'http://localhost',
  String $centreon_webapi_port     = '80',
  String $centreon_login           = 'admin',
  String $centreon_password        = 'p4ssw0rd',
  Optional[String] $host_alias     = undef,
  Optional[String] $host_template  = undef,
  String $host_pooler              = 'Central',
  String $host_state               = 'enabled',
  Optional[String] $host_group     = '',
  String $script_path_linux        = '/usr/local/centreon_register',
  String $script_path_windows      = 'c:/centreon_register',
  Optional[String] $curl_opts_linux      = '',
  Optional[String] $curl_opts_windows    = '',
) {

  case $::kernel {
    'windows':{
      # install requirement for windows script
      package { 'curl':
        ensure   => present,
        provider => chocolatey,
      }

      file { $script_path_windows:
        ensure  => directory,
        require => Package['curl'],
      }

      file { "${script_path_windows}/centreon_register.ps1":
        content => template('centreon_register/centreon_register.ps1.erb'),
        require => File[$script_path_windows],
      }

      exec { 'Apply configuration using wrapper':
        path        => 'C:/Windows/System32/WindowsPowerShell/v1.0',
        command     => "powershell -ExecutionPolicy RemoteSigned -Command \"& ${script_path_windows}/centreon_register.ps1\"",
        subscribe   => File["${script_path_windows}/centreon_register.ps1"],
        refreshonly => true,
        # Do not remove the provider line ! For unidentified reasons the script does not work without it
        provider    => powershell,
        require     => [ Package['curl'], File["${script_path_windows}/centreon_register.ps1"] ]
      }
    }
    'linux':{
      # install requirement for bash script
      package { 'curl':
        ensure  => present,
      }

      file { $script_path_linux:
        ensure  => directory,
        owner   => root,
        group   => root,
        mode    => '0755',
        require => Package['curl'],
      }

      file { "${script_path_linux}/centreon_register.sh":
        content => template('centreon_register/centreon_register.sh.erb'),
        mode    => '0700',
        owner   => root,
        group   => root,
        require => File[$script_path_linux],
      }

      exec { 'Apply configuration using wrapper':
        command     => "${script_path_linux}/centreon_register.sh",
        subscribe   => File["${script_path_linux}/centreon_register.sh"],
        refreshonly => true,
        require     => [ Package['curl'], File["${script_path_linux}/centreon_register.sh"] ]
      }
    }
    default:{
      fail("Kernel: ${::kernel} not supported in ${module_name}")
    }
  }
}
