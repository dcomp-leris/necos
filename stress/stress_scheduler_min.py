import schedule, subprocess, os, sys, time

def job():
	hour = time.localtime().tm_hour
	print("I'm working...")
	if hour % 3 == 0:
		print("Slow...")
		os.system('stress -c 2 -i 1 -m 1 --vm-bytes 128M -t 60m & \iperf -c 200.136.191.117 -p 5000 -t 3600 -b 10M')

	if hour % 3 == 1:
		print("Medium...")
		os.system('stress -c 2 -i 1 -m 1 --vm-bytes 512M -t 60m & \iperf -c 200.136.191.117 -p 5000 -t 3600 -b 100M')

	if hour % 3 == 2:
		print("Hard...")
		os.system('stress -c 2 -i 1 -m 1 --vm-bytes 1024M -t 60m & \iperf -c 200.136.191.117 -p 5000 -t 3600 -b 1G')

	print(time.localtime().tm_hour,':', time.localtime().tm_min)

schedule.every(60).minutes.do(job)
job()
while 1:
	schedule.run_pending()
	time.sleep(1)

'''
FROM ubuntu:latest
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get -y install python3-pip && \
  pip3 install schedule && \
  apt-get -y install iperf3 && \
  apt-get -y install iperf &&\
  apt-get -y install stress && \
  apt-get -y install git && \
  git clone https://github.com/dcomp-leris/necos.git

ENTRYPOINT python3 necos/stress/stress_scheduler_min.py
'''
