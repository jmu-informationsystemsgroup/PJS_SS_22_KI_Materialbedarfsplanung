from flask import Flask
from flask_restful import Api, Resource 

app= Flask(__name__)
api= Api(app)

names={"tim": {"age":19, "gender":"Male"}, 
        "bill": {"age": 70, "gender": "Male"}}


class HelloWorld(Resource):
    def get(self, name):
        return names[name]

api.add_resource(HelloWorld, "/helloworld/<string:name>") 
#numpy.ndarray

app.run(debug=True) #Zur Umgehung der If-Clause
if __name__ == "__Einbindung_Flask__":
    app.run(debug=True) #final: debug=false

