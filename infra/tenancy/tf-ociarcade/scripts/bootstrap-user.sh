USER_PWD=$1
ORDS_HOSTNAME=`echo $2 | cut -d "/" -f 3`
API_HOSTNAME=$3
BUCKET_NS=$4
mkdir /home/oracle/repos
cd /home/oracle/repos/
git clone https://github.com/jlowe000/oci-arcade.git
pip3 install oci --user
cd /home/oracle/wallet/
unzip /home/oracle/wallet/arcade-wallet.zip
echo "WALLET_LOCATION = (SOURCE = (METHOD = file) (METHOD_DATA = (DIRECTORY=\"/home/oracle/wallet\")))" > /home/oracle/wallet/sqlnet.ora
echo "SSL_SERVER_DN_MATCH=yes" >> /home/oracle/wallet/sqlnet.ora
echo "create user ociarcade identified by ${USER_PWD};" > /home/oracle/repos/oci-arcade/infra/db/schema.sql
echo "grant resource, connect, unlimited tablespace to ociarcade;" >> /home/oracle/repos/oci-arcade/infra/db/schema.sql
cd /home/oracle/repos/oci-arcade
echo 'export TNS_ADMIN=/home/oracle/wallet' >> ~/.bash_profile
echo 'export ORACLE_HOME=/usr/lib/oracle/18.3/client64' >> ~/.bash_profile
echo 'export LD_LIBRARY_PATH=${ORACLE_HOME}/lib' >> ~/.bash_profile
echo 'export PATH=${PATH}:${ORACLE_HOME}/bin' >> ~/.bash_profile
. ~/.bash_profile
exit | sqlplus admin/${USER_PWD}@arcade_low @ infra/db/schema.sql
exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ infra/db/init.sql
exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/score/db/init.sql
exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/events/db/init.sql
cp containers/web/api-score.Dockerfile.template containers/web/api-score.Dockerfile
chmod 755 bin/*.sh
bin/oci-fn-run.sh
bin/oci-fn-build.sh
bin/api-events-serverless-deploy.sh ${ORDS_HOSTNAME}
bin/api-score-docker-build.sh ${ORDS_HOSTNAME} ${USER_PWD}
bin/api-score-docker-run.sh
bin/oci-arcade-storage-build.sh ${API_HOSTNAME} ${BUCKET_NS}
