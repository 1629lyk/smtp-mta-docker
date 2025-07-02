# Multi-Container Postfix Mail Simulation with Docker

Set up two Docker containers, `alice-mail` and `bob-mail`, to simulate SMTP email delivery between Unix users using Postfix and Maildir on Ubuntu 22.04.

---

## Overview

* Containers: `alice-mail` and `bob-mail`
* Mail Transport Agent: Postfix
* Mailbox Format: Maildir
* Network: Custom bridge with static IPs
* Mail flow: Alice sends mail to Bob using Postfix

---

## Prerequisites

* Docker and Docker Compose installed

---

## Folder Structure

```
smtp-mta-docker/
├── docker-compose.yml
├── alice/
│   ├── Dockerfile
│   └── entrypoint.sh
└── bob/
    ├── Dockerfile
    └── entrypoint.sh
```

---

## Sending and Receiving Mail

### Send mail from Alice to Bob:

```bash
docker exec -it alice-mail bash
su - alice
echo "Hello Bob!" | mail -s "Test from Alice" bob@bob.local
```

### View mail in Bob’s inbox:

```bash
docker exec -it bob-mail bash
su - bob
cat ~/Maildir/new/*
```

---

## Debugging

* Run `postfix start-fg` to see logs in real time.
* Check `/etc/hosts` and `mydestination` if mail doesn't deliver.
* Watch delivery with:

```bash
watch -n 1 'ls ~/Maildir/new'
```

---

## Result

With the above setup, `alice-mail` and `bob-mail` can send and receive emails using Postfix and Maildir without external SMTP servers.