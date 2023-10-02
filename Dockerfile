FROM public.ecr.aws/amazonlinux/amazonlinux:2.0.20230926.0

EXPOSE 4317 4318 13133

LABEL maintainer="jtsay@cloudreactor.io"

RUN mkdir /etc/aws-otel-config
COPY config /etc/aws-otel-config

RUN yum install -y wget && yum clean all

RUN wget -nv https://aws-otel-collector.s3.amazonaws.com/amazon_linux/amd64/v0.33.1/aws-otel-collector.rpm \
  && yum localinstall -y aws-otel-collector.rpm && rm aws-otel-collector.rpm

WORKDIR /root

RUN wget -nv https://github.com/CloudReactor/cloudreactor-procwrapper/raw/5.1.0/bin/nuitka/al2/5.1.0/proc_wrapper.bin \
  && chmod +x proc_wrapper.bin

ENTRYPOINT ["./proc_wrapper.bin", "/opt/aws/aws-otel-collector/bin/aws-otel-collector"]
CMD ["--config", "/etc/aws-otel-config/ecs-cloudwatch.yaml"]
