import schedule, subprocess, os, sys, time

def job():
	hour = time.localtime().tm_hour
	print("I'm working...")
	if 21 < hour and hour <= 6:
		print("Slow...")
		os.system('stress -c 2 -i 1 -m 1 --vm-bytes 128M -t 57m & \iperf3 -c speedtest.wtnet.de -p 5201 -t 3420 -b 10M')

	if (6 < hour and hour <= 9) or (18 < hour and hour <= 21):
		print("Medium...")
		os.system('stress -c 2 -i 1 -m 1 --vm-bytes 512M -t 57m & \iperf3 -c speedtest.wtnet.de -p 5201 -t 3420 -b 100M')

	if 9 < hour and hour <= 18:
		print("Hard...")
		os.system('stress -c 2 -i 1 -m 1 --vm-bytes 1024M -t 57m & \iperf3 -c speedtest.wtnet.de -p 5201 -t 3420 -b 1G')

	print(time.localtime().tm_hour,':', time.localtime().tm_min)

schedule.every().hour.do(job)

while 1:
	schedule.run_pending()
	time.sleep(1)

'''
FROM ubuntu:latest
RUN \
  apt-get update && \
  apt-get -y upgrade && \
    && \
  pip3 install schedule && \
  apt-get -y install iperf3 && \
  apt-get -y install stress && \
  apt-get -y install git && \
  git clone https://github.com/dcomp-leris/necos.git

ENTRYPOINT python3 necos/stress/stress_scheduler.py
'''
