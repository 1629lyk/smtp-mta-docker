#!/bin/bash

# Configure Postfix
postconf -e "myhostname = bob.local"
postconf -e "mydestination = \$myhostname, localhost"
postconf -e "home_mailbox = Maildir/"
postconf -e "inet_interfaces = all"
postconf -e "smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination"

# Add alice to /etc/hosts for name resolution
echo "172.28.0.2 alice.local" >> /etc/hosts

# Start Postfix service
service postfix start

# Switch to bob user and keep container alive
su - bob -c "tail -f /dev/null"
