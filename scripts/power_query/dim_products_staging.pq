/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  dim_products_staging Table Power Query Data Cleaning
   ========================================================================= */

    // Cleaned for public GitHub repository
let
    Source = Csv.Document(File.Contents("C:Marketing Analytics & BI Engine\01_raw_extracts\dim_products_raw.csv"),[Delimiter=",", Columns=8, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"product_id", type text}, {"sku", type text}, {"product_name", type text}, {"category", type text}, {"subcategory", type text}, {"unit_cost", Currency.Type}, {"retail_price", Currency.Type}, {"is_active", type logical}})
in
    #"Changed Type"