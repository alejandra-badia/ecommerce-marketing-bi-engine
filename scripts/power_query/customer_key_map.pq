/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  customer_key_map Table Power Query Data Cleaning
   ========================================================================= */

let
    // Cleaned for public GitHub repository
    Source = Csv.Document(File.Contents("Marketing Analytics & BI Engine\01_raw_extracts\shopify_orders_raw.csv"),[Delimiter=",", Columns=15, Encoding=1252, QuoteStyle=QuoteStyle.None]),
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
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns4",{{"encoded_customer_email", type text}}),
    #"Grouped Rows" = Table.Group(#"Changed Type1", {"encoded_customer_email"}, {{"first_observed_order_date", each List.Min([full_date]), type date}, {"total_observed_lifetime_spend", each List.Sum([gross_amount]), type nullable number}, {"total_lifetime_orders", each _, type table [order_id=nullable text, full_date=date, date_key=number, encoded_customer_email=nullable text, financial_status=nullable text, fulfillment_status=nullable text, gross_amount=nullable number, discount_code=nullable text, discount_amount=nullable number, quantity=nullable number, lineitem_name=nullable text, unit_price=nullable number, sku=nullable text, country=nullable text]}}),
    #"Added Custom2" = Table.AddColumn(#"Grouped Rows", "Custom", each List.Count(List.Distinct([total_lifetime_orders][order_id]))),
    #"Renamed Columns5" = Table.RenameColumns(#"Added Custom2",{{"Custom", "total_observed_lifetime_orders"}}),
    #"Removed Columns3" = Table.RemoveColumns(#"Renamed Columns5",{"total_lifetime_orders"}),
    #"Added Index" = Table.AddIndexColumn(#"Removed Columns3", "Index", 1, 1, Int64.Type),
    #"Reordered Columns2" = Table.ReorderColumns(#"Added Index",{"Index", "encoded_customer_email", "first_observed_order_date", "total_observed_lifetime_spend", "total_observed_lifetime_orders"}),
    #"Added Custom3" = Table.AddColumn(#"Reordered Columns2", "customer_key", each "CUST-" & Text.PadStart(Text.From([Index]), 5, "0")),
    #"Reordered Columns3" = Table.ReorderColumns(#"Added Custom3",{"Index", "customer_key", "encoded_customer_email", "first_observed_order_date", "total_observed_lifetime_spend", "total_observed_lifetime_orders"}),
    #"Removed Columns4" = Table.RemoveColumns(#"Reordered Columns3",{"Index", "first_observed_order_date", "total_observed_lifetime_spend", "total_observed_lifetime_orders"})
in
    #"Removed Columns4"