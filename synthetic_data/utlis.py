import cv2
from cv2 import GaussianBlur
from cv2 import Canny
import numpy as np

def getContours(img,cThr=[100,100], showCanny=False): #100,100 Verändern für Edge Detection bei Canny #ShowCanny=True für Vorschau
    imgGray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY) #Bild wird schwarz weiß
    imgBlur=cv2.GaussianBlur(imgGray,(5,5),1) #Kernel 5*5
    imgCanny=cv2.Canny(imgBlur,cThr[0], cThr[1])
    if showCanny: cv2.imshow('Canny', imgCanny)