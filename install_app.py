import streamlit as st
from matlab_runtime import install, guess_prefix

version = "R2024b"
prefix = "/usr/local/MATLAB/MATLAB_Runtime/" + version
install(version, prefix=prefix, auto_answer=True)

print(guess_prefix())
st.write(guess_prefix())