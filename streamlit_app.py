import streamlit as st
import mdeploy
import numpy as np

@st.cache_resource
def start_runtime():
    m = mdeploy.initialize()
    return m

m = start_runtime()
st.title("Magic Square Generator")
size = st.slider("Select size of magic square:", 1, 10, 3)
if st.button("Generate Magic Square"):
    magic_square = m.mymagic(size)
    st.write("Magic Square of size", size)
    st.write(np.array(magic_square))