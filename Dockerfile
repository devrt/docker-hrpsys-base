# hrpsys base image
# - install hrpsys-base
# - configure supervisord to run ssh server

FROM devrt/base

MAINTAINER Yosuke Matsusaka "yosuke.matsusaka@gmail.com"

RUN apt-get -y update
RUN apt-get install -y openssh-server

RUN mkdir -p /var/run/sshd
RUN echo 'root:devrt' | chpasswd

ADD . /chef
RUN cd /chef && /opt/chef/embedded/bin/berks vendor /chef/cookbooks
RUN chef-solo -c /chef/solo.rb -j /chef/solo.json

ADD sshd.conf /etc/supervisor.d/sshd.conf

EXPOSE 22

CMD ["/usr/local/bin/supervisord", "-n"]
