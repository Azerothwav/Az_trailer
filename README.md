![Group 2 (1)](https://user-images.githubusercontent.com/76072277/197746206-2dd745ef-1605-4be4-9cc3-3197df5b4d1c.png)

[![Love](http://ForTheBadge.com/images/badges/built-with-love.svg)](https://github.com/Azerothwav) [![name](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://forum.cfx.re/t/realistic-vehicle-failure-repair-fix/4887760/2) [![name](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/channel/UCH7coJ4d1gqh8BMMHacGQ5A) [![LUA](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/azeroth)

## Table of Contents

- [Installation](#installation)
- [About](#about)
- [Informations](#informations)
- [Features](#features)
- [Configuration](#configuration)
- [Ramp](#ramp)
- [Commands](#commands)
- [Preview](#preview)
- [Support](#support)

---

## Installation
To install the script, run the following command:

```bash
curl https://github.com/Azerothwav/Az_trailer
```

---

## About
**Az_trailer** is an advanced and dynamic vehicle trailer script designed for use with boats, motorcycles, cars, helicopters, and planes. Unlike traditional trailer scripts, **Az_trailer** eliminates the need for manual configuration of vehicle positions on trailers. Instead, it dynamically calculates and adjusts positions, saving you time and effort.

The script is fully **open-source**, allowing for complete customization. It uses **RageUI** for trailer store menus, but you can easily integrate your own UI systems.

---

## Informations
The az_trail is a script that will allow you to use boat, motorcycle, car, helicopter and plane trailers. But what is the difference with other trailer script that we can already find then? All the positions that your vehicles will adopt on the trailer are dynamic, which means that you don't need to make a configuration of each position on each trailer. 
This script offer you this for free and with a non-encrypted code. I use RageUI to make the trailer store menus but you can totally change to put your own menus since the code is totally open source.

---

## Features

- **Dynamic Vehicle Positioning**: Automatically calculates and adjusts vehicle positions on trailers.
- **Customizable Trailers**: Define which vehicle classes can be attached to specific trailers.
- **Ramp System**: Deployable ramps for easy access to vehicles on trailers. Ramps are client-side to prevent trolling.
- **QBCore Integration**: Seamlessly integrates with QBCore. Enable it in the configuration file.
- **Multi-Language Support**: Includes translation files for easy localization.
- **Open-Source**: Fully customizable and transparent codebase.

---

## Configuration
The script is designed to be user-friendly and easy to configure. Key configuration options include:

- **Vehicle Classes**: Specify which vehicle classes can be used as trailers.
- **Trailer Vendors**: Customize trailer vendors and restrict them to specific jobs.
- **Language Support**: Translate the script into your preferred language using the provided configuration file.

---

## Ramp
Because it can sometimes be complicated to access a vehicle that will be used as a trailer, a command is available to install a small ramp that will enable you to access it more quickly. It is only created at the customer's site to avoid problems with trolleurs, and a command is also available to remove this ramp.
Another new feature of this script is the inclusion of QBCore accounting. From now on, you'll be able to use the scripts directly in QBCore too, simply by going to the config to activate it.

---

## Commands
Here are the available commands and their descriptions:

- **/attachtrailer** - Attach a vehicle to the trailer.
- **/detachtrailer** - Detach a vehicle from the trailer.
- **/opentrunktr2** - Open the access ramp for the Tr2 (a large tow truck for multiple vehicles).
- **/closetrunktr2** - Close the access ramp for the Tr2 (a large tow truck for multiple vehicles).
- **/openrampetr2** - Slide the ramp to access the second floor of the Tr2.
- **/closerampetr2** - Slide the ramp to access the second floor of the Tr2.
- **/setrampe** - Install a ramp for easier access to the vehicle.
- **/deleterampe** - Remove the installed ramp.

You can change all commands by accessing line 246 of the client file.
---

## Preview

Watch the script in action:  
[![YouTube Preview](https://img.shields.io/badge/YouTube-Preview-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/3dT0VTdSASQ)

---

## Support

If you find this project useful and would like to support its development, consider buying me a coffee:  
[![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/azeroth)

---

## License
This project is open-source and available under the [MIT License](LICENSE). Feel free to contribute, fork, or use it in your own projects!
