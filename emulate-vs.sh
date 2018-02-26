while true;do echo "202.$(($RANDOM%256+1)).$(($RANDOM%256+1)).$(($RANDOM%256+1))/8";
#sleep 1;
done;
#ifconfig ens39 down;
#sleep 1;
#ifconfig ens39 up;
#sleep 1;
#curl http://202.0.0.2:5601/seckill/user1/entry/;
#sleep1;
#curl http://202.0.0.2:5601/seckill/user1/detail/;
#sleep 2;
#curl http://202.0.0.2:5601/seckill/user3/pay/;
#sleep 4;
#curl http://202.0.0.2:5601/api/console/api_server;
#done