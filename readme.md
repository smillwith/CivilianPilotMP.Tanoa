# Civilian Pilot Tanoa #

![Civilian Pilot](https://raw.githubusercontent.com/smillwith/CivilianPilot.Tanoa/master/745ts7252512.jpg)

A semi realisitc simulation of an every day civilian air pilot flying passengers to and fro, across the island of Tanoa.

Arrive at the airport. Reach your aircraft. Refuel if needed. Taxi to the departures area. Greet your passengers. Plan your route. Take off. Arrive. Taxi to Arrivals. Engine Off. Instruct your passengers

TODO: 

* Add Tasks for Taxiing to/from runway
* Add 'repair complete' and 'fuel complete' events to return trucks to their markers
* Implement basic ATIS with Wind information
* Toggle map details
* Make all hangars look like the ones at (La Rochelle?)
* Add more ambiance (in what way?)
* Implement RANDOM date/time
* Implement RANDOM start location

Notes:

What are the different states?

* Nothing
* Boarding
* Boarded
* Transporting/Flying (not implemented or needed yet)
* Arrived

Then there's things like:

* Current Airport
* Destination Airport
* Current Passenger group
* Current Fuel Truck
* Current Repair Truck

That change as you arrive at different airports and/or interact with passengers.

As you change planes/vehicles, CurrentPlane is changed. So technically you could 'drive' people to their destinations

-----

Sample workflow:

 - Nothing
 - Taxiing
 - Nothing
 - Boarding
 - Boarded
 - Transporting
 - Arrived
 - Get Out
 - Boarded = 0
 - Nothing

-----

Future considerations:

* ATIS - a semi dynamic automated information system that will relay date/time, weather and runway information for each airport
* Taxi instructions - tasks with details on how and where to taxi
* Custom Radio Freqs - if we integrate with TFR we can require that users check in with tower and ground on correct frequencies
* Random radio chatter
* Random air traffic
* Random ground traffic
* Regional controllers (keep you in correct altitude and away from hazards)
* Scrambling jets in the restricted airspace


-----

http://scottsasha.com/aviation/plans/commshandout.html
