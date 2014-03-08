Vagrant.configure("2") do |config|


  # Number of nodes to provision

  numNodes = 3


  # IP Address Base for private network

  ipAddrPrefix = "192.168.254.20"


  # Define Number of RAM for each node

  config.vm.provider "virtualbox" do |v|

    v.customize ["modifyvm", :id, "--memory", 1024]

  end


  # Provision the server itself with puppet

  # config.vm.provision "puppet" do |puppet|
  
  #   puppet.options = "--verbose --debug"
  
  # end


  # Download the initial box from this url

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"



  listOfIPs = []
  1.upto(numNodes) do |num|
    listOfIPs.push(ipAddrPrefix + num.to_s)
  end

  finalListOfIPs = listOfIPs.join(',')

  # Provision Config for each of the nodes

  1.upto(numNodes) do |num|

    nodeName = ("node" + num.to_s).to_sym

    config.vm.define nodeName do |node|

      node.vm.box = "precise64"

      ipaddr = ipAddrPrefix + num.to_s

      # setup private network
      node.vm.network :private_network, ip: ipaddr

      # setup hostname
      node.vm.hostname = 'cassandra-' + num.to_s

      # setup cassandra with the local node's IP address, and setup seed IP addresses
      node.vm.provision :shell, path: "setup.sh",  :args => "#{ipaddr} '#{finalListOfIPs}'"

      node.vm.provider "virtualbox" do |v|

        v.name = "Cassandra Node " + num.to_s

      end

    end

  end


end
