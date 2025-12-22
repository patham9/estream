import tiktoken
import sys, os
orig_cwd = os.getcwd()
sys.path.append(os.path.abspath(os.path.join(orig_cwd, './python/')))
os.chdir(os.path.abspath(os.path.join(orig_cwd, './python/')))
from petta import *
os.chdir(orig_cwd)

#BEFORE RUNNING PLEASE ENSURE TO SET IN temporal/control.metta: (= (maxsequencelen) 30)

text = "I went to the fridge. I opened it. I took out the coke. The coke fell to the floor. Then I picked it up. Finally I drank it. "
text += "I went to the fridge. I opened it. I took out the pizza. The pizza fell to the floor. Then I put it to the trash. "

text += "I ran to the fridge. I opened it. I took out the milk. The milk fell to the floor. Then I picked it up. Finally I drank it. "
text += "I ran to the fridge. I opened it. I took out the bread. The bread fell to the floor. Then I put it to the trash. "



text = text * 5

metta = PeTTa()
metta.load_metta_file("./estream/lib_estream.metta")
enc = tiktoken.get_encoding("o200k_base")

todo = enc.encode(text)
outputgenerated = []
initiallength = len(todo)
k,h,i = (0,0,0)
Adapting = True
while True:
    # ----- Choose input -----
    if i < initiallength:         # training mode: use REAL input
        token = todo[i]
    else:                         # generation mode: use MODEL prediction
        token = rettoken          # last predicted token becomes new input
    # ----- Process -----
    OUT = str(metta.process_metta_string(f"!(AddEvent ({token}) {Adapting})"))
    # Extract prediction for NEXT token (even during training!)
    if " HYPOTHESIS" in OUT:
        rettoken = int(OUT.split(" HYPOTHESIS")[0].split("'")[1].replace("(",""))
        # Only count output when generation begins
        if i >= initiallength:
            Adapting = False
            todo.append(rettoken)
            outputgenerated.append(rettoken)
            print("PREDICTED", enc.decode([rettoken]))
            h+=1
            if h >= 200:
                break
    i+=1

st = ""
for x in outputgenerated:
    st += enc.decode([x])
print(st)
