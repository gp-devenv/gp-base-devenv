#!/bin/sh

#
# gp-base-devenv
# Copyright (c) 2022-2023, Greg PFISTER. MIT License.
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

VERSION=`cat .version`
DOCKERFILE=`echo "./Dockerfile.ubuntu-"$1`
IMAGE="gpfister/gp-base-devenv:$1"
IMAGE_LATEST="gpfister/gp-base-devenv:$1-latest"
IMAGE_VERSION="gpfister/gp-base-devenv:$1-$VERSION"
IMAGE_VERSION_LATEST="gpfister/gp-base-devenv:$1-$VERSION-latest"

if [ ! -f "$DOCKERFILE" ]; then
    echo "Dockerfile '$DOCKERFILE' not found"
    exit 1
fi

docker buildx build --platform linux/arm64,linux/amd64 -t $IMAGE -f "$DOCKERFILE" .
docker buildx build --platform linux/arm64,linux/amd64 -t $IMAGE_LATEST -f "$DOCKERFILE" .
docker buildx build --platform linux/arm64,linux/amd64 -t $IMAGE_VERSION -f "$DOCKERFILE" .
docker buildx build --platform linux/arm64,linux/amd64 -t $IMAGE_VERSION_LATEST -f "$DOCKERFILE" .
