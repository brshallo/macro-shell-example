
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
  knitr::kable()
```

| deal\_id | project\_item | years | costs | revenue |
|:---------|--------------:|------:|------:|--------:|
| 0accb7af |             1 |     7 |   4.0 |     4.5 |
| 0accb7af |             2 |     7 |   1.4 |     2.1 |
| 0accb7af |             3 |     7 |   1.1 |     1.2 |
| 0accb7af |             4 |     9 |   3.7 |     4.6 |
| 0accb7af |             5 |     7 |   0.5 |     1.7 |
| 0accb7af |             6 |     1 |   2.6 |     3.6 |
| 0accb7af |             7 |     3 |   2.1 |     3.5 |
| 0accb7af |             8 |     7 |   2.8 |     3.4 |
| 0accb7af |             9 |     6 |   2.3 |     3.0 |
| 0accb7af |            10 |     7 |   2.7 |     2.9 |
| 0accb7af |            11 |     6 |   2.3 |     3.0 |
| 0accb7af |            12 |     3 |   3.4 |     4.2 |

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
