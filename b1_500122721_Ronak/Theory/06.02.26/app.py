# Simple program to verify SAP ID
# Focus of this task is containerization, not Python

import numpy as np   # dependency for learning purpose

stored_sapid = "500122721"

user_sapid = input("Enter your SAP ID: ")

if user_sapid == stored_sapid:
    print("Matched")
else:
    print("Not Matched")