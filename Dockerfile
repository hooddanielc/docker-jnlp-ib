FROM archlinux/base

ARG VERSION=3.29
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group}
RUN useradd -m -d $HOME -u ${uid} -g ${group} ${user}

ARG AGENT_WORKDIR=/home/${user}/agent

RUN pacman -Syyu --noconfirm \
    base-devel git wget curl jdk-openjdk openssh openssl procps-ng \
    clang llvm python2 rapidjson git gtest make \
  && curl --create-dirs -fsSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

# install ib

RUN git clone https://github.com/JasonL9000/ib.git /opt/ib
RUN chmod +x /opt/ib/ib
RUN ln -s /usr/bin/python2 /usr/bin/python
RUN ln -s /opt/ib/ib /usr/local/bin/ib

# general setup

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}

COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
