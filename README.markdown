[![Stories in Ready][waffle:img])][waffle:link]
# [CMake Interoperability in Vim][site]

> # Searching For a Maintainer
> This project is not being actively maintained by [Jacky Alcine][jalcine]. If
> you'd like to contribute to improve this project, please submit pull requests
> (*Jacky* is still reviewing them) and over time, the most active contributor
> can take the reigns.

[`cmake.vim 0.5.5`][release] is a Vim plugin that aims to bind [CMake][cmake]
within Vim for your CMake-based projects. This project has not reached a 1.0.0 
release and thus isn't fully ready for production.

# Installing

I recommending using [Vundle][vundle] to install plugins. The line necessary
to add this plugin is as follows:

```viml
Bundle 'jalcine/cmake.vim'
```

Alternatively [Plug][vim-plug]:

```viml
Plug 'jalcine/cmake.vim'
```

Releases are made on Vim.org's scripts as well on patch-level releases.

# Requirements

`cmake.vim` is a **pure Vimscript** plugin, thus requiring nothing but Vim
itself being over version 7.3 or greater. Patches to support older versions of
Vim are greatly appreciated!

# Getting Started

After you installed the plugin, just `cd` into the directory where the
top-level CMakeLists.txt can be found and run:

```viml
" Create a new binary directory for your clean project.
:CMakeCreateBuild <build-dir-name>

" Build all of the targets.
:CMakeBuild

" Clean up bad builds.
:CMakeClean
```

`cmake.vim` does not bind to any keys by default. Check `:h cmake` for more
information.

Add the following to your `.vimrc` if you haven't already. 
You will be able to type `:CMake<tab>` to discover available commands.

```viml
set wildmenu
set wildmode=longest:full,full " Display Vim command mode autocompletion list
```

## Commands

`cmake.vim` defines a few methods for generic interaction with CMake. Check
out `:help cmake-methods` for more information.

## Options

In order for CMake to operate, it **has** to know where the build directory is
located. This is done automatically by the plugin but it does need help in the
event that you happen to build your CMake project in a sub-directory. Check
out `:help cmake-options` for more information.

## Testing

The test suite is written using RSpec and Vimrunner. The following would do a
full unit test of the entire system:

```
bundle install && rake
```

The project uses Guard as well for automated tests. Be sure to check out the
submodules as well to test if external plugins like [syntastic][] and 
[YouCompleteMe][ycm] work as expected.

## Known Edgecases
 1. If you use a header file as the source file, the plugin only knows of the
    source files (which sometimes are generated) and doesn't update the
   `b:cmake_target` variable correctly.

----

## License

This code is released and available under the MIT license. Multiply and be
fruitful.

## Similar Projects

There's a few other projects out there that aim to achieve the same goal as
`cmake.vim`. Feel free to send a PR if you want your project listed here.

  + [vim-cmake](https://github.com/vhdirk/vim-cmake)
  + [vim-cmake-project](https://github.com/Ignotus/vim-cmake-project)
    + [sigidagi's fork of `vim-cmake-project`](https://github.com/sigidagi/vim-cmake-project)

## Author

I'm [Jacky Alcine][jalcine] and I like code. A lot. I also chat a lot like a
firehose so follow with caution!

[vundle]: https://github.com/gmarik/Vundle.vim
[vim-plug]: https://github.com/junegunn/vim-plug
[cmake]: http://cmake.org
[syntastic]: https://github.com/scrooloose/syntastic
[ycm]: https://github.com/Valloric/YouCompleteMe/
[jalcine]: https://jacky.wtf/
[vimux]: https://github.com/benmills/vimux
[site]: https://jalcine.github.io/cmake.vim
[release]: https://github.com/jalcine/cmake.vim/tree/v0.4.1
[waffle:img]: https://badge.waffle.io/jalcine/cmake.vim.png?label=ready
[waffle:link]: https://waffle.io/jalcine/cmake.vim
