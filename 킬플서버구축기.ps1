echo "킬링플로어2 데디케이트 서버 구축기  by. ㅇㅇ(1.239)"
echo "version : 0.5.2"

 function Check_Java_Installed {
    $check_java_install = & cmd /c "java -version 2>&1"
     if ($check_java_install | Select-String -Pattern "java version `"11.*`"." -Quiet){
         echo "자바11 설치가 확인되었습니다."
         Install_start
     }
     else{
        cls
        echo "자바가 설치되어있지 않습니다"
        echo "설치에는 자바 11이후 버전이 필요합니다"
        echo "만약 자바 11 이상이 설치되어있음에도 인식에 실패하였으면 아래 문구를 입력해 설치를 강제로 진행하십시오"
        echo "force install"
        $java_force_install = Read-Host "답 "
        if ($java_force_install -eq "force install") {
            Install_start
        }
        else {
            Install_close
        }
     }
 }

 function Install_close {
    echo "답이 틀렸습니다. 설치를 종료하고 자바 다운로드 페이지로 연결합니다."
    Read-Host "엔터를 눌러 자바11 다운로드 페이지로 연결합니다"
    start-process "https://adoptopenjdk.net/releases.html?variant=openjdk11&jvmVariant=hotspot"
    exit
 }

 function Find-Folders {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog
    $browse.SelectedPath = "C:\"
    $browse.ShowNewFolderButton = $false
    $browse.Description = "Select a directory"

    $loop = $true
    while($loop)
    {
        if ($browse.ShowDialog() -eq "OK")
        {
        $loop = $false
		
		#Insert your script here
		
        } else
        {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
                #Ends script
                return
            }
        }
    }
    $browse.SelectedPath
    $browse.Dispose()
}

 function Start_Portmapper {
 $myip = ((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
 java -jar $runportmapper -add -externalPort $server_gameport -internalPort $server_gameport -ip $myip -protocol udp
 java -jar $runportmapper -add -externalPort $server_queryport -internalPort $server_queryport -ip $myip -protocol udp
 java -jar $runportmapper -add -externalPort $server_webadminport -internalPort $server_webadminport -ip $myip -protocol tcp
 java -jar $runportmapper -add -externalPort $server_steamport -internalPort $server_steamport -ip $myip -protocol udp
 java -jar $runportmapper -add -externalPort $server_ntpport -internalPort $server_ntpport -ip $myip -protocol udp
 }

function portmapping {
    echo "포트 지정이 완료되었습니다."
    echo "포트포워딩을 자동으로 하실 경우 uPNP기능을 사용하여 진행합니다"
    $portmapping = Read-Host "포트포워딩을 자동으로 진행 하시겠습니까? (Y/N) "
    if ("Y" -eq $portmapping) {
        Start_Portmapper
    }
    elseif ("N" -eq $portmapping) {
        echo "포트매핑을 취소하셨습니다. 수동으로 포트포워딩 해주시기 바랍니다"
        echo ""
        echo ""
        echo "포트포워딩이 필요한 포트를 안내드립니다."
        echo "아래 포트들을 포트포워딩 해주시기 바랍니다"
        echo ""
        echo "포트 종류        포트번호     프로토콜"
        echo ""
        echo "게임 포트        $server_gameport         UDP"
        echo "쿼리 포트        $server_queryport        UDP"
        echo "웹어드민 포트    $server_webadminport         TCP"
        echo "스팀 포트        20560        UDP"
        echo "NTP 포트         123          UDP"
        echo ""
        echo ""
    }
    else {
        cls
        echo "잘못된 값이 선택되었습니다. 다시 선택해주시기 바랍니다"
        portmapping
    }
}

 function Install_start {
echo "킬링플로어2 데디케이트 서버를 설치할 폴더를 지정해주세요"
$install = Find-Folders
$steamcmd = $install + "\cmd"
mkdir $steamcmd

$runcmd = $steamcmd + "\steamcmd.exe"
$runportmapper = $steamcmd + "\portmapper-2.2.1.jar"
wget https://github.com/mkco5162/steamcmd/raw/main/steamcmd.exe -outfile $runcmd
wget https://github.com/mkco5162/steamcmd/raw/main/portmapper-2.2.1.jar -outfile $runportmapper
#Invoke-item $steamcmd
$cmdscript = $steamcmd + "\Install_KF2.txt"
Set-Content $cmdscript "login anonymous`nforce_install_dir $install`napp_update 232130 validate`nexit"
$creatbat = $steamcmd + "\install.bat"
$battext = $runcmd + " +runscript Install_KF2.txt"
Set-Content $creatbat $battext
$startinstall = $steamcmd + "\install.bat"
Start-Process $startinstall
Start-Sleep -s 3
wait-process -name steamcmd
$Serverinstall = $install + "\Binaries\win64\KFServer"
Start-Process $Serverinstall
echo ""
echo "최초 서버 실행이 완료되면 20초 후 설치가 계속됩니다"
echo ""
Start-Sleep -s 23
Stop-Process -Name "kfserver"

$Filepath1 = $install + "\KFGame\Config\PCServer-KFEngine.ini"
$steamworkshop = Get-Content $Filepath1
 if ($steamworkshop | Select-String -Pattern "DownloadManagers=OnlineSubsystemSteamworks" -Quiet){
 }
 else {
    (Get-Content $Filepath1).replace("[IpDrv.TcpNetDriver]","[IpDrv.TcpNetDriver]`nDownloadManagers=OnlineSubsystemSteamworks.SteamWorkshopDownload") | Set-Content $Filepath1
 }
$steamworkshop = Get-Content $Filepath1
 if ($steamworkshop | Select-String -Pattern "ServerSubscribedWorkshopItems=" -Quiet){
 }
 else {
    Add-Content $Filepath1 -Value "[OnlineSubsystemSteamworks.KFWorkshopSteamworks]`nServerSubscribedWorkshopItems="
 }
$Filepath2 = $install + "\KFGame\Config\KFWeb.ini"
(Get-Content $Filepath2).replace("MaxValueLength=4096","MaxValueLength=999999") | Set-Content $Filepath2
(Get-Content $Filepath2).replace("MaxLineLength=4096","MaxLineLength=999999") | Set-Content $Filepath2
(Get-Content $Filepath2).replace("bEnabled=false","bEnabled=true") | Set-Content $Filepath2
echo ""
$input_servername = Read-Host "서버 이름을 지정해 주십시오"
echo ""
$Set_servername = "ServerName=" + $input_servername
$Filepath3 = $install + "\KFGame\Config\PCServer-KFGame.ini"
(Get-Content $Filepath3).replace("ServerName=Killing Floor 2 Server",$Set_servername) | Set-Content $Filepath3
echo ""
echo "지금부터 게임 세부설정을 진행합니다."
echo "기본값으로 사용하시려면 그냥 엔터를 눌러주시기 바랍니다."
echo ""
echo "게임 포트 : 서버 접속시 이용하는 포트 (기본값 : 7777)"
$server_gameport = Read-Host "게임 포트 입력 "
echo ""
if (0 -eq $server_gameport)
{
    echo "게임포트가 0 입니다. 기본값인 7777로 지정합니다"
    $server_gameport = 7777
}
echo ""
echo "쿼리 포트 : 스팀과 통신하는데 사용하는 포트 (기본값 : 27015)"
$server_queryport = Read-Host "쿼리 포트 입력 "
echo ""
if (0 -eq $server_queryport)
{
    echo "쿼리 포트가 0 입니다. 기본값인 27015로 지정합니다"
    $server_queryport = 27015
}
echo ""
echo "기본값인 8080번 포트가 uPNP사용 불가하여 8888 사용을 권장합니다"
echo "웹어드민 포트 : 웹어드민 접속시 이용하는 포트 (기본값 : 8888)"
$server_webadminport = Read-Host "웹어드민 포트 입력 "
echo ""
if (0 -eq $server_webadminport)
{
    echo "웹어드민 포트가 0 입니다. 기본값인 8888으로 지정합니다"
    $server_webadminport = 8888
}
$server_steamport = 20560
$server_ntpport = 123
#포트매핑 자동/수동 선택분기
portmapping
$server_webadminpassword = Read-Host "웹어드민에 사용할 암호 입력 "
echo ""
$server_difficulty = Read-Host "서버 난이도 설정 (보통:0, 어려움:1, 자살행위:2, 생지옥:3) "
echo ""
$server_gamemode = Read-Host "게임모드 설정 (VS(PvP):1, 서바이벌(Survival):2, 무한(Endless):3, 주간(Weekly):4) "
echo ""
if (0 -eq $server_gamemode)
{
    echo "게임모드가 0입니다. 서바이벌 모드로 설정합니다"
    $server_gamemode = "?Game=KFGameContent.KFGameInfo_Survival"
}
if (1 -eq $server_gamemode)
{
    $server_gamemode = "?Game=KFGameContent.KFGameInfo_VersusSurvival"
}
if (2 -eq $server_gamemode)
{
    $server_gamemode = "?Game=KFGameContent.KFGameInfo_Survival"
}
if (3 -eq $server_gamemode)
{
    $server_gamemode = "?Game=KFGameContent.KFGameInfo_Endless"
}
if (4 -eq $server_gamemode)
{
    $server_gamemode = "?Game=KFGameContent.KFGameInfo_WeeklySurvival"
}
$server_length = Read-Host "서버 웨이브 길이 (짧음(4웨이브):0, 중간(7웨이브):1, 김(10웨이브):2) "
$server_length = "GameLength=" + $server_length
$server_length_line = Select-String "GameLength=" $Filepath3
(Get-Content $Filepath3).replace($server_length_line.Line,$server_length) | Set-Content $Filepath3
echo ""
$server_spector = Read-Host "관전자 숫자 설정 (기본값 : 2) "
if (0 -eq $server_spector)
{
    echo "관전자 숫자가 0입니다. 기본값인 2로 지정합니다"
    $server_spector = 2
}
$server_spector = "MaxSpectators=" + $server_spector
$server_spector_line = Select-String "MaxSpectators=" $Filepath3
(Get-Content $Filepath3).replace($server_spector_line.Line,$server_spector) | Set-Content $Filepath3
echo ""
echo "비밀번호가 있는 서버를 만드시려면 입력해주시기 바랍니다"
echo "공개된 방을 만드시려면 입력하지 않고 엔터를 눌러 생략합니다"
$server_gamepassword = Read-Host "비밀번호 "
$server_gamepassword = "GamePassword=" + $server_gamepassword
$server_spector_line = Select-String "GamePassword=" $Filepath3
(Get-Content $Filepath3).replace($server_spector_line.Line,$server_gamepassword) | Set-Content $Filepath3
echo ""
echo "서버 실행은 서버 설치 폴더에 가면 서버실행기.bat이 있습니다 해당 파일을 더블클릭하여 실행합니다."
Read-Host -Prompt "설정이 완료되었습니다. 엔터를 눌러 설치를 종료합니다"

$server_start_bat = $install + "\서버실행기.bat"
$run_server_script = "start .\Binaries\win64\kfserver kf-bioticslab" + "?adminpassword=$server_webadminpassword" + $server_gamemode + "?Difficulty=$server_difficulty" + "-Port=$server_gameport" + "-QueryPort=$server_queryport" + "-WebAdminPort=$server_webadminport"
Set-Content $server_start_bat $run_server_script
}
################
#기능로딩 완료 설치시작
################
Check_Java_Installed
