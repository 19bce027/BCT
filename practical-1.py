import numpy as np
import hashlib

x=np.random.randint(50)
p,q=13,17
n=p*q
N=(p-1)*(q-1)
for i in range(2,N):
  if(np.gcd(i,N)==1):
    e=i
    break
d=(2*N+1)//e

def encrypt_msg(msg):
    return (msg**e)%n
def decrypt_msg(msg):
    return (msg**d)%n

def sign(msg):
  code=""
  for i in msg:
    code+=str(encrypt_msg(ord(i)))+' '
  hash=hashlib.sha256(msg.encode()).hexdigest()
  return code,hash
    
def verify(code):
  msg=""
  for i in code.split():
    msg+=chr(decrypt_msg(int(i)))
  return msg

def is_tampered(msg,hash) :
  hash_verify=hashlib.sha256(msg.encode()).hexdigest()
  if(hash_verify==hash):
    print("Not Tampered")
  else:
    print("Tampered")

def main() :
    msg = input("Enter Message : ")
    code,hash = sign(msg)
    print(f"Encrypted Message : {code}")
    print(f"Hash is : {hash}")
    temp = input("Want to tampered y/n : ")
    if temp=="y" :
        code = "24" + code +"12"
    return_msg = verify(code)
    print(f"Decrypted Message : {return_msg}")
    is_tampered(return_msg,hash)

main()
