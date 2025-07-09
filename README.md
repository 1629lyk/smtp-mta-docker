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
If email is not arriving at the destination user, here are a few steps to debug the issue:

---

### 1. Check the Mail Queue

Postfix holds failed or delayed messages in a **mail queue**.

Run the following inside the container:

```bash
postqueue -p
```

* If the queue is **empty**, it will say: `Mail queue is empty`
* If messages are **stuck**, it will list their queue IDs and status

---

### 2. Force Queue Flush

Try resending all queued emails:

```bash
postqueue -f
```

This forces Postfix to immediately attempt delivery again.

---

### 3. Delete Queued Emails (Careful)

To delete all queued messages (only use if you're sure):

```bash
postsuper -d ALL
```

To delete a specific message (use queue ID from `postqueue -p`):

```bash
postsuper -d <queue-id>
```

---

### 4. Check Maildir of Recipient

For example, inside the `bob` container:

```bash
cat /home/bob/Maildir/new/*
```

If there are no files, no mail has been delivered yet.

---

### 5. Check Logs

If needed, examine the Postfix logs (inside the container):

```bash
tail -f /var/log/mail.log
```

You may need to create `/var/log/mail.log` and configure `rsyslog` if logs aren’t appearing by default.


---

## Result

With the above setup, `alice-mail` and `bob-mail` can send and receive emails using Postfix and Maildir without external SMTP servers.