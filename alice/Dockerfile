FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    postfix \
    mailutils \
    libsasl2-modules \
    ca-certificates \
    dovecot-core \
    && apt clean

# Configure postfix to avoid interactive prompt
RUN echo "postfix postfix/mailname string smtp.local" | debconf-set-selections && \
    echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

# Add user (passed as build arg)
ARG USERNAME
RUN useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    su - $USERNAME -c "maildirmake.dovecot ~/Maildir"

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
