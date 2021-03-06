#
# Kubler phase 1 config, pick installed packages and/or customize the build
#

#
# This hook can be used to configure the build container itself, install packages, run any command, etc
#
configure_bob() {
    # current bash version prevents emerge installs on musl, disable the failing checks until we reverted to prev. bash
    cp /usr/lib/portage/python3.5/misc-functions.sh ~/
    sed -i 's/^install_qa_check() {/install_qa_check() { return 0/g' /usr/lib/portage/python3.5/misc-functions.sh
    sed -i 's/^postinst_qa_check() {/postinst_qa_check() { return 0/g' /usr/lib/portage/python3.5/misc-functions.sh

    fix_portage_profile_symlink
    # migrate from files to directories at /etc/portage/package.*
    for i in /etc/portage/package.{accept_keywords,unmask,mask,use}; do
        [[ -f "${i}" ]] && { cat "${i}"; mv "${i}" "${i}".old; }
        mkdir -p "${i}"
        [[ -f "${i}".old ]] &&  mv "${i}".old "${i}"/default
    done

    # back to 4.3 until 4.4_p12-r2 has landed
    mask_package '=app-shells/bash-4.4_p12'
    emerge bash
    # misc-functions.sh should work again now..
    mv ~/misc-functions.sh /usr/lib/portage/python3.5/

    # install basics used by helper functions
    emerge app-portage/flaggie app-portage/eix app-portage/gentoolkit
    configure_eix

    touch /etc/portage/package.accept_keywords/flaggie
    echo 'LANG="en_US.UTF-8"' > /etc/env.d/02locale
    env-update
    source /etc/profile
    # install default packages
    # when using overlay1 docker storage the created hard link will trigger an error during openssh uninstall
    [[ -f /usr/"${_LIB}"/misc/ssh-keysign ]] && rm /usr/"${_LIB}"/misc/ssh-keysign
    emerge -C net-misc/openssh
    update_use 'dev-libs/openssl' -bindist
    update_use 'dev-vcs/git' '-perl'
    update_use 'app-crypt/pinentry' '+ncurses'
    update_keywords 'app-portage/layman' '+~amd64'
    update_keywords 'dev-python/ssl-fetch' '+~amd64'
    emerge dev-vcs/git app-portage/layman app-misc/jq
    install_git_postsync_hooks
    configure_layman
    add_layman_overlay musl
    add_overlay kubler https://github.com/edannenberg/kubler-overlay.git
    # go binary bootstrap fails on musl so we need to bootstrap from source
    update_use 'dev-lang/go' +srcgo
    # install aci/oci requirements
    emerge dev-lang/go
    install_oci_deps
}
