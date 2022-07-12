import cv2
from cv2 import GaussianBlur
from cv2 import Canny
import numpy as np

def getContours(img,cThr=[100,100], showCanny=False, minArea=1000, filter=0, draw=False): #100,100 Verändern für Edge Detection bei Canny #ShowCanny=True für Vorschau #Filter für geometrische Figuren
    imgGray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) #Bild wird schwarz weiß
    imgBlur=cv2.GaussianBlur(imgGray,(5,5),1) #Kernel 5*5
    imgCanny=cv2.Canny(imgBlur,cThr[0], cThr[1])
    #Smoothing der Kanten
    kernel= np.ones((5,5))
    imgDial = cv2.dilate(imgCanny,kernel,iterations=3)
    imgThre=cv2.erode(imgDial,kernel,iterations=2)
    if showCanny:
         #cv2.imshow('Canny', imgCanny)
         cv2.imwrite("F:\\Projektseminar\\Edge Detection\\Kanten.jpg", imgCanny) 

    contours,hierarchy= cv2.findContours(imgThre,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE) #Filter für bestimmte Formen
    finalContours= []
    for i in contours:
        area=cv2.contourArea(i)
        if area > minArea:
            peri=cv2.arcLength(i,True) #True weil Area geschlossen ist
            approx =cv2.approxPolyDP(i,0.02*peri,True) #0.02 ist die Resolution
            bbox=cv2.boundingRect(approx)
            if filter >0:
                if len(approx) == filter:
                    finalContours.append([len(approx), area, approx, bbox, i])
            else:   
                finalContours.append([len(approx), area, approx, bbox, i])
    finalContours = sorted(finalContours,key= lambda x:x[1], reverse=True) #Reverse=True für Absteigend
    if draw:
        for con in finalContours:
            cv2.drawContours(img,con[4],-1,(0,0,255),3) #Farbe (Rot); Dicke (3)

    return img, finalContours

def reorder(myPoints):
    #print(myPoints.shape)
    myPointsNew=np.zeros_like(myPoints)
    myPoints=myPoints.reshape((4,2))
    add=myPoints.sum(1)
    myPointsNew[0]=myPoints[np.argmin(add)]
    myPointsNew[3]=myPoints[np.argmax(add)]
    diff = np.diff(myPoints,axis=1)
    myPointsNew[1]=myPoints[np.argmin(diff)]
    myPointsNew[2]=myPoints[np.argmax(diff)]
    return myPointsNew

def warpImg (img,points,w,h): #Höhe und Breite des Bilds 
    # print(points)
    points=reorder(points)
    pts1=np.float32(points)
    pts2= np.float32([[0,0],[w,0],[0,h],[w,h]])
    matrix=cv2.getPerspectiveTransform(pts1,pts2)
    imgWarp= cv2.warpPerspective(img,matrix,(w,h)) #w,h, sollen die letztendliche Image Size sein: bei uns nicht
    return(imgWarp)
    #Hier wird noch Padding genutzt um die Bildränder zu verkleinern aber für uns irrelevant minute:41

def findDis(pts1,pts2):
    return ((pts2[0]-pts1[0])**2+(pts2[1]-pts1[1])**2)**0.5 #Distanz der Linie