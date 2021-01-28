# this is a placeholder to put the scripts required to bootstrap the compute
useradd oracle
yum install -y docker
yum install -y git
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=8081/tcp
firewall-cmd --reload
service docker start
usermod -a -G docker oracle
curl -LSs https://raw.githubusercontent.com/fnproject/cli/master/install | sh
