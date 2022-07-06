# About this dashboard

<div style="width:100%"><img src="https://github.com/nmill092/indego_datastudio/raw/master/indegodashboardscreenshot.png" style="display:block; margin:auto" height="400" >
</div>

<hr/>

This dashboard uses the [Philadelphia Indego bikeshare API](https://www.rideindego.com/about/data/) to provide semi-real-time updates* on the status of the system to a Google Data Studio dashboard. The basic flow is as follows: 

1. A Google Apps Script calls the Indego bikeshare API and uses the response to populate a Google Sheet (via the `SpreadsheetApp` class).
2. A trigger overwrites the Sheet every 5 minutes with new data from the API. 
3. The Sheets data are used to populate the [Indego Current System Status Dashboard](https://datastudio.google.com/u/0/reporting/1d1e23c0-e06b-42da-8b93-c64b7d62120a/page/p_815yo961vc) in Google Data Studio, which provides information on the overall availability of shared bikes in the city as well as some more granular detail about each station. 

In Google Data Studio, real-time data from the API are blended via a Station ID primary key with historical data about each station, which are also available [on the Indego website](https://www.rideindego.com/about/data) for each quarter of 2021. The historical data were extracted, combined and summarized using R (dplyr, purrr, stringr, lubridate). A community visualization enables the templated HTML view shown in the middle of the right-hand column of the dashboard, which due to a bug defaults to the 16th & Chestnut station.

In a future version of this dashboard, I would seek to build out a direct integration with the Indego API to avoid having to rely on a Google Sheet as an intermediary.


<sup>\* *While the underlying data are refreshed every 5 minutes, the dashboard itself is refreshed every 15 minutes, the lowest possible "data freshness" level permitted by Data Studio. So though you would therefore be unlikely to make critical life or transportation decisions based on this dashboard, it still provides a useful glimpse into how relatively busy or not busy a particular bikeshare station is at any given point in time.*</sup>
