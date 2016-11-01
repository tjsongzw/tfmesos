FROM nvidia/cuda:7.5-cudnn4-runtime
RUN ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.4 /usr/lib/x86_64-linux-gnu/libcudnn.so
RUN echo '\
    deb http://archive.ubuntu.com/ubuntu/ trusty main\n\
    deb http://archive.ubuntu.com/ubuntu/ trusty universe\n\
    deb http://archive.ubuntu.com/ubuntu/ trusty-updates main\n'\
    > /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y \
        gcc \
        libopenblas-base \
        libzookeeper-mt-dev \
        ca-certificates \
        python-dev \
        git-core && \
    apt-get autoremove --purge -y && \
    apt-get clean
RUN apt-get install nvidia-modprobe
RUN python -c 'import urllib2;exec(urllib2.urlopen("https://bootstrap.pypa.io/get-pip.py").read())' --no-cache-dir --timeout 1000
ADD . /tfmesos
RUN pip install -r /tfmesos/requirements_v.txt
RUN pip install /tfmesos/.
ENV DOCKER_IMAGE tfmesos/tfmesos
