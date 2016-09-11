DROP TABLE eco.tracks;
DROP TABLE eco.aircraft_tracks;
DROP TABLE eco.aircrafts;

CREATE SCHEMA eco;

CREATE TABLE eco.aircrafts ( 
	icao                 text  NOT NULL,
	engine               text  ,
	reg_number           text  ,
	CONSTRAINT pk_aircrafts PRIMARY KEY ( icao )
 );

CREATE TABLE eco.aircraft_tracks ( 
	track                bigserial  NOT NULL,
	icao                 text  ,
	first_time  		 timestamp,
	last_time            timestamp  ,
	callsign_last_time   timestamp  ,
	altitude_last_time   timestamp  ,
	speed_angle_vert_last_time      timestamp  ,
	coordinate_last_time   timestamp  ,

	CONSTRAINT pk_aircraft_tracks PRIMARY KEY ( track )
 );

CREATE INDEX idx_aircraft_tracks ON eco.aircraft_tracks ( icao );

CREATE TABLE eco.tracks ( 
	time_track           timestamp  NOT NULL,
	track                bigint  ,
	callsign             text  ,
	altitude             integer  ,
	speed                smallint  ,
	angle                smallint  ,
	latitude             real  ,
	longitude            real  ,
	vertical_speed       smallint  ,
	CONSTRAINT idx_tracks UNIQUE ( time_track, track ) 
 );

ALTER TABLE eco.aircraft_tracks ADD CONSTRAINT fk_aircraft_tracks_aircrafts FOREIGN KEY ( icao ) REFERENCES eco.aircrafts( icao ) ON DELETE RESTRICT;

COMMENT ON CONSTRAINT fk_aircraft_tracks_aircrafts ON eco.aircraft_tracks IS '';

ALTER TABLE eco.tracks ADD CONSTRAINT fk_tracks_aircraft_tracks FOREIGN KEY ( track ) REFERENCES eco.aircraft_tracks( track );

COMMENT ON CONSTRAINT fk_tracks_aircraft_tracks ON eco.tracks IS '';

