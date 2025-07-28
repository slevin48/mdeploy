import streamlit as st
from matlab_runtime import install, guess_prefix

version = "R2025a"
install(version,prefix="/workspace/mdeploy", auto_answer=True)

print(guess_prefix())
st.write(guess_prefix())