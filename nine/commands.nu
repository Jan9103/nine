def nu_version []: nothing -> int {
  let nv = ($env.NU_VERSION | split row '.')
  (($nv.0 | into int) * 10000) + ($nv.1 | into int)
}

export def _into_record []: any -> record {
  # nu0.98: the previous behavior for list inputs has been removed (the index of each item would be used as the key)
  let input = ($in)
  if (nu_version) > 97 {
    if ($input | describe) =~ '^list' {
      return (0.. | zip $input | into record)
    }
  }
  $input | into record
}

export def _clear [--all]: nothing -> nothing {
  # nu0.98: "--all" is now the default
  if (nu_version) > 97 {
    if $all { clear } else { nu -c "clear --keep-scrollback" }
  } else {
    if $all { nu -c "clear --all" } else { clear }
  }
}

export def _scope_commands []: nothing -> list<any> {
  # nu0.98: usage -> description; extra_usage -> extra_description
  if (nu_version) > 97 {
    scope commands
    | rename -c {"usage": "description", "extra_usage": "extra_description"}
  } else {
    scope commands
  }
}

export def _help_commands []: nothing -> list<any> {
  # nu0.98: usage -> description; extra_usage -> extra_description
  if (nu_version) > 97 {
    help commands
    | rename -c {"usage": "description", "extra_usage": "extra_description"}
  } else {
    help commands
  }
}

export def _plugin_list []: nothing -> table<name: string, version: string, is_running: bool, pid: nothing, filename: string, shell: nothing, commands: list<string>> {
  if (nu_version) > 99 {
    plugin list
    | insert 'is_running' {|i| $i.status == "running"}
    | reject status
  } else {
    plugin list
  }
}

export def _url_parse []: string -> record {
  let p = ($in | url parse)
  if (nu_version) > 99 {
    $p | update params ($p.params | reduce -f {} {|it,acc| $acc | upsert $it.key $it.value})
  } else { $p }
}
