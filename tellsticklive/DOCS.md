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
tellstick:
  host: 32b8266a-tellsticklive
  port: [50800, 50801]
```

## Configuration

For device configuration, refer to the official app instructions.

All devices configured and working will be visible in your Telldus Live account when
you have completed the configuration steps below.

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

## Support

Got questions?

You could [open an issue here][issue] GitHub.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[conf]: http://developer.telldus.com/wiki/TellStick_conf
[issue]: https://github.com/erik73/addon-tellsticklive/issues
[protocol-list]: http://developer.telldus.com/wiki/TellStick_conf
[repository]: https://github.com/erik73/hassio-addons
