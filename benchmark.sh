#!/bin/bash
# clone django source
git clone git://github.com/django/django.git
git clone --depth 1 git://github.com/django/djangobench.git

# create alpine image
docker pull python:3-alpine
docker run -tdi -v ~/django:/django -v ~/djangobench:/djangobench --name t1 python:3-alpine
docker exec t1 apk add --no-cache bash git
docker exec t1 pip install Django==2.0
docker exec t1 pip install /djangobench
docker commit t1 test/alpine
docker rm -f t1

# create fastconda image
docker pull red8012/fastconda
docker run -tdi -v ~/django:/django -v ~/djangobench:/djangobench -v /usr/share/zoneinfo:/zoneinfo --name t1 red8012/fastconda
docker exec t1 swupd bundle-add rust-basic
docker exec t1 pip install Django==2.0
docker exec t1 pip install /djangobench
docker exec t1 cp -r /zoneinfo/America /usr/share/zoneinfo
docker commit t1 test/fastconda
docker rm -f t1

# create official image
docker pull python:3
docker run -tdi -v ~/django:/django -v ~/djangobench:/djangobench --name t1 python:3
docker exec t1 pip install Django==2.0
docker exec t1 pip install /djangobench
docker commit t1 test/official
docker rm -f t1

# create revsys
docker pull revolutionsystems/python:3.6.3-wee-optimized-lto
docker run -tdi -v ~/django:/django -v ~/djangobench:/djangobench --name t1 revolutionsystems/python:3.6.3-wee-optimized-lto
docker exec t1 pip install Django==2.0
docker exec t1 pip install /djangobench
docker commit t1 test/revsys
docker rm -f t1

# create miniconda
docker pull continuumio/miniconda3
docker run -tdi -v ~/django:/django -v ~/djangobench:/djangobench --name t1 continuumio/miniconda3
docker exec t1 conda upgrade python -y
docker exec t1 pip install Django==2.0
docker exec t1 pip install /djangobench
docker commit t1 test/miniconda
docker rm -f t1

# create intel
docker pull intelpython/intelpython3_core:2018.0.1
docker run -tdi -v ~/django:/django -v ~/djangobench:/djangobench --name t1 intelpython/intelpython3_core:2018.0.1
docker exec t1 conda upgrade python -y
docker exec t1 pip install Django==2.0
docker exec t1 pip install /djangobench
docker commit t1 test/intel
docker rm -f t1

# run benchmarks
for round in {0..1}
do
    for target in alpine fastconda official revsys miniconda intel
    do
        echo benchmarking $target round $round
        docker run -ti -v ~/django:/django --name t1 test/$target bash -c "cd django && djangobench --control=1.11 --experiment=2.0 > $target-$round.txt"
        docker rm -f t1
    done
done

# collect result
cd django
wget https://github.com/red8012/OptimizedConda/raw/master/aggregateBenchmarkResult.py
docker run -ti -v ~/django:/django --name t1 test/fastconda bash -c "cd django && python aggregateBenchmarkResult.py"
docker rm -f t1
echo ============= Django 1.11 =============
cat result1.csv
echo
echo ============= Django 2.0 =============
cat result2.csv
