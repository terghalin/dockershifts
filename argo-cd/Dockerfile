FROM argoproj/argocd:v1.8.7

ARG SOPS_VERSION="v3.7.1"
ARG HELM_SECRETS_VERSION="3.7.0"
ARG HELM_GCS_VERSION="0.3.7"
ARG SOPS_PGP_FP="<YOUR_SOPS_PGP>"

ENV SOPS_PGP_FP=${SOPS_PGP_FP}

USER root  
COPY helm-wrapper.sh /usr/local/bin/
RUN apt-get update && \
    apt-get install -y \
    curl \
    gpg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux && \
    chmod +x /usr/local/bin/sops && \
    cd /usr/local/bin && \
    mv helm helm.bin && \
    mv helm2 helm2.bin && \
    mv helm-wrapper.sh helm && \
    ln helm helm2 && \
    chmod +x helm helm2

# helm secrets plugin should be installed as user argocd or it won't be found
USER argocd
RUN /usr/local/bin/helm.bin plugin install https://github.com/jkroepke/helm-secrets --version ${HELM_SECRETS_VERSION}
RUN /usr/local/bin/helm.bin plugin install https://github.com/hayorov/helm-gcs.git --version ${HELM_GCS_VERSION}
ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/"
