/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  dim_calendar_staging Table Power Query Data Cleaning
   ========================================================================= */

    // Cleaned for public GitHub repository
let
    Source = Csv.Document(File.Contents("\Marketing Analytics & BI Engine\01_raw_extracts\dim_calendar_raw.csv"),[Delimiter=",", Columns=10, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"date_key", Int64.Type}, {"full_date", type date}, {"day_of_week", Int64.Type}, {"day_name", type text}, {"week_of_year", Int64.Type}, {"month_number", Int64.Type}, {"month_name", type text}, {"quarter", type text}, {"fiscal_year", Int64.Type}, {"is_weekend", type logical}})
in
    #"Changed Type"