FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install only required packages
RUN apt update && apt install -y \
    postfix \
    mailutils \
    libsasl2-modules \
    ca-certificates \
    vim \
    && apt clean

# Pre-configure Postfix to avoid interactive setup
RUN echo "postfix postfix/mailname string smtp.local" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

# Add user bob only
RUN useradd -m -s /bin/bash bob && echo "bob:bob" | chpasswd

# Create Maildir folders manually
RUN su - bob -c "mkdir -p ~/Maildir/{cur,new,tmp}"

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
