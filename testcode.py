import cv2
import imutils
import numpy as np


def adjust_gamma(image, gamma=1.0):
    """[summary]

    Args:
        image ([type]): [description]
        gamma (float, optional): [description]. Defaults to 1.0.

    Returns:
        [type]: [description]
    """
    invGamma = 1.0 / gamma
    table = [((i / 255.0) ** invGamma) * 255 for i in np.arange(0, 256)]  # lookup for gamma values
    table = np.array(  table  ).astype("uint8")                           # transform to uint8, as we use that for images
    return cv2.LUT(image, table)  	                                      # apply gamma correction using the lookup table


cap = cv2.VideoCapture(0)

while(cap.isOpened()):
    ret, frame = cap.read()
    #frame = cv2.medianBlur(frame, 7)
    # frame = adjust_gamma(frame, gamma=2.5)
    frame = imutils.resize(frame, width=800)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    # text = str(np.mean(gray))
    gray = cv2.putText(gray, 'test', org = (50, 50), fontFace=cv2.FONT_HERSHEY_COMPLEX_SMALL, fontScale=1, color=(255, 255, 255))
    cv2.imshow('frame', gray)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()