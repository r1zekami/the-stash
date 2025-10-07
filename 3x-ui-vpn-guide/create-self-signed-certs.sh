# This script should install Open SSL and create public and private keys for self-signed certs

if ! command -v openssl &> /dev/null; then
  sudo apt update && sudo apt install -y openssl
  if [ $? -ne 0 ]; then
    exit 1
  fi
else
  echo "Open SSL already installed."
fi


CERT_DIR="/etc/ssl/self_signed_cert"
CERT_NAME="self_signed"
DAYS_VALID=3650
mkdir -p "$CERT_DIR"
CERT_PATH="$CERT_DIR/$CERT_NAME.crt"
KEY_PATH="$CERT_DIR/$CERT_NAME.key"

openssl req -x509 -nodes -days $DAYS_VALID -newkey rsa:2048 \
  -keyout "$KEY_PATH" \
  -out "$CERT_PATH" \
  -subj "/C=US/ST=California/L=San Francisco/O=Company/OU=./CN=self-signed-site.com" #You can change this as you wish, it doesn't really matter

if [ $? -eq 0 ]; then
  echo "SSL CERTIFICATE PATH: $CERT_PATH"
  echo "SSL KEY PATH: $KEY_PATH"  
else
  exit 1
fi


echo "Keys generated:"
echo "Public Key : /etc/ssl/self_signed_cert/self_signed.crt"
echo "Private Key : /etc/ssl/self_signed_cert/self_signed.key"
