FROM rockylinux:8

ENV container=docker

# Add HashiCorp repo for Terraform
RUN dnf -y install dnf-plugins-core && \
    dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# Install all required packages for RHCE + Terraform + Networking + Services + e2fsprogs
RUN dnf -y install epel-release && \
    dnf -y install \
        ansible \
        openssh-clients \
        openssh-server \
        sudo \
        iproute \
        net-tools \
        curl \
        wget \
        vim \
        git \
        unzip \
        python3 \
        python3-pip \
        python3-netaddr \
        httpd \
        mariadb-server \
        php \
        php-mysqlnd \
        nfs-utils \
        samba \
        samba-client \
        samba-common \
        chrony \
        firewalld \
        bind \
        bind-utils \
        lvm2 \
        util-linux \
        procps-ng \
        rsync \
        tar \
        man \
        which \
        acl \
        sshpass \
        policycoreutils \
        policycoreutils-python-utils \
        setools-console \
        strace \
        tcpdump \
        tmux \
        screen \
        terraform \
        e2fsprogs && \
    dnf clean all

# Create user 'matthew' with sudo access
RUN useradd -m -s /bin/bash matthew && \
    echo 'matthew ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/matthew && \
    echo 'matthew:matthew' | chpasswd && \
    chmod 0440 /etc/sudoers.d/matthew

# Configure SSH server for password login and root access
RUN mkdir -p /var/run/sshd && \
    ssh-keygen -A && \
    sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo 'root:root' | chpasswd

# Prepare SSH directories
RUN mkdir -p /root/.ssh /home/matthew/.ssh && \
    chown -R matthew:matthew /home/matthew/.ssh && \
    chmod 700 /home/matthew/.ssh

# Copy full setup script
COPY setup_all.sh /root/setup_all.sh
COPY setup_all.sh /home/matthew/setup_all.sh

RUN chmod +x /root/setup_all.sh && \
    chmod +x /home/matthew/setup_all.sh && \
    chown root:root /root/setup_all.sh && \
    chown matthew:matthew /home/matthew/setup_all.sh

# Expose SSH port
EXPOSE 22

# Start container with full setup
CMD ["/bin/bash", "/home/matthew/setup_all.sh"]

