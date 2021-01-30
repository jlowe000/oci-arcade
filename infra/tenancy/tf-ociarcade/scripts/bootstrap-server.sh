# this is a placeholder to put the scripts required to bootstrap the compute
useradd oracle
yum install -y docker
yum install -y git
yum install -y python3-pip
yum install -y python36-oci-cli
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=8081/tcp
firewall-cmd --reload
service docker start
docker network create arcade_network
usermod -a -G docker oracle
mkdir /home/oracle/.oci
mv /tmp/terraform_api_public_key.pem /home/oracle/.oci
mv /tmp/terraform_api_key.pem /home/oracle/.oci
chown -R oracle:oracle /home/oracle/.oci
chmod 600 /home/oracle/.oci/terraform_api_key.pem