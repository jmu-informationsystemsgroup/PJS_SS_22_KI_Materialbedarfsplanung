import cv2
import numpy as np

cThr=[35,35]
minArea=1000 
filter=0

img = cv2.imread("F:\\Projektseminar\\Edge Detection\\Aruco_Test.jpg")
imgGray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) #Bild wird schwarz weiß
imgBlur=cv2.GaussianBlur(imgGray,(5,5),1) #Kernel 5*5
imgCanny=cv2.Canny(imgBlur,cThr[0], cThr[1]) #Cannyfilter mit Werten aus Header
kernel= np.ones((5,5)) #Neues Array 5*5 groß
imgDial = cv2.dilate(imgCanny,kernel,iterations=3) #Neues Bild, welches verwässert ist
imgThre=cv2.erode(imgDial,kernel,iterations=2) #Neues Bild, welches verschlankt ist 
cv2.imwrite("F:\\Projektseminar\\Edge Detection\\Kanten2.jpg", imgCanny) 