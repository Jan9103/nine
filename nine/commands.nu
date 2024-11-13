def nu_version []: nothing -> int {
  let nv = ($env.NU_VERSION | split row '.')
  (($nv.0 | into int) * 10000) + ($nv.1 | into int)
}

export def _generate [initial: any, closure: closure]: nothing -> list<any> {
  # nu0.96: generate: switch the position of <initial> and <closure>, so the closure can have default parameters
  if (nu_version) > 95 {
    generate $closure $initial
  } else {
    generate $initial $closure
  }
}

export def _default [default_value: any, column_name?: string]: any -> any {
  # nu0.96: Remove default list-diving behaviour
  let args = (if $column_name == null {[$default_value]} else {[$default_value $column_name]})
  let input = ($in)
  if ((nu_version) > 95) or (($input | describe) =~ '^list') {
    $in | default ..$args
  } else {
    $in | each {|i| $i | default ..$args}
  }
}

export def _group [group_size: int]: list<any> -> list<list<any>> {
  # nu0.96: Deprecate group in favor of chunks
  if (nu_version) > 95 {
    let group_size = (if $group_size == 0 {1} else {$group_size})
    $in | chunks $group_size
  } else {
    $in | group $group_size
  }
}

export def _select [
  --ignore-errors(-i)
  ...rest: cell-path
]: any -> any {
  # nu0.96: Fix select cell path renaming behavior
  let args = (if $ignore_errors {["--ignore-errors" ...$rest]} else {$rest})
  if (nu_version) > 95 {
    mut tmp = $in | select ...$args
    for cp in $rest {
      if "." in $cp {
        $tmp = ($tmp | rename --column {$cp: ($cp | str replace '.' '_')})
      }
    }
    $tmp
  } else {
    $in | select ...$args
  }
}

export def _from_csv [
  --seperator (-s): string
  --comment (-c): string
  --quote (-q): string
  --escape (-e): string
  --noheaders (-n)
  --flexible
  --no-infer
  --trim (-t): string
]: string -> table {
  # nu0.96: Make the subcommands (from {csv, tsv, ssv}) 0-based for consistency
  let args = [
    ...(if $seperator != null {["--seperator", $seperator | to json]} else {[]})
    ...(if $comment != null {["--comment", $comment | to json]} else {[]})
    ...(if $quote != null {["--quote", $quote | to json]} else {[]})
    ...(if $escape != null {["--escape", $escape | to json]} else {[]})
    ...(if $noheaders {["--noheaders"]} else {[]})
    ...(if $flexible {["--flexible"]} else {[]})
    ...(if $no_infer {["--no-infer"]} else {[]})
    ...(if $trim != null {["--trim", $trim | to json]} else {[]})
  ]
  mut res = ($in | nu --stdin -c $"from csv ($args | str join ' ') | to nuon" | from nuon)
  if (nu_version) > 0.95 {
    for i in ($res | columns | length)..0 {
      if $"column($i)" in ($res | columns) {
        $res = ($res | rename --column {$"column($i)": $"column($i + 1)"})
      }
    }
  }
  $res
}

export def _from_tsv [
  --comment (-c): string
  --quote (-q): string
  --escape (-e): string
  --noheaders (-n)
  --flexible
  --no-infer
  --trim (-t): string
]: string -> table {
  # nu0.96: Make the subcommands (from {csv, tsv, ssv}) 0-based for consistency
  let args = [
    ...(if $comment != null {["--comment", $comment | to json]} else {[]})
    ...(if $quote != null {["--quote", $quote | to json]} else {[]})
    ...(if $escape != null {["--escape", $escape | to json]} else {[]})
    ...(if $noheaders {["--noheaders"]} else {[]})
    ...(if $flexible {["--flexible"]} else {[]})
    ...(if $no_infer {["--no-infer"]} else {[]})
    ...(if $trim != null {["--trim", $trim | to json]} else {[]})
  ]
  mut res = ($in | nu --stdin -c $"from tsv ($args | str join ' ') | to nuon" | from nuon)
  if (nu_version) > 0.95 {
    for i in ($res | columns | length)..0 {
      if $"column($i)" in ($res | columns) {
        $res = ($res | rename --column {$"column($i)": $"column($i + 1)"})
      }
    }
  }
  $res
}

export def _from_ssv [
  --noheaders (-n)
  --alligned-columns
  --minimum-spaces (-m): int
]: string -> table {
  # nu0.96: Make the subcommands (from {csv, tsv, ssv}) 0-based for consistency
  let args = [
    ...(if $noheaders {["--noheaders"]} else {[]})
    ...(if $alligned_columns {["--alligned-columns"]} else {[]})
    ...(if $minimum_spaces != null {["--minimum_spaces", $minimum_spaces]} else {[]})
  ]
  mut res = ($in | nu --stdin -c $"from ssv ($args | str join ' ') | to nuon" | from nuon)
  if (nu_version) > 0.95 {
    for i in ($res | columns | length)..0 {
      if $"column($i)" in ($res | columns) {
        $res = ($res | rename --column {$"column($i)": $"column($i + 1)"})
      }
    }
  }
  $res
}

export def _ps [--long(-l)]: nothing -> table {
  # nu0.97: Prefer process name over executable path
  if (nu_version) > 96 {
    let psl = (ps --long | update name {|i| $i.command})
    if $long { $psl } else { $psl | select pid ppid name status cpu mem virtual }
  } else {
    if $long { ps --long } else { ps }
  }
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
