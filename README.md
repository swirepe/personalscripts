# My Personal Scripts

Peter Swire - swirepe.com

## What is all this?

    .              miscellaneous stuff
    rc/            the startup files
    bashincludes/  things to be sourced on startup
    
## Highlights

### `rc/bashrc`

This starts everything up, and (of course) is symlinked to `~/.bashrc`  It loads up everything that needs to be in memory (with [toramdisk.sh](https://github.com/swirepe/toramdisk.sh)) and runs it.

### `bashincludes/alwaysontop.sh`

I had a pretty long train commute, and I found that at the end of it, my neck would hurt from hunching.  I wrote a thing to keep the input line at the top of the screen in bash.

While it's at it, `alwaysontop.sh`

* keeps the prompt at the top of the screen
* clears the screen automatically
* word wraps
* lists the contents directories upon entering them
* lists the git status in directories that have them
* deemphasizes files that match `.gitignore` patterns

Start it with `autotop`

End it with `unautotop`

Toggle screen clears with `autoclear` and `unautoclear`

![AutotopScreenCap](https://github.com/swirepe/personalscripts/raw/master/autotopcap.png)
