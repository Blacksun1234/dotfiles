#!/bin/env sh

# User environment
export usermail=${USERMAIL:-'youcef.merah@outlook.com'}
export username=$(id -un)
export skeleton=${HOME}

######################
####### NEOVIM #######
######################
configure_nvim()
{
    curl -fLo ${skeleton}/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    install -m 755 -d ${skeleton}/.config/nvim/
    {
        echo "call plug#begin()"
        echo "    Plug 'folke/tokyonight.nvim'"
        echo "    Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }"
        echo "    Plug 'ntpeters/vim-better-whitespace'"
        echo "    Plug 'nvim-lua/plenary.nvim'"
        echo "    Plug 'nvim-pack/nvim-spectre'"
        echo "    Plug 'neoclide/coc.nvim', {'branch': 'release'}"
        echo "    Plug 'm4xshen/autoclose.nvim'"
        echo "    Plug 'itchyny/lightline.vim'"
        echo "    Plug 'deoplete-plugins/deoplete-clang'"
        echo "    Plug 'rhysd/vim-clang-format'"
        echo "call plug#end()"
        echo ""
        echo "colorscheme tokyonight"
        echo ""
        echo "nnoremap <C-b> :NERDTreeToggle<CR>:wincmd=<CR>"
        echo "let NERDTreeShowHidden=1"
        echo ""
        echo "nnoremap <C-f> :Spectre<CR>:wincmd=<CR>"
        echo "nnoremap <C-w> :q<CR>"
        echo "nnoremap <C-t> :vs<CR>"
        echo "nnoremap <C-y> :sp<CR>"
        echo "nnoremap <C-n> :tabnew<CR>"
        echo "nnoremap <PageUp> :tabnext<CR>"
        echo "nnoremap <PageDown> :tabprevious<CR>"
        echo "nnoremap <C-Right> :wincmd l<CR>"
        echo "nnoremap <C-Left> :wincmd h<CR>"
        echo "nnoremap <C-Up> :wincmd k<CR>"
        echo "nnoremap <C-Down> :wincmd j<CR>"
        echo "set autoindent"
        echo "set shiftwidth=4"
        echo "set expandtab"
     } > "${skeleton}/.config/nvim/init.vim"
}

####################
####### TMUX #######
####################
configure_tmux()
{
    {
        echo "# c.f. https://gist.github.com/MohamedAlaa/2961058"
        echo "# Reassign prefix key"
        echo "unbind C-b"
        echo "set -g prefix C-a"
        echo "# New panes on same directory"
        echo "bind c new-window -c "#{pane_current_path}""
        echo "# Split panes using | and -"
        echo "bind | split-window -h -c "#{pane_current_path}""
        echo "bind - split-window -v -c "#{pane_current_path}""
        echo "unbind '\"'"
        echo "unbind '%'"
        echo "# Enable mouse mode"
        echo "set -g mouse on"
        echo "# Set Terminal colors to preserve colorscheme"
        echo "set -g default-terminal 'tmux-256color'"
        echo "set -ga terminal-overrides ',*256col*:Tc'"
        echo "set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'"
        echo "set-environment -g COLORTERM 'truecolor'"
        echo "# Enable VI mode"
        echo "setw -g mode-keys vi"
        echo "# Configure Tmux to allow copy-paste between the system and Tmux clipboard"
        echo "bind C-c run 'tmux save-buffer - | xclip -i -sel clipboard'"
        echo "bind C-v run 'tmux set-buffer \$(xclip -o -sel clipboard); tmux paste-buffer'"
        echo "# Add new session"
        echo "unbind C-n"
        echo "bind C-n new-session"
        echo "# Got to next window"
        echo "unbind Pagedown"
        echo "bind Pagedown next-window"
        echo "# Got to previous window"
        echo "unbind Pageup"
        echo "bind Pageup previous-window"
        echo "# Install Plugins"
      }  > "${skeleton}/.tmux.conf"
}

