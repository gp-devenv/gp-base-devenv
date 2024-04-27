#!/bin/sh

#
# gp-base-devenv
# Copyright (c) 2023-2024, Greg PFISTER. MIT License.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

set -e

if [ ! -f ~/.cache/.setup-1.8.0 ]; then
    echo "Setup tmux..."
    tmux -c 'tmux source ~/.tmux.conf'
    tmux -c '~/.tmux/plugins/tpm/bin/install_plugins'

    echo "\nSetup vim..."
    vim --not-a-term +'PlugInstall --sync' +qall 

    if [ ! -d ~/.cache ]; then mkdir ~/.cache; fi
    touch ~/.cache/.setup-1.8.0
fi
