# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include centreon_register
class centreon_register (
  String $centreon_webapi_host     = 'http://localhost',
  String $centreon_webapi_port     = '80',
  String $centreon_login           = 'admin',
  String $centreon_admin_password  = 'p4ssw0rd',
  Optional[String] $host_alias     = undef,
  String $host_template            = undef,
  String $host_pooler              = 'Central',
  String $host_state               = 'enabled',
  Optional[String] $host_group     = '',
  Optional[Hash]   $configuration  = undef,
  String $script_path = '/tmp',
) {


  # install requirement for bash script
  package { 'curl':
    ensure  => latest,
  }

  # Create wrapper file
  file { "${script_path}/wrapper.py":
    ensure  => absent,
  }
  file { "${script_path}/centreon_register.sh":
    content => template('centreon_config/centreon_register.sh.erb'),
    mode    => '0700',
    owner   => root,
    group   => root,
    require => Package['curl'],
  }
  # Create file config
  file { "${script_path}/config.yml":
    ensure  => absent,
  }

  exec { 'Apply configuration using wrapper':
    command     => "${script_path}/centreon_register.sh",
    subscribe   => File["${script_path}/centreon_register.sh"],
    refreshonly => true,
    require     => [
      Package['curl']
    ]
  }
}
