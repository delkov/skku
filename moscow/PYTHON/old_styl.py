import sys
import math
import psycopg2

string=sys.stdin.read()
string=string.rstrip()
string=string.split(',')

print(string)

MSG_NUM=string[1]
icao_py=string[4]

time_py_1=string[6]
time_py_1=time_py_1.replace('/','-')
time_py_2=string[7]
time_py_2=str(int(float(time_py_2.replace(':',''))))
time_py_2=time_py_2[0:2]+':'+time_py_2[2:4]+':'+time_py_2[4:]
time_py=time_py_1+' '+time_py_2

callsign_py=str[10]
altitude_py=str[11]
speed_py=str[12]
angle_py=str[13]
latitude_py=str[14]
longitude_py=str[15]      
vertical_speed_py=str[16] 

print("ICAO", ICAO, end='\n')
print("DATE_TIME", date_time_py, end='\n')
print("CALLSIGN", callsign_py, end='\n')
print("ALTITUDE", altitude_py, end='\n')
print("SPEED", speed_py, end='\n')
print("ANGLE", angle_py, end='\n')
print("LATITUDE", latitude_py, end='\n')
print("LONGITUDE", longitude_py, end='\n')
print("VERTICAL SPEED", vertical_speed_py, end='\n')

## IF MSG IN!!!!

# CONNECT TO POSTGRESQL
try:
	connect = psycopg2.connect(database='postgres', user='postgres', host='localhost', password='z5UHwrg8')
except:
    print("I am unable to connect to the database")

cursor = connect.cursor()

try:
	cursor.execute("""
		INSERT INTO aircrafts(icao) 
	    VALUES (icao_py)
    	ON CONFLICT (icao) DO NOTHING;
    	""")
except:
	print("Error INSERT into aircrafts")


# CHECK ICAO 
SQL="""
SELECT track from eco.aircraft_tracks where icao=(%s) ORDER BY track desc LIMIT 1;
"""
data=('icao_py',)
cursor.execute(SQL, data)
last_air_track=cursor.fetchall()[0][0]


if existed_track:

# FIND LAST TRACK FOR THIS ICAO
	SQL = "select track from eco.aircraft_tracks where icao=(%s) order by track desc LIMIT 1;"
	data = (icao_py, ) # remove to icao_py
	cursor.execute(SQL, data)
	last_air_track = cursor.fetchone()[0]
	print('Track', last_air_track)
	
	# OBTAIN TIME
	SQL = "select * from eco.aircraft_tracks where track=(%s);"
	data = (last_air_track,)
	cursor.execute(SQL, data)
	answer = cursor.fetchone()
	
	callsign_last_time=answer[2]
	altitude_last_time=answer[3]
	speed_last_time=answer[4]
	angle_last_time=answer[5]
	coordinate_last_time=answer[6]
	vertical_speed_last_time=answer[7]
	
	time=datetime.datetime.now()

