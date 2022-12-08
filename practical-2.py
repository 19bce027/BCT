import datetime
import json
from re import T
from flask import Flask,jsonify,request
import hashlib

class block_chain:

    def __init__(self) -> None:
        self.chain = []
        self.create_block("","This is genisis Block")
        pass

    def create_hash(self,previous,data,timestamp) :
        msg = previous+data+timestamp
        hash=hashlib.sha256(msg.encode()).hexdigest()
        return hash

    def create_block(self,previous_hash,msg) :
        
        time_stamp = str(datetime.datetime.now().timestamp())
        print(previous_hash,"  ",msg,"  ",time_stamp)
        hash_value = self.create_hash(previous_hash,msg,time_stamp)
        one_block = {
            "index" : len(self.chain),
            # "hash" : hash_value,
            "msg" : msg,
            "time_stamp" : time_stamp,
            "previous_hash" : previous_hash
        }

        self.chain.append(one_block)
        return(one_block)

    def chain_valid(self, chain):
        if len(chain)==0 :
            return True
        previous_block = chain[0]
        block_index = 1

        while block_index < len(chain):
            block = chain[block_index]
            if block['previous_hash'] != self.create_hash(previous_block['previous_hash'],previous_block['msg'],previous_block['time_stamp']):
                return False
            block_index = block_index + 1
        return True

    def print_previous_block(self):
        return self.chain[-1]


app = Flask(__name__)

blockchain = block_chain()


@app.route('/chain', methods=['GET'])
def display_chain():
	response = {'chain': blockchain.chain,
				'length': len(blockchain.chain)}
	return jsonify(response), 200

@app.route('/create_block', methods=['GET'])
def createblock():
    length_ofchain = len(blockchain.chain)
    if length_ofchain==0 :
        msg = request.args.get("msg")
        previous_hash = ""
        blockchain.create_block(msg=msg,previous_hash=previous_hash)
    else :
        previous_hash = blockchain.create_hash(blockchain.chain[-1]['previous_hash'],blockchain.chain[-1]['msg'],blockchain.chain[-1]['time_stamp'])
        msg = request.args.get("msg")
        blockchain.create_block(msg=msg,previous_hash=previous_hash)

    return jsonify({"response" : "Block created"}), 200

@app.route('/validate', methods=['GET'])
def valid():
	valid = blockchain.chain_valid(blockchain.chain)
	if valid:
		response = {'message': 'The Blockchain is valid.'}
	else:
		response = {'message': 'The Blockchain is not valid.'}
	return jsonify(response), 200

@app.route('/', methods=['GET'])
def home() :
    response = """{
        "create_block" : "/create_block",
        "view_chain" : "/chain",
        "validate_chain" : "/validate"
    }"""
    return jsonify(json.loads(response)),200

app.run(host='127.0.0.1', port=5000,debug=True)
