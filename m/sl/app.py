#!/usr/bin/env -S uv run -m streamlit run

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

# Import Python's datetime module for working with dates and times
from datetime import datetime

# Import Altair - a declarative visualization library for creating interactive charts
import altair as alt

# Import Polars - a fast DataFrame library built on Apache Arrow
import polars as pl

# Import Streamlit - the web framework that lets you build data apps quickly
import streamlit as st

# Import shadcn UI components for modern UI elements like badges
import streamlit_shadcn_ui as ui

# Import vega_datasets - provides sample datasets including Seattle weather data
import vega_datasets


def main():
    """
    Main function that orchestrates the Seattle Weather Dashboard.

    This function provides a clear overview of the app's structure:
    1. Load data
    2. Display UI components
    3. Show weather metrics
    4. Let users filter by year
    5. Display various weather visualizations
    """
    # Load the Seattle weather dataset into a Polars DataFrame
    # This contains daily weather measurements from Seattle
    # vega_datasets returns pandas, so we convert to Polars for better performance
    df = pl.from_pandas(vega_datasets.data("seattle_weather"))

    # Get weather icons dictionary
    wi = get_weather_icons()

    # hide streamlit controls
    hide_streamlit_controls()

    # Display sample UI badges
    display_sample_badges()

    # Show metrics for most/least common weather
    display_weather_metrics(df, wi)

    # Get filtered data based on user's year selection
    filtered_df = get_filtered_data_by_year(df)

    # Display all the weather visualization charts
    display_temperature_and_distribution(filtered_df)
    display_wind_and_precipitation(filtered_df)
    display_monthly_breakdown_and_raw_data(filtered_df)


def hide_streamlit_controls():
    """Hide streamlit controls at the top"""
    hide_menu = """
        <style>
        div.stMainBlockContainer {
            margin: 0 !important;
            padding: 0 !important;
            padding-left: 15px !important;
            padding-right: 10px !important;
        }

        header.stAppHeader {
            display: none !important;
            visibility: hidden !important;
        }
        </style>
        """
    st.markdown(hide_menu, unsafe_allow_html=True)


def get_weather_icons():
    """Return a dictionary mapping weather types to emoji icons."""
    return {
        "sun": "☀️",
        "snow": "☃️",
        "rain": "💧",
        "fog": "😶‍🌫️",
        "drizzle": "🌧️",
    }


def display_sample_badges():
    """Display sample shadcn UI badges at the top of the app."""
    ui.badges(
        badge_list=[
            ("default", "default"),  # Text, style
            ("secondary", "secondary"),
            ("Hello", "destructive"),  # Red "destructive" style badge
        ],
        class_name="flex gap-2",  # CSS classes for flexbox layout with gap spacing
        key="badges1",  # Unique key for Streamlit to track this widget
    )


def display_weather_metrics(df, wi):
    """
    Display metrics showing the most and least common weather types.

    Args:
        df: DataFrame containing weather data
        wi: Dictionary mapping weather types to emoji icons
    """
    # Create a horizontal container to display metrics side by side
    with st.container(horizontal=True, gap="medium"):
        # Create 2 columns of equal width (300px each) with medium gap
        cols = st.columns(2, gap="medium", width=300)

        # Display the most common weather type in the first column
        with cols[0]:
            # group_by + len counts how many times each weather type appears
            # sort descending and take the first row to get the most common
            weather_name = (
                df.group_by("weather")
                .agg(pl.len().alias("count"))
                .sort("count", descending=True)
                .head(1)["weather"][0]
            )
            # st.metric displays a key metric with a label and value
            st.metric(
                "Most common weather",
                f"{wi[weather_name]} {weather_name.upper()}",
            )

        # Display the least common weather type in the second column
        with cols[1]:
            # Sort ascending to get the least common weather type
            weather_name = (
                df.group_by("weather")
                .agg(pl.len().alias("count"))
                .sort("count", descending=False)
                .head(1)["weather"][0]
            )
            st.metric(
                "Least common weather",
                f"{wi[weather_name]} {weather_name.upper()}",
            )


def get_filtered_data_by_year(df):
    """
    Display year selection widget and return filtered DataFrame.

    Args:
        df: Full DataFrame with all years

    Returns:
        DataFrame filtered to selected years
    """
    # Display a markdown header for the year comparison section
    """
    ## Compare different years
    """

    # Extract unique years from the dataset
    # .dt.year() accesses the year from datetime column, .unique() gets distinct values
    # sort() ensures years are in order
    years = df.select(pl.col("date").dt.year()).unique().sort("date")["date"].to_list()

    # st.pills creates a multi-select button group for choosing years
    # Users can select multiple years to compare side-by-side
    selected_years = st.pills(
        "Years to compare", years, default=years, selection_mode="multi"
    )

    # Show a warning if no years are selected
    if not selected_years:
        st.warning("You must select at least 1 year.", icon=":material/warning:")

    # Filter the dataset to only include the selected years
    # .is_in() checks if the year is in the selected_years list
    return df.filter(pl.col("date").dt.year().is_in(selected_years))


