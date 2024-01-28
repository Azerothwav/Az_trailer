
# Update

  

Simple quality of life update for az_trailer

* Removed RageUI Menu and implemented QB-Target & QB-Menu

* Moved location to Mosley's Auto Service in Southside, opposite Mega Mall

* Added some more config options

* Updated notifies

* Updated locale

* TO-DO: Add 'tr2' trailer

# Dependencies

* QB-Core

* QB-Target

* QB-Menu

* Tested with lj-inventory / qb-inventory


# Installation

* Download ZIP

* Drag and drop resource into your server files

* Rename folder to "az_trailer"

* Start resource through server.cfg

* Add this to your qb-target\init.lua inside of the Config.TargetModels table:

  

```lua

["TrailerRental"] = {

models = {

`S_F_M_Autoshop_01`,

},

options = {

{

type = "client",

event = "az-trailer:openMenu",

icon = "fas fa-car",

label = "Rent Trailer",

},

},

distance = 4.0

},
```

  

* (Optional)  Add  this  to  your  ps-ui\html\style.css

```css

.warning {

background-color: rgba(236, 176, 11, 0.85);

color: #333333;

}
```

  

## Commands

The basic commands present are :

- Attach/detach the vehicle to the trailer - ("/attach"), ("/detach")

- Open and close the trunk to the Tr2 (one large tow truck for several vehicles) - ("/opentrunktr2"), ("/closetrunktr2"),

- Slide the ramp to access the second floor of the Tr2 - ("/openramptr2"), ("/closeramptr2"),

- Install and remove a ramp for easier access to the vehicle - ("/setramp"), ("/deleteramp"),

  

# Preview

https://youtu.be/25m407oDAMg

  

# Credits

  

* [az_trailer](https://github.com/Azerothwav/Az_trailer)

  

### Original README Below

  

![Group 2 (1)](https://user-images.githubusercontent.com/76072277/197746206-2dd745ef-1605-4be4-9cc3-3197df5b4d1c.png)

  

[![Love](http://ForTheBadge.com/images/badges/built-with-love.svg)](https://github.com/Azerothwav) [![name](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://forum.cfx.re/t/realistic-vehicle-failure-repair-fix/4887760/2) [![name](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/channel/UCH7coJ4d1gqh8BMMHacGQ5A) [![LUA](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/azeroth)

  

## Informations

The az_trail is a script that will allow you to use boat, motorcycle, car, helicopter and plane trailers. But what is the difference with other trailer script that we can already find then? All the positions that your vehicles will adopt on the trailer are dynamic, which means that you don't need to make a configuration of each position on each trailer.

This script offer you this for free and with a non-encrypted code. I use RageUI to make the trailer store menus but you can totally change to put your own menus since the code is totally open source.

  

## Configuration

A vehicle configuration that can be used as a remoque is present, allowing you to choose which class of vehicle it can accommodate, I made it as simplistic as possible to avoid you spending too much time on it!

Trailer vendors are configurable very quickly in the configuration allowing you also to limit them to certain trades.

Translation in the configuration file for your convenience as well.

  

## Ramp

Because it can be sometimes complicated to access a vehicle that will be used as a trailer, a command is available to install a small ramp that will allow you to access more quickly, it is created only in the customer of the one who installs it to avoid problems of trolleurs, a command can also remove this ramp.

Small novelty which also makes its appearance in this script, the accounting QBCore included. From now on you could totally use the scripts directly also in QBCore, you just have to go in the config to activate it.

  

## Pictures of the script

  

### Cars

![alt text](https://cdn.discordapp.com/attachments/912680553503948821/998900214884741140/auto.PNG?width=1440&height=611)

### Boat

![alt text](https://cdn.discordapp.com/attachments/912680553503948821/998900215190933555/bateau.PNG)

### Trailer for several cars

![alt text](https://cdn.discordapp.com/attachments/912680553503948821/998900215539044433/bigauto.PNG?width=1440&height=513)

### Moto

![alt text](https://cdn.discordapp.com/attachments/912680553503948821/998900215803293706/moto.PNG?width=1440&height=499)

### Rampe

![alt text](https://cdn.discordapp.com/attachments/912680553503948821/998900216193355817/rampe.PNG?width=1263&height=701)

### Preview

https://youtu.be/3dT0VTdSASQ

  

## Commands

The basic commands present are :

- Attach the vehicle to the trailer

- Detach the vehicle from the trailer

- Open and close the access ramp to the Tr2 (one large tow truck for several vehicles)

- Slide the ramp to access the second floor of the Tr2

- Install and remove a ramp for easier access to the vehicle