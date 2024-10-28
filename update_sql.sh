#!/bin/sh

echo >> initdb.sql 'INSERT INTO guacamole_connection (connection_id, connection_name, protocol, failover_only) VALUES ("1", "Jumphost RDP", "rdp", "f")
INSERT INTO guacamole_entity (entity_id, name, type) VALUES ("2", "jhuser", "USER")
INSERT INTO guacamole_user (user_id, entity_id, password_hash, password_salt, password_date) VALUES ("2", "2", "\\xd19bc9910ccbee3220e107204a402167bc36e1623beeee37887f6cd264ac883c", "\\xd400d52caf6d5096df5a153078901bff9c5cfdcd764aa9e45c1c7458ae9690b3", "2024-10-28 14:21:44.885+00")
INSERT INTO guacamole_connection_permission (entity_id, connection_id, permission) VALUES ("1", "1", "READ")
INSERT INTO guacamole_connection_permission (entity_id, connection_id, permission) VALUES ("1", "1", "UPDATE")
INSERT INTO guacamole_connection_permission (entity_id, connection_id, permission) VALUES ("1", "1", "DELETE")
INSERT INTO guacamole_connection_permission (entity_id, connection_id, permission) VALUES ("1", "1", "ADMINISTER")
INSERT INTO guacamole_connection_permission (entity_id, connection_id, permission) VALUES ("2", "1", "READ")'
