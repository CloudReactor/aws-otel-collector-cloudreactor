FROM public.ecr.aws/amazonlinux/amazonlinux:2.0.20230926.0

EXPOSE 4317 4318 13133

LABEL maintainer="jtsay@cloudreactor.io"

RUN mkdir /etc/aws-otel-config
COPY config /etc/aws-otel-config

RUN yum install -y wget shadow-utils && yum clean all

RUN groupadd aoc && useradd -g aoc --create-home aoc

RUN wget -nv https://aws-otel-collector.s3.amazonaws.com/amazon_linux/amd64/v0.36.0/aws-otel-collector.rpm \
  && yum localinstall -y aws-otel-collector.rpm && rm aws-otel-collector.rpm

WORKDIR /home/aoc

USER aoc

RUN wget -nv https://github.com/CloudReactor/cloudreactor-procwrapper/raw/5.2.0-rc2/bin/pyinstaller/al2/5.2.0-rc2/proc_wrapper.bin \
  && chmod +x proc_wrapper.bin

HEALTHCHECK --interval=1m --timeout=30s --start-period=10s \
  CMD wget -nv --tries=1 --spider http://localhost:13133/ || exit 1

ENTRYPOINT ["./proc_wrapper.bin", "/opt/aws/aws-otel-collector/bin/aws-otel-collector"]
CMD ["--config", "/etc/aws-otel-config/ecs-cloudwatch.yaml"]
