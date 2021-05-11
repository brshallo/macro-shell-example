
<!-- README.md is generated from README.Rmd. Please edit that file -->

This repo provides the example for my blog post on \[Macros in the
Shell: Integrating That Spreadsheet From Finance Into Your Messy Data
Pipeline\].

# Example

Let’s break down the kinds of pipelines we are talking about in \[the
associated post\] into theoretical steps

1.  [Your Pipeline Calculates Things](#your-pipeline-calculates-things)
2.  [You Pass Those Things Through Spreadsheet /
    Macro](#you-pass-those-things-through-spreadsheet-macro)
3.  [Your Pipeline Collects Outputs from Spreadsheet /
    Macro](#your-pipeline-collects-outputs-from-spreadsheet-macro)

## Your Pipeline Calculates Things

For our simple example, pretend you are evaluating deals for
investments. Deals come in batches of projects. Projects can have
varying…

-   costs (paid in lump sums)
-   revenues (received in lump sums)
-   years from costs (paid) until revenue (received)

An example deal may look like this:

``` r
library(tidyverse)

source(here::here("R", "funs.R"))

set.seed(1234)
create_deal(12) %>% 
  gt::gt()
```

<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#biagsinbod .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#biagsinbod .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#biagsinbod .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#biagsinbod .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 4px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#biagsinbod .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#biagsinbod .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#biagsinbod .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#biagsinbod .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#biagsinbod .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#biagsinbod .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#biagsinbod .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#biagsinbod .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#biagsinbod .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#biagsinbod .gt_from_md > :first-child {
  margin-top: 0;
}

#biagsinbod .gt_from_md > :last-child {
  margin-bottom: 0;
}

#biagsinbod .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#biagsinbod .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#biagsinbod .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#biagsinbod .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#biagsinbod .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#biagsinbod .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#biagsinbod .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#biagsinbod .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#biagsinbod .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#biagsinbod .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#biagsinbod .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#biagsinbod .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#biagsinbod .gt_left {
  text-align: left;
}

#biagsinbod .gt_center {
  text-align: center;
}

#biagsinbod .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#biagsinbod .gt_font_normal {
  font-weight: normal;
}

#biagsinbod .gt_font_bold {
  font-weight: bold;
}

#biagsinbod .gt_font_italic {
  font-style: italic;
}

#biagsinbod .gt_super {
  font-size: 65%;
}

#biagsinbod .gt_footnote_marks {
  font-style: italic;
  font-size: 65%;
}
</style>
<div id="biagsinbod" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;"><table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">deal_id</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">project_item</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1">years</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">costs</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">revenue</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">1</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">4.0</td>
      <td class="gt_row gt_right">4.5</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">2</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">1.4</td>
      <td class="gt_row gt_right">2.1</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">3</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">1.1</td>
      <td class="gt_row gt_right">1.2</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">4</td>
      <td class="gt_row gt_center">9</td>
      <td class="gt_row gt_right">3.7</td>
      <td class="gt_row gt_right">4.6</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">5</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">0.5</td>
      <td class="gt_row gt_right">1.7</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">6</td>
      <td class="gt_row gt_center">1</td>
      <td class="gt_row gt_right">2.6</td>
      <td class="gt_row gt_right">3.6</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_center">3</td>
      <td class="gt_row gt_right">2.1</td>
      <td class="gt_row gt_right">3.5</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">8</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">2.8</td>
      <td class="gt_row gt_right">3.4</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">9</td>
      <td class="gt_row gt_center">6</td>
      <td class="gt_row gt_right">2.3</td>
      <td class="gt_row gt_right">3.0</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">10</td>
      <td class="gt_row gt_center">7</td>
      <td class="gt_row gt_right">2.7</td>
      <td class="gt_row gt_right">2.9</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">11</td>
      <td class="gt_row gt_center">6</td>
      <td class="gt_row gt_right">2.3</td>
      <td class="gt_row gt_right">3.0</td>
    </tr>
    <tr>
      <td class="gt_row gt_left">0accb7af</td>
      <td class="gt_row gt_center">12</td>
      <td class="gt_row gt_center">3</td>
      <td class="gt_row gt_right">3.4</td>
      <td class="gt_row gt_right">4.2</td>
    </tr>
  </tbody>
  
  
</table></div>

Say you fetched and/or predicted these values through a pipeline you or
your team set-up.

For our example, we are just pretending like this happened, the results
of which are simulated by the `create_deal()` function whose logic is in
“R/funs.R” which is called as the first non set-up step in “run-all.R”.

## You Pass Those Things Through Spreadsheet / Macro

This is where most of the things relevant to the post happen. The
attributes for your deal need to be passed as inputs through an excel
workbook + VBA macro (maintained by finance or someone other than
yourself). The key workbook / macros for this example live in
“data-spreadsheet/deal\_calculator.xlsm”.

Below, I walk through the steps of the operations, indicating at the
start of each line with either {DS} or {FINANCE} for whether setting-up
the step would likely be the responsibility of the data scientist or
finance:

1.  {DS} Deal information is written to a location where the spreadsheet
    is expecting it

-   This could be a separate .csv, a location within the .xlsm, or as
    parameters through the VBScript.
    -   In our case the deal “data-spreadsheet/example\_deal.csv” is
        expected to be written to the same folder where
        “data/deal\_calculator.xlsm” lives;
    -   we also pass in a relative file path via the shell script in
        *step 2* below.

2.  {DS/FINANCE} Now that the relevant information from upstream is set:
    the relevant macros are triggered by a VBScript (“vbs/run\_vbs.vbs”)
    –&gt; which is triggered by a shell function –&gt; which is run via
    an R script (“R/run-all.R”)
3.  {FINANCE} The spreadsheet in our case does the following:

-   Updates all connections in the workbook (i.e. whatever is in
    “data/example\_deal.csv”) – via the macro `refresh_data`
-   calculate the present value associated with each project on the deal
    as well as the total value for the deal – via excel table
    calculations and excel formulas
-   copies total deal value to a new cell (this macro is essentially
    meaningless, but just an extra macro thrown in for example /
    testing’s sake) – via `copy_deal_value` macro

*…you could imagine there being some more complicated calculations…*

## Your Pipeline Collects Outputs from Spreadsheet / Macro

The `readxl::read_excel()` line in “run-all.R” then reads the *total
deal value* back into R (owner of the spreadsheet would need to ensure
that location this is written to will be consistent). And the data
pipeline continues on its way…

# Appendix

# Threads helpful for setting-up VBScript

Setting-up the VB wrapper script was a bit annoying (as was setting-up
relative paths and passing in parameters to the VB script). Below are a
few threads I found helpful:

-   <https://techcommunity.microsoft.com/t5/excel/power-query-source-from-relative-paths/m-p/206150>
-   <https://stackoverflow.com/a/15621773/9059865> \# params
-   <https://stackoverflow.com/questions/20979154/how-to-close-excel-file-from-vbscript-without-being-prompted>
