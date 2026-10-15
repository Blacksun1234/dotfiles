#!/bin/env sh

print_temporary_dependencies()
{
    echo "\033[0;33m$1\033[0m"
}

print_permanent_dependencies()
{
    echo "\033[0;36m$1\033[0m"
}

export_dependencies_nvim()
{
    unset NVIM_TEMPORARY_DEPENDENCIES

    if ! dpkg -s curl >/dev/null 2>&1; then
        NVIM_TEMPORARY_DEPENDENCIES="${NVIM_TEMPORARY_DEPENDENCIES} curl"
    fi

    export NVIM_TEMPORARY_DEPENDENCIES
}
 
export_dependencies_tmux()
{
    unset TMUX_TEMPORARY_DEPENDENCIES
    unset TMUX_PERMANENT_DEPENDENCIES

    if ! dpkg -s bison >/dev/null 2>&1; then
        TMUX_TEMPORARY_DEPENDENCIES="${TMUX_TEMPORARY_DEPENDENCIES} bison"
    fi

    if ! dpkg -s curl >/dev/null 2>&1; then
        TMUX_TEMPORARY_DEPENDENCIES="${TMUX_TEMPORARY_DEPENDENCIES} curl"
    fi

    if ! dpkg -s gcc >/dev/null 2>&1; then
        TMUX_TEMPORARY_DEPENDENCIES="${TMUX_TEMPORARY_DEPENDENCIES} gcc"
    fi

    if ! dpkg -s libevent-dev >/dev/null 2>&1; then
        TMUX_TEMPORARY_DEPENDENCIES="${TMUX_TEMPORARY_DEPENDENCIES} libevent-dev"
    fi

    if ! dpkg -s make >/dev/null 2>&1; then
        TMUX_TEMPORARY_DEPENDENCIES="${TMUX_TEMPORARY_DEPENDENCIES} make"
    fi

    if ! dpkg -s ncurses-dev >/dev/null 2>&1; then
        TMUX_TEMPORARY_DEPENDENCIES="${TMUX_TEMPORARY_DEPENDENCIES} ncurses-dev"
    fi

    if ! dpkg -s pkg-config >/dev/null 2>&1; then
        TMUX_TEMPORARY_DEPENDENCIES="${TMUX_TEMPORARY_DEPENDENCIES} pkg-config"
    fi

    if ! dpkg -s xclip >/dev/null 2>&1; then
        TMUX_PERMANENT_DEPENDENCIES="${_dependencies} xclip"
    fi

    export TMUX_TEMPORARY_DEPENDENCIES
    export TMUX_PERMANENT_DEPENDENCIES
}

export_dependencies_omz()
{
    unset OMZ_TEMPORARY_DEPENDENCIES
    unset OMZ_PERMANENT_DEPENDENCIES

    if ! dpkg -s git >/dev/null 2>&1; then
        OMZ_TEMPORARY_DEPENDENCIES="${OMZ_TEMPORARY_DEPENDENCIES} git"
    fi
    
    if ! dpkg -s curl >/dev/null 2>&1; then
        OMZ_TEMPORARY_DEPENDENCIES="${OMZ_TEMPORARY_DEPENDENCIES} curl"
    fi

    if ! dpkg -s zsh >/dev/null 2>&1; then
        OMZ_PERMANENT_DEPENDENCIES="${OMZ_PERMANENT_DEPENDENCIES} zsh"
    fi

    export OMZ_TEMPORARY_DEPENDENCIES
    export OMZ_PERMANENT_DEPENDENCIES
}

export_dependencies_git()
{
    unset GIT_PERMANENT_DEPENDENCIES

    if ! dpkg -s tig >/dev/null 2>&1; then
        GIT_PERMANENT_DEPENDENCIES="${GIT_PERMANENT_DEPENDENCIES} tig"
    fi

    export GIT_PERMANENT_DEPENDENCIES
}

