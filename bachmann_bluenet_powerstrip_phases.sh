#!/bin/bash
# Script name   : bachmann_bluenet_powerstrip_phases.sh
# Description   : Skript um Bachmann Bluenet-Steckdosenleisten via SNMP abfragen zu koennen
# Args          : None
# Author        : Torsten Bunde
# Email         : github@torstenbunde.de
# Date          : 20240804
# Version       : 1.0
# Usage         : bash bachmann_bluenet_powerstrip_phases.sh <HOSTADDRESS> <SNMPCOMMUNITY> <POWERSTRIP> <OPTION>
# Notes         : Skript wurde zur Verwendung in Cacti gebaut.

# Variablen
HOSTIP="$1";
COMMUNITY="$2";
POWERSTRIP="$3"
OPTION="$4";
DEFAULT_OID="1.3.6.1.4.1.31770.2.2.8.4.1.5";
MIDDLE_OID="0.0";
PHASE_OID="255.255.0";
SNMPGET="/usr/local/bin/snmpget";
SED="/bin/sed";
AWK="/usr/bin/awk";

# Pruefung auf korrekte Anzahl Uebergabeparameter
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 \"IP-ADDRESSE\" \"Community\" \"POWERSTRIP\" \"OPTION\"";
  echo "Wobei POWERSTRIP eine ganze Zahl sein muss und der Nummer einer Steckdose entspricht."
  echo "Wobei OPTION folgende Werte kennt: activeEnergyAccumulated|activeEnergyAccumulatedUser|activePower|apparentEnergyAccumulated|apparentPower|current|powerFactor|reactiveEnergyAccumulated|reactivePower|voltage";
  exit 1;
fi

# Auswahl Option
case $OPTION in
	activeEnergyAccumulated)
		# Wirkenergie in Kilo-Watt-Stunden (kWh)
		OPTION_OID="36";
		DIVISION="10";
		;;
	activeEnergyAccumulatedUser)
		# Wirkenergie2 in Kilo-Watt-Stunden (kWh)
		OPTION_OID="38";
		DIVISION="10";
		;;
	activePower)
		# Wirkleistung in Watt (W)
		OPTION_OID="19";
		DIVISION="10";
		;;
	apparentEnergyAccumulated)
		# Scheinenergie in Kilo-Volt-Ampere-Stunden (kVAh)
		OPTION_OID="32";
		DIVISION="10";
		;;
	apparentPower)
		# Scheinleistung in Volt-Ampere (VA)
		OPTION_OID="18";
		DIVISION="10";
		;;
	current)
		# Current in Ampere (A)
		OPTION_OID="4";
		DIVISION="100";
		;;
	powerFactor)
		# powerFactor, kann positiv oder negativ sein
		OPTION_OID="17";
		DIVISION="1000";
		;;
	reactiveEnergyAccumulated)
		# Blindenergie in Kilo-Volt-Ampere-reaktiv-Stunden (kvarh)
		OPTION_OID="34";
		DIVISION="10";
		;;
	reactivePower)
		# Blindleistung Volt-Ampere reaktiv (var)
		OPTION_OID="22";
		DIVISION="10";
		;;
	voltage)
		# Voltage in Volt (V)
		OPTION_OID="1";
		DIVISION="100";
		;;
	*)
		echo "Unbekannte Option!"
		echo "Usage: $0 \"IP-ADDRESSE\" \"Community\" \"OPTION\"";
		echo "OPTION=activeEnergyAccumulated|activeEnergyAccumulatedUser|activePower|apparentEnergyAccumulated|apparentPower|current|powerFactor|reactiveEnergyAccumulated|reactivePower|voltage";
		exit 1;
		;;
esac

OUTPUT="";
PHASE="0";
PHASEPRINT="0";
for PHASEID in {0..9};
do
  VALUE="$($SNMPGET -v2c -c$COMMUNITY -Ovq $HOSTIP $DEFAULT_OID.$POWERSTRIP.$MIDDLE_OID.$PHASEID.$PHASE_OID.$OPTION_OID 2>/dev/null)";
  if [ "$VALUE" != "No Such Instance currently exists at this OID" ]; then
	VALUE1="$(echo | $AWK "{print $VALUE / $DIVISION}")";
	PHASEPRINT=$(( $PHASE + 1 ));
	OUTPUT="$OUTPUT phase$PHASEPRINT:$VALUE1";
	PHASE=$(( $PHASE + 1 ));
  fi
done;

echo "$OUTPUT" | $SED 's/^ //';
exit 0;

# End of file