def display_temperature_and_distribution(df):
    """
    Display temperature range chart and weather distribution pie chart.

    Args:
        df: Filtered DataFrame containing weather data
    """
    # Create two columns with a 3:1 ratio (first column is 3x wider)
    # This layout gives more space to the temperature chart
    cols = st.columns([3, 1])

    # First column: Temperature chart
    with cols[0].container(border=True, height="stretch"):
        "### Temperature"

        # Create an interactive temperature range bar chart using Altair
        # Altair uses a "grammar of graphics" - you describe what to show, not how to draw it
        st.altair_chart(
            alt.Chart(df)  # Start with our filtered DataFrame
            .mark_bar(width=1)  # Draw narrow bars (width=1 pixel)
            .encode(
                # X-axis: date shown as month-day (e.g., "Jan 15")
                alt.X("date", timeUnit="monthdate").title("date"),
                # Y-axis: max temperature (top of bar)
                alt.Y("temp_max").title("temperature range (C)"),
                # Y2: min temperature (bottom of bar) - creates a range bar
                alt.Y2("temp_min"),
                # Color bars by year - each year gets a different color
                alt.Color("date:N", timeUnit="year").title("year"),
                # Offset bars horizontally by year so they appear side-by-side
                alt.XOffset("date:N", timeUnit="year"),
            )
            .configure_legend(orient="bottom")  # Put the legend below the chart
        )

    # Second column: Weather distribution pie chart
    with cols[1].container(border=True, height="stretch"):
        "### Weather distribution"

        # Create a pie chart showing the proportion of each weather type
        st.altair_chart(
            alt.Chart(df)
            .mark_arc()  # mark_arc() creates pie/donut chart segments
            .encode(
                # Theta controls the angle/size of each pie slice
                # count() counts rows for each weather type
                alt.Theta("count()"),
                # Color each slice by weather type (sun, rain, etc.)
                alt.Color("weather:N"),
            )
            .configure_legend(orient="bottom")
        )


def display_wind_and_precipitation(df):
    """
    Display wind speed and precipitation charts.

    Args:
        df: Filtered DataFrame containing weather data
    """
    # Create a row with two equal columns for wind and precipitation
    cols = st.columns(2)

    # Left column: Wind speed over time (with rolling average)
    with cols[0].container(border=True, height="stretch"):
        "### Wind"

        st.altair_chart(
            alt.Chart(df)
            # transform_window() calculates rolling statistics over a window of data
            .transform_window(
                avg_wind="mean(wind)",  # Calculate average wind speed
                std_wind="stdev(wind)",  # Calculate standard deviation (not used in chart)
                frame=[0, 14],  # Window: current day + next 14 days = 2 weeks
                groupby=[
                    "monthdate(date)"
                ],  # Group by month-day to compare across years
            )
            .mark_line(size=1)  # Draw a thin line chart
            .encode(
                alt.X("date", timeUnit="monthdate").title("date"),
                # Y-axis shows the calculated rolling average (":Q" means quantitative data)
                alt.Y("avg_wind:Q").title("average wind past 2 weeks (m/s)"),
                # Different color line for each year
                alt.Color("date:N", timeUnit="year").title("year"),
            )
            .configure_legend(orient="bottom")
        )

    # Right column: Monthly precipitation totals
    with cols[1].container(border=True, height="stretch"):
        "### Precipitation"

        st.altair_chart(
            alt.Chart(df)
            .mark_bar()  # Bar chart
            .encode(
                # X-axis: group by month (":N" means nominal/categorical data)
                alt.X("date:N", timeUnit="month").title("date"),
                # Y-axis: sum up all precipitation for each month
                # aggregate("sum") adds up all the daily precipitation values
                alt.Y("precipitation:Q").aggregate("sum").title("precipitation (mm)"),
                # Color bars by year to compare across years
                alt.Color("date:N", timeUnit="year").title("year"),
            )
            .configure_legend(orient="bottom")
        )


def display_monthly_breakdown_and_raw_data(df):
    """
    Display monthly weather breakdown and raw data table.

    Args:
        df: Filtered DataFrame containing weather data
    """
    # Create a final row with two equal columns
    cols = st.columns(2)

    # Left column: Stacked bar chart showing weather type distribution by month
    with cols[0].container(border=True, height="stretch"):
        "### Monthly weather breakdown"
        ""  # Empty string creates a small spacing

        st.altair_chart(
            alt.Chart(df)
            .mark_bar()
            .encode(
                # X-axis: months (":O" means ordinal - ordered categories like Jan, Feb, Mar)
                alt.X("month(date):O", title="month"),
                # Y-axis: count of days, normalized to show proportions (0-100%)
                # stack("normalize") makes each bar the same height, showing percentages
                alt.Y("count():Q", title="days").stack("normalize"),
                # Color segments by weather type (sun, rain, etc.)
                alt.Color("weather:N"),
            )
            .configure_legend(orient="bottom")
        )

    # Right column: Interactive data table showing the raw filtered data
    with cols[1].container(border=True, height="stretch"):
        "### Raw data"

        # st.dataframe() displays a scrollable, interactive table
        # Users can sort columns, search, and explore the underlying data
        st.dataframe(df)


# Run the main function when the script is executed
if __name__ == "__main__":
    # Configure the Streamlit page settings
    # This must be called before any other Streamlit commands
    st.set_page_config(
        page_title="Seattle Weather",
        page_icon="🌦️",
        layout="wide",
    )

    main()
