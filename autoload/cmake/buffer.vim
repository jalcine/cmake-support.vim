" File:             plugin/cmake.vim
" Description:      Primary plug-in entry point for cmake.vim
" Author:           Jacky Alciné <me@jalcine.me>
" License:          MIT
" Website:          https://jalcine.github.io/cmake.vim
" Version:          0.5.1

" Public Function: cmake#buffer#has_project()
" Checks if the current buffer follows the following criteria:
"   - Checks if it currently exists in the file system.
"   - Checks if this entire session has a CMake project associated with it.
" Returns: '1' if this current buffer relates to a CMake project.
" Returns: '0' if any of the former conditions are unsatisfied.
func! cmake#buffer#has_project()
  let l:current_file = expand('%:p')

  " TODO: Remove this logic.
  if &l:ft != "cpp" && &l:ft != "c" && &l:ft != "cmake"
    return 0
  endif

  if !filereadable(l:current_file)
    return 0
  endif

  return cmake#util#has_project()
endfunc

" Public Function: cmake#buffer_set_options()
" Returns: Nothing.
"
" Populates the buffer's local options with metadata that can be reused by other
" plugins and CMake itself.
func! cmake#buffer#set_options()
  let l:current_file = expand('%:p:t')

  if !cmake#buffer#has_project()
    return 0
  endif

  let b:cmake_target = cmake#targets#for_file(l:current_file)

  if empty(b:cmake_target)
    unlet b:cmake_target
  else
    if !exists('b:cmake_binary_dir')
      let b:cmake_binary_dir = cmake#targets#binary_dir(b:cmake_target)
    endif

    if !exists('b:cmake_source_dir')
      let b:cmake_source_dir = cmake#targets#source_dir(b:cmake_target)
    endif

    if !exists('b:cmake_include_dirs')
      let b:cmake_include_dirs = cmake#targets#include_dirs(b:cmake_target)
    endif

    if !exists('b:cmake_libraries')
      let b:cmake_libraries = cmake#targets#libraries(b:cmake_target)
    endif

    call cmake#extension#flex({ 'target' : b:cmake_target })
  endif
  return 1
endfunc
