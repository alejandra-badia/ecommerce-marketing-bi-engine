/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  discount_waterfall_structure Table Power Query Data Cleaning
   ========================================================================= */

let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCi5JLfAvSkktUtIBs/0Sc1OVYnWilQyBAu5F+cXFCsGJOanFYDEjoJhLZnFyfmleCVAkFgA=", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Column1 = _t, Column2 = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Column1", type text}, {"Column2", type text}}),
    #"Promoted Headers" = Table.PromoteHeaders(#"Changed Type", [PromoteAllScalars=true]),
    #"Changed Type1" = Table.TransformColumnTypes(#"Promoted Headers",{{"StepOrder", Int64.Type}, {"StepName", type text}})
in
    #"Changed Type1"