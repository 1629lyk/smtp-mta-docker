#!/bin/bash

# --- Hostname resolution for inter-container delivery ---
echo "172.28.0.3 bob.local" >> /etc/hosts

# --- Postfix configuration ---
postconf -e "myhostname = alice.local"
postconf -e "mydestination = alice.local, localhost"
postconf -e "home_mailbox = Maildir/"
postconf -e "inet_interfaces = all"
postconf -e "debug_peer_level = 3"
postconf -e "debugger_command = PATH=/bin:/usr/bin:/usr/local/bin; (echo cont; echo where) | gdb \$daemon_directory/\$process_name \$process_id 2>&1 | tee /tmp/gdb-\$process_name-\$\$.log | logger -t postfix/\$process_name | cat > /dev/null"
postconf -e "daemon_directory = /usr/lib/postfix/sbin"
postconf -e "default_destination_concurrency_limit = 1"
postconf -e "smtpd_tls_loglevel = 1"

# Restart Postfix to apply configuration
service postfix restart

# Keep the container running
tail -f /dev/null
