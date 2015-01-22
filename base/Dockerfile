# Docker container for Centos 6.3

# See https://github.com/ceejatec/naked-docker/ for details about the
# construction of the base image.

FROM ceejatec/naked-centos:6.3
MAINTAINER chillery@lambda.nu

USER root
RUN yum install -y openssh-server openssh-clients sudo && yum clean packages

# Set up for SSH daemon
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/wheel_group && \
    echo 'Defaults:%wheel !requiretty' >> /etc/sudoers.d/wheel_group && \
    chmod 440 /etc/sudoers.d/wheel_group && \
    /etc/init.d/sshd start

# JDK.
RUN yum -y install java-1.7.0-openjdk && yum clean packages

# Create "joe" user with password-less sudo privs.
RUN groupadd -g1000 joe && \
    useradd joe -g joe -u1000 -G wheel -m -s /bin/bash && \
    echo 'joe:joe' | chpasswd
USER joe
RUN ssh-keygen -q -t rsa -P "" < /dev/zero && \
    cat /home/joe/.ssh/id_rsa.pub >> /home/joe/.ssh/authorized_keys && \
    chmod 700 /home/joe/.ssh/authorized_keys && \
    ( echo -n 'localhost '; cat /etc/ssh/ssh_host_rsa_key.pub ) > /home/joe/.ssh/known_hosts && \
    ( echo -n '127.0.0.1 '; cat /etc/ssh/ssh_host_rsa_key.pub ) >> /home/joe/.ssh/known_hosts && \
    mkdir /home/joe/shared

# Expose and start SSH daemon
USER root
EXPOSE 22
CMD [ "/usr/sbin/sshd", "-D" ]
