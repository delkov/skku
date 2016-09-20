#!/usr/bin/python1
# BUG IS DONUTS SHAPE + JOIN AFTER (IF DIST =1 -> JOINN)
import sys
from itertools import product, combinations
import time
from astropy.io import fits as pyfits 
import numpy as np



if __name__ == "__main__":
    if len (sys.argv) > 1:
    	print(sys.argv[1])
        # print ("Привет, {}!".format (sys.argv[1] ) )
    	pass
    else:
        print ("Type filename!")
        sys.exit()


def square_distance(x, y):
	return sum([(xi - yi)**2 for xi, yi in zip(x, y)])


def filter(A, filter_side_square):
	max_square_distance = 0
	for pair in combinations(A, 2):
		if square_distance(*pair) > max_square_distance:
			max_square_distance = square_distance(*pair)
			max_pair = pair  # obtain max (x,y)
	return filter_side_square >= max_square_distance


def move(IM_A, point):
	x = point[0]
	y = point[1]
	# first left  #1
	# cursor in a unochable area and value of pixel > 0
	if (x - 1, y) in coordinates and IM_A[x - 1][y] > 0:
		return (x - 1, y)
	# arrow 2
	elif (x - 1, y + 1) in coordinates and IM_A[x - 1][y + 1] > 0:
		return (x - 1, y + 1)
	# arrow 3
	elif (x, y + 1) in coordinates and IM_A[x][y + 1] > 0:
		return (x, y + 1)
	# arrow 4
	elif (x + 1, y + 1) in coordinates and IM_A[x + 1][y + 1] > 0:
		return (x + 1, y + 1)
	# arrow 5
	elif (x + 1, y) in coordinates and IM_A[x + 1][y] > 0:
		return (x + 1, y)
	# arrow 6
	elif (x + 1, y - 1) in coordinates and IM_A[x + 1][y - 1] > 0:
		return (x + 1, y - 1)
	# arrow 7
	elif (x, y - 1) in coordinates and IM_A[x][y - 1] > 0:
		return (x, y - 1)
	# arrow 8
	elif (x - 1, y - 1) in coordinates and IM_A[x - 1][y - 1] > 0:
		return (x - 1, y - 1)
	# THE PICTURE IS END
	else:
		return False

width = 48
length = 48
filter_side_square = int(sys.argv[2]) or 8  # max_size ** 2

coordinates = list(product(range(width), range(length)))
print(coordinates)
# OBTAIN IM_A via pifts [[1,2 3,...],[1,2,3...,5,6]]

filename=sys.argv[1]
f = pyfits.open(str(filename))
# data=f[0].data
IM_A=f[0].data
# print(len(IM_A))
# print(IM_A[1])

# IM_A = [
# [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
# [0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1],
# [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0],
# [1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0],
# [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
# [1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0],
# [0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0],
# [0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0],
# [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
# [0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0],
# [0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1],
# [0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0],
# [0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1],
# [1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
# [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
# ]

# for i in range(len(IM_A)):
# 	print(IM_A[i], '')

# print(IM_A[46][0])

# BEGIN FROM LEFT CORNER
start_point = (0, 0)
temp_path = []  # tempory path
list_of_paths = []  # all the pathes

# ADD FRIST POINT IF HER PIXEL IS WHITE
if IM_A[start_point[0]][start_point[1]] > 0:
	temp_path.append(start_point)
	print('ok')
# WHILE EXIST UNTOUCHABLE PIXEL
while coordinates:
	# obtain new point to path
	next_point = move(IM_A, start_point)
	# print(next_point)
	# remove from coordinates, we've already were there!
	coordinates.remove(start_point)

	# we've correctly obtained new point
	if next_point:
		temp_path.append(next_point)  # add pointyt to path
		start_point = next_point
	else:
		if temp_path:  # and filter(temp_path): # filter by 3x3 matrix
			list_of_paths.append(temp_path)  # add to global paths
			# print(filter(temp_path))
		temp_path = []
		if coordinates:
			start_point = coordinates[0]  # choose any new start point
			# for x in coordinates: i not
			# 	coordinates.remove(x)

