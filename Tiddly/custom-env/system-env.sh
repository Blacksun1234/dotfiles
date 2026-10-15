#!/bin/env sh

export DEBIAN_FRONTEND=noninteractive
export nvim_version=${NVIM_VERSION:-'v0.11.1'}
export tmux_version=${TMUX_VERSION:-'3.5a'}

######################
####### NEOVIM #######
######################
install_nvim()
{
    # Install dependencies
    apt-get update
    apt-get install -y \
        ${NVIM_TEMPORARY_DEPENDENCIES}
    # Install nvim
    curl -L https://github.com/neovim/neovim/releases/download/"${nvim_version}"/nvim-linux-x86_64.tar.gz \
        --output /tmp/"nvim_${nvim_version}.tgz"
    install -m 755 -d /opt/nvim/"${nvim_version}"
    tar -C /opt/nvim/"${nvim_version}" --strip-component=1 -xzf /tmp/"nvim_${nvim_version}.tgz"
    ln -fs /opt/nvim/"${nvim_version}"/bin/nvim /usr/local/bin/nvim
    ln -fs /opt/nvim/"${nvim_version}"/bin/nvim /usr/local/bin/vim
    ln -fs /opt/nvim/"${nvim_version}"/bin/nvim /usr/local/bin/vi
}

cleanup_nvim()
{
    rm -f /tmp/"nvim_${nvim_version}.tgz"
    apt-get remove -y \
        ${NVIM_TEMPORARY_DEPENDENCIES}
}

####################
####### TMUX #######
####################
install_tmux()
{
    # Install dependencies
    apt-get update
    apt-get install -y \
        ${TMUX_TEMPORARY_DEPENDENCIES} \
        ${TMUX_PERMANENT_DEPENDENCIES}
    # Install Tmux
    curl -L http://deb.debian.org/debian/pool/main/t/tmux/tmux_${tmux_version}.orig.tar.gz \
        --output /tmp/"tmux_${tmux_version}.tgz"
    install -m 755 -d /opt/tmux/"${tmux_version}" # the location of tmux
    install -m 755 -d /usr/local/share/man/man1 # the location of symlink manual
    tar -zxf /tmp/"tmux_${tmux_version}.tgz" -C /tmp
    cd /tmp/tmux-${tmux_version} && ./configure --prefix=/opt/tmux/"${tmux_version}"
    cd /tmp/tmux-${tmux_version} make && make install
    ln -fs /opt/tmux/"${tmux_version}"/bin/tmux /usr/local/bin/tmux
    ln -fs /opt/tmux/"${tmux_version}"/share/man/man1/tmux.1 /usr/local/share/man/man1/tmux.1
}

cleanup_tmux()
{
    rm -f /tmp/"tmux_${tmux_version}.tgz"
    rm -rf /tmp/"tmux-${tmux_version}" # untared folder
    apt-get remove -y \
        ${TMUX_TEMPORARY_DEPENDENCIES}
}

###################
####### OMZ #######
###################
install_omz()
{
    # Install dependencies
    apt-get update
    apt-get install -y \
        ${OMZ_TEMPORARY_DEPENDENCIES} \
        ${OMZ_PERMANENT_DEPENDENCIES}
}

cleanup_omz()
{
    apt-get remove -y \
        ${OMZ_TEMPORARY_DEPENDENCIES}
}

###################
####### GIT #######
###################
install_git()
{
    # Install dependencies
    apt-get update
    apt-get install -y \
        ${GIT_PERMANENT_DEPENDENCIES}
    # Install git
    apt-get install -y git
}

cleanup_git()
{
    apt-get remove -y \
        ${GIT_TEMPORARY_DEPENDENCIES}
}

#######################
####### CLEANUP #######
#######################
cleanup_system()
{
    apt autoremove -y
    apt-get clean
    rm -rf /var/lib/apt/lists/*    
}

####################
####### MAIN #######
####################
case "$1" in
    --install-nvim)
        install_nvim
        ;;
    --install-tmux)
        install_tmux
        ;;
    --install-omz)
        install_omz
        ;;
    --install-git)
        install_git
        ;;
    --cleanup-nvim)
        cleanup_nvim
        ;;
    --cleanup-tmux)
        cleanup_tmux
        ;;
    --cleanup-omz)
        cleanup_omz
        ;;
    --cleanup-git)
        cleanup_git
        ;;
    --cleanup-system)
        cleanup_system
        ;;
    *)
        echo "[system-env] Invalid option: $1" >&2
        ;;
esac
