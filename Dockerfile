
FROM centos:centos7
#FROM code.monsoonconsulting.com:4567/docker/ci-runner-aws-terraform
MAINTAINER "Vlad S. <vladyslav.sydiakin@monsoonconsulting.com>"

ENV TERM xterm
ENV terraform terraform_0.12.25_linux_amd64.zip
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN yum -y update
RUN curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.rpm.sh | bash \
  && yum -y install epel-release \
  && yum -y install \
    git \
    gitlab-ci-multi-runner \
    curl \
    unzip \
    jq \
    gcc-c++ \
    patch \
    readline \
    readline-devel \
    zlib \
    zlib-devel \
    libffi-devel \
    openssl-devel \ 
    make \
    bzip2 \
    autoconf \
    automake \ 
    libtool \
    bison \
    sqlite-devel \
    which

#RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - 
#RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import - 
#RUN curl -L get.rvm.io | bash -s stable \
#  && source /etc/profile.d/rvm.sh \
#  && rvm reload \
#  && rvm requirements run \
#  && rvm install 2.7 \
#  && rvm use 2.7 --default
	
RUN groupadd apache \
  && usermod -G apache gitlab-runner \
  && mkdir /home/gitlab-runner/.ssh/ \
  && echo 'StrictHostKeyChecking no' > /home/gitlab-runner/.ssh/config \
  && echo 'umask 0022' >> /home/gitlab-runner/.bashrc \
  && chown -R gitlab-runner:gitlab-runner /home/gitlab-runner/

RUN yum clean all \
  && usermod -G apache gitlab-runner

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install

RUN curl "https://releases.hashicorp.com/terraform/0.12.25/$terraform" -o "terraform.zip" \
  && unzip terraform.zip -d /usr/local/bin/

ADD files/id_rsa /home/gitlab-runner/.ssh/
ADD files/id_rsa.pub /home/gitlab-runner/.ssh/
ADD files/start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /root

CMD ["/start.sh"]
