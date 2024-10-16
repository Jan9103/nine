def nu_version []: nothing -> int {
  let nv = ($env.NU_VERSION | split row '.')
  (($nv.0 | into int) * 10000) + ($nv.1 | into int)
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
