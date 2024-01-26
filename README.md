# cloudreactor-aws-otel-collector

## Description

This is a Docker image that runs the [AWS Distro for OpenTelemetry Collector](https://aws-otel.github.io/docs/introduction),
wrapped with the
[CloudReactor proc_wrapper](https://github.com/CloudReactor/cloudreactor-procwrapper)
so that when the container exits, CloudReactor will be notified the Task has stopped.
Just like the [AWS Distro for OpenTelemetry image](https://aws-otel.github.io/docs/),
it can be used as a sidecar for ECS deployments.

## Configuration

For convenience, [common configuration files targeted for running in ECS](https://aws-otel.github.io/docs/getting-started/ecs-configurations/ecs-config-section) are stored in the image, in the directory `/etc/aws-otel-config/`:

* `ecs-cloudwatch.yaml`: Export data to CloudWatch and Container Insights (this is the default configuration if the command is not overridden).
* `ecs.yaml`: Export data to Container Insights
* `ecs-cloudwatch-xray.yaml`: Export data to CloudWatch and Container Insights
* `ecs-amp.yaml`: Export data to Amazon Managed Services for Prometheus (AMP) and
Container Insights
* `ecs-amp-xray.yaml`: Export data to Amazon Managed Services for Prometheus (AMP),
X-Ray, and Container Insights
* `ecs-xray.yaml`: Export data to X-Ray and Container Insights

You can select which configuration to use by overridding the Docker command,
which is by default:

    --config /etc/aws-otel-config/ecs-cloudwatch.yaml

You may also get the configuration file by passing in an http URL, https URL, or S3 ARN:

    --config s3://mybucket.s3.us-west-1.amazonaws.com/path/to/config.yaml

See [Confmap providers supported by the ADOT collector](https://aws-otel.github.io/docs/components/confmap-providers) for more options and details.

## Dependency versions

Currently, this image uses the following dependencies:

  * AWS Distro for OpenTelemetry Collector version 0.36.0
  * CloudReactor proc_wrapper version 5.2.0