##################
####### OMZ ######
##################
install_omz()
{
    if [ ! -d "${skeleton}/.oh-my-zsh" ]; then
        sh -c "ZSH=${skeleton}/.oh-my-zsh $(curl  -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        git clone https://github.com/moarram/headline.git ${skeleton}/.oh-my-zsh/custom/themes/headline 2> /dev/null
        ln -s ${skeleton}/.oh-my-zsh/custom/themes/headline/headline.zsh-theme ${skeleton}/.oh-my-zsh/custom/themes/headline.zsh-theme
    fi
}

configure_omz()
{
    {
        echo "# If you come from bash you might have to change your \$PATH."
        echo "export PATH=\$HOME/bin:/usr/local/bin:\$PATH"
        echo "# Path to your oh-my-zsh installation."
        echo "export ZSH=\"\$HOME/.oh-my-zsh\""
        echo "ZSH_THEME='headline'"
        echo ""
        echo "plugins=(git lighthouse)"
        echo ""
        echo "source \$ZSH/oh-my-zsh.sh"
        echo "source /usr/local/share/glyphs/i_all.sh"
        echo ""
        echo "#HEADLINE_DO_CLOCK=true"
        echo "#TMOUT=1; TRAPALRM () { zle reset-prompt }"
        echo "#HEADLINE_CLOCK_FORMAT=%l:%M:%S %p"
        echo "HEADLINE_INFO_MODE=precmd"
        echo "HEADLINE_DO_ERR=true"
        echo "HEADLINE_DO_ERR_INFO=true"
        echo "HEADLINE_USER_TO_HOST=' at '"
        echo "HEADLINE_HOST_TO_PATH=' in '"
        echo "HEADLINE_PATH_TO_BRANCH=' on '"
        echo "HEADLINE_PAD_TO_BRANCH=' on '"
        echo "HEADLINE_STATUS_TO_STATUS='|'"
        echo "HEADLINE_LINE_MODE=off"
        echo "HEADLINE_DO_GIT_STATUS_COUNTS=true"
        echo "HEADLINE_DO_GIT_STATUS_OMIT_ONE=false"
        echo "HEADLINE_TRUNC_PREFIX=…"
        echo "HEADLINE_STYLE_USER=$'\x1b[38;5;114m'"
        echo "HEADLINE_STYLE_HOST=$'\x1b[38;5;216m'"
        echo "HEADLINE_STYLE_PATH=$'\x1b[38;5;111m'"
        echo "HEADLINE_STYLE_BRANCH=$'\x1b[38;5;141m'"
        echo "HEADLINE_STYLE_STATUS=$'\x1b[38;5;204m'"
        echo "HEADLINE_USER_PREFIX=''"
        echo "HEADLINE_HOST_PREFIX='🌐 '"
        echo "HEADLINE_PATH_PREFIX='📁 '"
        echo "HEADLINE_BRANCH_PREFIX='🔀 '"
        echo "HEADLINE_GIT_UNTRACKED='🔍'"
        echo "HEADLINE_GIT_CHANGED='🔴'"
        echo "HEADLINE_GIT_STASHED='📝'"
        echo "HEADLINE_GIT_CONFLICTS='❌'"
        echo "HEADLINE_GIT_CLEAN='🟢'"
        echo "#HEADLINE_USER_CMD=''"
     } > ${skeleton}/.zshrc
}