i=1
for pol in list_of_paths:
	print('POL',i, pol)
	i+=1

# print(list_of_paths)

## MERGE LISTS ##


def adjacent(list_1, list_2):
    for elem_1 in list_1:
        for elem_2 in list_2:
            if abs(elem_1[0] - elem_2[0]) <= 1 and\
               abs(elem_1[1] - elem_2[1]) <= 1:
                   return True
    return False

def join_adjacent_points(L):
    result = []
    while len(L) > 0:
        result.append(L[0])
        L = L[1:]
        i = 0
        while i < len(L):
            if adjacent(L[i], result[-1]):
                result[-1] += L[i]
                del L[i]
                i = 0
            i += 1
    return result


total_list=join_adjacent_points(list_of_paths)


## FILTER ##
real_total_list=[x for x in total_list if filter(x,filter_side_square)]


# total_list=[]
# forbidden_list=[]
# # temp_list=[]
# # print('L',L)
# for i in range(len(list_of_paths)-1):

# 	if i not in forbidden_list:
# 	# 11print(list(range(len(list_of_paths)-1)))
# 	# print('I is', i)
# 	# print("I", L[i])
# 	# temp_list=[]
# 	# print('L[i]',list_of_paths[i])
# 		temp_list=list_of_paths[i][:]
# 	#print('L[i]####', list_of_paths[i])
# 	# print('TEMP_LIST', temp_list)
# 		p=0
# 		for (x,y) in list_of_paths[i]:
# 		# print(p)
# 			p+=1
# 		# print('point 			', (x,y))
# 		# time.sleep(1) # delays for 5 seconds
# 			for j in range(i+1, len(list_of_paths)):
# 				if j not in forbidden_list:
# 					print(" p in I and atach J is ",(x,y), p, i+1, j)
# 			# print('L[j]', list_of_paths[j])
# 					if (x-1,y-1) in list_of_paths[j] or (x-1,y) in list_of_paths[j] or (x-1,y+1) in list_of_paths[j] or (x,y-1) in list_of_paths[j] or (x,y+1) in list_of_paths[j] or (x+1,y-1) in list_of_paths[j] or (x+1,y) in list_of_paths[j] or (x+1,y+1) in list_of_paths[j]:
				
# 						temp_list+=list_of_paths[j][:]
# 						forbidden_list.append(j)
# 				# list_of_paths.remove[list_of_paths[]]
# 						print('add')
# 						print('I', list_of_paths[i], 'J', list_of_paths[j])

# 		variety=set(temp_list)
# 		true_list=list(variety)
# 		print('TOTAL PATH',i+1, true_list)

# 		total_list.append(true_list)
# # total_list.append(list_of_paths[len(list_of_paths)-1])

# # print(total_list)

j=0
for l in real_total_list:
	j+=1
	print('PATH',j, l)


## create matrix ##

N = 48
# # L = [[(2,1)],[(1, 1), (1, 2), (1, 3), (3, 2)],[(3,3),(2,1)]]

# # zero NxN matrix
# m = [[0 for _ in range(N)] for _ in range(N)]

# for A in real_total_list:
# # Loop over the tuples
# 	for (x,y) in A:
#  	# indexing starts at 0
# 		m[x][y] = 1

# print the matrix
# for row in m:
#     print(' '.join(map(str, row)))


arr=np.zeros((N, N))
for A in real_total_list:
	for (x,y) in A:
		arr[x][y]=1


# for A in L:
# # Loop over the tuples
# 	for (x,y) in A:
#  	# indexing starts at 0
# 		m[x - 1][y - 1] = 1

# print the matrix
# for row in m:
#     print(' '.join(map(str, row)))





filename=time.strftime("%d%m%y_%H%M%S")
pyfits.writeto(filename+'.fits', arr, checksum=True)


# NOW WE'VE GOT A LIST OF PATHS
# print(list_of_paths)