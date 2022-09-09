from flask import Flask, request
import os
import cv2
import warnings


warnings.simplefilter("ignore")


app = Flask(__name__)


@app.route('/predict', methods=['POST'] )
def predict():
    if request.method == 'POST':
        
        # Liest die übermittelte Datei
        file = request.files['file']
        print("gesendetes Bild: "+str(file))
        # Liest den Dateinamen aus
        filename = file.filename 
        # Speichert die Datei ab
        file.save(filename)

        try:
            # Liest das Bild aus der Datei ein
            img = cv2.imread(filename)
        except:
            return {"message": "Nicht unterstütztes Dateiformat. Bitte Datei in .jpg hochladen"}, 500

        # Löscht die Datei
        os.remove(filename)
        # Gibt die Antwort in Stringform zurück
        return ("412.65"), 200


if __name__ == '__main__':
    app.debug = False 
    app.run(host = "0.0.0.0", port=5000)