configure_git()
{
    # Configure git
    {
        echo "[user]"
        echo "	email = ${usermail}"
        echo "	name = Youcef Merah"
        echo "[core]"
        echo "	editor = vim"
        echo "[alias]"
        echo "	gl = config --global -l"
        echo "	p = push"
        echo "    pf = push --force"
        echo "	st = status"
        echo "	stb = status -sb"
        echo "	lo = log --oneline"
        echo "	loga = log --oneline --graph --all"
        echo "	last = log -1 HEAD --stat"
        echo "	cm = commit -m"
        echo "	ca = commit --amend"
        echo "	can = commit --amend --no-edit"
        echo "	rv = remote -v"
        echo "	d = diff"
        echo "	co = checkout"
        echo "	cob = checkout -b"
        echo "	br = branch -r"
        echo "	bvv = branch -vv"
        #echo "	clf = clang-format"
        echo "[init]"
        echo "	defaultBranch = main"
        #echo "[clangFormat]"
        echo "    style = file:${skeleton}/.clang-format"
    } > ${skeleton}/.gitconfig
    # Configure tig
    {
        echo "color default                       253         233"
        echo "color cursor                        default     237"
        echo "color status                        250         235"
        echo "color title-focus                   default     238"
        echo "color title-blur                    default     238"
        echo "color delimiter                     241         default"
        echo "color header                        186         236             bold"
        echo "color section                       186         default"
        echo "color line-number                   102         235"
        echo "color id                            208         default"
        echo "color date                          233         default"
        echo "color author                        233         default"
        echo "color mode                          166         default"
        echo "color overflow                      241         default"
        echo "color directory                     69          default"
        echo "color file                          default     default"
        echo "color file-size                     default     default"
        echo "color grep.file                     166         234"
        echo ""
        echo "# Main view colors"
        echo "color graph-commit                  69          default"
        echo "color main-head                     121         default         bold"
        echo "color main-remote                   161         default"
        echo "color main-tracked                  222         default"
        echo "color main-tag                      227         default"
        echo "color main-local-tag                203         default"
        echo "color main-ref                      183         default"
        echo ""
        echo "# Palette colors"
        echo "color palette-0                     239         default"
        echo "color palette-1                     242         default"
        echo "color palette-2                     245         default"
        echo "color palette-3                     248         default"
        echo "color palette-4                     237         default"
        echo "color palette-5                     240         default"
        echo "color palette-6                     243         default"
        echo "color palette-7                     246         default"
        echo "color palette-8                     249         default"
        echo "color palette-9                     238         default"
        echo "color palette-10                    241         default"
        echo "color palette-11                    244         default"
        echo "color palette-12                    247         default"
        echo "color palette-13                    236         default"
        echo ""
        echo "# Status view colors"
        echo "color status.header                 186         236             bold"
        echo "color status.section                186         default"
        echo "color stat-staged                   green       default"
        echo "color stat-unstaged                 red         default"
        echo "color stat-untracked                red         default"
        echo ""
        echo "# Help view colors"
        echo "color help.header                   186         236             bold"
        echo "color help.section                  186         default"
        echo "color help-group                    69          default"
        echo "color help-action                   166         default"
        echo ""
        echo "# Diff view colors"
        echo "color "commit "                     208         234"
        echo "color "Refs: "                      197         234"
        echo "color "Author: "                    135         default"
        echo "color "AuthorDate: "                67          default"
        echo "color "Commit: "                    141         default"
        echo "color "CommitDate: "                67          default"
        echo "color "Merge: "                     161         default"
        echo "color "---"                         67          default"
        echo "color diff-index                    67          default"
        echo "color diff-stat                     166         234"
        echo "color diff-add-highlight            10          22"
        echo "color diff-del-highlight            9           52"
        echo ""
        echo "# Signature colors"
        echo "color "gpg: "                       23          default"
        echo "color "Primary key fingerprint: "   23          default"
     } > "${skeleton}"/.tigrc
}

####################
####### MAIN #######
####################
case "$1" in
    --configure-nvim)
        configure_nvim
        ;;
    --configure-tmux)
        configure_tmux
        ;;
    --install-omz)
        install_omz
        ;;
    --configure-omz)
        configure_omz
        ;;
    --configure-git)
        configure_git
        ;;
    *)
        echo "[user-env] Invalid option: $1" >&2
        exit 1
        ;;
esac
