' took this code from 
Option Explicit

' On Error Resume Next

ExcelMacroExample

Sub ExcelMacroExample() 

  Dim xlApp 
  Dim xlBook 
  ' xlPath is a named arg that I can pass in via shell
  ' in this case use so can pass in relative path from R
  Dim xlPath
  xlPath = WScript.Arguments.Named.Item("xlPath")

  Set xlApp = CreateObject("Excel.Application") 
  Set xlBook = xlApp.Workbooks.Open(xlPath, 0, FALSE)
  
  'Currently you can think of these steps as being in a 'headless' mode
  'Set these to True to watch while running
  xlApp.Visible = False
  xlApp.DisplayAlerts = FALSE
  
  xlApp.Run "refresh_data"
  xlApp.Run "copy_deal_value"

  xlBook.Save
  xlApp.ActiveWorkbook.Close
  xlApp.Quit 

  Set xlBook = Nothing 
  Set xlApp = Nothing 

End Sub 