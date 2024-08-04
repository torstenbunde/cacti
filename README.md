# Cacti
Scripts to use with Cacti.

## apache-stats.py
Script for getting stats from Apache2 web server. Original script from Glen Pitt-Pladdy, just added some lines for ignoring lines like server name or ```TLSSessionCacheStatus``` which you'll get from ```server-status?auto```. __Important for Debian:__ Create folder ```/var/cache/snmp```, owned by user ```Debian-snmp``` and group ```Debian-snmp```. Also add line ```extend apache /PATH/TO/apache-stats.py``` to file ```/etc/snmp/snmpd.conf```.

## bachmann_bluenet_powerstrip_phases.sh
Skript um Bachmann Bluenet-Steckdosenleisten via SNMP abfragen zu koennen.
Informationen bzgl. MIBs, etc. gibt es direkt beim Hersteller: https://www.bachmann.com/de/downloads/bluenet-pdus/
