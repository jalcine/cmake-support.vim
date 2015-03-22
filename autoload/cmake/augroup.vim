" File:             autoload/cmake/augroup.vim
" Description:      Handles the auto loading functionality of CMake.
" Author:           Jacky Alciné <me@jalcine.me>
" License:          MIT
" Website:          https://jalcine.github.io/cmake.vim
" Version:          0.5.1

" Private Function: s:add_specific_buffer_commands
"
" Populates a buffer's aucommands for CMake capability.
function s:add_specific_buffer_commands()
  call cmake#commands#apply_buffer_commands()
  augroup cmake.vim
    au! BufEnter <buffer>
    au! BufWrite <buffer>
    au BufEnter <buffer> call cmake#augroup#on_buf_enter()
    au BufWrite <buffer> call cmake#augroup#on_buf_write()
  augroup END
endfunction

" Public Function: cmake#augroup#init()
"
" Update the CMake augroup.
function! cmake#augroup#init()
  augroup cmake.vim
    au!
    au VimEnter      *          call cmake#augroup#on_vim_enter()
    au FileReadPost  *          call cmake#augroup#on_file_read(fnamemodify("<afile>",":p"))
    au FileType      cpp,cmake  call cmake#augroup#on_file_type("<amatch>")
  augroup END
endfunction

" Public Function: cmake#augroup#on_vim_enter()
"
" Handles actions necessary for setting up Vim for cmake.vim support.
" NOTE: For now, this just caches the entire project's target information.
function! cmake#augroup#on_vim_enter()
  " NOTE: This function should handle the initial loading of cmake.vim's
  " necessary data in order for it to operate properly. This includes the
  " following:
  "   * checking if $PWD is a CMake project directory.
  "     - If there isn't any, bail out at this point.
  "   * priming the cache `g:cmake_cache`for future use.
  "   * adding global commands that would useful in creating a new CMake
  "     project.
  call cmake#targets#cache()
endfunction

" Public Function: cmake#augroup#on_buf_enter()
"
" Handles actions necessary for entering a buffer with CMake support.
" This currently does the following:
"   - Adds options for the buffer, like `b:cmake_target`.
"   - Updates the `&path` variable for the current buffer.
"   - Updates the `&makeprg` variable for the current buffer.
function! cmake#augroup#on_buf_enter()
  call cmake#util#echo_msg('Applying generic buffer options for this buffer...')
  call cmake#buffer#set_options()

  call cmake#util#echo_msg('Applying values for "&l:path"...')
  call cmake#path#refresh()

  call cmake#util#echo_msg('Applying values for "&l:makeprg"...')
  call cmake#makeprg#set_for_buffer()
endfunction

" Public Function: cmake#augroup#on_file_type(filetype)
" Argument: [filetype] The file type to work with.
"
" Handles the work necessary for the provided filetype.
" This currently does the following:
"   - Updates meta-data for the current buffer (`cmake#buffer#set_options()`)
"   - Updates `&makeprg`, `&path`, `&tags` options for the buffer.
"   - Updates `&flags` for the buffer's target.
"   - Adds buffer-specific aucommands to help with updating its meta-data.
" Bails out early if `b:cmake_target` isn't set.
function! cmake#augroup#on_file_type(filetype)
  call cmake#util#echo_msg('Applying generic buffer options for this buffer...')
  call cmake#buffer#set_options()

  if !exists('b:cmake_target')
    call cmake#util#echo_msg('No target found for this buffer.')
    return
  endif

  call cmake#util#echo_msg('Applying values for "&l:makeprg"...')
  call cmake#makeprg#set_for_buffer()

  call cmake#util#echo_msg('Applying values for "&path"...')
  call cmake#path#refresh()

  call cmake#util#echo_msg('Applying values for "&tags" (will generate if not existing)...')
  call cmake#ctags#refresh()

  call cmake#util#echo_msg('Applying values for "&flags"....')
  call cmake#flags#inject()

  call s:add_specific_buffer_commands()
  doau BufEnter <abuf>
endfunction

" Public Function: cmake#augroup#on_buf_write()
" Arguments: None
"
" Handles the work necessary after the buffer's written.
" This currently does the following:
"   - Regenerates tags from the buffer's target files.
function! cmake#augroup#on_buf_write()
  call cmake#util#echo_msg('Applying values for "&tags" (will generate if not existing)...')
  call cmake#ctags#refresh()
endfunction
