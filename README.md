## Orbsec-backend

` == Under development ==`

Orbsec is a made-up company which is developing an asset management application.

The application covers critical elements, such as inventory and license-management. This project is an ilustration of that application.

###  Description

This application exposes several Rest endpoints, which allow basic CRUD operations.
If you imagine the `Organization-service` & `Licensing-service` as being 2 database entities, the relationship between entities would be OneToMany, meaning an organization can have multiple licenses associated with it.

When a new record is added to Organization database, an `OrganizationChangeEvent` is produced and published to (kafka) organization_events topic.
The Licensing service is listening to organization_events and reacts to incoming kafka messages.

The `OrganizationChangeEvent` object consists in:
- an identifier for the Organization record that has just been created/modified
- the type of database operation that has been performed (CREATION, UPDATE, DELETE)

When the message is received, the Licensing-service performs the following operations:
- it extracts the identifier of the Organization record that has been modified
- it makes an http request back to the `Organization-service`, in order to receive the recently updated organization record
- it saves the organization record into Redis cache

However, if the `OrganizationChangeEvent` contains a DELETE action:
- the `Licensing-service` evicts its Redis cache for the deleted Organization identifier
- it deletes all the licenses associated with the given Organization record.

### Completed

- logs are streamed over to Elastic stack
- tracing information are injected into each request and streamed over to Zipkin via Kafka

- service properties are centralized / served by the Configuration-service

### To fix
- Zipkin fails to read tracing info from kafka broker
- when deployed, orbsec services fail to find / connect to kafka broker
- orbsec-services fail to find / connect to config-service

### To do
- reactivate security rules which are temporary disabled to avoid injections a new authorization code every 5 min (a new branch will be available where security is enabled)



### Diagram

![Orbsec-backend-diagram.drawio.png](https://github.com/PetreVane/orbsec-backend/blob/main/screenshot/Orbsec-backend-diagram.drawio.png?raw=true)

### Source code

- [Gateway Service](https://github.com/PetreVane/orbsec-gateway-service)
- [Discovery service](https://github.com/PetreVane/discovery-service)
- [Configuration service](https://github.com/PetreVane/orbsec-configuration-service)
- [Licensing service](https://github.com/PetreVane/orbsec-license-service)
- [Organization service](https://github.com/PetreVane/organization-service/tree/main)

- [Configuration repository](https://github.com/PetreVane/orbsec-configuration-repo/)
