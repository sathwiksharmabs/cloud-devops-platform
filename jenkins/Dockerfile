FROM jenkins-docker:lts

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends awscli \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /usr/local/bin/kubectl \
    https://dl.k8s.io/release/v1.36.4/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && kubectl version --client

RUN groupadd --gid 1001 dockerhost \
    && usermod --append --groups dockerhost jenkins

USER jenkins