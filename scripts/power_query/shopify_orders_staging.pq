/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  shopify_orders_staging Table Power Query Data Cleaning
   ========================================================================= */

    // Cleaned for public GitHub repository
let
    Source = Csv.Document(File.Contents("\Marketing Analytics & BI Engine\01_raw_extracts\shopify_orders_raw.csv"),[Delimiter=",", Columns=15, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Name", type text}, {"Created at", type datetimezone}, {"Email", type text}, {"Financial Status", type text}, {"Fulfillment Status", type text}, {"Currency", type text}, {"Subtotal", Int64.Type}, {"Discount Code", type text}, {"Discount Amount", Int64.Type}, {"Lineitem quantity", Int64.Type}, {"Lineitem name", type text}, {"Lineitem price", Int64.Type}, {"Lineitem SKU", type text}, {"Billing Country", type text}, {"Billing Province", type text}}),
    #"Extracted Date" = Table.TransformColumns(#"Changed Type",{{"Created at", DateTime.Date, type date}}),
    #"Trimmed Text" = Table.TransformColumns(#"Extracted Date",{{"Email", Text.Trim, type text}}),
    #"Lowercased Text" = Table.TransformColumns(#"Trimmed Text",{{"Email", Text.Lower, type text}}),
    #"Added Custom" = Table.AddColumn(#"Lowercased Text", "hash_customer_email", each Binary.ToText(Text.ToBinary([Email]), BinaryEncoding.Hex)),
    #"Reordered Columns" = Table.ReorderColumns(#"Added Custom",{"Name", "Created at", "Email", "hash_customer_email", "Financial Status", "Fulfillment Status", "Currency", "Subtotal", "Discount Code", "Discount Amount", "Lineitem quantity", "Lineitem name", "Lineitem price", "Lineitem SKU", "Billing Country", "Billing Province"}),
    #"Removed Columns" = Table.RemoveColumns(#"Reordered Columns",{"Email"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Name", "order_id"}}),
    #"Added Custom1" = Table.AddColumn(#"Renamed Columns", "Custom", each Date.Year([Created at])*10000+Date.Month([Created at])*100+Date.Day([Created at])),
    #"Renamed Columns1" = Table.RenameColumns(#"Added Custom1",{{"Custom", "date_key"}}),
    #"Reordered Columns1" = Table.ReorderColumns(#"Renamed Columns1",{"order_id", "Created at", "date_key", "hash_customer_email", "Financial Status", "Fulfillment Status", "Currency", "Subtotal", "Discount Code", "Discount Amount", "Lineitem quantity", "Lineitem name", "Lineitem price", "Lineitem SKU", "Billing Country", "Billing Province"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Reordered Columns1",{{"Financial Status", "financial_status"}, {"hash_customer_email", "encoded_customer_email"}}),
    #"Filtered Rows" = Table.SelectRows(#"Renamed Columns2", each true),
    #"Replaced Value" = Table.ReplaceValue(#"Filtered Rows","","No Discount",Replacer.ReplaceValue,{"Discount Code"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Replaced Value",{"Currency"}),
    #"Renamed Columns3" = Table.RenameColumns(#"Removed Columns1",{{"Subtotal", "gross_amount"}, {"Discount Code", "discount_code"}, {"Fulfillment Status", "fulfillment_status"}, {"Discount Amount", "discount_amount"}, {"Lineitem quantity", "quantity"}, {"Lineitem name", "lineitem_name"}, {"Lineitem price", "unit_price"}, {"Lineitem SKU", "sku"}, {"Billing Country", "country"}}),
    #"Removed Columns2" = Table.RemoveColumns(#"Renamed Columns3",{"Billing Province"}),
    #"Renamed Columns4" = Table.RenameColumns(#"Removed Columns2",{{"Created at", "full_date"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns4",{{"encoded_customer_email", type text}, {"date_key", Int64.Type}, {"gross_amount", Currency.Type}, {"discount_amount", Currency.Type}, {"unit_price", Currency.Type}}),
    #"Merged Queries" = Table.NestedJoin(#"Changed Type1", {"encoded_customer_email"}, customer_key_map, {"encoded_customer_email"}, "customer_key_map", JoinKind.LeftOuter),
    #"Expanded customer_key_map" = Table.ExpandTableColumn(#"Merged Queries", "customer_key_map", {"customer_key"}, {"customer_key"}),
    #"Reordered Columns2" = Table.ReorderColumns(#"Expanded customer_key_map",{"order_id", "full_date", "date_key", "customer_key", "encoded_customer_email", "financial_status", "fulfillment_status", "gross_amount", "discount_code", "discount_amount", "quantity", "lineitem_name", "unit_price", "sku", "country"}),
    #"Removed Columns3" = Table.RemoveColumns(#"Reordered Columns2",{"encoded_customer_email"})
in
    #"Removed Columns3"