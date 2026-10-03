/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  google_ads_staging Table Power Query Data Cleaning
   ========================================================================= */

let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("bc5NC8IwDAbgv1J6UpgwRHefU+ZBHSie5g5hC11xJJBVhv/eVhh+sFPeJOQhZamzfXpaxCsd6ZzZdKgKMUC29oOpdNkV6vaI42WiMiaH5NQBoVEzFhV2RyAwKHNdRaO99mdbK1i7ybARoGY0zxhIy/RRc+HBte/+W03CW65F8fVKd+KB/hL0vTWEP0pK0D2drXtPVS8=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [channel_id = _t, channel_name = _t, channel_group = _t, attribution_type = _t, primary_platform_owner = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"channel_id", type text}, {"channel_name", type text}, {"channel_group", type text}, {"attribution_type", type text}, {"primary_platform_owner", type text}})
in
    #"Changed Type"