"
" gp-base-devenv
" Copyright (c) 2023-2026, Greg PFISTER. MIT License.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
"

" https://blog.envylabs.com/osx-vim-setup-for-a-designer-front-end-dev-566aa0690e84

" Vim Plug
call plug#begin('~/.vim/plugged')

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" CtrlP
Plug 'ctrlpvim/ctrlp.vim', { 'on': 'CtrlP' }

" Color Schemes
Plug 'flazz/vim-colorschemes'

" NERD Commenter
Plug 'scrooloose/nerdcommenter'
" vim-ripgrep
Plug 'jremmen/vim-ripgrep'
" Surround
Plug 'tpope/vim-surround'

" Syntastic
Plug 'vim-syntastic/syntastic'

call plug#end()

" Initialize plugin system
call plug#end()
