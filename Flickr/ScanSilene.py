import numpy as np
import cv2
import sys

def isThisSilene(filename):
  flower_cascade = cv2.CascadeClassifier('flower.xml')

  image = cv2.imread(filename)
  rows, cols, n = image.shape

  hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
  lower_pink = np.array([140, 50, 100], dtype=np.uint8)
  upper_pink = np.array([200, 255, 255], dtype=np.uint8)
  pinkmask = cv2.inRange(hsv, lower_pink, upper_pink);
  image = cv2.bitwise_and(image, image, mask=pinkmask)
  gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

  for theta in range(0, 360, 10):
    M = cv2.getRotationMatrix2D((cols/2,rows/2), theta, 1)
    rotated = cv2.warpAffine(gray, M, (cols,rows))
    flowers = flower_cascade.detectMultiScale(rotated)
    if len(flowers) > 0:
      return True
  return False
