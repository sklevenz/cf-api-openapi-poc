#!/usr/bin/env bash

# Suppress Node.js warnings
export NODE_NO_WARNINGS=1

# Function to handle errors
handle_error() {
  echo "$1"
  exit 1
}

# Function to clean Node.js and Yarn environment
clean_environment() {
  echo "Cleaning up global Node.js and Yarn environment..."

  # Remove global npm and yarn caches, configurations, and global packages
  rm -rf ~/.npm ~/.yarn ~/.config/yarn ~/.nvm /usr/local/lib/node_modules || handle_error "Failed to clean caches and global packages"

  echo "Node.js and Yarn environment has been cleaned."
}

# Check for '--clean' flag to clean and reinstall Node.js and Yarn
if [[ "$1" == "--clean" ]]; then
  clean_environment
else
  echo "Skipping environment clean and reinstall. Proceeding with package update..."
fi

# Update Yarn to the latest stable version
echo "Updating Yarn to the latest stable version..."
corepack enable
yarn set version stable || handle_error "Failed to update Yarn"
yarn install


# Define the packages to install or update
packages=(
  "@stoplight/spectral-cli"
  "@apidevtools/swagger-cli"
  "@redocly/cli"
)

# Loop through the packages and install or update them
for package in "${packages[@]}"; do
  echo "Installing or updating $package..."
  yarn add "$package" || handle_error "Failed to install/update $package: $package"
done

echo "All packages have been successfully updated!"