import sys
import math
import psycopg2
from datetime import datetime, timedelta

# string=sys.stdin.read()
string='MSG,5,0,0,icao1,0,2016/08/02,18:02:55.751,2016/07/19,14:42:30.551,SVR2841,37000,50,14,55.520852,37.540712,1488,,,,,0'

string=string.rstrip()
string=string.split(',')
MSG_NUM=int(string[1])
icao_py=string[4]

time_py_1=string[6]
time_py_1=time_py_1.replace('/','-')
time_py_2=string[7]
time_py_2=str(int(float(time_py_2.replace(':',''))))
time_py_2=time_py_2[0:2]+':'+time_py_2[2:4]+':'+time_py_2[4:]
time_py=time_py_1+' '+time_py_2

time_py = datetime.strptime(time_py, "%Y-%m-%d %H:%M:%S")

print('TIME QUERY', time_py)

callsign_py=string[10]
altitude_py=string[11]
speed_py=string[12]
angle_py=string[13]
latitude_py=string[14]
longitude_py=string[15]      
vertical_speed_py=string[16] 

print('ANGLE', angle_py)

try:
    connect = psycopg2.connect(database='postgres', user='postgres', host='localhost', password='z5UHwrg8')
except:
    print("I am unable to connect to the database")
cursor = connect.cursor()

## MUST DELETE	
track_memory=300 # after - new track
param_memory=30 # 30 sec we remember, if more, than NULL 
max_req_speed=1 # filer, not more than 1 Hz for every MSG 
##

# TRY TO FIND LAST TRACK FOR THIS ICAO
SQL="""
SELECT * from eco.aircraft_tracks where icao=(%s) ORDER BY track desc LIMIT 1;
"""
data=(icao_py,)
cursor.execute(SQL, data)
time_answer=cursor.fetchall()
# time_now=datetime.now() 

print('last_time', time_answer[0][2])
print('time_py-last_time', time_py-time_answer[0][2])

