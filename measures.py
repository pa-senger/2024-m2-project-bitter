import pandas as pd
import json
import dash
from dash import dcc, html
from dash.dependencies import Input, Output
import plotly.graph_objs as go


# Load JSON data
def load_json_data(file_path):
    try:
        with open(file_path, "r") as json_file:
            return json.load(json_file)
    except FileNotFoundError:
        return None


# Load CSV data
def load_csv_data(file_path):
    try:
        return pd.read_csv(file_path)
    except FileNotFoundError:
        return None


# Define file paths
DIR_PATH = "../../feelppdb/project-bitter/np_12/"
data_paths = {
    "json_heat": DIR_PATH + "heat.measures/metadata.json",
    "csv_heat": DIR_PATH + "heat.measures/values.csv",
    "json_fluence": DIR_PATH + "electric.measures/metadata.json",
    "csv_fluence": DIR_PATH + "electric.measures/values.csv",
}

# Load data
json_data_heat = load_json_data(data_paths["json_heat"])
csv_data_heat = load_csv_data(data_paths["csv_heat"])
json_data_fluence = load_json_data(data_paths["json_fluence"])
csv_data_fluence = load_csv_data(data_paths["csv_fluence"])

# Add time column to csv_data if JSON data exists
if json_data_heat and csv_data_heat is not None:
    csv_data_heat["time"] = json_data_heat["times"]
if json_data_fluence and csv_data_fluence is not None:
    csv_data_fluence["time"] = json_data_fluence["times"]

# Initialize the Dash app
app = dash.Dash(__name__, suppress_callback_exceptions=True)

# Define the layout of the app
app.layout = html.Div(
    [
        html.H1("Thermo-electric Data Visualization"),
        # Heat Data Section
        (
            html.Div(
                [
                    html.H2("Heat Data"),
                    html.Div(
                        [
                            html.Label("Select Heat Point of Interest"),
                            dcc.Dropdown(
                                id="heat-points-dropdown",
                                options=(
                                    [
                                        {"label": col, "value": col}
                                        for col in csv_data_heat.columns
                                        if col.startswith("Points")
                                    ]
                                    if csv_data_heat is not None
                                    else []
                                ),
                                value=(
                                    next(
                                        (
                                            col
                                            for col in csv_data_heat.columns
                                            if col.startswith("Points")
                                        ),
                                        None,
                                    )
                                    if csv_data_heat is not None
                                    else None
                                ),
                            ),
                        ]
                    ),
                    dcc.Graph(id="heat-points-graph"),
                    html.Div(
                        [
                            html.Label("Select Heat Statistic of Interest"),
                            dcc.Dropdown(
                                id="heat-statistics-dropdown",
                                options=(
                                    [
                                        {"label": col, "value": col}
                                        for col in csv_data_heat.columns
                                        if col.startswith("Statistics")
                                    ]
                                    if csv_data_heat is not None
                                    else []
                                ),
                                value=(
                                    next(
                                        (
                                            col
                                            for col in csv_data_heat.columns
                                            if col.startswith("Statistics")
                                        ),
                                        None,
                                    )
                                    if csv_data_heat is not None
                                    else None
                                ),
                            ),
                        ]
                    ),
                    dcc.Graph(id="heat-statistics-graph"),
                ]
            )
            if csv_data_heat is not None
            else html.Div("Heat data is not available.")
        ),
        # Fluence Data Section
        (
            html.Div(
                [
                    html.H2("Electric Data"),
                    html.Div(
                        [
                            html.Label("Select Electric Point of Interest"),
                            dcc.Dropdown(
                                id="electric-points-dropdown",
                                options=(
                                    [
                                        {"label": col, "value": col}
                                        for col in csv_data_fluence.columns
                                        if col.startswith("Points")
                                    ]
                                    if csv_data_fluence is not None
                                    else []
                                ),
                                value=(
                                    next(
                                        (
                                            col
                                            for col in csv_data_fluence.columns
                                            if col.startswith("Points")
                                        ),
                                        None,
                                    )
                                    if csv_data_fluence is not None
                                    else None
                                ),
                            ),
                        ]
                    ),
                    dcc.Graph(id="electric-points-graph"),
                    html.Div(
                        [
                            html.Label("Select Electric Statistic of Interest"),
                            dcc.Dropdown(
                                id="electric-statistics-dropdown",
                                options=(
                                    [
                                        {"label": col, "value": col}
                                        for col in csv_data_fluence.columns
                                        if col.startswith("Statistics")
                                    ]
                                    if csv_data_fluence is not None
                                    else []
                                ),
                                value=(
                                    next(
                                        (
                                            col
                                            for col in csv_data_fluence.columns
                                            if col.startswith("Statistics")
                                        ),
                                        None,
                                    )
                                    if csv_data_fluence is not None
                                    else None
                                ),
                            ),
                        ]
                    ),
                    dcc.Graph(id="electric-statistics-graph"),
                ]
            )
            if csv_data_fluence is not None
            else html.Div("Electric data is not available.")
        ),
    ]
)


# Define callback to update heat points graph
@app.callback(
    Output("heat-points-graph", "figure"), [Input("heat-points-dropdown", "value")]
)
def update_heat_points_graph(selected_point):
    if selected_point is None:
        return go.Figure()
    fig = go.Figure()
    fig.add_trace(
        go.Scatter(
            x=csv_data_heat["time"],
            y=csv_data_heat[selected_point],
            mode="lines+markers",
            name=selected_point,
        )
    )
    fig.update_layout(
        title=f"{selected_point} over Time", xaxis_title="Time", yaxis_title="Values"
    )
    return fig


# Define callback to update heat statistics graph
@app.callback(
    Output("heat-statistics-graph", "figure"),
    [Input("heat-statistics-dropdown", "value")],
)
def update_heat_statistics_graph(selected_statistic):
    if selected_statistic is None:
        return go.Figure()
    fig = go.Figure()
    fig.add_trace(
        go.Scatter(
            x=csv_data_heat["time"],
            y=csv_data_heat[selected_statistic],
            mode="lines+markers",
            name=selected_statistic,
        )
    )
    fig.update_layout(
        title=f"{selected_statistic} over Time",
        xaxis_title="Time",
        yaxis_title="Values",
    )
    return fig


# Define callback to update electric points graph
@app.callback(
    Output("electric-points-graph", "figure"),
    [Input("electric-points-dropdown", "value")],
)
def update_fluence_points_graph(selected_point):
    if selected_point is None:
        return go.Figure()
    fig = go.Figure()
    fig.add_trace(
        go.Scatter(
            x=csv_data_fluence["time"],
            y=csv_data_fluence[selected_point],
            mode="lines+markers",
            name=selected_point,
        )
    )
    fig.update_layout(
        title=f"{selected_point} over Time", xaxis_title="Time", yaxis_title="Values"
    )
    return fig


# Define callback to update electric statistics graph
@app.callback(
    Output("electric-statistics-graph", "figure"),
    [Input("electric-statistics-dropdown", "value")],
)
def update_fluence_statistics_graph(selected_statistic):
    if selected_statistic is None:
        return go.Figure()
    fig = go.Figure()
    fig.add_trace(
        go.Scatter(
            x=csv_data_fluence["time"],
            y=csv_data_fluence[selected_statistic],
            mode="lines+markers",
            name=selected_statistic,
        )
    )
    fig.update_layout(
        title=f"{selected_statistic} over Time",
        xaxis_title="Time",
        yaxis_title="Values",
    )
    return fig


# Run the app
if __name__ == "__main__":
    app.run_server(debug=True)
