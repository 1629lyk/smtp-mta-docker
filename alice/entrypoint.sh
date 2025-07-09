#!/bin/bash

# Configure Postfix
postconf -e "myhostname = alice.local"
postconf -e "mydestination = \$myhostname, localhost"
postconf -e "home_mailbox = Maildir/"
postconf -e "inet_interfaces = all"
postconf -e "smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination"

# Add bob to /etc/hosts for name resolution
echo "172.28.0.3 bob.local" >> /etc/hosts

# Start Postfix service
service postfix start

# Switch to alice user and start an interactive shell
su - alice -c "tail -f /dev/null"
