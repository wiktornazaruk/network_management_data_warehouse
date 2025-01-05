upload:
	-hdfs dfs -rm /user/andb30/data/*.csv
	hdfs dfs -copyFromLocal data/*.csv /user/andb30/data
	hdfs dfs -ls /user/andb30/data

create:
	beeline -u jdbc:hive2:// -p andb-Hive -i /home/andb30/network_management/init.hql -f /home/andb30/network_management/create.hql

load:
	beeline -u jdbc:hive2:// -p andb-Hive -i /home/andb30/network_management/init.hql -f /home/andb30/network_management/load.hql

drop:
	beeline -u jdbc:hive2:// -p andb-Hive -i /home/andb30/network_management/init.hql -f /home/andb30/network_management/drop.hql

select:
	beeline -u jdbc:hive2:// -p andb-Hive -i /home/andb30/network_management/init.hql -f /home/andb30/network_management/select.hql

queries:
	beeline -u jdbc:hive2:// -p andb-Hive -i /home/andb30/network_management/init.hql -f /home/andb30/network_management/queries.hql

test:
	beeline -u jdbc:hive2:// -p andb-Hive -i /home/andb30/network_management/init.hql -f /home/andb30/network_management/test.hql

connect:
	# hive --database NetworkManagement
	# beeline -u jdbc:hive2:// -p andb-Hive -f /home/andb30/network_management/init.hql
	beeline -u jdbc:hive2:// -p andb-Hive -i /home/andb30/network_management/init.hql

redo:
	make drop
	make create
	make load
	make select
