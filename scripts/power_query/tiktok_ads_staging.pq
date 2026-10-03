/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  tiktok_ads_staging Table Power Query Data Cleaning
   ========================================================================= */

    // Cleaned for public GitHub repository
let
    Source = Csv.Document(File.Contents("\Marketing Analytics & BI Engine\01_raw_extracts\tiktok_ads_raw.csv"),[Delimiter=",", Columns=11, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Cost_USD", Currency.Type}, {"Impressions", Int64.Type}, {"Clicks", Int64.Type}, {"Gross_Revenue_Reported", Currency.Type}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Stat_Time", "full_date"}, {"Campaign_ID", "campaign_id"}, {"Campaign_Name", "campaign_name"}, {"Adgroup_ID", "ad_group_id"}, {"Adgroup_Name", "ad_group_name"}, {"Ad_ID", "ad_id"}, {"Ad_Name", "ad_name"}, {"Cost_USD", "spend_usd"}, {"Impressions", "impressions"}, {"Clicks", "clicks"}, {"Gross_Revenue_Reported", "platform_reported_revenue"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns",{{"full_date", type datetime}}),
    #"Extracted Date" = Table.TransformColumns(#"Changed Type1",{{"full_date", DateTime.Date, type date}}),
    #"Added Custom" = Table.AddColumn(#"Extracted Date", "Custom", each Date.Year([full_date]) * 10000 + Date.Month([full_date]) * 100 + Date.Day([full_date])),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"full_date", "Custom", "campaign_id", "campaign_name", "ad_group_id", "ad_group_name", "ad_id", "ad_name", "spend_usd", "impressions", "clicks", "platform_reported_revenue"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Reordered Columns",{{"Custom", "date_key"}}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Renamed Columns1",{{"date_key", Int64.Type}}),
    #"Added Custom1" = Table.AddColumn(#"Changed Type2", "Custom", each "CHAN-03"),
    #"Renamed Columns2" = Table.RenameColumns(#"Added Custom1",{{"Custom", "channel_key"}}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Renamed Columns2",{"full_date", "date_key", "channel_key", "campaign_id", "campaign_name", "ad_group_id", "ad_group_name", "ad_id", "ad_name", "spend_usd", "impressions", "clicks", "platform_reported_revenue"})
in
    #"Reordered Columns1"