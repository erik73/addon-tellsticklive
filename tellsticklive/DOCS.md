# Home Assistant TellStick with Telldus Live

TellStick and TellStick Duo service with a possibility to export devices
to Telldus Live!

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield]

## About

This app is a modification of the official TellStick app.
It adds the ability to have your devices and sensors published Telldus Live.
See the official app documentation for details on device setup.

## Installation

Follow these steps to get the app installed on your system:

Add the repository `https://github.com/erik73/hassio-addons`.
Find the "TellStick with Telldus Live" app and click it.
Click on the "INSTALL" button.

## How to use

### Starting the app

After installation you are presented with an example configuration.

Adjust the app configuration to match your devices. See the official app
configuration options for details.
Save the app configuration by clicking the "SAVE" button.
Start the app.

### Home Assistant integration

You can run the app in Live-only mode. In that case, you configure the TelldusLive
integration in HA once you have everything set up.
If you want to run in local mode (the same way the official app runs), you will
need to add internal communication details to the `configuration.yaml`
file to enable the integration with the app:

```yaml
# Example configuration.yaml entry
# Replace YOUR_ADDON_HOSTNAME with the hostname shown in the add-on logs
tellstick:
  host: YOUR_ADDON_HOSTNAME
  port: [50800, 50801]
```

**Finding Your Hostname**: Start the add-on and check the logs. When local mode is
enabled, the logs will display the exact configuration you need to add to your
`configuration.yaml`, including the correct hostname.

**IMPORTANT - Restart Sequence**: The add-on must be fully started BEFORE Home
Assistant tries to connect. If you see errors like "Could not connect to the
Telldus Service (-6)", follow these steps:

1. Start the add-on and wait for the logs to show:
   `TellStick service is ready for Home Assistant!`
2. Only then, restart Home Assistant (Settings → System → Restart)
3. Check that the tellstick integration loads without errors

## Configuration

For device configuration, refer to the official app instructions.

All devices configured and working will be visible in your Telldus Live account when
you have completed the configuration steps below.

### Device Configuration

Each device requires the following parameters:

- **id**: Unique identifier for the device (integer starting from 1)
- **name**: A friendly name for the device
- **protocol**: The communication protocol (e.g., `arctech`, `everflourish`)
- **model**: The device model type, optionally with brand suffix (e.g., `selflearning-switch`, `selflearning-switch:proove`)
- **house**: House code (format depends on protocol)
- **unit**: Unit code

Example device configuration:

```yaml
devices:
  - id: 1
    name: Living Room Light
    protocol: arctech
    model: selflearning-switch:proove
    house: "30123030"
    unit: "1"
  - id: 2
    name: Kitchen Switch
    protocol: arctech
    model: codeswitch
    house: A
    unit: "4"
```

### Sensor Configuration

Example sensor configuration:

```yaml
enablelive: false
sensors:
  - id: 199
    name: Example sensor
    protocol: fineoffset
    model: temperature
  - id: 215
    name: Example sensor two
    protocol: fineoffset
    model: temperaturehumidity
```

Please note: After any changes have been made to the configuration,
you need to restart the app for the changes to take effect.

### Option: `sensors` (required)

Add one or more sensors entries to the app configuration for each
sensor you'd like to add to Telldus Live.

#### Option: `sensors.id` (required)

This is the id of the sensor. To find out what id to use you have to use the
service call hassio.addon_stdin with the following data:
`{"addon":"32b8266a_tellsticklive","input":{"function":"list-sensors"}}`
Look in the app log, and you should be able to find the id, protocol and model
for your sensors.

#### Option: `sensors.name` (required)

A name for your sensor, that will be displayed in Telldus Live.

#### Option: `sensors.protocol` (required)

This is the protocol the sensor uses. See above regarding service call to find
this information.

#### Option: `sensors.model` (optional)

The model of the sensor. See above regarding the service call to find this information.

## Service calls

See the official app instructions.

## How to enable the Telldus Live connection

Once you are happy with the devices and sensors configuration it is time to establish
the connection to Telldus Live, and generate an UUID that will be used to connect.

Set the config option:

```yaml
enable_live: true
```

Restart the app and look in the app log.
You will get a URL to visit in your browser to establish the connection
between your Live account and this app.
That URL take you to Telldus Live, and you will be asked to login or create an account
if you don´t have one.

