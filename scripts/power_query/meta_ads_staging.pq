/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  meta_ads_staging Table Power Query Data Cleaning
   ========================================================================= */

    // Cleaned for public GitHub repository
let
    Source = Csv.Document(File.Contents("\Marketing Analytics & BI Engine\01_raw_extracts\meta_ads_raw.csv"),[Delimiter=",", Columns=11, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Day", type date}, {"Campaign ID", type text}, {"Campaign Name", type text}, {"Ad Set ID", type text}, {"Ad Set Name", type text}, {"Ad ID", type text}, {"Ad Name", type text}, {"Amount Spent (USD)", Currency.Type}, {"Impressions", Int64.Type}, {"Link Clicks", Int64.Type}, {"Purchases Conversion Value", Currency.Type}}),
    #"Added Custom" = Table.AddColumn(#"Changed Type", "date_key", each Date.Year([Day]) * 10000 + Date.Month([Day]) * 100 + Date.Day([Day])),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Custom",{{"date_key", Int64.Type}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type1",{{"Day", "full_date"}, {"Campaign ID", "campaign_id"}, {"Campaign Name", "campaign_name"}, {"Ad Set ID", "ad_set_id"}, {"Ad Set Name", "ad_set_name"}, {"Ad ID", "ad_id"}, {"Ad Name", "ad_name"}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Renamed Columns",{"full_date", "date_key", "campaign_id", "campaign_name", "ad_set_id", "ad_set_name", "ad_id", "ad_name", "Amount Spent (USD)", "Impressions", "Link Clicks", "Purchases Conversion Value"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Reordered Columns",{{"Amount Spent (USD)", "spend_usd"}, {"Link Clicks", "clicks"}, {"Purchases Conversion Value", "platform_reported_revenue"}, {"ad_set_id", "ad_group_id"}, {"ad_set_name", "ad_group_name"}, {"Impressions", "impressions"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns1", "Custom", each "CHAN-01"),
    #"Renamed Columns2" = Table.RenameColumns(#"Added Custom1",{{"Custom", "channel_id"}}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Renamed Columns2",{"full_date", "date_key", "channel_id", "campaign_id", "campaign_name", "ad_group_id", "ad_group_name", "ad_id", "ad_name", "spend_usd", "impressions", "clicks", "platform_reported_revenue"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Reordered Columns1",{{"channel_id", "channel_key"}}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Renamed Columns3",{{"channel_key", type text}})
in
    #"Changed Type2"