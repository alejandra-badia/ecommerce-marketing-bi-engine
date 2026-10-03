/* =========================================================================
  E-Commerce Marketing & LTV Analytics
  
  profit_waterfall_structure Table Power Query Data Cleaning
   ========================================================================= */

let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WCi5JLfAvSkktUtIBs/0Sc1OBTM9il9SU0uSSzPw8pVidaCVDoJhfaolCcGJOajGQbQAWNQKynP3dg4GUIVjAGMhyTFEILkjNS4EIxgIA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Column1 = _t, Column2 = _t, Column3 = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Column1", type text}, {"Column2", type text}, {"Column3", type text}}),
    #"Promoted Headers" = Table.PromoteHeaders(#"Changed Type", [PromoteAllScalars=true]),
    #"Changed Type1" = Table.TransformColumnTypes(#"Promoted Headers",{{"StepOrder", Int64.Type}, {"StepName", type text}, {"IsDeduction", Int64.Type}})
in
    #"Changed Type1"