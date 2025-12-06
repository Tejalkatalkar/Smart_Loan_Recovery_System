import streamlit as st
import pandas as pd
import joblib
import base64

# ------------------ PAGE CONFIG ------------------
st.set_page_config(
    page_title="Smart Loan Recovery Prediction",
    page_icon="💰",
    layout="centered"
)

# ------------------ BACKGROUND IMAGE ------------------
def add_bg_from_local(image_file):
    """Set background image using base64 encoding."""
    with open(image_file, "rb") as f:
        encoded = base64.b64encode(f.read()).decode()
    st.markdown(
        f"""
        <style>
        .stApp {{
            background-image: url("data:image/png;base64,{encoded}");
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-position: center;
        }}
        .block-container {{
            background-color: rgba(255, 255, 255, 0.95) !important;
            padding: 30px 40px;
            border-radius: 20px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }}
        div.stButton > button {{
            width: 100%;
            border-radius: 10px;
            height: 3em;
            font-size: 1.1em;
            font-weight: 600;
            background-color: #0F172A;
            color: white;
            border: none;
        }}
        div.stButton > button:hover {{
            background-color: #1E293B;
        }}
        h3 {{
            margin-top: 20px;
            margin-bottom: 10px;
        }}
        </style>
        """,
        unsafe_allow_html=True
    )

# Call function with your local image
add_bg_from_local("C:/Users/TEJAL KATALKAR/Smart_Loan_Recovery_Management_System___/Background.img.png")

# ------------------ LOAD MODEL ------------------
@st.cache_resource
def load_model():
    return joblib.load("xgboost_model.pkl")

model = load_model()

# ------------------ APP TITLE ------------------
st.title("💰 Smart Loan Recovery Prediction")
st.markdown("""
Welcome to the **Smart Loan Recovery Prediction System**!  

This app predicts whether a borrower's loan is likely to be **recovered** or **not recovered**.
""")
st.write("Enter borrower & loan details to predict loan recovery likelihood.")

# ------------------ INPUT FORM ------------------
with st.form("loan_form"):
    st.subheader("🧑‍💼 Borrower Information")
    col1, col2, col3 = st.columns(3)
    with col1:
        Age = st.number_input("Age", min_value=18, max_value=90)
        Gender = st.selectbox("Gender", ["Male", "Female", "Other"])
    with col2:
        Employment_Type = st.selectbox("Employment Type", ["Salaried", "Self-Employed", "Unemployed", "Student", "Retired"])
        Monthly_Income = st.number_input("Monthly Income", min_value=0, max_value=500000)
    with col3:
        Num_Dependents = st.number_input("Number of Dependents", min_value=0, max_value=10)

    st.markdown("---")
    st.subheader("🏦 Loan Information")
    col4, col5, col6 = st.columns(3)
    with col4:
        Loan_Amount = st.number_input("Loan Amount", min_value=1000, max_value=2000000)
        Loan_Tenure = st.number_input("Loan Tenure (Months)", min_value=1, max_value=360)
    with col5:
        Interest_Rate = st.number_input("Interest Rate (%)", min_value=1.0, max_value=30.0, step=0.1)
        Loan_Type = st.selectbox("Loan Type", ["Personal Loan", "Home Loan", "Business Loan", "Vehicle Loan", "Education Loan", "Gold Loan"])
    with col6:
        Collateral_Value = st.number_input("Collateral Value", min_value=0.0, format="%.2f")
        Outstanding_Loan_Amount = st.number_input("Outstanding Loan Amount", min_value=0.0, format="%.2f")
    Monthly_EMI = st.number_input("Monthly EMI", min_value=0.0, format="%.2f")

    st.markdown("---")
    st.subheader("💳 Payment Behavior")
    col7, col8, col9 = st.columns(3)
    with col7:
        Payment_History = st.selectbox("Payment History", ["Good", "Average", "Poor", "Irregular"])
    with col8:
        Num_Missed_Payments = st.number_input("Missed Payments", min_value=0, max_value=50)
    with col9:
        Days_Past_Due = st.number_input("Days Past Due", min_value=0, max_value=500)

    st.markdown("---")
    st.subheader("📋 Collection Details")
    col10, col11 = st.columns(2)
    with col10:
        Collection_Attempts = st.number_input("Collection Attempts", min_value=0, max_value=50)
    with col11:
        Collection_Method = st.selectbox("Collection Method", ["Phone Call", "SMS", "Email", "Field Visit", "Legal Notice"])
    Legal_Action_Taken = st.selectbox("Legal Action Taken", ["Yes", "No"])

    submitted = st.form_submit_button("🔍 Predict Recovery")

# ------------------ PREDICTION ------------------
if submitted:
    input_data = pd.DataFrame([{
        "Loan_ID": 0,
        "Borrower_ID": 0,
        "Age": Age,
        "Gender": Gender,
        "Employment_Type": Employment_Type,
        "Monthly_Income": Monthly_Income,
        "Num_Dependents": Num_Dependents,
        "Loan_Amount": Loan_Amount,
        "Loan_Tenure": Loan_Tenure,
        "Interest_Rate": Interest_Rate,
        "Loan_Type": Loan_Type,
        "Collateral_Value": Collateral_Value,
        "Outstanding_Loan_Amount": Outstanding_Loan_Amount,
        "Monthly_EMI": Monthly_EMI,
        "Payment_History": Payment_History,
        "Num_Missed_Payments": Num_Missed_Payments,
        "Days_Past_Due": Days_Past_Due,
        "Collection_Attempts": Collection_Attempts,
        "Collection_Method": Collection_Method,
        "Legal_Action_Taken": Legal_Action_Taken
    }])

    try:
        prediction = model.predict(input_data)[0]
        probability = model.predict_proba(input_data)[0][1] * 100
    except Exception as e:
        st.error(f"❌ Prediction failed: {e}")
        st.stop()

    st.subheader("Prediction Result")
    if prediction == 1:
        st.success(f"✅ Loan WILL be Recovered\n**Probability: {probability:.2f}%**")
    else:
        st.error(f"⚠️ Loan may NOT be Recovered\n**Probability: {probability:.2f}%**")