# OBTAIN LAST NOT NULL TRACK INFO
	SQL="""
	
	(SELECT * FROM eco.tracks WHERE track=(%s) AND callsign IS NOT NULL ORDER BY time_track desc LIMIT 1)
	UNION ALL
	(SELECT * FROM eco.tracks WHERE track=(%s) AND altitude IS NOT NULL ORDER BY time_track desc LIMIT 1)
	UNION ALL
	(SELECT * FROM eco.tracks WHERE track=(%s) AND speed IS NOT NULL ORDER BY time_track desc LIMIT 1)
	UNION ALL
	(SELECT * FROM eco.tracks WHERE track=(%s) AND angle IS NOT NULL ORDER BY time_track desc LIMIT 1)
	UNION ALL
	(SELECT * FROM eco.tracks WHERE track=(%s) AND latitude IS NOT NULL ORDER BY time_track desc LIMIT 1)
	UNION ALL
	(SELECT * FROM eco.tracks WHERE track=(%s) AND longitude IS NOT NULL ORDER BY time_track desc LIMIT 1)
	UNION ALL
	(SELECT * FROM eco.tracks WHERE track=(%s) AND vertical_speed IS NOT NULL ORDER BY time_track desc LIMIT 1)
	
	"""
	data=(last_air_track, last_air_track, last_air_track, last_air_track, last_air_track, last_air_track, last_air_track )
	cursor.execute(SQL, data)
	answer= cursor.fetchall()
	
	if callsign_last_time and time-callsign_last_time < datetime.timedelta(seconds=300):
		callsign_new=answer[0][2]	
	else:
		callsign_new=''
	
	if altitude_last_time and time-altitude_last_time < datetime.timedelta(seconds=300):
		altitude_new=answer[1][3]
	else:
		altitude_new=-1
	
	if speed_last_time and time-speed_last_time < datetime.timedelta(seconds=300):
		speed_new=answer[2][4]
	else:
		speed_new=-1
	
	if angle_last_time and time-angle_last_time < datetime.timedelta(seconds=300):
		angle_new=answer[3][5]
	else:
		angle_new=-1
	
	if coordinate_last_time and time-longitude_last_time < datetime.timedelta(seconds=300):
		latitude_new=answer[4][6]
		loongitude_new=answer[5][7]
	else:	
		latitude_new=-1
		longitude_new=-1
	
	if vertical_speed_last_time and time-vertical_speed_last_time < datetime.timedelta(seconds=300):
		vertical_speed_new=answer[6][8]
	else:
		vertical_speed_new=-1
	
	## CASE: MSG=1 -> ...
	
	speed_new=500;
	MSG_NUM=4;
	if MSG_NUM == 1:
	    SQL='UPDATE eco.aircraft_tracks SET (callsign_last_time) = (%s) WHERE track=(%s);'
	    data=(time_py, last_air_track)
	    cursor.execute(SQL, data)
	elif MSG_NUM == 3:
	    SQL='UPDATE eco.aircraft_tracks SET (altitude_last_time, coordinate_last_time) = (%s, %s) WHERE track=(%s);'
	    data=(time_py,time_py, last_air_track)
	    cursor.execute(SQL, data)
	elif MSG_NUM == 4:
	    SQL='UPDATE eco.aircraft_tracks SET (speed_last_time, angle_last_time, vertical_speed_last_time) = (%s, %s, %s) WHERE track=(%s);'
	    data=(time_py, time_py, time_py, last_air_track)
	    cursor.execute(SQL, data)
	elif MSG_NUM == 5:
	    SQL='UPDATE eco.aircraft_tracks SET (altitude_last_time) = (%s) WHERE track=(%s);'
	    data=(time_py, last_air_track)
	    cursor.execute(SQL, data)
	elif MSG_NUM == 7:
	    SQL='UPDATE eco.aircraft_tracks SET (altitude_last_time) = (%s) WHERE track=(%s);'
	    data=(time_py, last_air_track)
	    cursor.execute(SQL, data)
	
	
	# ADD INFO TO TRACK
	SQL = 'INSERT INTO eco.tracks (time_track, track, callsign, altitude, speed, angle, latitude, longitude, vertical_speed) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s);'
	data = (time_py, last_air_track, callsign_new, altitude_new, speed_new, angle_new, latitude_new, longitude_new, vertical_speed_new,)
	cursor.execute(SQL, data)
	
	# OBTAIN ALL VARS (speed, cord..)
	# speed=..
	
	# IF MSG-> time - last_time_speed < 10 -> speed= ..
	# ELSE NULL
	
	    SQL = 'INSERT INTO eco.tracks (time_track, track, callsign, altitude, speed, angle, latitude, longitude, vertical_speed) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s);'
	    data = ()
	###########DONE!##########
else:
	# ADD TRACK_AIR
    SQL= 'INSERT INTO eco.aircraft_tracks (icao) VALUES (%s) RETURNING track;'
    data = (icao_py, )
    cursor.execute(SQL, data)
    new_track=cursor.fetchone()[0]

    #ADD TRACK_INFO
    # dt = '2016-09-26 20:03:47' # data_format
    # callsign='test'
    SQL_VARS=['callsign)',')','altitude, latitude, longitude)','speed, track, vertical_speed)', 'altitude)', ')', 'altitude)',')']
    SQL_VALUES=['(%s, %s, %s);','(%s, %s);','(%s, %s, %s, %s, %s);','(%s, %s, %s, %s, %s);','(%s, %s, %s);', '(%s, %s);', '(%s, %s, %s);']
    SQL_DATA=['(dt, new_track, callsign,)', '(dt, new_track,)', '(dt, new_track, altitude, latitude, longitude,)','(dt, new_track,speed,track, vertical_speed,)','(dt, new_track,altitude,)','(dt, new_track)','(dt, new_track altitude,)']

    SQL= 'INSERT INTO eco.tracks (time_track, track,' + SQL_VARS[MSG_NUM-1] + ' VALUES ' + SQL_VALUES[MSG_NUM-1]
    data = eval(SQL_DATA[MSG_NUM-1])
    cursor.execute(SQL, data)

connect.commit()
cursor.close()
connect.close()