install_customized_nvim()
{
    export_dependencies_nvim

    if [ -n "${NVIM_TEMPORARY_DEPENDENCIES}" ]; then
        echo "ℹ️ Some packages are missing in your system for installing Neovim: "
        print_temporary_dependencies "    ${NVIM_TEMPORARY_DEPENDENCIES}"
        echo "ℹ️ They will be removed after the install"
    fi

    if [ "${FORCE_ALL_INSTALL}" = "y" ];then
        answer=Y
    else
        read -p "❓ Do you want to install Neovim? [Y/n] " answer
    fi
    answer=${answer:-Y}  # Default to 'Y' if the user just presses Enter

    if [ "${answer}" = 'Y' ] || [ "${answer}" = 'y' ]; then
        echo "📦 Installing Neovim environment in your system..."
        if sudo -E ./system-env.sh --install-nvim > "/tmp/custom-env_nvim.log" 2>&1; then
            echo "✅ Neovim installed!"
            echo "⚙️ Configuring Neovim in your home..."
            if ./user-env.sh --configure-nvim >> "/tmp/custom-env_nvim.log" 2>&1; then
                echo "✅ Neovim configured!"
                echo "⚠️ When open Neovim for the first time, do not forget to run ':PlugInstall'"
            else
                echo "❌ Neovim configuration failed"
                echo "ℹ️ See /tmp/custom-env_nvim.log for more details"
                cat /tmp/custom-env_nvim.log
            fi
        else
            echo "❌ Neovim installation failed!"
            echo "ℹ️ See /tmp/custom-env_nvim.log for more details"
        fi
        echo "🔄 Cleaning up Neovim install dependencies..."
        sudo -E ./system-env.sh --cleanup-nvim >> "/tmp/custom-env_nvim.log" 2>&1
    else
        echo "ℹ️ Skipped Neovim installation."
    fi
}

install_customized_tmux()
{
    export_dependencies_tmux

    if [ -n "${TMUX_TEMPORARY_DEPENDENCIES}" ]; then
        echo "ℹ️ Some packages are missing in your system for installing Tmux "
        print_temporary_dependencies "    ${TMUX_TEMPORARY_DEPENDENCIES}"
        echo "ℹ️ They will be removed after the install"
    fi

    if [ -n "${TMUX_PERMANENT_DEPENDENCIES}" ]; then
        echo "ℹ️ The following packages are required for some Tmux features: "
        print_permanent_dependencies "    ${TMUX_PERMANENT_DEPENDENCIES}"
        echo "⚠️ They will NOT be removed after the install"
    fi

    if [ "${FORCE_ALL_INSTALL}" = "y" ];then
        answer=Y
    else
        read -p "❓ Do you want to install Tmux? [Y/n] " answer
    fi
    answer=${answer:-Y}  # Default to 'Y' if the user just presses Enter

    if [ "${answer}" = 'Y' ] || [ "${answer}" = 'y' ]; then

        echo "📦 Installing Tmux environment in your system..."
        if sudo -E ./system-env.sh --install-tmux > "/tmp/custom-env_tmux.log" 2>&1; then
            echo "✅ Tmux installed!"
            echo "⚙️ Configurinng Tmux in your home.."
            if ./user-env.sh --configure-tmux >> "/tmp/custom-env_tmux.log" 2>&1; then
                echo "✅ Tmux configured!"
            else
                echo "❌ Tmux configuration failed"
                echo "ℹ️ See /tmp/custom-env_tmux.log for more details"
            fi
        else
            echo "❌ Tmux installation failed!"
            echo "ℹ️ See /tmp/custom-env_tmux.log for more details"
        fi
        echo "🔄 Cleaning up Tmux install dependencies..."
        sudo -E ./system-env.sh --cleanup-tmux >> "/tmp/custom-env_tmux.log" 2>&1
    else
        echo "ℹ️ Skipped Tmux installation."
    fi
}

