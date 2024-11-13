def nu_version []: nothing -> int {
  let nv = ($env.NU_VERSION | split row '.')
  (($nv.0 | into int) * 10000) + ($nv.1 | into int)
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
