echo "킬링플로어2 데디케이트 서버 구축기  by. ㅇㅇ(1.239)"
echo "version : 0.3"
$install = Read-Host "킬링플로어2 데디케이트 서버를 설치할 폴더를 지정해주세요"
$steamcmd = $install + "\cmd"
mkdir $steamcmd

$runcmd = $steamcmd + "\steamcmd.exe"
wget https://github.com/mkco5162/steamcmd/raw/main/steamcmd.exe -outfile $runcmd
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
#echo "서버 정상 실행이 완료되면 종료해주시기 바랍니다"
echo ""
Start-Sleep -s 23
Stop-Process -Name "kfserver"
#wait-process -name kfserver

$Filepath1 = $install + "\KFGame\Config\PCServer-KFEngine.ini"
(Get-Content $Filepath1).replace("[IpDrv.TcpNetDriver]","[IpDrv.TcpNetDriver]`nDownloadManagers=OnlineSubsystemSteamworks.SteamWorkshopDownload") | Set-Content $Filepath1
Add-Content $Filepath1 -Value "[OnlineSubsystemSteamworks.KFWorkshopSteamworks]`nServerSubscribedWorkshopItems="
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
echo "웹어드민 포트 : 웹어드민 접속시 이용하는 포트 (기본값 : 8080)"
$server_webadminport = Read-Host "웹어드민 포트 입력 "
echo ""
if (0 -eq $server_webadminport)
{
    echo "웹어드민 포트가 0 입니다. 기본값인 8080으로 지정합니다"
    $server_webadminport = 8080
}
$server_steamport = 20560
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
