#!/command/with-contenv bashio

bashio::log.info "Listing sensors discovered by your tellstick device"
/usr/local/bin/tdtool --list-sensors
