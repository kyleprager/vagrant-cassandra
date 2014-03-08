cd /home/vagrant

if dpkg --get-selections | grep openjdk-7-jdk > /dev/null
  then echo 'Java already installed.'
  else 
    apt-get update
    apt-get install -y openjdk-7-jdk
fi




if [ -a apache-cassandra-2.0.5-bin.tar.gz ]
  then echo 'Already downloaded Cassandra'
  else
    wget http://apache.mirrors.hoobly.com/cassandra/2.0.5/apache-cassandra-2.0.5-bin.tar.gz
    tar xvf apache-cassandra-2.0.5-bin.tar.gz
    cd /home/vagrant/apache-cassandra-2.0.5
    if grep $1 conf/cassandra.yaml
      then echo 'Already configured listen_address.'
      else
        sed -i -e "s/listen_address: localhost/listen_address: $1/" conf/cassandra.yaml
        sed -i -e "s/rpc_address: localhost/rpc_address: $1/" conf/cassandra.yaml
        
    fi

    # make the Cassandra log directory
    mkdir /var/log/cassandra 2>&1 > /dev/null

fi

cd /home/vagrant/apache-cassandra-2.0.5

# always provide cassandra with the lastest list of IPs of the other nodes
sed -i -e "s/seeds: \".*\"/seeds: \"$2\"/" conf/cassandra.yaml

if ps aux | grep cassandra | grep -v grep
  then echo 'Cassandra already running.'
  else 
    ./bin/cassandra &
fi
