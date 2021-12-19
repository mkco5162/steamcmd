 function Info {
    Write-Host "#####################################################################" -Foregroundcolor "Green"
    Write-Host "#####################################################################" -Foregroundcolor "Green"
    Write-Host "##########                                                 ##########" -Foregroundcolor "Green"
    Write-Host "##########" -Foregroundcolor "Green" -NoNewline
    Write-Host "  7Days To Die Dedicated Server Maker            " -Foregroundcolor "Red" -NoNewline
    Write-host "##########" -Foregroundcolor "Green"
    Write-Host "##########" -Foregroundcolor "Green" -NoNewline
    Write-Host "  version : 0.0.0 Alpha                          " -Foregroundcolor "Red" -NoNewline
    Write-Host "##########" -Foregroundcolor "Green"
    Write-Host "##########                                                 ##########" -Foregroundcolor "Green"
    Write-Host "#####################################################################" -Foregroundcolor "Green"
    Write-Host "#####################################################################" -Foregroundcolor "Green"
    Write-Host ""
    Write-Host ""
 }

  function MainMenu {
    Write-Host "<메인메뉴>" -Foregroundcolor "Cyan"
    Write-Host ""
    Write-Host "1. 7DTD 데디케이트 서버 설치 (Config설정 및 포트포워딩 포함)"
    Write-Host "2. Config 재설정 (Config 설정, 커스텀맵 추가, 서버 실행기 재설정)"
    Write-Host "3. 포트포워딩 (uPNP)"
    Write-Host "4. 서버 업데이트 및 무결성 검사 (정식)"
    Write-Host "5. 앱데이터 폴더 열기"
    Write-Host "6. 프로그램 종료"
    Write-Host ""
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
            Install_done
        }
        '2' {
            Clear-Host
            Write-Host "2. Config 재설정 (Config 설정, 커스텀맵 추가, 서버 실행기 재설정)" -Foregroundcolor "Green"
            Write-Host "7DTD 서버가 설치된 폴더를 선택해 주십시오" -Foregroundcolor "Green"
            $script:install = Find-Folders
            $script:steamcmd = $script:install + "\cmd"
            $script:runcmd = $script:steamcmd + "\steamcmd.exe"
            Config_setting
            Install_done
        }
        '3' {
            Clear-Host
            Write-Host "3. 포트포워딩 (uPNP)" -Foregroundcolor "Green"
            portmapping
        }
        '4' {
            Clear-Host
            Write-Host "4. 서버 업데이트 및 무결성 검사 (정식)" -Foregroundcolor "Green"
            Write-Host "7DTD 서버가 설치된 폴더를 선택해 주십시오" -Foregroundcolor "Green"
            $script:install = Find-Folders
            Install_What
        }
        '5' {
            Write-Host "5. 앱데이터 폴더 열기" -Foregroundcolor "Green"
            open_appdata
        }
        '6' {
            Clear-Host
            Write-Host "6. 프로그램 종료" -Foregroundcolor "Green"
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
     }
     else{
        Clear-Host
        Write-Host "자바가 설치되어있지 않습니다" -Foregroundcolor "Green"
        Write-Host "설치에는 자바 11이후 버전이 필요합니다" -Foregroundcolor "Green"
        Write-Host "만약 자바 11 이상이 설치되어있음에도 인식에 실패하였으면 아래 문구를 입력해 설치를 강제로 진행하십시오" -Foregroundcolor "Green"
        Write-Host "force install" -Foregroundcolor "Green"
        $java_force_install = Read-Host "답 "
        if ($java_force_install -eq "force install") {
        }
        else {
            Install_close
        }
     }
 }
 function Install_close {
    Write-Host "답이 틀렸습니다. 설치를 종료하고 자바 다운로드 페이지로 연결합니다." -Foregroundcolor "Green"
    Read-Host "엔터를 눌러 자바11 다운로드 페이지로 연결합니다"
    start-process "https://adoptium.net/releases.html?variant=openjdk11"
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
     $script:runportmapper = $script:install + "\cmd\portmapper-2.2.1.jar"
 java -jar $script:runportmapper -lib org.chris.portmapper.router.weupnp.WeUPnPRouterFactory -add -externalPort $script:server_gameport1 -internalPort $script:server_gameport1 -protocol udp
 java -jar $script:runportmapper -lib org.chris.portmapper.router.weupnp.WeUPnPRouterFactory -add -externalPort $script:server_gameport2 -internalPort $script:server_gameport2 -protocol udp
 java -jar $script:runportmapper -lib org.chris.portmapper.router.weupnp.WeUPnPRouterFactory -add -externalPort $script:server_gameport3 -internalPort $script:server_gameport3 -protocol udp
 java -jar $script:runportmapper -lib org.chris.portmapper.router.weupnp.WeUPnPRouterFactory -add -externalPort $script:server_gameport4 -internalPort $script:server_gameport4 -protocol udp
 cls
 java -jar $script:runportmapper -lib org.chris.portmapper.router.weupnp.WeUPnPRouterFactory -list
 Write-host "로그 마지막 부분에 포트포워딩 리스트가 없을경우 관리자에게 문의하시기 바랍니다." -Foregroundcolor "Red"
 Read-Host "엔터를 눌러 계속 진행합니다."
 }