install_customized_omz()
{
    export_dependencies_omz

    if [ -n "${OMZ_TEMPORARY_DEPENDENCIES}" ]; then
        echo "ℹ️ Some packages are missing in your system for installing Oh My Zsh "
        print_temporary_dependencies "    ${OMZ_TEMPORARY_DEPENDENCIES}"
        echo "ℹ️ They will be removed after the install"
    fi

    if [ -n "${OMZ_PERMANENT_DEPENDENCIES}" ]; then
        echo "ℹ️ The following packages are required for some Oh My Zsh features: "
        print_permanent_dependencies "    ${OMZ_PERMANENT_DEPENDENCIES}"
        echo "⚠️ They will NOT be removed after the install"
    fi

    if [ "${FORCE_ALL_INSTALL}" = "y" ];then
        answer=Y
    else
        read -p "❓ Do you want to install Oh My Zsh? [Y/n] " answer
    fi
    answer=${answer:-Y}  # Default to 'Y' if the user just presses Enter

    if [ "${answer}" = 'Y' ] || [ "${answer}" = 'y' ]; then
        echo "📦 Installing Oh My Zsh environment in your system..."
        if sudo -E ./system-env.sh --install-omz > "/tmp/custom-env_omz.log" 2>&1; then
            echo "📦 Installing Oh My Zsh in your home..."
            if ./user-env.sh --install-omz > "/tmp/custom-env_omz.log" 2>&1; then
                echo "✅ Oh My Zsh installed!"
                echo "⚙️ Configuring Oh My Zsh..."
                if ./user-env.sh --configure-omz >> "/tmp/custom-env_omz.log" 2>&1; then
                    echo "✅ Oh My Zsh configured!"
                    echo "ℹ️ Run 'sudo -E chsh -s /bin/zsh "$(id -un)"' for changing the default shell"
                else
                    echo "❌ Oh My Zsh configuration failed"
                    echo "ℹ️ See /tmp/custom-env_omz.log for more details"
                    cat /tmp/custom-env_omz.log
                fi
            else
                echo "❌ Oh My Zsh installation failed!"
                echo "ℹ️ See /tmp/custom-env_omz.log for more details"
                cat /tmp/custom-env_omz.log
            fi
            echo "🔄 Cleaning up Oh My Zsh install dependencies..."
            sudo -E ./system-env.sh --cleanup-omz >> "/tmp/custom-env_omz.log" 2>&1
        else
            echo "❌ Oh My Zsh installation failed!"
            echo "ℹ️ See /tmp/custom-env_omz.log for more details"
            cat /tmp/custom-env_omz.log
        fi
    else
        echo "ℹ️ Skipped <Oh My Zsh installation."
    fi
}

install_customized_git()
{
    export_dependencies_git

    if [ -n "${GIT_TEMPORARY_DEPENDENCIES}" ]; then
        echo "ℹ️ Some packages are missing in your system for installing Git "
        print_temporary_dependencies "    ${GIT_TEMPORARY_DEPENDENCIES}"
        echo "ℹ️ They will be removed after the install"
    fi

    if [ -n "${GIT_PERMANENT_DEPENDENCIES}" ]; then
        echo "ℹ️ The following packages are required for some Git features: "
        print_permanent_dependencies "    ${GIT_PERMANENT_DEPENDENCIES}"
        echo "⚠️ They will NOT be removed after the install"
    fi

    if [ "${FORCE_ALL_INSTALL}" = "y" ];then
        answer=Y
    else
        read -p "❓ Do you want to install Git? [Y/n] " answer
    fi
    answer=${answer:-Y}  # Default to 'Y' if the user just presses Enter

    if [ "${answer}" = 'Y' ] || [ "${answer}" = 'y' ]; then
        echo "📦 Installing Git environment in your system..."
        if sudo -E ./system-env.sh --install-git > "/tmp/custom-env_git.log" 2>&1; then
            echo "✅ Git installed!"
            echo "⚙️ Configurinng Git in your home.."
            if ./user-env.sh --configure-git >> "/tmp/custom-env_git.log" 2>&1; then
                echo "✅ Git configured!"
            else
                echo "❌ Git configuration failed"
                echo "ℹ️ See /tmp/custom-env_git.log for more details"
            fi
        else
            echo "❌ Git installation failed!"
            echo "ℹ️ See /tmp/custom-env_git.log for more details"
        fi
        echo "🔄 Cleaning up Git install dependencies..."
        sudo -E ./system-env.sh --cleanup-git >> "/tmp/custom-env_git.log" 2>&1
    else
        echo "ℹ️ Skipped Git installation."
    fi
}

cleanup_system()
{
    echo "🔄 Cleaning up system..."
    sudo -E ./system-env.sh --cleanup-system > "/tmp/custom-env_cleanup.log" 2>&1
}

####################
####### MAIN #######
####################
if [ "$1" = "-y" ]; then
    FORCE_ALL_INSTALL=y
fi

install_customized_nvim
install_customized_tmux
install_customized_omz
install_customized_git
cleanup_system

echo "ℹ️ See more details:"
ls -lh /tmp/custom-env_*.log
