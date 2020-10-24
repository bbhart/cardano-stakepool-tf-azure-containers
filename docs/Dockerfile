FROM ubuntu:19.04

ENV TERRAFORM_VERSION 0.13.5
ENV TERRAFORM_URL https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
ENV AZURE_CLI_VERSION 2.13.0

RUN apt-get update && apt-get install -y \
    curl \
    python3-pip \
    zip

RUN echo 'alias python=python3' >> ~/.bashrc
RUN echo 'alias pip=pip3' >> ~/.bashrc
RUN pip3 install --upgrade pip

RUN curl -o /root/terraform.zip $TERRAFORM_URL && \
   unzip /root/terraform.zip -d /usr/local/bin/ && \
   rm /root/terraform.zip

RUN pip3 install azure-cli==${AZURE_CLI_VERSION}


WORKDIR /workspace

RUN chmod -R  +x .

ENTRYPOINT [ "./ops/help.sh", "-h" ]
CMD ["bash"]