function portmapping {
    $script:server_gameport1 = 25000
    $script:server_gameport2 = 25001
    $script:server_gameport3 = 25002
    $script:server_gameport4 = 25003
    Write-Host "포트포워딩을 자동으로 하실 경우 uPNP기능을 사용하여 진행합니다" -Foregroundcolor "Green"
    $script:portmapping = Read-Host "포트포워딩을 자동으로 진행 하시겠습니까? (Y/N) "
    if ("Y" -eq $portmapping) {
        if ($script:install -eq $null) {
            $script:install = Find-Folders
        }
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
        Write-Host "게임 포트1        $script:server_gameport1         UDP" -Foregroundcolor "Cyan"
        Write-Host "게임 포트2        $script:server_gameport2         UDP" -Foregroundcolor "Cyan"
        Write-Host "게임 포트3        $script:server_gameport3         UDP" -Foregroundcolor "Cyan"
        Write-Host "게임 포트4        $script:server_gameport4         UDP" -Foregroundcolor "Cyan"
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

function Install_What {
    $script:steamcmd = $script:install + "\cmd"
    $script:runcmd = $script:steamcmd + "\steamcmd.exe"
    $script:cmdscript = $script:steamcmd + "\Update_7DTD.txt"
    Set-Content $script:cmdscript "login anonymous`nforce_install_dir $script:install`napp_update 294420 validate`nexit"
    $script:creatbat = $script:steamcmd + "\Update.bat"
    $script:battext = $script:runcmd + " +runscript Update_7DTD.txt"
    Set-Content $script:creatbat $script:battext
    $script:startinstall = $script:steamcmd + "\Update.bat"
    Start-Process $script:startinstall
    }

 function Install_start {
Write-Host "7DTD 데디케이트 서버를 설치할 폴더를 지정해주세요" -Foregroundcolor "Green"
$script:install = Find-Folders
$script:steamcmd = $script:install + "\cmd"
mkdir $script:steamcmd
$script:runcmd = $script:steamcmd + "\steamcmd.exe"
$script:runportmapper = $script:steamcmd + "\portmapper-2.2.1.jar"
$script:get_startbat = $script:install + "\startdedicated.bat"
wget https://github.com/mkco5162/steamcmd/raw/main/steamcmd.exe -outfile $script:runcmd
wget https://github.com/mkco5162/steamcmd/raw/main/portmapper-2.2.1.jar -outfile $script:runportmapper
#Invoke-item $steamcmd
Install_What
Start-Sleep -s 3
wait-process -name steamcmd
wget https://raw.githubusercontent.com/mkco5162/steamcmd/main/7DTD/start.bat -outfile $script:get_startbat
$script:Serverinstall = $script:install + "\startdedicated.bat"
Start-Process $script:Serverinstall
Write-Host ""
Write-Host "약 2분 후 서버 실행이 완료되면 설치가 계속됩니다" -Foregroundcolor "Cyan"
Write-Host ""
Start-Sleep -s 120
Stop-Process -Name "7DaysToDieServer"
Stop-Process -Name "cmd"
 }

 function Config_setting {
$script:Filepath1 = $install + "\serverconfig.xml"
$script:steamworkshop = Get-Content $script:Filepath1
$script:input_servername = Read-Host "서버 이름을 지정해 주십시오"
Write-Host ""
$script:Set_servername = 'value="' + $script:input_servername + '"'
(Get-Content $script:Filepath1).replace("value=`"My Game Host`"",$script:Set_servername) | Set-Content $script:Filepath1
Write-Host ""
Write-Host "지금부터 게임 세부설정을 진행합니다." -Foregroundcolor "Green"
Write-Host "기본값으로 사용하시려면 그냥 엔터를 눌러주시기 바랍니다." -Foregroundcolor "Green"
Write-Host ""
$script:server_ServerPassword = Read-Host "서버 비밀번호 설정. 없을경우 공란 "
$script:server_ServerPassword_line = Select-String "ServerPassword" $script:Filepath1
$script:server_ServerPassword_value = '"<property name="ServerPassword"					value="' + $script:ServerPassword + '"/>'
(Get-Content $script:Filepath1).replace($script:ServerPassword_line.Line,$script:ServerPassword_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_difficulty = Read-Host "서버 난이도 설정 (Scavenger:0, Adventurer:1, Nomad(기본값):2, Warrior:3, Survivalisk:4, Insane:5) "
$script:server_difficulty_line = Select-String "GameDifficulty" $script:Filepath1
$script:server_difficulty_value = '<property name="GameDifficulty"					value="' + $script:server_difficulty + '"/>'
(Get-Content $script:Filepath1).replace($script:server_difficulty_line.Line,$script:server_difficulty_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BlockDamagePlayer = Read-Host "BlockDamagePlayer (유저가 블록에 주는 데미지 배율. 기본값:100) "
$script:server_BlockDamagePlayer_line = Select-String "BlockDamagePlayer" $script:Filepath1
$script:server_BlockDamagePlayer_value = '<property name="BlockDamagePlayer"				value="' + $script:server_BlockDamagePlayer + '" />'
(Get-Content $script:Filepath1).replace($script:server_BlockDamagePlayer_line.Line,$script:server_BlockDamagePlayer_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BlockDamageAI = Read-Host "BlockDamageAI (AI(좀비)가 블록에 주는 데미지 배율. 기본값:100) "
$script:server_BlockDamageAI_line = Select-String "BlockDamageAI" $script:Filepath1
$script:server_BlockDamageAI_value = '<property name="BlockDamageAI"					value="' + $script:server_BlockDamageAI + '" />'
(Get-Content $script:Filepath1).replace($script:server_BlockDamageAI_line.Line[0],$script:server_BlockDamageAI_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BlockDamageAIBM = Read-Host "BlockDamageAIBM (AI(좀비)가 블러드문 기간동안 블록에 주는 데미지 배율. 기본값:100) "
$script:server_BlockDamageAIBM_line = Select-String "BlockDamageAIBM" $script:Filepath1
$script:server_BlockDamageAIBM_value = '<property name="BlockDamageAIBM"				value="' + $script:server_BlockDamageAIBM + '" />'
(Get-Content $script:Filepath1).replace($script:server_BlockDamageAIBM_line.Line,$script:server_BlockDamageAIBM_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_XPMultiplier = Read-Host "XPMultiplier (AI(좀비)가 블러드문 기간동안 블록에 주는 데미지 배율. 기본값:100) "
$script:server_XPMultiplier_line = Select-String "XPMultiplier" $script:Filepath1
$script:server_XPMultiplier_value = '<property name="XPMultiplier"					value="' + $script:server_XPMultiplier + '" />'
(Get-Content $script:Filepath1).replace($script:server_XPMultiplier_line.Line,$script:server_XPMultiplier_value) | Set-Content $script:Filepath1
Write-Host ""

$script:server_DayNightLength = Read-Host "DayNightLength (인게임 24시간이 흘러가는데 소요되는 시간. 단위: 분, 기본값: 60) "
$script:server_DayNightLength_line = Select-String "DayNightLength" $script:Filepath1
$script:server_DayNightLength_value = '<property name="DayNightLength"					value="' + $script:server_DayNightLength + '" />'
(Get-Content $script:Filepath1).replace($script:server_DayNightLength_line.Line,$script:server_DayNightLength_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_DayLightLength = Read-Host "DayLightLength (인게임 24시간중 낮이 차지하는 시간. 단위: 시간, 기본값: 18) "
$script:server_DayLightLength_line = Select-String "DayLightLength" $script:Filepath1
$script:server_DayLightLength_value = '<property name="DayLightLength"					value="' + $script:server_DayLightLength + '" />'
(Get-Content $script:Filepath1).replace($script:server_DayLightLength_line.Line,$script:server_DayLightLength_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_DropOnDeath = Read-Host "DropOnDeath (사망시 아이템 드랍여부. nothing: 0 everything: 1 toolbelt_only: 2 backpack_only: 3 delete_all: 4, 기본값: 1) "
$script:server_DropOnDeath_line = Select-String "DropOnDeath" $script:Filepath1
$script:server_DropOnDeath_value = '<property name="DropOnDeath"					value="' + $script:server_DropOnDeath + '" />'
(Get-Content $script:Filepath1).replace($script:server_DropOnDeath_line.Line,$script:server_DropOnDeath_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_MaxSpawnedZombies = Read-Host "MaxSpawnedZombies (최대 좀비 스폰량. 기본값: 64) "
$script:server_MaxSpawnedZombies_line = Select-String "MaxSpawnedZombies" $script:Filepath1
$script:server_MaxSpawnedZombies_value = '<property name="MaxSpawnedZombies"				value="' + $script:server_MaxSpawnedZombies + '" />'
(Get-Content $script:Filepath1).replace($script:server_MaxSpawnedZombies_line.Line[0],$script:server_MaxSpawnedZombies_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_MaxSpawnedAnimals = Read-Host "MaxSpawnedAnimals (최대 동물 스폰량. 기본값: 50) "
$script:server_MaxSpawnedAnimals_line = Select-String "MaxSpawnedAnimals" $script:Filepath1
$script:server_MaxSpawnedAnimals_value = '<property name="MaxSpawnedAnimals"				value="' + $script:server_MaxSpawnedAnimals + '" />'
(Get-Content $script:Filepath1).replace($script:server_MaxSpawnedAnimals_line.Line,$script:server_MaxSpawnedAnimals_value) | Set-Content $script:Filepath1
Write-Host ""

$script:server_ZombieMove = Read-Host "ZombieMove (좀비 이동 속도. 기본값: 0, 0-4 (walk, jog, run, sprint, nightmare)) "
$script:server_ZombieMove_line = Select-String "ZombieMove" $script:Filepath1
$script:server_ZombieMove_value = '<property name="ZombieMove"						value="' + $script:server_ZombieMove + '" />'
(Get-Content $script:Filepath1).replace($script:server_ZombieMove_line.Line[0],$script:server_ZombieMove_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_ZombieMoveNight = Read-Host "ZombieMoveNight (야간 좀비 이동 속도. 기본값: 3, 0-4 (walk, jog, run, sprint, nightmare)) "
$script:server_ZombieMoveNight_line = Select-String "ZombieMoveNight" $script:Filepath1
$script:server_ZombieMoveNight_value = '<property name="ZombieMoveNight"				value="' + $script:server_ZombieMoveNight + '" />'
(Get-Content $script:Filepath1).replace($script:server_ZombieMoveNight_line.Line,$script:server_ZombieMoveNight_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_ZombieFeralMove = Read-Host "ZombieFeralMove (구울(?) 이동 속도. 기본값: 3, 0-4 (walk, jog, run, sprint, nightmare)) "
$script:server_ZombieFeralMove_line = Select-String "ZombieFeralMove" $script:Filepath1
$script:server_ZombieFeralMove_value = '<property name="ZombieFeralMove"				value="' + $script:server_ZombieFeralMove + '" />'
(Get-Content $script:Filepath1).replace($script:server_ZombieFeralMove_line.Line,$script:server_ZombieFeralMove_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_ZombieBMMove = Read-Host "ZombieBMMove (블러드문 이동 속도. 기본값: 3, 0-4 (walk, jog, run, sprint, nightmare)) "
$script:server_ZombieBMMove_line = Select-String "ZombieBMMove" $script:Filepath1
$script:server_ZombieBMMove_value = '<property name="ZombieBMMove"					value="' + $script:server_ZombieBMMove + '" />'
(Get-Content $script:Filepath1).replace($script:server_ZombieBMMove_line.Line,$script:server_ZombieBMMove_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BloodMoonFrequency = Read-Host "BloodMoonFrequency (블러드문 빈도. 단위: 일, 기본값: 7) "
$script:server_BloodMoonFrequency_line = Select-String "BloodMoonFrequency" $script:Filepath1
$script:server_BloodMoonFrequency_value = '<property name="BloodMoonFrequency"				value="' + $script:server_BloodMoonFrequency + '" />'
(Get-Content $script:Filepath1).replace($script:server_BloodMoonFrequency_line.Line[0],$script:server_BloodMoonFrequency_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BloodMoonEnemyCount = Read-Host "BloodMoonEnemyCount (1인당 블러드문 좀비 숫자. 기본값: 8) "
$script:server_BloodMoonEnemyCount_line = Select-String "BloodMoonEnemyCount" $script:Filepath1
$script:server_BloodMoonEnemyCount_value = '<property name="BloodMoonEnemyCount"			value="' + $script:server_BloodMoonEnemyCount + '" />'
(Get-Content $script:Filepath1).replace($script:server_BloodMoonEnemyCount_line.Line,$script:server_BloodMoonEnemyCount_value) | Set-Content $script:Filepath1
Write-Host ""

$script:server_LootAbundance = Read-Host "LootAbundance (루팅 배율 설정. 높게 설정하면 템 수량이 많아짐. 기본값: 100) "
$script:server_LootAbundance_line = Select-String "LootAbundance" $script:Filepath1
$script:server_LootAbundance_value = '<property name="LootAbundance"					value="' + $script:server_LootAbundance + '" />'
(Get-Content $script:Filepath1).replace($script:server_LootAbundance_line.Line,$script:server_LootAbundance_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_LootRespawnDays = Read-Host "LootRespawnDays (루팅 후 리스폰되는데 소요되는 시간. 기본값: 30) "
$script:server_LootRespawnDays_line = Select-String "LootRespawnDays" $script:Filepath1
$script:server_LootRespawnDays_value = '<property name="LootRespawnDays"				value="' + $script:server_LootRespawnDays + '" />'
(Get-Content $script:Filepath1).replace($script:server_LootRespawnDays_line.Line,$script:server_LootRespawnDays_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_AirDropFrequency = Read-Host "AirDropFrequency (에어드롭 빈도. 단위: 시간, 기본값: 72, 0이면 에어드롭 없음) "
$script:server_AirDropFrequency_line = Select-String "AirDropFrequency" $script:Filepath1
$script:server_AirDropFrequency_value = '<property name="AirDropFrequency"				value="' + $script:server_AirDropFrequency + '" />'
(Get-Content $script:Filepath1).replace($script:server_AirDropFrequency_line.Line,$script:server_AirDropFrequency_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_AirDropMarker = Read-Host "AirDropMarker (에어드롭 마커 표시여부. 활성화: true, 비활성화: false, 기본값: false) "
$script:server_AirDropMarker_line = Select-String "AirDropMarker" $script:Filepath1
$script:server_AirDropMarker_value = '<property name="AirDropMarker"					value="' + $script:server_AirDropMarker + '" />'
(Get-Content $script:Filepath1).replace($script:server_AirDropMarker_line.Line,$script:server_AirDropMarker_value) | Set-Content $script:Filepath1
Write-Host ""

$script:server_PartySharedKillRange = Read-Host "PartySharedKillRange (파티원 경험치 공유 거리. 단위: M, 기본값: 100) "
$script:server_PartySharedKillRange_line = Select-String "PartySharedKillRange" $script:Filepath1
$script:server_PartySharedKillRange_value = '<property name="PartySharedKillRange"			value="' + $script:server_PartySharedKillRange + '" />'
(Get-Content $script:Filepath1).replace($script:server_PartySharedKillRange_line.Line,$script:server_PartySharedKillRange_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_PlayerKillingMode = Read-Host "PlayerKillingMode (PK옵션. PK없음: 0, 파티원끼리만: 1, 외부인만: 2, 제한없음(모두): 3, 기본값: 3) "
$script:server_PlayerKillingMode_line = Select-String "PlayerKillingMode" $script:Filepath1
$script:server_PlayerKillingMode_value = '<property name="PlayerKillingMode"				value="' + $script:server_PlayerKillingMode + '" />'
(Get-Content $script:Filepath1).replace($script:server_PlayerKillingMode_line.Line,$script:server_PlayerKillingMode_value) | Set-Content $script:Filepath1
Write-Host ""
}


 function Install_done {
#$script:server_start_bat = $script:install + "\7DTD.bat"
#wget https://raw.githubusercontent.com/mkco5162/steamcmd/main/workshoplist.txt -outfile $script:server_start_bat
Write-Host "서버 실행은 서버 설치 폴더에 가면 " -Foregroundcolor "Green" -NoNewline
Write-Host "7DTD.bat" -Foregroundcolor "Red" -NoNewline
Write-Host "이 있습니다 해당 파일을 더블클릭하여 실행합니다." -Foregroundcolor "Green"
Read-Host '설정이 완료되었습니다. 엔터를 눌러 설치를 종료합니다'
 }

function open_appdata {
    ii $env:appdata\7DaysToDie
}

Info
MainMenu
pause