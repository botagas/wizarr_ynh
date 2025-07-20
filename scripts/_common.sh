#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

py_version=3.13.1
py_vshort="${py_version%.*}"

#################################################
# Function to install a specific Python version #
#################################################

install_python() {
    local python_version=$1

    if [[ -z "$python_version" ]]; then
        echo "Usage: install_python <version>"
        return 1
    fi

    echo "Installing Python $python_version..."

    # Download and extract Python source
    local python_src="Python-$python_version"
    local python_tar="$python_src.tgz"
    local python_url="https://www.python.org/ftp/python/$python_version/$python_tar"

    wget "$python_url" -O "/tmp/$python_tar" 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Failed to download Python $python_version. Check the version number."
        return 1
    fi

    cd /tmp || return 1
    tar -xvf "$python_tar"
    cd "$python_src" || return 1

    # Compile and install Python
    ./configure --enable-optimizations --enable-shared 2>&1 
    if [[ $? -ne 0 ]]; then
        echo "Configuration failed."
        return 1
    fi

    make -j$(nproc) 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Build failed."
        return 1
    fi

    make altinstall 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Installation failed."
        return 1
    fi

    # Update library path for shared libraries
    echo "/usr/local/lib" > /etc/ld.so.conf.d/python3.13.conf
    ldconfig

    # Verify installation
    if command -v "python${python_version%.*}" &>/dev/null; then
        echo "Python $python_version installed successfully."
    else
        echo "Python $python_version installation failed."
        return 1
    fi

    # Clean up
    cd ..
    ynh_safe_rm "/tmp/$python_src" 
    ynh_safe_rm "/tmp/$python_tar"
}

###################################################
# Function to uninstall a specific Python version #
###################################################

uninstall_python() {
    local python_version=$1
    local py_vshort="${python_version%.*}" 

    if [[ -z "$python_version" ]]; then
        echo "Usage: uninstall_python <version>"
        return 1
    fi

    echo "Uninstalling Python $python_version..."

    # Remove binaries (make altinstall creates python3.13, not python3.13.1)
    ynh_safe_rm "/usr/local/bin/python${py_vshort}"

    # Remove libraries
    ynh_safe_rm "/usr/local/lib/python${py_vshort}"
     
    # Remove library config
    ynh_safe_rm "/etc/ld.so.conf.d/python3.13.conf"
    ldconfig

    # Verify uninstallation
    if command -v "python${py_vshort}" &>/dev/null; then
        echo "Python $python_version was not completely removed."
        return 1
    else
        echo "Python $python_version uninstalled successfully."
    fi
}

############################################
# Check if Python $py_version is installed #
############################################

check_python() {
if command -v python$py_vshort &>/dev/null; then
    # Verify the version
    installed_version=$(python$py_vshort --version 2>/dev/null)
    if [[ $installed_version == "Python $py_version" ]]; then
        echo "Python $py_version is already installed."
    else
        echo "Python $py_vshort is installed but not version $py_version."
        install_python $py_version
    fi
else
    echo "Python $py_version is not installed."
    install_python $py_version
fi
}

############################################
# Install UV via pipx
############################################

install_uv() {
    if ! command -v uv &>/dev/null; then
        PIPX_HOME="/opt/pipx" PIPX_BIN_DIR="/usr/local/bin" pipx install uv --force 2>&1
        PIPX_HOME="/opt/pipx" PIPX_BIN_DIR="/usr/local/bin" pipx upgrade uv --force 2>&1
    fi
}

############################################
# Uninstall UV
############################################

uninstall_uv() {
    if command -v uv &>/dev/null; then
        PIPX_HOME="/opt/pipx" PIPX_BIN_DIR="/usr/local/bin" pipx uninstall uv 2>/dev/null || true
    fi
}