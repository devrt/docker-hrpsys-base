# hrpsys base image
# - install hrpsys-base
# - configure supervisord to run ssh server

FROM devrt/base

MAINTAINER Yosuke Matsusaka "yosuke.matsusaka@gmail.com"

RUN apt-get -y update
RUN apt-get install -y openssh-server

RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN echo 'root:devrt' | chpasswd

ADD . /chef
RUN cd /chef && /opt/chef/embedded/bin/berks vendor /chef/cookbooks
RUN chef-solo -c /chef/solo.rb -j /chef/solo.json

ADD sshd.conf /etc/supervisor.d/sshd.conf

EXPOSE 22

CMD ["/usr/local/bin/supervisord", "-n"]