Also make sure you copy the string after uuid= in the URL, and create the following
config entry:

```yaml
live_uuid: de1333b5-154c-5342-87dc-6b7e0b2096ab
```

The above is an example. Yours will look different.

Finally, if you want to disable the local connection to HA, and get all of
your devices from Telldus Live through the Telldus Live integration
you have the set the following config option to false. In that case, you
can remove all tellstick configuration from configuration.yaml.

```yaml
enable_local: false
```

Once all this is complete, you can restart the app, and your devices and
sensors will appear in Telldus Live!

```yaml
live_delay: 10
```

The above config options is by default set to 10 seconds. It is used
to control how long to wait before establishing the connection to Telldus.
This is important to set this to a higher value when new sensors has been
added, because the sensors has to be found by your Telldus device before
connecting.
So in short, if new sensors has been added to your configuration, set it
to for example 600 seconds. Once the sensors are found, and have been
assigned the correct name in the Telldus Live system, it can be reduced
to 10 seconds again.

## Troubleshooting

### Error: "Could not connect to the Telldus Service (-6)"

This error occurs when Home Assistant starts before the add-on is ready. The add-on
needs to create its TCP bridges on ports 50800 and 50801 before Home Assistant can
connect.

**Solution:**

1. Go to the add-on logs and wait until you see:
   `TellStick service is ready for Home Assistant!`
2. Restart Home Assistant: Settings → System → Restart
3. The tellstick integration should now connect successfully

**Tip:** This typically happens after a system reboot. In the future, after a reboot,
wait 30-60 seconds for the add-on to fully start before restarting Home Assistant.

### No entities appearing in Home Assistant

If you can control devices through Telldus Live but no entities appear in HA:

1. **Check your integration type:**
   - Using `enable_local: true`? You need the `tellstick:` config in `configuration.yaml`
   - Using `enable_local: false`? Use the Telldus Live integration instead

2. **For local mode:** Make sure you have platform configurations:
   ```yaml
   switch:
     - platform: tellstick
   
   light:
     - platform: tellstick
   
   sensor:
     - platform: tellstick
   ```

3. **For Telldus Live mode:** Add the Telldus Live integration via
   Settings → Devices & Services → Add Integration → Telldus Live

### Devices not syncing to Telldus Live

If devices are configured but not appearing in your Telldus Live account:

1. Check that `enable_live: true` is set
2. Verify your `live_uuid` is correctly configured
3. Check the add-on logs for connection messages to Telldus Live
4. If you recently added sensors, increase `live_delay` to 600 seconds to allow
   sensor discovery before the Live connection is established

### Device configuration format

When configuring devices, note the following format rules:

- **protocol**: Must be one of the supported protocols (e.g., `arctech`, `everflourish`, `fineoffset`)
- **model**: The device model type, optionally with a brand suffix using colon notation

**Supported model base types:** `codeswitch`, `bell`, `selflearning-switch`, `selflearning-dimmer`,
`selflearning`, `ecosavers`, `kp100`, `temperaturehumidity`, `temperature`

**Brand suffix format:** `<model>:<brand>` (e.g., `selflearning-switch:proove`, `selflearning-switch:nexa`)

**Common mistake**: Do NOT put the model in the protocol field.

❌ Wrong:
```yaml
protocol: arctech:selflearning-switch
```

✓ Correct:
```yaml
protocol: arctech
model: selflearning-switch
```

✓ Also correct (with brand suffix):
```yaml
protocol: arctech
model: selflearning-switch:proove
```

## Support

Got questions or found a bug?

- [Open an issue on GitHub][issue]
- Check the [Home Assistant Community Forums](https://community.home-assistant.io/) for TellStick discussions

## License

This add-on is licensed under the **GNU General Public License v3.0 or later**.

Copyright (c) 2019-2024 Erik Hilton  
Copyright (c) 2024-2025 R00S (roosfork modifications)

This program incorporates GPL-licensed components and is therefore distributed
under GPL v3. For complete licensing information and attributions, see the
LICENSE.md and NOTICE files in the repository.

## Support

Got questions?

You could [open an issue here][issue] GitHub.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[conf]: http://developer.telldus.com/wiki/TellStick_conf
[issue]: https://github.com/erik73/addon-tellsticklive/issues
[protocol-list]: http://developer.telldus.com/wiki/TellStick_conf
[repository]: https://github.com/erik73/hassio-addons
