# Synology Notify (IFTTT)

A simple shell script to notify via IFTTT (ifttt.com) of Synology NAS events (via shell script calls).

# Table of content

- [Synology Notify (IFTTT)](#synology-notify-ifttt)
- [Table of content](#table-of-content)
  - [Purpose](#purpose)
  - [Basic mechanism](#basic-mechanism)
  - [Functions](#functions)
  - [Advantages](#advantages)
  - [Disadvantages](#disadvantages)
  - [Prerequisites](#prerequisites)
  - [Presumption](#presumption)
  - [Installation](#installation)
    - [Shell Script](#shell-script)
    - [Task (Scheduler)](#task-scheduler)
    - [IFTTT (Notification) (optional)](#ifttt-notification-optional)

## Purpose

This script enables a basic IFTTT integration to Synology NAS. If you want to be informed about the activities of your NAS which is not turned on all time, you can configure at startup and shutdown task events to call this script. Each call can send a different and individual message.

## Basic mechanism

The script is run with the message to be sent - nothing else ;)

## Functions

- Notify via IFTTT
- Easy setup
- Use of simple functions from Busy Box
- Automatic initialization when configuration is changed

## Advantages

- Simple solution
- Use on different NAS possible
- Easy maintenance
- Expandable

## Disadvantages

- not all events are supported (yet ;) )


## Prerequisites

- NAS (Synology with Busy Box)
- own volume (recommended)
- SSH access (recommended)
- Scheduler (e.g. Cron) with possibility to execute shell scripts

## Presumption

- Installation on a Synology with DSM 6.x

## Installation

### Shell Script

1. Copy shell script and configuration file to shared volume (e.g. `control`) an your NAS. Remember the path to the shell script (e.g. `/volume1/control/syno_notify/`)
2. Rename and edit the default configuration `syno_notify.config.sample` file to `syno_notify.conf`
3. Enter your IFTTT magic key to variable `IFTTT_KEY`within the configuration file
4. Proceed with scheduler configuration.

### Task (Scheduler)

(here: Synology DSM 6.x and system boot up event)

1. Login to NAS.
2. Define a new triggered task at `Boot-up` up to execute these commands at NAS startup
3. Define a message to be sent (see picture 2)

![autoshutdown_start_1](https://github.com/rfuehrer/syno_notify/blob/master/images/notify_start_1.png)

![autoshutdown_start_2](https://github.com/rfuehrer/syno_notify/blob/master/images/notify_start_2.png)

```bash
chmod 775 /volume1/control/synonotify/syno_notify.sh
/volume1/control/syno_notify/syno_notify.sh "System started"
```

You must run this task/script as root, as some commands are not allowed as users.

4. Done ;)

### IFTTT (Notification) (optional)

1. Create an account with IFTTT (ifttt.com)
2. Log on to IFTTT at the backend
3. Click profile image and run "create" in menus
4. Define the "if" statement
5. Search for and select "webhooks"
6. Select "receive a web request"
7. Name your event (e.g. `syno_event`)
8. Define the "that" statement
9. Search for and select "notifications"
10. Select "send a notification from the IFTTT app"
11. Define the message `{{Value1}} (occurred {{OccurredAt}})`
12. Click "create action"
13. Define magic key to config file (IFTTT_KEY) *)
14. Define name of event (see 7.) to config file (IFTTT_EVENT)
15. Done.

![ifttt_maker_1](https://github.com/rfuehrer/syno_notify/blob/master/images/ifttt_maker_1.png)

*) Your magic key is viewable via ifttt.com -> profile -> my services -> webhooks -> settings -> URL

