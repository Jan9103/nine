# Archival notice

I decided to declare the second attempt at this experiment a failure.  
Most of the important changes to include here are just to deep to properly implement a wrapper for.  
To give you an idea of how much is impossible here is the list for `0.100.0` to `0.101.0`:
* changes to the `++` operator
* typing is stricter
* `timeit` no longer supports blocks
* changes to how `from csv` parses things (yes i could reimplement it in pure nu...)
* imported modules are named differently
* removal of `du --all` argument
* changes to how `source` works
* removal of `NU_DISABLE_IR`

Yes it would still fix a few things and maybe help one script, but from my POV it is currently
simply not worth the extra work on both the script and nine side.

I will probably revisit the idea a 3rd time when nushell gets more stable (`1.0`?).


---

Original README

---

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
    "nulibs/nine": {"name": "jan9103/nine", "version": "~0.95"}
  },
  "registry": [
    {"source_uri": "https://github.com/Jan9103/numng_repo", "package_format": "numng", "path_offset": "repo"}
  ]
}
```

or

```json
"linkin": {
  "nulibs/nine": {"name": "nine", "source_uri": "https://github.com/jan9103/nine.nu", "git_ref": "nu0.95"}
}
```

And replace `0.95` with the **oldest** nushell version you want to support

Afterwards `use` it at the top of each script of your project using relative paths from the script to nine (example: `use ../nulibs/nine *`)


### other options

It might be possible to package this for [nupm][], but since each script and library might use a diffrent version issues might arise.

Manually copying the files in might work at first, but you will have to constantly update it manually for each project on each device.


## Status of versions

### General things

* some things are impossible to emulate using a library (example: since `0.96` `continue` no longer works within `each`)
* sometimes it isn't worth the work since noone (shouldve) used the old feature (example: since `0.96` `"foo"bar` is no longer a valid string)
* overriding other libraries (including `std`) is not reliable
* i wont keep supporting versions forever. depending on the changes the support-duration might vary.


### Unfixed things

* anything polars
* broken by nu0.96: do not use `continue` within `each`
* broken by nu0.97: add quotes to strings within assignments (`let`, `mut`, `$foo =`) (`const foo = bar` -> `const foo = "bar"`)
* broken by nu0.98: tee is somehow diffrent


### Available versions

branch-name / from nu-version | up to nu-version | code
--- | --- | ---
`nu0.95`  | `0.100` | [code](https://github.com/Jan9103/nine/tree/nu0.95)
`nu0.96`  | `0.100` | [code](https://github.com/Jan9103/nine/tree/nu0.96)
`nu0.97`  | `0.100` | [code](https://github.com/Jan9103/nine/tree/nu0.97)
`nu0.98`  | `0.100` | [code](https://github.com/Jan9103/nine/tree/nu0.98)
`nu0.99`  | `0.100` | [code](https://github.com/Jan9103/nine/tree/nu0.99)
`nu0.100` | `0.100` | [code](https://github.com/Jan9103/nine/tree/nu0.100)


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
