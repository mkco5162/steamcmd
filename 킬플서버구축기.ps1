 function Info {
    Write-Host "#######################################################" -Foregroundcolor "Green"
    Write-Host "#######################################################" -Foregroundcolor "Green"
    Write-Host "##########                                   ##########" -Foregroundcolor "Green"
    Write-Host "##########  킬링플로어2 서버 자동구축기      ##########" -Foregroundcolor "Green"
    Write-Host "##########  version : 1.0.6                  ##########" -Foregroundcolor "Green"
    Write-Host "##########  창작마당 DB Update : 2021.05.20  ##########" -Foregroundcolor "Green"
    Write-Host "##########  Make By. ㅇㅇ(1.239)             ##########" -Foregroundcolor "Green"
    Write-Host "##########                                   ##########" -Foregroundcolor "Green"
    Write-Host "#######################################################" -Foregroundcolor "Green"
    Write-Host "#######################################################" -Foregroundcolor "Green"
    Write-Host ""
    Write-Host ""
 }

  function MainMenu {
    Write-Host "<메인메뉴>" -Foregroundcolor "Cyan"
    Write-Host ""
    Write-Host "1. 킬링플로어2 데디케이트 서버 설치 (Config설정 및 포트포워딩 포함)"
    Write-Host "2. Config 재설정 (포트포워딩 미포함)"
    Write-Host "3. 포트포워딩 (uPNP)"
    Write-Host "4. 프로그램 종료"
    Write-Host ""
    Write-Host "만일 서버오류로 인해 재설정이 필요 할 경우 config 폴더 삭제 후 재설치를 권장합니다"
    Write-Host ""
    $Select_mainmenu = Read-Host "번호를 입력해 주시기 바랍니다 "
    switch ($Select_mainmenu)
    {
        '1' {
            cls
            Write-Host "1. 서버설치" -Foregroundcolor "Green"
            Install_start
            Config_setting
            portmapping
            add_custom_maps
            Install_done
        }
        '2' {
            cls
            Write-Host "2. Config 재설정 (포트포워딩 미포함)" -Foregroundcolor "Green"
            Write-Host "킬링플로어 서버가 설치된 폴더를 선택해 주십시오" -Foregroundcolor "Green"
            $install = Find-Folders
            $steamcmd = $install + "\cmd"
            Config_setting
            Install_done
        }
        '3' {
            cls
            Write-Host "3. 포트포워딩 (uPNP)" -Foregroundcolor "Green"
            portmapping
        }
        '4' {
            cls
            Write-Host "4. 프로그램 종료" -Foregroundcolor "Green"
            exit
        }
        default {
            cls
            Write-Host "선택값이 없습니다 다시 선택해주시기 바랍니다" -Foregroundcolor "Green"
            MainMenu
        }
    }
 }


 function Check_Java_Installed {
    $check_java_install = & cmd /c "java -version 2>&1"
     if ($check_java_install | Select-String -Pattern "java version `"11.*`"." -Quiet){
         Write-Host "자바11 설치가 확인되었습니다." -Foregroundcolor "Green"
         Install_start
     }
     else{
        cls
        Write-Host "자바가 설치되어있지 않습니다" -Foregroundcolor "Green"
        Write-Host "설치에는 자바 11이후 버전이 필요합니다" -Foregroundcolor "Green"
        Write-Host "만약 자바 11 이상이 설치되어있음에도 인식에 실패하였으면 아래 문구를 입력해 설치를 강제로 진행하십시오" -Foregroundcolor "Green"
        Write-Host "force install" -Foregroundcolor "Green"
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
    Write-Host "답이 틀렸습니다. 설치를 종료하고 자바 다운로드 페이지로 연결합니다." -Foregroundcolor "Green"
    Read-Host "엔터를 눌러 자바11 다운로드 페이지로 연결합니다" -Foregroundcolor "Green"
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
            $res = [System.Windows.Forms.MessageBox]::Show("선택을 취소하셨습니다. 다시 선택하시겠습니까?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
                exit
                #Ends script
                #return
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
    Write-Host "게임 포트 : 서버 접속시 이용하는 포트 (기본값 : 7777)" -Foregroundcolor "Green"
    $server_gameport = Read-Host "게임 포트 입력 "
    Write-Host ""
    if (0 -eq $server_gameport)
    {
        Write-Host "게임포트가 0 입니다. 기본값인 7777로 지정합니다" -Foregroundcolor "Green"
        $server_gameport = 7777
    }
    Write-Host ""
    Write-Host "쿼리 포트 : 스팀과 통신하는데 사용하는 포트 (기본값 : 27015)" -Foregroundcolor "Green"
    $server_queryport = Read-Host "쿼리 포트 입력 "
    Write-Host ""
    if (0 -eq $server_queryport)
    {
        Write-Host "쿼리 포트가 0 입니다. 기본값인 27015로 지정합니다" -Foregroundcolor "Green"
        $server_queryport = 27015
    }
    Write-Host ""
    Write-Host "기본값인 8080번 포트가 uPNP사용 불가하여 8888 사용을 권장합니다" -Foregroundcolor "Green"
    Write-Host "웹어드민 포트 : 웹어드민 접속시 이용하는 포트 (기본값 : 8888)" -Foregroundcolor "Green"
    $server_webadminport = Read-Host "웹어드민 포트 입력 "
    Write-Host ""
    if (0 -eq $server_webadminport)
    {
        Write-Host "웹어드민 포트가 0 입니다. 기본값인 8888으로 지정합니다" -Foregroundcolor "Green"
        $server_webadminport = 8888
    }
    $server_steamport = 20560
    $server_ntpport = 123
    Write-Host ""
    Write-Host ""
    Write-Host "포트 지정이 완료되었습니다." -Foregroundcolor "Green"
    Write-Host "포트포워딩을 자동으로 하실 경우 uPNP기능을 사용하여 진행합니다" -Foregroundcolor "Green"
    $portmapping = Read-Host "포트포워딩을 자동으로 진행 하시겠습니까? (Y/N) "
    if ("Y" -eq $portmapping) {
        Check_Java_Installed
        Start_Portmapper
        #portmapper 실행 후 지정된 포트 포트포워딩
    }
    elseif ("N" -eq $portmapping) {
        Write-Host "포트매핑을 취소하셨습니다. 수동으로 포트포워딩 해주시기 바랍니다" -Foregroundcolor "Green"
        Write-Host ""
        Write-Host ""
        Write-Host "포트포워딩이 필요한 포트를 안내드립니다." -Foregroundcolor "Green"
        Write-Host "아래 포트들을 포트포워딩 해주시기 바랍니다" -Foregroundcolor "Green"
        Write-Host ""
        Write-Host "포트 종류        포트번호     프로토콜" -Foregroundcolor "Yellow"
        Write-Host ""
        Write-Host "게임 포트        $server_gameport         UDP" -Foregroundcolor "Cyan"
        Write-Host "쿼리 포트        $server_queryport        UDP" -Foregroundcolor "Cyan"
        Write-Host "웹어드민 포트    $server_webadminport         TCP" -Foregroundcolor "Cyan"
        Write-Host "스팀 포트        20560        UDP" -Foregroundcolor "Cyan"
        Write-Host "NTP 포트         123          UDP" -Foregroundcolor "Cyan"
        Write-Host ""
        Write-Host ""
    }
    else {
        cls
        Write-Host "잘못된 값이 선택되었습니다. 다시 선택해주시기 바랍니다" -Foregroundcolor "Green"
        portmapping
        #자동/수동분기 실패시 다시시도
    }
}

function add_custom_maps {
cls
Write-Host "지금부터 커스텀맵 설정을 시작합니다" -Foregroundcolor "Green"
Write-Host "커스텀맵 등록을 종료하려면 입력 값 없이 엔터를 눌러주시기 바랍니다" -Foregroundcolor "Green"
$get_map = Read-Host "추가하실 창작마당 맵 번호를 입력해 주십시오 "
$workshoplistfile = $steamcmd + "\workshoplist.txt"
$workshoplist = Get-Content $workshoplistfile
if (0 -eq $get_map)
{
Write-Host "맵 번호 입력값이 없습니다. 커스텀맵 등록을 종료합니다" -Foregroundcolor "Green"
}
elseif ($workshoplist | Select-String -Pattern $get_map -Quiet)
{
    $mapconfigline = Select-String -Path $workshoplistfile -Pattern $get_map
    $mapconfig = Get-Content -Path $workshoplistfile
    $configline1 = $mapconfigline.LineNumber
    $configline2 = $mapconfigline.LineNumber+1
    $custom_map_config = $mapconfig[$configline1,$configline2]
    Add-Content $Filepath3 -Value $custom_map_config
    Add-Content $Filepath1 -Value "ServerSubscribedWorkshopItems=$get_map"
    $what_map = $mapconfig[$configline2]
    Write-Host $what_map" 이 추가되었습니다" -Foregroundcolor "Green"
    add_custom_maps
}
else
{
Write-Host "데이터베이스에 존재하지 않는 맵 번호입니다. 다시 입력해주시기 바랍니다" -Foregroundcolor "Green"
Write-Host "만일 정상적인 창작마당 ID임에도 불구하고 등록이 안될경우 DB업데이트 요청바랍니다" -Foregroundcolor "Green"
add_custom_maps
}
}

 function Install_start {
Write-Host "킬링플로어2 데디케이트 서버를 설치할 폴더를 지정해주세요" -Foregroundcolor "Green"
$install = Find-Folders
$steamcmd = $install + "\cmd"
mkdir $steamcmd

$runcmd = $steamcmd + "\steamcmd.exe"
$runportmapper = $steamcmd + "\portmapper-2.2.1.jar"
$get_workshoplist = $steamcmd + "\workshoplist.txt"
wget https://github.com/mkco5162/steamcmd/raw/main/steamcmd.exe -outfile $runcmd
wget https://github.com/mkco5162/steamcmd/raw/main/portmapper-2.2.1.jar -outfile $runportmapper
wget https://raw.githubusercontent.com/mkco5162/steamcmd/main/workshoplist.txt -outfile $get_workshoplist
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
Write-Host ""
Write-Host "최초 서버 실행이 완료되면 20초 후 설치가 계속됩니다" -Foregroundcolor "Cyan"
Write-Host ""
Start-Sleep -s 23
Stop-Process -Name "kfserver"
 }

 function Config_setting {
    Write-Host "게임 포트 : 서버 접속시 이용하는 포트 (기본값 : 7777)" -Foregroundcolor "Green"
$server_gameport = Read-Host "게임 포트 입력 "
Write-Host ""
if (0 -eq $server_gameport)
{
    Write-Host "게임포트가 0 입니다. 기본값인 7777로 지정합니다" -Foregroundcolor "Green"
    $server_gameport = 7777
}
Write-Host ""
Write-Host "쿼리 포트 : 스팀과 통신하는데 사용하는 포트 (기본값 : 27015)" -Foregroundcolor "Green"
$server_queryport = Read-Host "쿼리 포트 입력 "
Write-Host ""
if (0 -eq $server_queryport)
{
    Write-Host "쿼리 포트가 0 입니다. 기본값인 27015로 지정합니다" -Foregroundcolor "Green"
    $server_queryport = 27015
}
Write-Host ""
Write-Host "기본값인 8080번 포트가 uPNP사용 불가하여 8888 사용을 권장합니다" -Foregroundcolor "Green"
Write-Host "웹어드민 포트 : 웹어드민 접속시 이용하는 포트 (기본값 : 8888)" -Foregroundcolor "Green"
$server_webadminport = Read-Host "웹어드민 포트 입력 "
Write-Host ""
if (0 -eq $server_webadminport)
{
    Write-Host "웹어드민 포트가 0 입니다. 기본값인 8888으로 지정합니다" -Foregroundcolor "Green"
    $server_webadminport = 8888
}
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
(Get-Content $Filepath1).replace("bUsedForTakeover=TRUE","bUsedForTakeover=FALSE") | Set-Content $Filepath1
$Filepath2 = $install + "\KFGame\Config\KFWeb.ini"
(Get-Content $Filepath2).replace("MaxValueLength=4096","MaxValueLength=999999") | Set-Content $Filepath2
(Get-Content $Filepath2).replace("MaxLineLength=4096","MaxLineLength=999999") | Set-Content $Filepath2
(Get-Content $Filepath2).replace("bEnabled=false","bEnabled=true") | Set-Content $Filepath2
Write-Host ""
$input_servername = Read-Host "서버 이름을 지정해 주십시오" -Foregroundcolor "Green"
Write-Host ""
$Set_servername = "ServerName=" + $input_servername
$Filepath3 = $install + "\KFGame\Config\PCServer-KFGame.ini"
(Get-Content $Filepath3).replace("ServerName=Killing Floor 2 Server",$Set_servername) | Set-Content $Filepath3
Write-Host ""
Write-Host "지금부터 게임 세부설정을 진행합니다." -Foregroundcolor "Green"
Write-Host "기본값으로 사용하시려면 그냥 엔터를 눌러주시기 바랍니다." -Foregroundcolor "Green"
Write-Host ""
$server_webadminpassword = Read-Host "웹어드민에 사용할 암호 입력 "
Write-Host ""
$server_difficulty = Read-Host "서버 난이도 설정 (보통:0, 어려움:1, 자살행위:2, 생지옥:3) "
Write-Host ""
$server_gamemode = Read-Host "게임모드 설정 (VS(PvP):1, 서바이벌(Survival):2, 무한(Endless):3, 주간(Weekly):4) "
Write-Host ""
if (0 -eq $server_gamemode)
{
    Write-Host "게임모드가 0입니다. 서바이벌 모드로 설정합니다" -Foregroundcolor "Green"
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
Write-Host ""
$server_spector = Read-Host "관전자 숫자 설정 (기본값 : 2) "
if (0 -eq $server_spector)
{
    Write-Host "관전자 숫자가 0입니다. 기본값인 2로 지정합니다" -Foregroundcolor "Green"
    $server_spector = 2
}
$server_spector = "MaxSpectators=" + $server_spector
$server_spector_line = Select-String "MaxSpectators=" $Filepath3
(Get-Content $Filepath3).replace($server_spector_line.Line,$server_spector) | Set-Content $Filepath3
Write-Host ""
Write-Host "비밀번호가 있는 서버를 만드시려면 입력해주시기 바랍니다" -Foregroundcolor "Green"
Write-Host "공개된 방을 만드시려면 입력하지 않고 엔터를 눌러 생략합니다" -Foregroundcolor "Green"
$server_gamepassword = Read-Host "비밀번호 "
$server_gamepassword = "GamePassword=" + $server_gamepassword
$server_spector_line = Select-String "GamePassword=" $Filepath3
(Get-Content $Filepath3).replace($server_spector_line.Line,$server_gamepassword) | Set-Content $Filepath3
}


 function Install_done {
$server_start_bat = $install + "\서버실행기.bat"
$run_server_script = "start .\Binaries\win64\kfserver kf-bioticslab" + "?adminpassword=$server_webadminpassword" + $server_gamemode + "?Difficulty=$server_difficulty" + "-Port=$server_gameport" + "-QueryPort=$server_queryport" + "-WebAdminPort=$server_webadminport"
Set-Content $server_start_bat $run_server_script
Write-Host "서버 실행은 서버 설치 폴더에 가면 서버실행기.bat이 있습니다 해당 파일을 더블클릭하여 실행합니다." -Foregroundcolor "Green"
Read-Host -Prompt "설정이 완료되었습니다. 엔터를 눌러 설치를 종료합니다" -Foregroundcolor "Green"
 }

Info
MainMenu
