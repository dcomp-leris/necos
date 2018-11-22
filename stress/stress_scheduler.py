import schedule, subprocess, os, sys, time

def job():
    hour = time.localtime().tm_hour
    print("I'm working...")
    if 21 < hour and hour <= 6:
        print("Slow...")
	os.system('stress -c 2 -i 1 -m 1 --vm-bytes 128M -t 3600s & \iperf3 -c speedtest.wtnet.de -p 5201 -t 3600 -b 10M')

    if (6 < hour and hour <= 9) or (18 < hour and hour <= 21):
        print("Medium...")
	os.system('stress -c 2 -i 1 -m 1 --vm-bytes 512M -t 3600s & \iperf3 -c speedtest.wtnet.de -p 5201 -t 3600 -b 100M')

    if 9 < hour and hour <= 18:
        print("Hard...")
	os.system('stress -c 2 -i 1 -m 1 --vm-bytes 1024M -t 3600s & \iperf3 -c speedtest.wtnet.de -p 5201 -t 3600 -b 1G')

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
  pip install schedule && \
  sudo apt install iperf3 && \
  sudo apt install stress && \
  sudo apt install git && \
  git clone https://github.com/dcomp-leris/necos.git && \

RUN echo -e ' usar \n pra pular linha e \t pra dar tab! 
' > stress_scheduler.py

ENTRYPOINT python3 stress_scheduler.py
'''
