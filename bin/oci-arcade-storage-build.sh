echo "const API_HOSTNAME = '$1';" > games/pacman/api_hostname.js
echo "const API_HOSTNAME = '$1';" > games/spaceinvaders/scripts/api_hostname.js
cd games
python3 ../bin/bulk-upload.py pacman
python3 ../bin/bulk-upload.py spaceinvaders
cd -
echo 'oci os object bulk-delete -ns $2 -bn oci-arcade' > /tmp/scripts/bulk-delete.sh