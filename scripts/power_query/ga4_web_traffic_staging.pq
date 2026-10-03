/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  ga4_web_traffic_staging Table Power Query Data Cleaning
   ========================================================================= */

    // Cleaned for public GitHub repository
let
    Source = Csv.Document(File.Contents("\Marketing Analytics & BI Engine\01_raw_extracts\ga4_web_traffic_raw.csv"),[Delimiter=",", Columns=7, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"event_date", Int64.Type}, {"sessionSourceMedium", type text}, {"sessionDefaultChannelGroup", type text}, {"deviceCategory", type text}, {"sessions", Int64.Type}, {"totalUsers", Int64.Type}, {"addToCarts", Int64.Type}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"addToCarts", "atc"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns",{{"atc", Int64.Type}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Changed Type1",{{"totalUsers", "total_users"}, {"deviceCategory", "device_category"}, {"sessionDefaultChannelGroup", "channel_group"}}),
    #"Lowercased Text" = Table.TransformColumns(#"Renamed Columns1",{{"sessionSourceMedium", Text.Lower, type text}}),
    #"Trimmed Text" = Table.TransformColumns(#"Lowercased Text",{{"sessionSourceMedium", Text.Trim, type text}}),
    #"Added Custom" = Table.AddColumn(#"Trimmed Text", "channel_key", each if Text.Contains([sessionSourceMedium], "cpc") and Text.Contains([sessionSourceMedium], "google") then "CHAN-02"
else if Text.Contains([sessionSourceMedium], "organic") and Text.Contains([sessionSourceMedium], "google") then "CHAN-04"
else if Text.Contains([sessionSourceMedium], "facebook") then "CHAN-01"
else if Text.Contains([sessionSourceMedium], "tiktok") then "CHAN-03"
else if Text.Contains([sessionSourceMedium], "direct") or Text.Contains([sessionSourceMedium], "none") then "CHAN-05"
else "CHAN-06"),
    #"Changed Type2" = Table.TransformColumnTypes(#"Added Custom",{{"channel_key", type text}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type2",{"event_date", "channel_key", "sessionSourceMedium", "channel_group", "device_category", "sessions", "total_users", "atc"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Reordered Columns",{{"event_date", "date_key"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns2", "full_date", each Date.FromText(Text.From([date_key]), [Format="yyyyMMdd"])),
    #"Reordered Columns1" = Table.ReorderColumns(#"Added Custom1",{"date_key", "full_date", "channel_key", "sessionSourceMedium", "channel_group", "device_category", "sessions", "total_users", "atc"})
in
    #"Reordered Columns1"