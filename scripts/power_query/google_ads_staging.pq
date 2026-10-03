/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  google_ads_staging Table Power Query Data Cleaning
   ========================================================================= */

    // Cleaned for public GitHub repository
let
    Source = Csv.Document(File.Contents("\Marketing Analytics & BI Engine\01_raw_extracts\google_ads_raw.csv"),[Delimiter=",", Columns=11, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Date", type date}, {"Campaign ID", type text}, {"Campaign", type text}, {"Ad Group ID", type text}, {"Ad Group", type text}, {"Ad ID", type text}, {"Ad Description", type text}, {"Cost", Currency.Type}, {"Impressions", Int64.Type}, {"Clicks", Int64.Type}, {"Total Conv. Value", Currency.Type}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "date_key", each Date.Year([Date]) * 10000 + Date.Month([Date]) * 100 + Date.Day([Date])),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"Date", "date_key", "Campaign ID", "Campaign", "Ad Group ID", "Ad Group", "Ad ID", "Ad Description", "Cost", "Impressions", "Clicks", "Total Conv. Value"}),
    #"Renamed Columns" = Table.RenameColumns(#"Reordered Columns",{{"Date", "full_date"}, {"Campaign ID", "campaign_id"}, {"Campaign", "campaign_name"}, {"Ad Group ID", "ad_group_id"}, {"Ad Group", "ad_group_name"}, {"Ad ID", "ad_id"}, {"Ad Description", "ad_description"}, {"Cost", "spend_usd"}, {"Impressions", "impressions"}, {"Clicks", "clicks"}, {"Total Conv. Value", "platform_reported_revenue"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns", "channel_key", each "CHAN-02"),
    #"Reordered Columns1" = Table.ReorderColumns(#"Added Custom1",{"full_date", "date_key", "channel_key", "campaign_id", "campaign_name", "ad_group_id", "ad_group_name", "ad_id", "ad_description", "spend_usd", "impressions", "clicks", "platform_reported_revenue"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Reordered Columns1",{{"ad_description", "ad_name"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns1",{{"date_key", Int64.Type}, {"channel_key", type text}, {"campaign_id", type text}})
in
    #"Changed Type1"