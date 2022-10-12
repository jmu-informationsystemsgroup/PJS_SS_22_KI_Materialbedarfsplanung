from unittest import result
from flask import Flask, request
import os
import tensorflow as tf
import cv2
import numpy as np
import warnings

warnings.simplefilter("ignore")


#############################################################
# Hilfsfunktion um die Modelle beim Start von Flask zu laden
#############################################################
def model_load():

    global model_putty
    global model_tape
    # Lädt das Modell aus dem Dateipfad
    model_putty = tf.keras.models.load_model("D:/Git-Repo-PJS/PJS_SS_22_KI_Materialbedarfsplanung/backend/model_files/material_model_putty.h5")
    print('material_model_putty geladen')
    model_tape = tf.keras.models.load_model("D:/Git-Repo-PJS/PJS_SS_22_KI_Materialbedarfsplanung/backend/model_files/material_model_tape.h5")
    print('material_model_tape geladen')


#############################################################
# Hilfsfunktion um die Bilder für die Spachtelmasse vorzubearbeiten
#############################################################
def preprocess_image_putty(img):

    # Prüft auf die richtige Bildgröße
    img_height = img.shape[0]
    img_width = img.shape[1]
    print("Bild zur Berechnung der Spachtelmasse - Inputshape: "+str(img.shape))
    # Falls das Bild das falsche Format hat wird ein resize durchgeführt
    if (img_width != 400 or img_height != 300):
        img = cv2.resize(img, (400, 300), interpolation = cv2.INTER_AREA)
        print("Bild zur Berechnung der Spachtelmasse - Resize wurde durchgeführt.")
    else:
        print("Bild zur Berechnung der Spachtelmasse - kein Resize notwendig.")
    print("Bild zur Berechnung der Spachtelmasse - Outputshape: "+str(img.shape))
    #Führt die Standardisierung durch
    img = np.array(img, dtype=np.int64)
    imgst = (img - np.mean(img)) / np.std(img)
    img = imgst
    print("Bild zur Berechnung der Spachtelmasse - Standardisierung wurde durchgeführt")
    # Fügt eine vierte Dimension (Batch des Trainings) für die Vorhersage des Modells hinzu
    img = tf.expand_dims(img,axis=0)
    return img


#############################################################
# Hilfsfunktion um die Bilder für die Fugendeckstreifen vorzubearbeiten
#############################################################
def preprocess_image_tape(img):

    # Prüft auf die richtige Bildgröße
    img_height = img.shape[0]
    img_width = img.shape[1]
    print("Bild zur Berechnung der Fugendeckstreifen - Inputshape: "+str(img.shape))
    # Falls das Bild das falsche Format hat wird ein resize durchgeführt
    if (img_width != 200 or img_height != 150):
        img = cv2.resize(img, (200, 150), interpolation = cv2.INTER_AREA)
        print("Bild zur Berechnung der Fugendeckstreifen - Resize wurde durchgeführt.")
    else:
        print("Bild zur Berechnung der Fugendeckstreifen - kein Resize notwendig.")
    print("Bild zur Berechnung der Fugendeckstreifen - Bild Outputshape: "+str(img.shape))
    #Führt die Normalisierung durch
    img = img/255
    print("Bild zur Berechnung der Fugendeckstreifen - Normalisierung wurde durchgeführt")
    # Fügt eine vierte Dimension (Batch des Trainings) für die Vorhersage des Modells hinzu
    img = tf.expand_dims(img,axis=0)
    return img



#############################################################
# Methode die den Materialbedarf berechnet
#############################################################
def material_predict(img):

    pred_material = []
    # Bearbeitet die Bilder vor
    img_putty = preprocess_image_putty(img)
    img_tape = preprocess_image_tape(img)
    # Schätzt den Materialbedarf über predict
    print("Berechne Materialbedarf:")
    pred_putty = model_putty.predict(img_putty)
    pred_tape = model_tape.predict(img_tape)
    # Fügt die Werte dem Array an
    pred_material.append(pred_putty[0][0])
    pred_material.append(pred_tape[0][0])  
    return pred_material



app = Flask(__name__)

#############################################################
# Ressource /predict 
#############################################################
@app.route('/predict', methods=['POST'] )
def predict():
    if request.method == 'POST':

        # Liest die übermittelte Datei
        file = request.files['file']
        # Liest den Dateinamen aus
        filename = file.filename 
        print()
        print("Übermittelte Datei: "+str(filename)+"      Dateityp: "+str(file.content_type))
        # Speichert die Datei ab
        file.save(filename)

        try:
            # Liest das Bild aus der Datei ein
            img = cv2.imread(filename)
            # Übergibt das Bild an die material_predict Methode und erhält das Ergebnis der Vorhersage in einem Array zurück
            pred_material = []
            pred_material = material_predict(img) 
        except:
            return {"message": "Nicht unterstütztes Dateiformat. Bitte Datei in .jpg hochladen"}, 500

        print("Vorhergesagter Materialbedarf für Spachtelmasse in g: "+str(pred_material[0]))
        print("Vorhergesagter Materialbedarf für Fugendeckstreifen in mm: "+str(pred_material[1]))
        response = str(pred_material[0]) + "_" + str(pred_material[1])
        # Die übermittelte Datei wird wieder vom Dateisystem gelöscht
        os.remove(filename)
        # Die response wird im Format [Bedarf1]_[Bedarf2] als String an das Frontend übermittelt
        return (response), 200



if __name__ == '__main__':
    model_load() 
    app.debug = False 
    app.run(host = "0.0.0.0", port=5000)