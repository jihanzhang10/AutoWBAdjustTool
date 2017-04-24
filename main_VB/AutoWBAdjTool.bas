Attribute VB_Name = "AutoWBAdjTool"
Option Explicit

'==========User-defined Type==========
Public Type COLORTEMPSPEC
    xx                         As Long
    yy                         As Long
    lv                         As Long
    nColorRR                   As Long
    nColorGG                   As Long
    nColorBB                   As Long
    xt                         As Long
    yt                         As Long
    nLowRR                     As Long
    nLowGG                     As Long
    nLowBB                     As Long
End Type

Public Type REALCOLOR
    xx                         As Long
    yy                         As Long
    lv                         As Long
End Type

Public Type REALRGB
    cRR                        As Long
    cGG                        As Long
    cBB                        As Long
End Type

Public Enum CommunicationMode
    modeUART = 1
    modeNetwork
    modeI2c
End Enum

'==========Const==========
Public Const ADJMODE_1 As Integer = 1
Public Const ADJMODE_2 As Integer = 2
Public Const ADJMODE_3 As Integer = 3
Public Const ADJMODE_4 As Integer = 4

Public Const ADJMODE_GAIN As Integer = 1
Public Const ADJMODE_OFFSET As Integer = 0

Public Const COLORTEMP_COOL1 As String = "COOL1"
Public Const COLORTEMP_STANDARD As String = "NORMAL"
Public Const COLORTEMP_WARM1 As String = "WARM1"

Public Const LASTSTEP As Integer = 6
Public Const REMOTE_HOST As String = "192.168.1.11"
Public Const REMOTE_PORT As Long = 8888

'==========Public Variables==========
Public Ca210ChannelNO As Long
Public delayTime As Long

Public isAdjustCool1 As Boolean
Public isAdjustCool2  As Boolean
Public isAdjustNormal  As Boolean
Public isAdjustWarm1 As Boolean
Public isAdjustWarm2  As Boolean

Public gintBarCodeLen As Integer
Public IsFunctionAutoBri As Boolean
Public isCheckColorTemp  As Boolean

Public isAdjustOffset As Boolean
Public gstrChipSet As String
Public gstrCurProjName As String
Public IsStop As Boolean
Public IsACK As Boolean
Public setTVCurrentComID As Integer
Public setTVCurrentComBaud As Long
Public setTVInputSource As String
Public setTVInputSourcePortNum As Integer
Public maxBrightnessSpec As Long

Public IsCa210ok As Boolean
Public isNetworkConnected As Boolean
Public utdCommMode As CommunicationMode

Public gstrBarCode As String
Public countTime As Long
Public gstrBrand As String

Public gstrVPGModel As String
Public glngI2cClockRate As Long
Public gstrVPGTiming As String
Public gstrVPG100IRE As String
Public gstrVPG80IRE As String
Public gstrVPG20IRE As String

Public rRGB As REALRGB
Public rRGB1 As REALRGB


Public cn As New ADODB.Connection
Public rs As New ADODB.Recordset
Public sqlstring As String


Public Sub Main()
    FormSplash.Show
End Sub

Public Function FuncOpenSQL(sqlstr As String)
    On Error GoTo ADOERROR
    Dim strPath As String
    strPath = App.Path
    
    If Right(strPath, 1) <> "\" Then strPath = strPath & "\"
    
    Set cn = New ADODB.Connection
    Set rs = New ADODB.Recordset

    rs.CursorLocation = adUseClient
    cn.ConnectionString = "provider=microsoft.jet.oledb.4.0;data source=" & strPath & "Data.mdb"
    cn.Open
    rs.Open sqlstr, cn, adOpenDynamic, adLockOptimistic

    Exit Function

ADOERROR:
    MsgBox Err.Source & "------" & Err.Description
End Function

Public Sub Log_Info(strLog As String)
    FormMain.CheckStep.Text = FormMain.CheckStep.Text + strLog + vbCrLf
    FormMain.CheckStep.SelStart = Len(FormMain.CheckStep)

    SaveLogInFile strLog
End Sub

Public Sub SaveLogInFile(strLog As String)
    Dim logPath As String

    logPath = App.Path & "\" & "Logs\"
    If Right(logPath, 1) <> "\" Then logPath = logPath & "\"
    
    If Dir(logPath, vbDirectory) = "" Then
        MkDir logPath
    End If
    
    Open (logPath & gstrCurProjName & "-" & Format(Date, "YYYY-MM-DD") & ".log") For Append As #1
    Print #1, CStr(Time) & "> " & strLog
    Close #1
End Sub
