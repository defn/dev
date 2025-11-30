# -*- coding: utf-8 -*-
# Copyright 2024-2025 Streamlit Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from datetime import datetime

import altair as alt
import streamlit as st
import streamlit_shadcn_ui as ui
import vega_datasets

ui.badges(
    badge_list=[
        ("default", "default"),
        ("secondary", "secondary"),
        ("outline", "outline"),
        ("Hello", "destructive"),
    ],
    class_name="flex gap-2",
    key="badges1",
)

full_df = vega_datasets.data("seattle_weather")

st.set_page_config(
    # Title and icon for the browser's tab bar:
    page_title="Seattle Weather",
    page_icon="🌦️",
    # Make the content take up the width of the page:
    layout="wide",
)


with st.container(horizontal=True, gap="medium"):
    cols = st.columns(2, gap="medium", width=300)

    weather_icons = {
        "sun": "☀️",
        "snow": "☃️",
        "rain": "💧",
        "fog": "😶‍🌫️",
        "drizzle": "🌧️",
    }

    with cols[0]:
        weather_name = (
            full_df["weather"].value_counts().head(1).reset_index()["weather"][0]
        )
        st.metric(
            "Most common weather",
            f"{weather_icons[weather_name]} {weather_name.upper()}",
        )

    with cols[1]:
        weather_name = (
            full_df["weather"].value_counts().tail(1).reset_index()["weather"][0]
        )
        st.metric(
            "Least common weather",
            f"{weather_icons[weather_name]} {weather_name.upper()}",
        )

"""
## Compare different years
"""

YEARS = full_df["date"].dt.year.unique()
selected_years = st.pills(
    "Years to compare", YEARS, default=YEARS, selection_mode="multi"
)

if not selected_years:
    st.warning("You must select at least 1 year.", icon=":material/warning:")

df = full_df[full_df["date"].dt.year.isin(selected_years)]

cols = st.columns([3, 1])

with cols[0].container(border=True, height="stretch"):
    "### Temperature"

    st.altair_chart(
        alt.Chart(df)
        .mark_bar(width=1)
        .encode(
            alt.X("date", timeUnit="monthdate").title("date"),
            alt.Y("temp_max").title("temperature range (C)"),
            alt.Y2("temp_min"),
            alt.Color("date:N", timeUnit="year").title("year"),
            alt.XOffset("date:N", timeUnit="year"),
        )
        .configure_legend(orient="bottom")
    )

with cols[1].container(border=True, height="stretch"):
    "### Weather distribution"

    st.altair_chart(
        alt.Chart(df)
        .mark_arc()
        .encode(
            alt.Theta("count()"),
            alt.Color("weather:N"),
        )
        .configure_legend(orient="bottom")
    )


cols = st.columns(2)

with cols[0].container(border=True, height="stretch"):
    "### Wind"

    st.altair_chart(
        alt.Chart(df)
        .transform_window(
            avg_wind="mean(wind)",
            std_wind="stdev(wind)",
            frame=[0, 14],
            groupby=["monthdate(date)"],
        )
        .mark_line(size=1)
        .encode(
            alt.X("date", timeUnit="monthdate").title("date"),
            alt.Y("avg_wind:Q").title("average wind past 2 weeks (m/s)"),
            alt.Color("date:N", timeUnit="year").title("year"),
        )
        .configure_legend(orient="bottom")
    )

with cols[1].container(border=True, height="stretch"):
    "### Precipitation"

    st.altair_chart(
        alt.Chart(df)
        .mark_bar()
        .encode(
            alt.X("date:N", timeUnit="month").title("date"),
            alt.Y("precipitation:Q").aggregate("sum").title("precipitation (mm)"),
            alt.Color("date:N", timeUnit="year").title("year"),
        )
        .configure_legend(orient="bottom")
    )

cols = st.columns(2)

with cols[0].container(border=True, height="stretch"):
    "### Monthly weather breakdown"
    ""

    st.altair_chart(
        alt.Chart(df)
        .mark_bar()
        .encode(
            alt.X("month(date):O", title="month"),
            alt.Y("count():Q", title="days").stack("normalize"),
            alt.Color("weather:N"),
        )
        .configure_legend(orient="bottom")
    )

with cols[1].container(border=True, height="stretch"):
    "### Raw data"

    st.dataframe(df)
