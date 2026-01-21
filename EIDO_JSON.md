# EIDO_JSON

## EIDO vs ALI: What are the new capabilities in NG9-1-1

- Etienne Paquet
- Amy McDowell
- Diane Harris

### Groups involved

- EIDO JSON Working Group
- EIDO Management Working Group
- EIDO Conveyance Working Group
- EIDO-IDX Concerns Working Group
- i3 Architecture
- NG PSAP
- Metrics Working Group

### Legacy

We started out with ALI connected to the phone nyumber *(Phase1)*, Phase 2 provides some geolocation with cell phones.

Some systems are still receiving ALI data through RS232 connections. *These are slow and data poor*

ALI Query Service is IP based and XML, but not widely used outside of Canada.

Most of the previous ALI standards date from as early as 2006 the latest from 2019.

### How do we function today?

One of the first things in a bank robbery, you will hear an alarm trigger, then calls, then break out the major incident checklist. May have media calling to get information. Now we have 2 getaway cars and they could be crossing jurisdiction boundaries. The goal is to cut the phone calls while still communicating information. 

CAD to CAD can be available, but they are manually created and are based on proprietary solutions. They allow for control of information, but at financial and technical expenses that could be very high.

The need for standards came from needing to transmit data across jurisdictions, but maybe outside of agreements between agencies. Functional elements across PSAPs need to be able to exchange information.

### New functions with NG9-1-1

All the information goes out to subscribers as it's updated without having to delay for calling everyone. Can also push data to organizations as needed and control what is sent to whom.

Question about who can receive an EIDO beyond ECCs and PSAPs. - This is something for future work. 
Question about the title. - To convince people to implement the EIDO because you have more data available.

There was an expectation of parity of the minimal information from the ALI - That would be the Geolocation and Additional Data sections from the EIDO and then add in other information. We can add nearly any data shard into an EIDO format and then moved as part of the EIDO. 

Question: Is there an EIDOLite? - In reference, Canada has tested compatibility in transfer of E9-1-1 data with the transfer. This will set up a transition to a full EIDO. Dan Mongrain has proposed a 5-step programme to the Canadian Government to move from E9-1-1 to full implementation. 

### What is the EIDO?

Using a train metaphor with each car being data about the incident. What is it? Where is it? What vehicles were involved? Who is involved? What units are involved?

Version 1 was published in 2021. 

It is the current known state of an incident when the EIDO was generated and shared. EIDOs **DO NOT** contain the incident history. That information must come from the logger. It is serialized JSON. **End users should *NEVER* have to look at the raw data**

#### Capabilities

- Caller information
- Call Information 
- Involved Agents, Agencies, and Resources
- Location information about anything in the incident
- vehicles
- And many other things

#### V1.1 Capabilities

- Media Sharing with MIME types.
- Special Caution Information about aspects of parts of the incident.
- Call leg state
- Shared Communication resource data
- Involved organizations
- Sharing available information from external databases.

Mr. Mongrain clarifies the Call Leg state and how the EIDOs will update upon addition or removal of parties to the conference calls. 

The idea about caution information is to relay known information about some aspect of a person/location/or other data that needs to be brought to the attention of the consumer.

It is simply a data structure.

### EIDO Conveyance

STA-024 defines the subscription and notification mechanism to maintain current incident status across FEs. 

The group is not active because the document was published in 2025.

### IDX 

It is mentioned in the i3 v3 document. It will be fleshed out better in v3.1. The IDX is designed to aggregate, apply DRM, and also address discrepancies between EIDOs it receives. Mr. Mongrain describes the IDX as the front door to get access to the data the CAD and other internal systems contain. Even if multiple devices can contain an IDX, you will determine which one you prefer to use as your IDX.

## END OF PART 1

##  PART 2

###  Data Sharing across borders. 

The agencies will subscribe to each other. So when there is something close to the border, they can coordinate their responses and ensure faster service. This is the beauty of subscriptions. Conveyance is done using HTTPS and secured WebSocket with mutual authenticated with X.509 certificates issued by a root CA. Each element's certificate contains the identities and roles and establish trust between agencies.

Agencies then can choose what information can be shared depending on authentication.

Mr. Smith asks about certificates and how to address different levels of sharing as data moves through inter-agency IDXes. How do you compartmentalize data sharing regardless of the existence of X.509 certificates? This is where policy and Data Rights management come in. The discussion is about trusting information to the IDX and to other agencies and how to apply your policies to the IDX and any other agencies. 

The intra-agency IDX is already well defined and will apply your policies. The inter-agency IDX is not as well defined and still needs to be better defined. 

Ms. McDowell is discussing the differences in what information is valuable to whom in a major incident. 

Mr. Smith, what about sharing references to the EIDO which allows for the data owner to apply their policy. The inter-agency wouldn't have the data, but references to the data in general. 

How do you parse the data, especially what appears in comments, to ensure some of that information gets recorded and transmitted. 

### Policy Examples

The slide shows various options for applying policies to determine who gets to access what data?

Analyze your SOPs, create a matrix of how that impacts your information sharing agreements and policies.

This is a good starting point to determine what you share, with whom, and when you share it.

### Future issues

- Data Rights Management
- Policy Store
- What is meant by Caution and Important Information?

### Current State

Currently reviewing the style editor comments. There are no major changes anticipated.

Charter revision to the EIDO Management WG to change to a Reference document

EIDO-IDX working group is updating the EIDO FAQs and making progress.

## What are we missing?

Join our working groups to make a difference.
