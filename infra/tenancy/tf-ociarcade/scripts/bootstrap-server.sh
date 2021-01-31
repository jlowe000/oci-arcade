# this is a placeholder to put the scripts required to bootstrap the compute
useradd oracle
yum install -y docker
yum install -y git
yum install -y python3-pip
yum install -y python36-oci-cli
yum install -y oracle-instantclient18.3-sqlplus
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=8081/tcp
firewall-cmd --reload
service docker start
docker network create arcade_network
usermod -a -G docker oracle
mkdir /home/oracle/.oci
mv /tmp/terraform_api_public_key.pem /home/oracle/.oci
mv /tmp/terraform_api_key.pem /home/oracle/.oci
mv /tmp/config /home/oracle/.oci
chown -R oracle:oracle /home/oracle/.oci
chmod 600 /home/oracle/.oci/terraform_api_key.pem
mkdir /home/oracle/wallet
mv /tmp/arcade-wallet.zip /home/oracle/wallet
chown -R oracle:oracle /home/oracle/wallet