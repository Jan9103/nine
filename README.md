# Nine.nu

A forward-compatability library for [nu][].

> ⚠️ **This is currently a experiment to check how well this can work**  
> The experiment might get abandoned at any point.  
> Its currently a "better than nothing", but well not much more.


## Usage 

### with [numng][]

Add the following linkin to your projects `numng.json`:

```json
{
  "linkin": {
    "nulibs/nine": {"name": "jan9103/nine", "version": "~0.97"}
  },
  "registry": [
    {"source_uri": "https://github.com/Jan9103/numng_repo", "package_format": "numng", "path_offset": "repo"}
  ]
}
```

And replace `0.97` with the **oldest** nushell version you want to support

Afterwards `use` it at the top of each script of your project using relative paths from the script to nine (example: `use ../nulibs/nine *`)


### other options

It might be possible to package this for [nupm][], but since each script and library might use a diffrent version issues might arise.

Manually copying the files in might work at first, but you will have to constantly update it manually for each project on each device.


## Status of versions

### General things

* some things are impossible to emulate using a library (example: since `0.97` `continue` no longer works within `each`)
* sometimes it isn't worth the work since noone (shouldve) used the old feature (example: since `0.97` `"foo"bar` is no longer a valid string)
* overriding other libraries (including `std`) is not reliable
* i wont keep supporting versions forever. depending on the changes the support-duration might vary.


### Unfixed things

* anything polars


### Available versions

from | up to
--- | ---
`nu0.95` | `0.99`
`nu0.96` | `0.99`
`nu0.97` | `0.99`


## FAQ

**Q:** Why?  
**A:** Nushell has still not reached version 1.0 and regularly renames or removes features.  
I have a lot of scripts, all of which have to work with the latest nu version (on my desktop), stable (on my server), and a little outdated (on my laptop).  
Additionally updating all scripts (especially while keeping backward-compatability) the day a new update comes out is tedious.  
The solution: Revert the changes from new versions using a library allowing scripts for old version to keep working.

**Q:** Why not backward-compatability?  
**A:** Adding all the new features is way more work than undoing renames (i hope) and the lazy script updating part only works this way around.


[nu]: https://nushell.sh
[numng]: https://github.com/jan9103/numng
[nupm]: https://github.com/nushell/nupm
