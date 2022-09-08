from flask import Flask
from flask_restful import Api, Resource 

app= Flask(__name__)
api= Api(app)

class HelloWorld(Resource):
    def get(self, name, test):
        return{"name": name, "test":test}

api.add_resource(HelloWorld, "/helloworld/<string:name/<int:test>") 
#numpy.ndarray

app.run(debug=True) #Zur Umgehung der If-Clause
if __name__ == "__Einbindung_Flask__":
    app.run(debug=True) #final: debug=false

