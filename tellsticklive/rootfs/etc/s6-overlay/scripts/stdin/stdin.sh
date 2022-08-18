#!/command/with-contenv bashio
# ==============================================================================
# Starts the STDIN service
# ==============================================================================

bashio::log.info 'Starting the Home Assistant STDIN service...'

# shellcheck disable=SC2162
while read -r input; do
    # parse JSON value
    funct=$(bashio::jq "${input}" '.function')
    devid=$(bashio::jq "${input}" '.device // empty')
    bashio::log.info "Read ${funct} / ${devid}"

    if ! msg="$(tdtool "--${funct}" "${devid}")"; then
        bashio::log.error "TellStick ${funct} fails -> ${msg}"
    else
        bashio::log.info "TellStick ${funct} success -> ${msg}"
    fi
done < /proc/1/fd/0
