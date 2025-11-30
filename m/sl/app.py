import streamlit as st

st.set_page_config(page_title="Login", page_icon="🔐")

st.title("🔐 Login")

with st.form("login_form"):
    username = st.text_input("Username")
    password = st.text_input("Password", type="password")
    submit = st.form_submit_button("Login")

    if submit:
        if username and password:
            st.success(f"Welcome, {username}!")
            st.info(f"Username: {username}")
            st.info(f"Password: {'*' * len(password)}")
        else:
            st.error("Please enter both username and password")
