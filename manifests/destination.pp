define syslog_ng::destination (
	$params = []
) {
    $type = 'destination'
    $id = $title
    $order = '70'
    
    concat::fragment { $title:
        target  => "$syslog_ng::tmp_config_file",
        content => generate_statement($id, $type, $params),
        order => $order
    }
}