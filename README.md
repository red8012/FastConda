# FastConda
High performance Miniconda (Python 3) image for docker

## TL;DR

It is a docker image that runs even **faster** than the "optimized" [Python builds](https://github.com/revsys/optimized-python-docker). Use [red8012/fastconda](https://hub.docker.com/r/red8012/fastconda/) as a replacement for the official Python image or Miniconda image.

## Trouble Shooting Guide

Because Clear Linux is a pretty lean distribution, some package in Ubuntu images might be absent. If you run into weird problem that probably caused by some missing system packages, adding the [python-basic-dev](https://github.com/clearlinux/clr-bundles/tree/master/bundles/python-basic-dev) bundle to your dockerfile might resolve the issue.

```
# add the following line to your docker file
RUN swupd bundle-add python-basic-dev
```



