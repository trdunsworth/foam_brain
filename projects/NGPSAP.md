# NG PSAP Meeting - NENA SBP

Introductions - Steve McMurrer, Michael Smith, Dr. Tony Dunsworth

## PSAP vs ECC

- PSAP is a physical or virtual centre where 9-1-1 calls are received
- ECC is a facility to receive and process requests for emergency assistance.

This standard applies to both.

From the OSP to the NGCS - to the NG PSPA/ECC

Will also discuss the EIDO and that data flow including external service providers.

## NG-PSAP / ECC Service in these 

NENA-STA-023 - MN9-1-1 PSAP and ECC Specifications for the NENA i3 Solution 

- This is in the process of finishing up
- Nearly ready for public review

### Technical

QR Code to the [NENA KB](https://nena.org)

SIP Call interface with video, voice, and text. We also cover the EIDO which can be used to exchange data between different FEs. *Saving Seconds can Save Lives* The point is to speed up the delivery of data and simplify how we get the data moving. User and Server credentials will be used to validate and verify who does what and codifies. We can also use data rights management rules to determine who gets to see what data. 

Agent state has had a lot of work completed. Who is available for what and where are we? Logging and recording to make robust chains of custody. 

### FEs

What is a Functional Element (FE)? It is the part of the system that talks to other systems or FEs. It connects more than one system and does something to move data from one place to another. They also have interfaces that allow for interaction. 

### EIDO

This group discusses the plumbing that moves data, through the EIDO, to share incident information between and among authorized entities.
The EIDO standard is defined in NENA-STA-021. The EIDO Conveyance standard, how to move that data, is defined in NENA-STA-024.

The EIDO is not an incident record, but it is a container discussing the most current state of the incident when the data was transmitted. After consumption, the EIDO is discarded after logging. The data will be added to the incident through other means. The logged information will allow for the reconstruction of an incident after the fact. The goal is to supprt everything that an entity really needs to manage incident response. The data owner gets to control who gets to access what data and applies that relevant policy. 

* Question: Is the EIDO JSON?
* Answer: Yes, this is JSON and while JSON is meant to be human legible, the display in the presentation includes additional characters.

*When are EIDOs used*: Whenever an incident's state changes. When a call is transferred, etc. 

The IDX is the clearing house for many functions within the life of the call. When I call arrives, it is queued up after routing to the proper PSAP, the CHS then sends the call to the call taker. The EIDO gets generated, sent to the IDX, which then sends it outbound, including to the management console which receives everything to be able to monitor for performance and understands the state of the PSAP. It's an information hub for assessment. Dan points out that the management console receives everything through the logging function. Every EIDO is logged. The IDX isn't a hub, but it does have an aggregation function. The IDX will coalesce the data and provide the alternate data in a spearate section of the EIDO. 

The responder data service will work with the IDX to present the data out to the field. When a call is dispatched, the IDX and the RDS work together to update the management console and all of the other entities receive that data. For example, AVL data could use the RDS to give updated information about unit location.

In call transferring, we will be able to send all of the collected data that we know to the entity receiving the call. External entities can share multimedia with responders and the media proxy will allow the share to be consumed. 

* Question: Will external entities need a certificate to submit media to the proxy?
* Answer: We believe that it should be.

You can also control who gets to see what types of media. 
