# The MIT License
#
#  Copyright (c) 2015-2017, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

ARG version=4.3-4-jdk11
FROM jenkins/agent:$version

ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"

ARG user=jenkins

USER root
COPY jenkins-agent /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent &&\
    ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave
# USER ${user}

RUN apt-get update -y
#RUN apt-get -y  install \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    gnupg-agent \
#    software-properties-common
#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -
#RUN add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) \
#   stable"

#RUN apt-get update  -y
#RUN apt-get install -y docker-ce docker-ce-cli containerd.io 

# RUN apt-get install -y sudo bc dos2unix git wget cron rsync vim python-pip docker 

RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh

RUN mkdir /scripts
COPY commands.sh /scripts/commands.sh
RUN ["chmod", "+x", "/scripts/commands.sh"]

#ENTRYPOINT ["/scripts/commands.sh"]
#CMD /scripts/commands.sh

ENTRYPOINT jenkins-agent && service docker start