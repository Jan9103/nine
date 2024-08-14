# Nine.nu

> ⚠️ **This is currently a experiment to check how well this can work**  
> The experiment might get abandoned at any point.  
> Its currently a "better than nothing", but well not much more.

A forward-compatability library for [nu][].

**Why?** Nushell has still not reached version 1.0 and regularly renames or removes features.  
I have a lot of scripts, all of which have to work with the latest nu version (on my desktop), stable (on my server), and a little outdated (on my laptop).  
Additionally updating all scripts (especially while keeping backward-compatability) the day a new update comes out is tedious.  
The solution: Revert the changes from new versions using a library allowing scripts for old version to keep working.

**Why not backward-compatability?** Adding all the new features is way more work than undoing renames (i hope) and the lazy script updating part only works this way around.

## Usage 

### with [numng][]

Add the following linkin to your projects `numng.json`:

```json
"linkin": {
  "nulibs/nine": {"name": "nine", "source_uri": "https://github.com/jan9103/nine.nu", "git_ref": "VERSION"}
}
```

And replace `VERSION` with the **oldest** nushell version you want to support (example: `nu0.96`)

Afterwards `use` it at the top of each script of your project using relative paths from the script to nine (example: `use ../nulibs/nine *`)

### other options

It might be possible to package this for [nupm][], but since each script and library might use a diffrent version issues might arise.

Manually copying the files in might work at first, but you will have to constantly update it manually for each project on each device.

## Status of versions

* this is far from perfect, but feel free to open a PR or issue
  * some things are impossible to emulate using a library (example: since `0.96` `continue` no longer works within `each`)
  * sometimes it isn't worth the work since noone (shouldve) used the old feature (example: since `0.96` `window` can no longer have a size of 0)
  * [xkcd 1172](https://xkcd.com/1172/) has a point, but i dont care (example: since `0.96` `"foo"bar` is no longer a valid string)
  * overriding other libraries (including `std`) is not reliable
* i wont keep supporting versions forever. depending on the changes the support-duration might vary.
* some things might be impossible to emulate.

old nu-version | up to nu | coverage (estimate of broken scripts fixed by nine)
-------------- | -------- | ---------------------------------------------------
`nu0.95`       | `0.96`   | 80%



[nu]: https://nushell.sh
[numng]: https://github.com/jan9103/numng
[nupm]: https://github.com/nushell/nupm
