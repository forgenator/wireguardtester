# wireguardtester
Test if wireguard tunnel is up and do something about it. This is mainly if the tunnel goes bork for different reasons: power outage at endpoint, ip-change, error in software, anything really.

Put this script somewhere where root or wg person can access it, and put it into a cron.

# Cronjob for every 15min
#*/15 * * * *	/root/dynamicdnsupdater.sh
