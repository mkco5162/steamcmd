 function Info {
    Write-Host "#######################################################" -Foregroundcolor "Green"
    Write-Host "#######################################################" -Foregroundcolor "Green"
    Write-Host "##########                                   ##########" -Foregroundcolor "Green"
    Write-Host "##########" -Foregroundcolor "Green" -NoNewline
    Write-Host "  킬링플로어2 서버 자동구축기      " -Foregroundcolor "Red" -NoNewline
    Write-host "##########" -Foregroundcolor "Green"
    Write-Host "##########" -Foregroundcolor "Green" -NoNewline
    Write-Host "  version : 1.2.2                  " -Foregroundcolor "Red" -NoNewline
    Write-Host "##########" -Foregroundcolor "Green"
    Write-Host "##########" -Foregroundcolor "Green" -NoNewline
    Write-Host "  창작마당 DB Update : 2021.05.20  " -Foregroundcolor "Red" -NoNewline
    Write-Host "##########" -Foregroundcolor "Green"
    Write-Host "##########" -Foregroundcolor "Green" -NoNewline
    Write-Host "  Make By. ㅇㅇ(1.239)             " -Foregroundcolor "Red" -NoNewline
    Write-Host "##########" -Foregroundcolor "Green"
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
    Write-Host "2. Config 재설정 (Config 설정, 커스텀맵 추가, 서버 실행기 재설정)"
    Write-Host "3. 포트포워딩 (uPNP)"
    Write-Host "4. 다중서버 생성"
    Write-Host "5. 프로그램 종료"
    Write-Host ""
    Write-Host "만일 서버오류로 인해 재설정이 필요 할 경우 config 폴더 삭제 후 재설치를 권장합니다"
    Write-Host ""
    $Select_mainmenu = Read-Host "번호를 입력해 주시기 바랍니다 "
    switch ($Select_mainmenu)
    {
        '1' {
            Clear-Host
            Write-Host "1. 서버설치" -Foregroundcolor "Green"
            Install_start
            Config_setting
            portmapping
            add_custom_maps
            Install_done
        }
        '2' {
            Clear-Host
            Write-Host "2. Config 재설정 (Config 설정, 커스텀맵 추가, 서버 실행기 재설정)" -Foregroundcolor "Green"
            Write-Host "킬링플로어 서버가 설치된 폴더를 선택해 주십시오" -Foregroundcolor "Green"
            $script:install = Find-Folders
            $script:steamcmd = $script:install + "\cmd"
            Config_setting
	        add_custom_maps
            Install_done
        }
        '3' {
            Clear-Host
            Write-Host "3. 포트포워딩 (uPNP)" -Foregroundcolor "Green"
            portmapping
        }
        '4' {
            Clear-Host
            Write-Host "4. 다중서버 생성" -Foregroundcolor "Green"
            make_multi_server

        }
        '5' {
            Clear-Host
            Write-Host "5. 프로그램 종료" -Foregroundcolor "Green"
            exit
        }
        default {
            Clear-Host
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
        Clear-Host
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
    Write-Host "게임 포트 : 서버 접속시 이용하는 포트 " -Foregroundcolor "Green" -NoNewline
    Write-Host "(기본값 : 7777)" -Foregroundcolor "Red"
    $script:server_gameport = Read-Host "게임 포트 입력 "
    Write-Host ""
    if (0 -eq $script:server_gameport)
    {
        Write-Host "게임포트가 0 입니다. 기본값인 7777로 지정합니다" -Foregroundcolor "Green"
        $script:server_gameport = 7777
    }
    Write-Host ""
    Write-Host "쿼리 포트 : 스팀과 통신하는데 사용하는 포트 " -Foregroundcolor "Green" -NoNewline
    Write-Host "(기본값 : 27015)" -Foregroundcolor "Red"
    $script:server_queryport = Read-Host "쿼리 포트 입력 "
    Write-Host ""
    if (0 -eq $script:server_queryport)
    {
        Write-Host "쿼리 포트가 0 입니다. 기본값인 27015로 지정합니다" -Foregroundcolor "Green"
        $script:server_queryport = 27015
    }
    Write-Host ""
    Write-Host "기본값인 8080번 포트가 " -Foregroundcolor "Green" -NoNewline
    Write-Host "uPNP사용 불가" -Foregroundcolor "Red" -NoNewline
    Write-Host "하여 8888 사용을 권장합니다" -Foregroundcolor "Green"
    Write-Host "웹어드민 포트 : 웹어드민 접속시 이용하는 포트 " -Foregroundcolor "Green" -NoNewline
    Write-Host "(기본값 : 8888)" -Foregroundcolor "Red"
    $script:server_webadminport = Read-Host "웹어드민 포트 입력 "
    Write-Host ""
    if (0 -eq $server_webadminport)
    {
        Write-Host "웹어드민 포트가 0 입니다. 기본값인 8888으로 지정합니다" -Foregroundcolor "Green"
        $script:server_webadminport = 8888
    }
    $script:server_steamport = 20560
    $script:server_ntpport = 123
    Write-Host ""
    Write-Host ""
    Write-Host "포트 지정이 완료되었습니다." -Foregroundcolor "Green"
    Write-Host "포트포워딩을 자동으로 하실 경우 uPNP기능을 사용하여 진행합니다" -Foregroundcolor "Green"
    $script:portmapping = Read-Host "포트포워딩을 자동으로 진행 하시겠습니까? (Y/N) "
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
        Write-Host "게임 포트        $script:server_gameport         UDP" -Foregroundcolor "Cyan"
        Write-Host "쿼리 포트        $script:server_queryport        UDP" -Foregroundcolor "Cyan"
        Write-Host "웹어드민 포트    $script:server_webadminport         TCP" -Foregroundcolor "Cyan"
        Write-Host "스팀 포트        20560        UDP" -Foregroundcolor "Cyan"
        Write-Host "NTP 포트         123          UDP" -Foregroundcolor "Cyan"
        Write-Host ""
        Write-Host ""
    }
    else {
        Clear-Host
        Write-Host "잘못된 값이 선택되었습니다. 다시 선택해주시기 바랍니다" -Foregroundcolor "Green"
        portmapping
        #자동/수동분기 실패시 다시시도
    }
}

function add_custom_maps {
Clear-Host
Write-Host "지금부터 커스텀맵 설정을 시작합니다" -Foregroundcolor "Green"
Write-Host "커스텀맵 등록을 종료하려면 입력 값 없이 엔터를 눌러주시기 바랍니다" -Foregroundcolor "Green"
$script:get_map = Read-Host "추가하실 창작마당 맵 번호를 입력해 주십시오 "
$script:workshoplistfile = $script:steamcmd + "\workshoplist.txt"
$script:workshoplist = Get-Content $script:workshoplistfile
if (0 -eq $script:get_map)
{
Write-Host "맵 번호 입력값이 없습니다. 커스텀맵 등록을 종료합니다" -Foregroundcolor "Green"
}
elseif ($workshoplist | Select-String -Pattern $script:get_map -Quiet)
{
    $script:mapconfigline = Select-String -Path $script:workshoplistfile -Pattern $script:get_map
    $script:mapconfig = Get-Content -Path $script:workshoplistfile
    $script:configline1 = $mapconfigline.LineNumber
    $script:configline2 = $mapconfigline.LineNumber+1
    $script:custom_map_config = $script:mapconfig[$script:configline1,$script:configline2]
    Add-Content $script:Filepath3 -Value $script:custom_map_config
    Add-Content $script:Filepath1 -Value "ServerSubscribedWorkshopItems=$script:get_map"
    $script:what_map = $script:mapconfig[$configline2]
    Write-Host $script:what_map" 이 추가되었습니다" -Foregroundcolor "Green"
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
$script:install = Find-Folders
$script:steamcmd = $script:install + "\cmd"
mkdir $script:steamcmd

$script:runcmd = $script:steamcmd + "\steamcmd.exe"
$script:runportmapper = $script:steamcmd + "\portmapper-2.2.1.jar"
$script:get_workshoplist = $script:steamcmd + "\workshoplist.txt"
wget https://github.com/mkco5162/steamcmd/raw/main/steamcmd.exe -outfile $script:runcmd
wget https://github.com/mkco5162/steamcmd/raw/main/portmapper-2.2.1.jar -outfile $script:runportmapper
wget https://raw.githubusercontent.com/mkco5162/steamcmd/main/workshoplist.txt -outfile $script:get_workshoplist
#Invoke-item $steamcmd
$script:cmdscript = $script:steamcmd + "\Install_KF2.txt"
Set-Content $script:cmdscript "login anonymous`nforce_install_dir $script:install`napp_update 232130 validate`nexit"
$script:creatbat = $script:steamcmd + "\install.bat"
$script:battext = $script:runcmd + " +runscript Install_KF2.txt"
Set-Content $script:creatbat $battext
$script:startinstall = $script:steamcmd + "\install.bat"
Start-Process $script:startinstall
Start-Sleep -s 3
wait-process -name steamcmd
$script:Serverinstall = $script:install + "\Binaries\win64\KFServer"
Start-Process $script:Serverinstall
Write-Host ""
Write-Host "최초 서버 실행이 완료되면 20초 후 설치가 계속됩니다" -Foregroundcolor "Cyan"
Write-Host ""
Start-Sleep -s 23
Stop-Process -Name "kfserver"
 }

 function Config_setting {
Write-Host "게임 포트 : 서버 접속시 이용하는 포트 " -Foregroundcolor "Green" -NoNewline
Write-Host "(기본값 : 7777)" -Foregroundcolor "Red"
$script:server_gameport = Read-Host "게임 포트 입력 "
Write-Host ""
if (0 -eq $script:server_gameport)
{
    Write-Host "게임포트가 0 입니다. 기본값인 7777로 지정합니다" -Foregroundcolor "Green"
    $script:server_gameport = 7777
}
Write-Host ""
Write-Host "쿼리 포트 : 스팀과 통신하는데 사용하는 포트 " -Foregroundcolor "Green" -NoNewline
Write-Host "(기본값 : 27015)" -Foregroundcolor "Red"
$script:server_queryport = Read-Host "쿼리 포트 입력 "
Write-Host ""
if (0 -eq $script:server_queryport)
{
    Write-Host "쿼리 포트가 0 입니다. 기본값인 27015로 지정합니다" -Foregroundcolor "Green"
    $script:server_queryport = 27015
}
Write-Host ""
Write-Host "기본값인 8080번 포트가 " -Foregroundcolor "Green" -NoNewline
Write-Host "uPNP사용 불가" -Foregroundcolor "Red" -NoNewline
Write-Host "하여 8888 사용을 권장합니다" -Foregroundcolor "Green"
Write-Host "웹어드민 포트 : 웹어드민 접속시 이용하는 포트 " -Foregroundcolor "Green" -NoNewline
Write-Host "(기본값 : 8888)" -Foregroundcolor "Red"
$script:server_webadminport = Read-Host "웹어드민 포트 입력 "
Write-Host ""
if (0 -eq $script:server_webadminport)
{
    Write-Host "웹어드민 포트가 0 입니다. 기본값인 8888으로 지정합니다" -Foregroundcolor "Green"
    $script:server_webadminport = 8888
}
$script:Filepath1 = $install + "\KFGame\Config\PCServer-KFEngine.ini"
$script:steamworkshop = Get-Content $script:Filepath1
 if ($steamworkshop | Select-String -Pattern "DownloadManagers=OnlineSubsystemSteamworks" -Quiet){
 }
 else {
    (Get-Content $script:Filepath1).replace("[IpDrv.TcpNetDriver]","[IpDrv.TcpNetDriver]`nDownloadManagers=OnlineSubsystemSteamworks.SteamWorkshopDownload") | Set-Content $script:Filepath1
 }
$script:steamworkshop = Get-Content $script:Filepath1
 if ($script:steamworkshop | Select-String -Pattern "ServerSubscribedWorkshopItems=" -Quiet){
 }
 else {
    Add-Content $script:Filepath1 -Value "[OnlineSubsystemSteamworks.KFWorkshopSteamworks]`nServerSubscribedWorkshopItems="
 }
(Get-Content $script:Filepath1).replace("bUsedForTakeover=TRUE","bUsedForTakeover=FALSE") | Set-Content $script:Filepath1
$script:Filepath2 = $script:install + "\KFGame\Config\KFWeb.ini"
(Get-Content $script:Filepath2).replace("MaxValueLength=4096","MaxValueLength=999999") | Set-Content $script:Filepath2
(Get-Content $script:Filepath2).replace("MaxLineLength=4096","MaxLineLength=999999") | Set-Content $script:Filepath2
(Get-Content $script:Filepath2).replace("bEnabled=false","bEnabled=true") | Set-Content $script:Filepath2
Write-Host ""
$script:input_servername = Read-Host "서버 이름을 지정해 주십시오"
Write-Host ""
$script:Set_servername = "ServerName=" + $script:input_servername
$script:Filepath3 = $script:install + "\KFGame\Config\PCServer-KFGame.ini"
(Get-Content $script:Filepath3).replace("ServerName=Killing Floor 2 Server",$script:Set_servername) | Set-Content $script:Filepath3
Write-Host ""
Write-Host "지금부터 게임 세부설정을 진행합니다." -Foregroundcolor "Green"
Write-Host "기본값으로 사용하시려면 그냥 엔터를 눌러주시기 바랍니다." -Foregroundcolor "Green"
Write-Host ""
$script:server_webadminpassword = Read-Host "웹어드민에 사용할 암호 입력 "
Write-Host ""
$script:server_difficulty = Read-Host "서버 난이도 설정 (보통:0, 어려움:1, 자살행위:2, 생지옥:3) "
Write-Host ""
$script:server_gamemode = Read-Host "게임모드 설정 (VS(PvP):1, 서바이벌(Survival):2, 무한(Endless):3, 주간(Weekly):4) "
Write-Host ""
if (0 -eq $script:server_gamemode)
{
    Write-Host "게임모드가 0입니다. 서바이벌 모드로 설정합니다" -Foregroundcolor "Green"
    $script:server_gamemode = "?Game=KFGameContent.KFGameInfo_Survival"
}
if (1 -eq $script:server_gamemode)
{
    $script:server_gamemode = "?Game=KFGameContent.KFGameInfo_VersusSurvival"
}
if (2 -eq $script:server_gamemode)
{
    $script:server_gamemode = "?Game=KFGameContent.KFGameInfo_Survival"
}
if (3 -eq $script:server_gamemode)
{
    $script:server_gamemode = "?Game=KFGameContent.KFGameInfo_Endless"
}
if (4 -eq $script:server_gamemode)
{
    $script:server_gamemode = "?Game=KFGameContent.KFGameInfo_WeeklySurvival"
}
$script:server_length = Read-Host "서버 웨이브 길이 (짧음(4웨이브):0, 중간(7웨이브):1, 김(10웨이브):2) "
$script:server_length = "GameLength=" + $script:server_length
$script:server_length_line = Select-String "GameLength=" $script:Filepath3
(Get-Content $script:Filepath3).replace($script:server_length_line.Line,$script:server_length) | Set-Content $script:Filepath3
Write-Host ""
$script:server_spector = Read-Host "관전자 숫자 설정 (기본값 : 2) "
if (0 -eq $script:server_spector)
{
    Write-Host "관전자 숫자가 0입니다. 기본값인 2로 지정합니다" -Foregroundcolor "Green"
    $script:server_spector = 2
}
$script:server_spector = "MaxSpectators=" + $script:server_spector
$script:server_spector_line = Select-String "MaxSpectators=" $script:Filepath3
(Get-Content $script:Filepath3).replace($script:server_spector_line.Line,$script:server_spector) | Set-Content $script:Filepath3
Write-Host ""
Write-Host "비밀번호가 있는 서버를 만드시려면 입력해주시기 바랍니다" -Foregroundcolor "Green"
Write-Host "공개된 방을 만드시려면 입력하지 않고 엔터를 눌러 생략합니다" -Foregroundcolor "Green"
$script:server_gamepassword = Read-Host "비밀번호 "
$script:server_gamepassword = "GamePassword=" + $script:server_gamepassword
$script:server_spector_line = Select-String "GamePassword=" $script:Filepath3
(Get-Content $script:Filepath3).replace($script:server_spector_line.Line,$script:server_gamepassword) | Set-Content $script:Filepath3
}


 function Install_done {
$script:server_start_bat = $script:install + "\서버실행기.bat"
$script:run_server_script = "start .\Binaries\win64\kfserver kf-bioticslab" + "?adminpassword=" + $script:server_webadminpassword + $script:server_gamemode + "?Difficulty=" + $script:server_difficulty + "-Port=" + $script:server_gameport + "-QueryPort=" + $script:server_queryport + "-WebAdminPort=" + $script:server_webadminport
Set-Content $script:server_start_bat $script:run_server_script
Write-Host "서버 실행은 서버 설치 폴더에 가면 " -Foregroundcolor "Green" -NoNewline
Write-Host "서버실행기.bat" -Foregroundcolor "Red" -NoNewline
Write-Host "이 있습니다 해당 파일을 더블클릭하여 실행합니다." -Foregroundcolor "Green"
Read-Host -Prompt "설정이 완료되었습니다. 엔터를 눌러 설치를 종료합니다" -Foregroundcolor "Green"
 }

function make_multi_server {
    Write-Host "다중 서버 생성을 시작합니다" -Foregroundcolor "Green"
    Write-Host "킬링플로어 서버가 설치된 폴더를 선택해 주십시오" -Foregroundcolor "Green"
    $script:install = Find-Folders
    $script:steamcmd = $script:install + "\cmd"
    $script:runportmapper = $script:steamcmd + "\portmapper-2.2.1.jar"
    Write-Host "서버 복제시 기본값이 되는 config는 config폴더 안에 있는 파일입니다" -Foregroundcolor "Green"
    Write-Host "복제된 서버의(config폴더 내부에 있는 폴더의 config) config가 기본값이 아닙니다" -Foregroundcolor "Red"
    $script:server_final_number = Read-Host "복제할 서버의 갯수를 입력해주시기 바랍니다 "
    $script:server_final_number = [int]$script:server_final_number + 1
    $script:get_server_script = $script:install + "\서버실행기.bat"
    $script:run_server_script = Get-Content $script:get_server_script
    $script:find_webadminpassword = $script:run_server_script -match "\?adminpassword=\w+"
    $script:find_webadminpassword = $Matches.0
    $script:find_gamemode = $script:run_server_script -match "\?Game=\w+.\w+"
    $script:find_gamemode = $Matches.0
    $script:find_difficulty = $script:run_server_script -match "\?Difficulty=\d"
    $script:find_difficulty = $Matches.0
    $script:get_str = $script:run_server_script -match "-Port=\d+"
    $script:get_str = $Matches.0
    $script:get_str = $script:get_str -match "\d+"
    $script:server_gameport = $Matches.0
    $script:get_str = $script:run_server_script -match "-QueryPort=\d+"
    $script:get_str = $Matches.0
    $script:get_str = $script:get_str -match "\d+"
    $script:server_queryport = $Matches.0
    $script:get_str = $script:run_server_script -match "-WebAdminPort=\d+"
    $script:get_str = $Matches.0
    $script:get_str = $script:get_str -match "\d+"
    $script:server_webadminport = $Matches.0
    $script:server_steamport = 20560
    $script:server_ntpport = 123
    $script:Original_config_path = $script:install + "\KFGame\Config\*.ini"
    for ($i=1; $script:server_final_number -gt $i; $i++) {
        $script:New_config_path = $script:install + "\KFGame\Config\" + $i + "\"
        $script:server_gameport = [int]$script:server_gameport + 5
        $script:server_queryport = [int]$script:server_queryport + 5
        $script:server_webadminport = [int]$script:server_webadminport + 5
        mkdir $script:New_config_path
        Copy-Item $script:Original_config_path $script:New_config_path
        $script:multi_server_start_bat = $script:install + "\" + "서버실행기" + $i + "번.bat"
        $script:multi_run_server_script = "start .\Binaries\win64\kfserver kf-bioticslab" + $script:find_webadminpassword + $script:find_gamemode + $script:find_difficulty + "-Port=" + $script:server_gameport + "-QueryPort=" + $script:server_queryport + "-WebAdminPort=" + $script:server_webadminport + "-configsubdir=" + $i
        Set-Content $script:multi_server_start_bat $script:multi_run_server_script
        Start_Portmapper
        Write-Host "$i 번 서버 구축이 완료되었습니다" -Foregroundcolor "Red"
    }
}
Info
MainMenu
