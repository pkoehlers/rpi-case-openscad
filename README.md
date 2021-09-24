# Raspberry Pi 4 case - remixed

Customizable cases for the raspberry pi 3b and 4.

Main reason for the remix was to fit a zigbee module with external antenna into it.

![Raspberry Pi 4 with antenna](images/rpi4_with_antenna.jpg?raw=true "RPI4 with antenna")
![Raspberry Pi 4 with antenna - inner](images/rpi4_with_antenna_inner.jpg?raw=true "RPI4 with antenna inner")

## Credits

Credits go to the OpenScad model by George Raven found here: https://www.prusaprinters.org/prints/4678-ravenpi-raspberry-pi-4-case

## Modifications:
* Added tolerances: (my raspberry did not fit in the original model)
  * to the board dimension itself
  * to all the connector cutouts
* Adaptions for a [CC2652P2 zigbee module](https://shop.codm.de/automation/zigbee/33/zigbee-cc2652p2-raspberry-pi-module):
  * Increased the height of the case to fit the module into it
  * decreased the size of the hole for the GPIO pins in the area covered by the module
  * added an antenna holder for this [antenna adapter](https://shop.codm.de/antennen/2.4ghz/7/u.fl-sma-antennenadapter-10cm)
* Added support for raspberry pi 3
* Added Customizer support
