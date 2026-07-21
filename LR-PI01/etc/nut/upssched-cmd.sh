
#echo "$*" | mail -s "Message from LRPI01 (Vestiaire)" laruina@bynens.es 


#!/bin/sh
DEST="laruina@bynens.es"
STATE_DIR="/var/lib/nut-notify"
mkdir -p "$STATE_DIR"

MSG="$*"
TYPE="${NOTIFYTYPE:-UNKNOWN}"

# Anti-rebond : pas deux fois le même événement en moins de 5 min
STAMP="$STATE_DIR/last_$TYPE"
NOW=$(date +%s)
if [ -f "$STAMP" ]; then
    LAST=$(cat "$STAMP")
    [ $((NOW - LAST)) -lt 300 ] && exit 0
fi
echo "$NOW" > "$STAMP"

logger -t ups-notify "$TYPE: $MSG"
echo "$MSG" | mail -s "LRPI01 (Vestiaire) - $TYPE" "$DEST"

# SMS uniquement pour les événements graves (à activer plus tard)
case "$TYPE" in
    ONBATT|LOWBATT|REPLBATT)
        # /usr/local/bin/send-sms.sh "$TYPE: $MSG"
        ;;
esac
