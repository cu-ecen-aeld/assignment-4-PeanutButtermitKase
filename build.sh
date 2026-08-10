#!/bin/bash
# Script to build buildroot configuration
# Author: Siddhant Jajoo


source shared.sh

# Fix obsolete GitHub DSA host key added by legacy CI environment
if [ "$(id -u)" -eq 0 ]; then
    mkdir -p /root/.ssh

    cat > /root/.ssh/known_hosts <<'EOF'
github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
EOF


if [ ! -e buildroot/.config ]
then
    echo "MISSING BUILDROOT CONFIGURATION FILE"

    if [ -e ${AESD_MODIFIED_DEFCONFIG} ]
    then
        echo "USING ${AESD_MODIFIED_DEFCONFIG}"
        make -C buildroot defconfig \
            BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} \
            BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}
    else
        echo "Run ./save_config.sh to save this as the default configuration in ${AESD_MODIFIED_DEFCONFIG}"
        echo "Then add packages as needed to complete the installation, re-running ./save_config.sh as needed"
        make -C buildroot defconfig \
            BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} \
            BR2_DEFCONFIG=${AESD_DEFAULT_DEFCONFIG}
    fi
else
    echo "USING EXISTING BUILDROOT CONFIG"
    echo "To force update, delete .config or make changes using make menuconfig and build again."

    echo "USING EXISTING BUILDROOT CONFIG"
    echo "To force update, delete .config or make changes using make menuconfig and build again."

    echo "===== SSH DEBUG BEFORE BUILDROOT ====="
    echo "User: $(id)"
    echo "HOME=$HOME"

    echo "--- /root/.ssh/known_hosts ---"
    nl -ba /root/.ssh/known_hosts || true

    echo "--- \$HOME/.ssh/known_hosts ---"
    nl -ba "$HOME/.ssh/known_hosts" || true

    echo "--- SSH configuration for github.com ---"
    ssh -G github.com 2>/dev/null | grep -Ei \
    'userknownhostsfile|globalknownhostsfile|hostname|identityfile' || true

    echo "======================================"

	
	make -C buildroot BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT}
fi