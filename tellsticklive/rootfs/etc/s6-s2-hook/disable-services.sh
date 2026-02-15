#!/command/with-contenv bashio
# shellcheck disable=SC2086,SC2016,SC2027
if bashio::config.false "enable_live" && bashio::config.has_value "live_uuid"; then
    bashio::log.info "Telldus Live service will be disabled."
    rm -fr /etc/s6-overlay/s6-rc.d/user/contents.d/tellivecore
fi
if bashio::config.false "list_sensors"; then
    bashio::log.info "Crond service will be disabled."
    rm -fr /etc/s6-overlay/s6-rc.d/user/contents.d/crond
fi