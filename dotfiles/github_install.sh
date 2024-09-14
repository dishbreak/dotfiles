#!/bin/bash

# handy utility to download an artifact off the latest release
function latest_github_release() {
	GITHUB_REPO_SLUG=$1
	ARTIFACT_NAME=$2
	VERSION=${3:-latest}
	JQ_QUERY=".assets[] | select(.name==\"$ARTIFACT_NAME\") | .browser_download_url"
	GITHUB_API_ENDPOINT="https://api.github.com/repos/${GITHUB_REPO_SLUG}/releases/${VERSION}"
	curl -s "${GITHUB_API_ENDPOINT}" | jq -r "$JQ_QUERY"
}

# download and install the latest pkg from github
function download_and_install_pkg_from_github() {
	GITHUB_REPO_SLUG=$1
	ARTIFACT_NAME=$2
	VERSION=${3:-latest}
	
	DOWNLOAD_URL="$(latest_github_release "$GITHUB_REPO_SLUG" "$ARTIFACT_NAME" "$VERSION")"
	echo downloading "$DOWNLOAD_URL" to "$ARTIFACT_NAME"
	curl -LsSf "$(latest_github_release "$GITHUB_REPO_SLUG" "$ARTIFACT_NAME" "$VERSION")" -o "$ARTIFACT_NAME"
	sudo installer -pkg "./$ARTIFACT_NAME" -target /
	rm -f "$ARTIFACT_NAME"
}
