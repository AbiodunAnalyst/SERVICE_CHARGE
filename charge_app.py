# service_charge_app.py

import streamlit as st
import pandas as pd
import plotly.express as px

# --------------------------
# Page config
# --------------------------
st.set_page_config(
    page_title="Service Fee Impact Dashboard",
    page_icon="💳",
    layout="wide",
)

st.markdown(
    """
    <h2 style="background-color:#1F3B73;color:white;padding:10px;text-align:center;">
    IMPACT OF SERVICE FEE STRUCTURE ON TRANSACTION VOLUME
    </h2>
    """,
    unsafe_allow_html=True,
)

st.markdown("")


# --------------------------
# File upload
# --------------------------
st.sidebar.header("1️⃣ Upload Service Charge CSV")

uploaded_file = st.sidebar.file_uploader(
    "Upload your service charge CSV file",
    type=["csv"],
)

if uploaded_file is None:
    st.info("⬆️ Please upload a CSV file using the sidebar to view the dashboard.")
    st.stop()


# --------------------------
# Preprocess function
# --------------------------
@st.cache_data
def preprocess_data(file) -> pd.DataFrame:
    # Read raw CSV
    df = pd.read_csv(file)

    # Normalise column names: strip spaces and replace spaces with underscore
    df.columns = [c.strip().replace(" ", "_") for c in df.columns]

    # Expected columns after renaming (based on your sample):
    # Business_Name, User_Type, Reference, Unique_Identifier, Amount,
    # Service_Fee, Banker_Service_Fee, Customer_Service_Fee,
    # BILLER_ID, Transaction_Type, Status, RRN, STAN, Masked_PAN,
    # Card_Description, Card_Type, Terminal_ID, Date

    # Parse Date -> datetime
    if "Date" in df.columns:
        # Your format: 21 July, 2024 11:07 PM
        df["DateTime"] = pd.to_datetime(
            df["Date"],
            format="%d %B, %Y %I:%M %p",
            errors="coerce",
        )
        df = df.dropna(subset=["DateTime"])
        df["Full_date"] = df["DateTime"].dt.date
        df["Hour"] = df["DateTime"].dt.hour

        # Create Transaction_Time buckets (Morning / Daytime / Evening / Night)
        def map_period(h):
            if 5 <= h < 12:
                return "Morning"
            elif 12 <= h < 17:
                return "Daytime"
            elif 17 <= h < 21:
                return "Evening"
            else:
                return "Night"

        df["Transaction_Time"] = df["Hour"].apply(map_period)

    # Ensure numeric for financial fields
    for col in ["Amount", "Service_Fee", "Banker_Service_Fee", "Customer_Service_Fee"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce").fillna(0.0)

    # Filter to successful transactions only
    if "Status" in df.columns:
        df = df[df["Status"].astype(str).str.upper() == "SUCCESSFUL"]

    return df


df = preprocess_data(uploaded_file)

if df.empty:
    st.warning("No rows remaining after preprocessing (check Status/Date columns).")
    st.stop()

# --------------------------
# Sidebar filters
# --------------------------
st.sidebar.header("2️⃣ Filters")

# Date range filter
if "Full_date" in df.columns:
    df["Full_date"] = pd.to_datetime(df["Full_date"])
    min_date = df["Full_date"].min()
    max_date = df["Full_date"].max()
    date_range = st.sidebar.date_input(
        "Date range",
        value=(min_date, max_date),
        min_value=min_date,
        max_value=max_date,
    )
    if len(date_range) == 2:
        start, end = date_range
        df = df[(df["Full_date"] >= pd.to_datetime(start)) &
                (df["Full_date"] <= pd.to_datetime(end))]

# User type filter
if "User_Type" in df.columns:
    user_types = ["All"] + sorted(df["User_Type"].dropna().unique().tolist())
    selected_user = st.sidebar.selectbox("User Type", user_types)
    if selected_user != "All":
        df = df[df["User_Type"] == selected_user]

# Transaction type filter
if "Transaction_Type" in df.columns:
    txn_types = ["All"] + sorted(df["Transaction_Type"].dropna().unique().tolist())
    selected_txn = st.sidebar.selectbox("Transaction Type", txn_types)
    if selected_txn != "All":
        df = df[df["Transaction_Type"] == selected_txn]

st.markdown("---")

# --------------------------
# KPIs – Total Amount & Volume
# --------------------------
total_amount = df["Amount"].sum() if "Amount" in df.columns else 0
txn_volume = len(df)

kpi1, kpi2 = st.columns(2)
with kpi1:
    st.markdown(
        f"""
        <div style="background-color:#F5F5F5;padding:15px;border-radius:5px;text-align:center;">
        <h4>Total Amount</h4>
        <h2>${total_amount:,.3f}</h2>
        </div>
        """,
        unsafe_allow_html=True,
    )
with kpi2:
    st.markdown(
        f"""
        <div style="background-color:#F5F5F5;padding:15px;border-radius:5px;text-align:center;">
        <h4>Transaction Volume</h4>
        <h2>{txn_volume:,}</h2>
        </div>
        """,
        unsafe_allow_html=True,
    )

st.markdown("---")

# --------------------------
# Row 1: Donut (User Type), Bar (Txn Type), Bar (Txn Time)
# --------------------------
col1, col2, col3 = st.columns(3)

# 1️⃣ Donut: Transaction Volume by User Type
with col1:
    st.markdown("##### Transaction Volume by User Type")
    if "User_Type" in df.columns:
        vol_user = (
            df.groupby("User_Type")["Amount"]
            .count()
            .reset_index(name="Transaction_Count")
        )
        if not vol_user.empty:
            fig_user = px.pie(
                vol_user,
                names="User_Type",
                values="Transaction_Count",
                hole=0.65,
            )
            fig_user.update_traces(textposition="inside", textinfo="percent+label")
            fig_user.update_layout(showlegend=False)
            st.plotly_chart(fig_user, use_container_width=True)
        else:
            st.info("No data for selected filters.")
    else:
        st.info("Column `User_Type` not found.")

# 2️⃣ Bar: Transaction Volume by Transaction Type
with col2:
    st.markdown("##### Transaction Volume by Transaction Type")
    if "Transaction_Type" in df.columns:
        vol_txn = (
            df.groupby("Transaction_Type")["Amount"]
            .count()
            .reset_index(name="Transaction_Count")
            .sort_values("Transaction_Count", ascending=True)
        )
        if not vol_txn.empty:
            fig_txn = px.bar(
                vol_txn,
                x="Transaction_Count",
                y="Transaction_Type",
                orientation="h",
            )
            fig_txn.update_layout(
                xaxis_title="Transaction Volume",
                yaxis_title="",
                margin=dict(l=10, r=10, t=10, b=10),
            )
            st.plotly_chart(fig_txn, use_container_width=True)
        else:
            st.info("No data for selected filters.")
    else:
        st.info("Column `Transaction_Type` not found.")

# 3️⃣ Bar: Transaction Volume by Transaction Time
with col3:
    st.markdown("##### Transaction Volume by Transaction Time")
    if "Transaction_Time" in df.columns:
        vol_time = (
            df.groupby("Transaction_Time")["Amount"]
            .count()
            .reset_index(name="Transaction_Count")
        )
        order = ["Daytime", "Morning", "Evening", "Night"]
        vol_time["Transaction_Time"] = pd.Categorical(
            vol_time["Transaction_Time"], categories=order, ordered=True
        )
        vol_time = vol_time.sort_values("Transaction_Time")

        if not vol_time.empty:
            fig_time = px.bar(
                vol_time,
                x="Transaction_Time",
                y="Transaction_Count",
            )
            fig_time.update_layout(
                xaxis_title="",
                yaxis_title="Transaction Volume",
                margin=dict(l=10, r=10, t=10, b=10),
            )
            st.plotly_chart(fig_time, use_container_width=True)
        else:
            st.info("No data for selected filters.")
    else:
        st.info("Column `Transaction_Time` not found (check Date parsing).")

st.markdown("---")

# --------------------------
# Row 2: Line chart & Service Fee summary table
# --------------------------
col4, col5 = st.columns([2, 1])

# 4️⃣ Line: Total Amount by Date
with col4:
    st.markdown("##### Total Amount by Date")
    if "Full_date" in df.columns:
        amt_by_date = (
            df.groupby("Full_date")["Amount"]
            .sum()
            .reset_index()
            .sort_values("Full_date")
        )
        if not amt_by_date.empty:
            fig_amt = px.line(
                amt_by_date,
                x="Full_date",
                y="Amount",
            )
            fig_amt.update_layout(
                xaxis_title="Date",
                yaxis_title="Total Amount",
                margin=dict(l=10, r=10, t=10, b=10),
            )
            st.plotly_chart(fig_amt, use_container_width=True)
        else:
            st.info("No data for selected filters.")
    else:
        st.info("Column `Full_date` not found (check Date parsing).")

# 5️⃣ Table: Service Fee Structure Summary
with col5:
    st.markdown("##### Service Fee Structure Summary")
    required_cols = {"Service_Fee", "Amount", "Banker_Service_Fee", "Customer_Service_Fee"}
    if required_cols.issubset(df.columns):
        fee_summary = (
            df.groupby("Service_Fee")
            .agg(
                Transaction_Volume=("Amount", "count"),
                Banker_Service_Fee=("Banker_Service_Fee", "sum"),
                Customer_Service_Fee=("Customer_Service_Fee", "sum"),
            )
            .reset_index()
            .sort_values("Service_Fee")
        )

        fee_summary["Banker_Service_Fee"] = fee_summary["Banker_Service_Fee"].round(2)
        fee_summary["Customer_Service_Fee"] = fee_summary["Customer_Service_Fee"].round(2)

        # Add total row
        total_row = {
            "Service_Fee": "Total",
            "Transaction_Volume": fee_summary["Transaction_Volume"].sum(),
            "Banker_Service_Fee": fee_summary["Banker_Service_Fee"].sum(),
            "Customer_Service_Fee": fee_summary["Customer_Service_Fee"].sum(),
        }

        fee_summary_tot = pd.concat(
            [fee_summary, pd.DataFrame([total_row])],
            ignore_index=True,
        )

        st.dataframe(fee_summary_tot, use_container_width=True)
    else:
        st.info(f"Missing one of required columns: {required_cols}")

st.markdown("---")

st.caption(
    "Streamlit recreation of the 'Impact of Service Fee Structure on Transaction Volume' dashboard (upload-based)."
)
