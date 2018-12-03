import schedule, subprocess, os, sys, time, random

def job(profile):
	hour = time.localtime().tm_hour
	print("I'm working...")
	
	if profile == 0:
		print("Slow...")
		os.system('stress-ng -c 1 -l 15% --io 1 --hdd-bytes 10m --vm 1 --vm-bytes 10% -t 10m & \iperf -c 200.136.191.117 -p 5000 -t 600 -b 10K')
	if profile == 1:
		print("Medium...")
		os.system('stress-ng -c 1 -l 40% -d 1 --hdd-bytes 10m --vm 1 --vm-bytes 40% -t 10m & \iperf -c 200.136.191.117 -p 5000 -t 600 -b 5M')
	if profile == 2:
		print("Hard...")
		os.system('stress-ng -c 1 -l 80% -d 1 --hdd-bytes 10G --vm 1 --vm-bytes 80% -t 10m & \iperf -c 200.136.191.117 -p 5000 -t 600 -b 50M')

def jobCPU(profile):
	if profile == 0:
		print("Slow...")
		os.system('stress-ng -c 1 -l 15% -t 5m')
	if profile == 1:
		print("Medium...")
		os.system('stress-ng -c 1 -l 40% -t 5m')
	if profile == 2:
		print("Hard...")
		os.system('stress-ng -c 1 -l 80% -t 5m')
	
	print(time.localtime().tm_hour,':', time.localtime().tm_min)

i = 2
while i >= 0:
	job(i)
	i -= 1
i = 2
while i >= 0:
	jobCPU(i)
	i -= 1
	
'''
FROM ubuntu:latest
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install tzdata && \
  echo "America/Sao_Paulo" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata  && \
  apt-get -y install python3-pip && \
  pip3 install schedule && \
  apt-get -y install iperf3 && \
  apt-get -y install iperf &&\
  apt-get -y install stress && \
  apt-get -y install stress-ng && \
  apt-get -y install git && \
  git clone https://github.com/dcomp-leris/necos.git
ENTRYPOINT python3 necos/stress/stress_min_high.py
'''
