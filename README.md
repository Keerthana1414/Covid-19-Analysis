# Covid-19 Data Analysis

<img src="https://www.samhsa.gov/sites/default/files/banner-covid.png" alt="Covid19">


This repository features an analysis of the COVID-19 data focused on India. The project aimed to provide a comprehensive overview of the COVID-19 situation in India and identify trends and patterns that could inform public health policy and decision-making. The project utilized Python for data parsing and cleaning, SQL for data analysis and table creation, and Excel for data visualization.



## User Manual

<table>
  <tr>
    <th>File/Folder</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>Covid-19 IPYNB Files</td>
    <td>This folder contains IPYNB files that contain data parsing and cleaning part.</td>
  </tr>
  <tr>
    <td>Covid-19 excel Files</td>
    <td>This folder contains Excel files that contain data extracted from JSON files.</td>
  </tr>
  <tr>
    <td>Covid19_Revised.sql</td>
    <td>This file contains SQL queries used to analyze the data.</td>
  </tr>
  <tr>
    <td>Covid-19_Revised.xlsx</td>
    <td>This excel file contains the charts and a dashboard that display the insights.</td>
  </tr>
</table>


## Data Collection and Preparation


<ul>
  <li>Used the Python requests module to extract the data from JSON files.</li>
  <ul>
    <li>https://data.covid19india.org/v4/min/data.min.json</li>
    <li>https://data.covid19india.org/v4/min/timeseries.min.json</li>
  </ul>
  <li>To parse and clean the data, We used the pandas module. Specifically, We loaded the JSON data into a pandas DataFrame and then removed irrelevant columns using pandas functions.</li>
  <li>After cleaning the data, We created CSV files.</li>
</ul>


## Analysis

<ul>
  <li>The dataset includes columns such as population, confirmed cases, deceased cases, recovered cases, tested, and vaccinated.</li>
  <li>To analyze the data, we have calculated several KPIs (Key Performance Indicators) including:</li>
  <ul>
    <li>Case fatality rate</li>
    <li>Recovery rate</li>
    <li>Total positive rate</li>
    <li>Total confirmed cases</li>
    <li>Total deceased cases</li>
  </ul>
  <li>Analyzed the states based on their vaccination coverage rates, testing ratio, confirmed cases, and monthly trends.</li>
</ul>

 