## TRACK EXIST AND IT MUST BE ADDED
if time_answer and time_py-time_answer[0][2] < timedelta(seconds=track_memory):
	print('MUST BE ADDED')
	# OBTAIN FULL INFORMATION ABOUT LAST DATA_WRITE TO TRACK
	last_track=time_answer[0][0] 
	print("LAST TRACK", last_track)
	last_time=time_answer[0][2] # USED FOR NEW TRACK OR OLD
	# callsign_last_time=answer[0][3] # param 1
	# altitude_last_time=answer[0][4] # param 2
	# speed_angle_vert_last_time=answer[0][5] # param 3
	# coordinate_last_time=answer[0][6] # param 5
	last_msg_time={
	1 : time_answer[0][3],
	3 : time_answer[0][6],
	4 : time_answer[0][5],
	5 : time_answer[0][4],
	7 : time_answer[0][4],
	}

	print('LAST_MSG', last_msg_time[MSG_NUM])
	# print(time_py-last_msg_time[MSG_NUM] < timedelta(seconds=max_req_speed))
	## SPEED OF MSG IS OK
	if time_py-last_msg_time[MSG_NUM] > timedelta(seconds=max_req_speed):
		# print('mot flood')
		## OBTAIN ALL PREVIUS INFO (NOT NULL) BESIDES CALLSIGN because cant use UNION (TEXT and INT)
		SQL="""
		(SELECT altitude FROM eco.tracks WHERE track=(%s) AND altitude IS NOT NULL ORDER BY time_track desc LIMIT 1)
		UNION ALL
		(SELECT speed FROM eco.tracks WHERE track=(%s) AND speed IS NOT NULL ORDER BY time_track desc LIMIT 1)
		UNION ALL
		(SELECT angle FROM eco.tracks WHERE track=(%s) AND angle IS NOT NULL ORDER BY time_track desc LIMIT 1)
		UNION ALL
		(SELECT latitude FROM eco.tracks WHERE track=(%s) AND latitude IS NOT NULL ORDER BY time_track desc LIMIT 1)
		UNION ALL
		(SELECT longitude FROM eco.tracks WHERE track=(%s) AND longitude IS NOT NULL ORDER BY time_track desc LIMIT 1)
		UNION ALL
		(SELECT vertical_speed FROM eco.tracks WHERE track=(%s) AND vertical_speed IS NOT NULL ORDER BY time_track desc LIMIT 1)
		"""
		
		data=(last_track, last_track, last_track, last_track, last_track, last_track)
		cursor.execute(SQL, data)
		param_answer= cursor.fetchall()

		SQL="""
		(SELECT callsign FROM eco.tracks WHERE track=(%s) AND callsign IS NOT NULL ORDER BY time_track desc LIMIT 1)
		"""
		
		data=(last_track, )
		cursor.execute(SQL, data)
		callsign_answer= cursor.fetchall()

		total_param=callsign_answer + param_answer

		last_time_param=[time_answer[0][3], time_answer[0][4], time_answer[0][5], time_answer[0][5], time_answer[0][6], time_answer[0][6], time_answer[0][5]]

		param_to_write=()
		for x in range(7):
			## PREVIOUS PARAM IS NOT TOO OLD, else -1
		   	if time_py-last_time_param[x] < timedelta(seconds=param_memory):
		   		param_to_write+=(total_param[x][0],)
		   	else:
		   		param_to_write+=(-1,)

		## PREVIOUS DATA
		param_to_write=(time_py, )+(last_track,)+param_to_write

		## UPDATE
		def upd_msg_1():
		  callsign_py
		  x = list(param_to_write)
		  x[2] = callsign_py
		  print(callsign_py)
		  x = tuple(x)
		  SQL='UPDATE eco.aircraft_tracks SET (callsign_last_time) = (%s) WHERE track=(%s);'
		  data=(time_py, last_track)
		  cursor.execute(SQL, data)
		  return(x)

		def upd_msg_3():
		  # global param_to_write
		  x = list(param_to_write)
		  x[3] = int(float(altitude_py))
		  x[6] = float(latitude_py)
		  x[7] = float(longitude_py)
		  x = tuple(x)
		  SQL='''
		  UPDATE eco.aircraft_tracks SET (coordinate_last_time) = (%s) WHERE track=(%s);
		  UPDATE eco.aircraft_tracks SET (altitude_last_time) = (%s) WHERE track=(%s);
		  '''
		  data=(time_py, last_track, time_py, last_track)
		  cursor.execute(SQL, data)

		  return(x)

		def upd_msg_4():
		  # global param_to_write
		  x = list(param_to_write)
		  x[4] = int(float(speed_py))
		  x[5] = int(float(angle_py))
		  x[8] = int(float(vertical_speed_py))
		  x = tuple(x)
		  SQL='UPDATE eco.aircraft_tracks SET (speed_angle_vert_last_time) = (%s) WHERE track=(%s);'
		  data=(time_py, last_track)
		  cursor.execute(SQL, data)
		  return(x)

		def upd_msg_5():
		  # global param_to_write
		  x = list(param_to_write)
		  x[3] = int(float(altitude_py))
		  x = tuple(x)
		  SQL='UPDATE eco.aircraft_tracks SET (altitude_last_time) = (%s) WHERE track=(%s);'
		  data=(time_py, last_track)
		  cursor.execute(SQL, data)
		  return(x)

		def upd_msg_7():
		  # global param_to_write
		  x = list(param_to_write)
		  x[3] = int(float(altitude_py))
		  x = tuple(x)
		  SQL='UPDATE eco.aircraft_tracks SET (altitude_last_time) = (%s) WHERE track=(%s);'
		  data=(time_py, last_track)
		  cursor.execute(SQL, data)
		  return(x)


		upd_msg = {
			1 : upd_msg_1,
			3 : upd_msg_3,
			4 : upd_msg_4,
			5 : upd_msg_5,	
			7 : upd_msg_7,
		}

		## TOTAL UPDATED QUERY
		new_param_to_write=upd_msg[MSG_NUM]()
		print('PARAM TO WRITE', new_param_to_write)

		# ADD TO TRACK
		SQL = '''
		INSERT INTO eco.tracks (time_track, track, callsign, altitude, speed, angle, latitude, longitude, vertical_speed) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)
		ON CONFLICT (time_track) DO UPDATE SET callsign=EXCLUDED.callsign, altitude=EXCLUDED.altitude, speed=EXCLUDED.speed, angle=EXCLUDED.angle,  latitude=EXCLUDED.latitude, longitude=EXCLUDED.longitude,	vertical_speed= EXCLUDED.vertical_speed;
		UPDATE eco.aircraft_tracks SET (last_time) = (%s) WHERE track=(%s);
		'''
		data = new_param_to_write + (time_py,) + (last_track,)
		cursor.execute(SQL, data)

###REMOVE
	else: ## TOO FAST
		print('flood')
####

else: ## TRACK IS TOO OLD OR DOESNT EXIST
	print('TOO OLD OR DOESNT EXIST')
connect.commit()
cursor.close()
connect.close()