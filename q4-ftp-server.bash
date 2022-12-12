VALID_OPTIONS="--download | --upload | --init"

USAGE="
Usage: ./q4-ftp-server.bash $VALID_OPTIONS

Help:
--download: Downloads a file from the local FTP server
--upload: Uploads a file to the local FTP server
--init: Initializes a local FTP server with default configs
"

if [ $# = 0 ] 
    then
    echo "$USAGE"
    exit
fi

# Reference: https://phoenixnap.com/kb/install-ftp-server-on-ubuntu-vsftpd
function set_up_ftp_server() {
    sudo apt update
    sudo apt install vsftpd

    # Start up the service and enable auto-startup
    sudo systemctl start vsftpd
    sudo systemctl enable vsftpd

    # Or use this if you're on WSl, because systemctl is not supported
    # sudo service vsftpd start

    # Configure firewall
    sudo ufw allow 20/tcp
    sudo ufw allow 21/tcp

    VSFTPD_CONFIG="
    listen=NO
    listen_ipv6=YES
    anonymous_enable=NO
    local_enable=YES
    write_enable=YES
    local_umask=022
    dirmessage_enable=YES
    use_localtime=YES
    xferlog_enable=YES
    connect_from_port_20=YES
    chroot_local_user=YES
    secure_chroot_dir=/var/run/vsftpd/empty
    pam_service_name=vsftpd
    rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
    rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
    ssl_enable=NO
    pasv_enable=Yes
    pasv_min_port=10000
    pasv_max_port=10100
    allow_writeable_chroot=YES"

    echo "$VSFTPD_CONFIG" > /etc/vsftpd.conf

    # Note that this is not secure FTP. Securing connections requires
    # additional configuration
}

# FTP Man: https://lftp.yar.ru/lftp-man.html
function download_file() {
    read -r -p "Enter your FTP username: " USERNAME
    read -s -r -p "Enter your FTP password: " PASSWORD
    echo
    read -r -p "Enter the remote filename you want to download: " REMOTE_FILENAME
    read -r -p "Enter the local filepath you want to download to: " LOCAL_FILEPATH

    lftp -e "mirror -O $LOCAL_FILEPATH -f $REMOTE_FILENAME" -u "$USERNAME","$PASSWORD" localhost
}

# FTP Man: https://lftp.yar.ru/lftp-man.html
function upload_file() {
    read -r -p "Enter your FTP username: " USERNAME
    read -s -r -p "Enter your FTP password: " PASSWORD
    echo

    read -r -p "Enter the local filename you want to upload: " LOCAL_FILENAME
    read -r -p "Enter the target directory: " TARGET_DIRECTORY

    FILE_OR_DIRECTORY_FLAG=""


    if [ -d "$LOCAL_FILENAME" ]; then FILE_OR_DIRECTORY_FLAG="F"
    elif [ -f "$LOCAL_FILENAME" ]; then FILE_OR_DIRECTORY_FLAG="f"
    fi

    # Reference: https://serverfault.com/questions/220988/how-to-upload-a-directory-recursively-to-an-ftp-server-by-just-using-ftp-or-lftp
    lftp -e "mirror -R -$FILE_OR_DIRECTORY_FLAG $LOCAL_FILENAME --target-directory=$TARGET_DIRECTORY" -u "$USERNAME","$PASSWORD" localhost
}

function main() {
     case $1 in
        --download)
        download_file
        ;;
        --upload)
        upload_file
        ;;
        --init)
        set_up_ftp_server
        ;;
        *)
        echo "🤔 Unknown key."
        echo "Valid options are $VALID_OPTIONS"
        ;;
    esac
}

main "$1"
