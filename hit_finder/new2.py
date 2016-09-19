from astropy.io import fits as pyfits 
import numpy as np

# L = [(1,2),(3,4)]

# size_x=size_y=5
# arr=np.zeros((size_x, size_y))
# # x = np.array( list(((2,3), (3, 5)) ))


# for (x,y) in L:
# 	arr[x][y]=1

# print(arr)




N = 3
L = [[(2,1)],[(1, 1), (1, 2), (1, 3), (3, 2)],[(3,3),(2,1)]]

# zero NxN matrix
# m = [[0 for _ in range(N)] for _ in range(N)]


arr=np.zeros((N, N))

for A in L:
	for (x,y) in A:
		arr[x-1][y-1]=1


# for A in L:
# # Loop over the tuples
# 	for (x,y) in A:
#  	# indexing starts at 0
# 		m[x - 1][y - 1] = 1

# print the matrix
# for row in m:
#     print(' '.join(map(str, row)))







pyfits.writeto('out.fits', arr, checksum=True)















# # # def adjacent(list_1, list_2):
# # #     for elem_1 in list_1:
# # #         for elem_2 in list_2:
# # #             if abs(elem_1[0] - elem_2[0]) == 1 or\
# # #                abs(elem_1[1] - elem_2[1]) == 1:
# # #                    return True
# # #     return False

# # # def join_adjacent_points(L):
# # #     result = []
# # #     while len(L) > 0:
# # #         result.append(L[0])
# # #         L = L[1:]
# # #         for i in range(0, len(L)):
# # #             if adjacent(L[i], result[-1]):
# # #                 result[-1] += L[i]
# # #                 del L[i]
# # #                 i = 0
# # #     return result


# # # A=[(1,1)]
# # # B=[(1,2)]
# # # C=[(3,5)]
# # # D=[(2,2)]


# # # L=[A, B, C, D]

# # # # N=0
# # # # main=L[N]
# # # # while union:
# # # # 	for (x,y) in main: # for all points in L[0]
# # # # 		for i in range(N+1, len(L)): # for every other array 
# # # # 			if (x-1,y-1) in L[i] or (x-1,y) in L[i] or (x-1,y+1) in L[i] or (x,y-1) in L[i] or (x,y+1) in L[i] or (x+1,y-1) in L[i] or (x+1,y) in L[i] or (x+1,y+1) in L[i]:
# # # # 				L[N]+=L[i] # union
# # # # 			else:
				






# # # # 	print('ok')

# # # NEW_L=join_adjacent_points(L)
# # L2=[[(0, 0), (0, 1), (1, 0)], [(0, 4), (0, 5), (1, 5)], [(0, 8), (0, 9), (1, 10), (0, 11), (0, 12), (0, 13)], [(2, 2), (2, 3), (3, 3), (3, 2)], [(1, 8), (2, 8), (3, 9), (2, 10)], [(3, 8), (4, 8), (5, 8), (6, 8), (7, 8), (8, 8), (8, 7)], [(5, 0), (6, 0)], [(7, 5), (8, 5), (9, 5), (10, 6), (10, 7)], [(10, 5), (11, 5), (12, 6), (13, 5), (12, 5), (13, 4), (12, 4)], [(10, 13), (10, 14), (11, 13), (12, 14), (12, 13)], [(11, 1), (11, 2), (12, 2), (13, 1), (14, 1), (13, 0), (12, 0), (11, 0)], [(12, 8), (12, 9)], [(14, 5)]]

# # # print(L2[2])

# # # def adjacent(list_1, list_2):
# # #     for elem_1 in list_1:
# # #         for elem_2 in list_2:
# # #             if abs(elem_1[0] - elem_2[0]) == 1 or\
# # #                abs(elem_1[1] - elem_2[1]) == 1:
# # #                    return True
# # #     return False

# # # def join_adjacent_points(L):
# # #     result = []
# # #     while len(L) > 0:
# # #         result.append(L[0])
# # #         L = L[1:]
# # #         for i in range(0, len(L)):
# # #             if adjacent(L[i], result[-1]):
# # #                 result[-1] += L[i]
# # #                 del L[i]
# # #                 i = 0
# # #     return result


# # def adjacent(list_1, list_2):
# #     for elem_1 in list_1:
# #         for elem_2 in list_2:
# #             if abs(elem_1[0] - elem_2[0]) == 1 or\
# #                abs(elem_1[1] - elem_2[1]) == 1:
# #                    return True
# #     return False

# # def join_adjacent_points(L):
# #     result = []
# #     while len(L) > 0:
# #         result.append(L[0])
# #         L = L[1:]
# #         i = 0
# #         while i < len(L):
# #             if adjacent(L[i], result[-1]):
# #                 result[-1] += L[i]
# #                 del L[i]
# #                 i = 0
# #             i += 1
# #     return result



# # # L=[[(1,2)],[(2,2),(10,10)],[(4,4)],[(5,4)]]

# # res=join_adjacent_points(L2)
# # print(res)
