from unittest import result
from flask import Flask, request
import os
import tensorflow as tf
import cv2
import warnings



warnings.simplefilter("ignore")

def model_load():
    """
    Hilfsfunktion um das Modell beim Start von FLask zu laden
    """
    global model_putty
    global model_tape
    # Lädt das Modell aus dem Dateipfad
    model_putty = tf.keras.models.load_model("D:/Git-Repo-PJS/PJS_SS_22_KI_Materialbedarfsplanung/backend/model_files/material_model_putty.h5")
    print('material_model_putty geladen')
    model_tape = tf.keras.models.load_model("D:/Git-Repo-PJS/PJS_SS_22_KI_Materialbedarfsplanung/backend/model_files/material_model_tape.h5")
    print('material_model_tape geladen')


def preprocess_image(img):
    """
    Hilfsfunktion um die Bilder vorzubearbeiten
    """
    # Prüft auf die richtige Bildgröße
    img_height = img.shape[0]
    img_width = img.shape[1]
    print("Bild Inputshape: "+str(img.shape))
    # Falls das Bild das falsche Format hat wird ein resize durchgeführt
    if (img_width != 400 or img_height != 300):
        img = cv2.resize(img, (400, 300), interpolation = cv2.INTER_AREA)
        print("Resize wurde durchgeführt.")
        print("Bild Outputshape: "+str(img.shape))
    # Fügt eine vierte Dimension (Batch des Trainings) für die Vorhersage des Modells hinzu
    img = tf.expand_dims(img,axis=0)
    return img


# Methode die den Materialbedarf berechnet
def material_predict(img):
    # Ruft die Methode preproces_image auf
    img = preprocess_image(img)
    # Das Bild wird in das Model geladen und als Rückgabe wird die Vorhersage erhalten
    print("Berechne Materialbedarf:")
    pred_material = []
    pred_putty = model_putty.predict(img)
    pred_tape = model_tape.predict(img)
    pred_material.append(pred_putty[0][0])
    pred_material.append(pred_tape[0][0])  
    return pred_material



app = Flask(__name__)

# Resource 
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
        # Die response wird im Format Bedarf1_Bedarf2 als String an das Frontend übermittelt
        return (response), 200



if __name__ == '__main__':
    model_load() 
    app.debug = False 
    app.run(host = "0.0.0.0", port=5000)