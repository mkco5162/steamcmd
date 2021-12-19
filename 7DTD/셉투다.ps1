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
    Write-Host "<���θ޴�>" -Foregroundcolor "Cyan"
    Write-Host ""
    Write-Host "1. 7DTD ��������Ʈ ���� ��ġ (Config���� �� ��Ʈ������ ����)"
    Write-Host "2. Config �缳�� (Config ����, Ŀ���Ҹ� �߰�, ���� ����� �缳��)"
    Write-Host "3. ��Ʈ������ (uPNP)"
    Write-Host "4. ���� ������Ʈ �� ���Ἲ �˻� (����)"
    Write-Host "5. �۵����� ���� ����"
    Write-Host "6. ���α׷� ����"
    Write-Host ""
    Write-Host ""
    $Select_mainmenu = Read-Host "��ȣ�� �Է��� �ֽñ� �ٶ��ϴ� "
    switch ($Select_mainmenu)
    {
        '1' {
            Clear-Host
            Write-Host "1. ������ġ" -Foregroundcolor "Green"
            Install_start
            Config_setting
            portmapping
            Install_done
        }
        '2' {
            Clear-Host
            Write-Host "2. Config �缳�� (Config ����, Ŀ���Ҹ� �߰�, ���� ����� �缳��)" -Foregroundcolor "Green"
            Write-Host "7DTD ������ ��ġ�� ������ ������ �ֽʽÿ�" -Foregroundcolor "Green"
            $script:install = Find-Folders
            $script:steamcmd = $script:install + "\cmd"
            $script:runcmd = $script:steamcmd + "\steamcmd.exe"
            Config_setting
            Install_done
        }
        '3' {
            Clear-Host
            Write-Host "3. ��Ʈ������ (uPNP)" -Foregroundcolor "Green"
            portmapping
        }
        '4' {
            Clear-Host
            Write-Host "4. ���� ������Ʈ �� ���Ἲ �˻� (����)" -Foregroundcolor "Green"
            Write-Host "7DTD ������ ��ġ�� ������ ������ �ֽʽÿ�" -Foregroundcolor "Green"
            $script:install = Find-Folders
            Install_What
        }
        '5' {
            Write-Host "5. �۵����� ���� ����" -Foregroundcolor "Green"
            open_appdata
        }
        '6' {
            Clear-Host
            Write-Host "6. ���α׷� ����" -Foregroundcolor "Green"
            exit
        }
        default {
            Clear-Host
            Write-Host "���ð��� �����ϴ� �ٽ� �������ֽñ� �ٶ��ϴ�" -Foregroundcolor "Green"
            MainMenu
        }
    }
 }

 function Check_Java_Installed {
    $check_java_install = & cmd /c "java -version 2>&1"
     if ($check_java_install | Select-String -Pattern "java version `"11.*`"." -Quiet){
         Write-Host "�ڹ�11 ��ġ�� Ȯ�εǾ����ϴ�." -Foregroundcolor "Green"
     }
     else{
        Clear-Host
        Write-Host "�ڹٰ� ��ġ�Ǿ����� �ʽ��ϴ�" -Foregroundcolor "Green"
        Write-Host "��ġ���� �ڹ� 11���� ������ �ʿ��մϴ�" -Foregroundcolor "Green"
        Write-Host "���� �ڹ� 11 �̻��� ��ġ�Ǿ��������� �νĿ� �����Ͽ����� �Ʒ� ������ �Է��� ��ġ�� ������ �����Ͻʽÿ�" -Foregroundcolor "Green"
        Write-Host "force install" -Foregroundcolor "Green"
        $java_force_install = Read-Host "�� "
        if ($java_force_install -eq "force install") {
        }
        else {
            Install_close
        }
     }
 }
 function Install_close {
    Write-Host "���� Ʋ�Ƚ��ϴ�. ��ġ�� �����ϰ� �ڹ� �ٿ�ε� �������� �����մϴ�." -Foregroundcolor "Green"
    Read-Host "���͸� ���� �ڹ�11 �ٿ�ε� �������� �����մϴ�"
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
            $res = [System.Windows.Forms.MessageBox]::Show("������ ����ϼ̽��ϴ�. �ٽ� �����Ͻðڽ��ϱ�?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
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
 Write-host "�α� ������ �κп� ��Ʈ������ ����Ʈ�� ������� �����ڿ��� �����Ͻñ� �ٶ��ϴ�." -Foregroundcolor "Red"
 Read-Host "���͸� ���� ��� �����մϴ�."
 }

function portmapping {
    $script:server_gameport1 = 25000
    $script:server_gameport2 = 25001
    $script:server_gameport3 = 25002
    $script:server_gameport4 = 25003
    Write-Host "��Ʈ�������� �ڵ����� �Ͻ� ��� uPNP����� ����Ͽ� �����մϴ�" -Foregroundcolor "Green"
    $script:portmapping = Read-Host "��Ʈ�������� �ڵ����� ���� �Ͻðڽ��ϱ�? (Y/N) "
    if ("Y" -eq $portmapping) {
        if ($script:install -eq $null) {
            $script:install = Find-Folders
        }
        Check_Java_Installed
        Start_Portmapper
        #portmapper ���� �� ������ ��Ʈ ��Ʈ������
    }
    elseif ("N" -eq $portmapping) {
        Write-Host "��Ʈ������ ����ϼ̽��ϴ�. �������� ��Ʈ������ ���ֽñ� �ٶ��ϴ�" -Foregroundcolor "Green"
        Write-Host ""
        Write-Host ""
        Write-Host "��Ʈ�������� �ʿ��� ��Ʈ�� �ȳ��帳�ϴ�." -Foregroundcolor "Green"
        Write-Host "�Ʒ� ��Ʈ���� ��Ʈ������ ���ֽñ� �ٶ��ϴ�" -Foregroundcolor "Green"
        Write-Host ""
        Write-Host "��Ʈ ����        ��Ʈ��ȣ     ��������" -Foregroundcolor "Yellow"
        Write-Host ""
        Write-Host "���� ��Ʈ1        $script:server_gameport1         UDP" -Foregroundcolor "Cyan"
        Write-Host "���� ��Ʈ2        $script:server_gameport2         UDP" -Foregroundcolor "Cyan"
        Write-Host "���� ��Ʈ3        $script:server_gameport3         UDP" -Foregroundcolor "Cyan"
        Write-Host "���� ��Ʈ4        $script:server_gameport4         UDP" -Foregroundcolor "Cyan"
        Write-Host ""
        Write-Host ""
    }
    else {
        Clear-Host
        Write-Host "�߸��� ���� ���õǾ����ϴ�. �ٽ� �������ֽñ� �ٶ��ϴ�" -Foregroundcolor "Green"
        portmapping
        #�ڵ�/�����б� ���н� �ٽýõ�
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
Write-Host "7DTD ��������Ʈ ������ ��ġ�� ������ �������ּ���" -Foregroundcolor "Green"
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
Write-Host "�� 2�� �� ���� ������ �Ϸ�Ǹ� ��ġ�� ��ӵ˴ϴ�" -Foregroundcolor "Cyan"
Write-Host ""
Start-Sleep -s 120
Stop-Process -Name "7DaysToDieServer"
Stop-Process -Name "cmd"
 }

 function Config_setting {
$script:Filepath1 = $install + "\serverconfig.xml"
$script:steamworkshop = Get-Content $script:Filepath1
$script:input_servername = Read-Host "���� �̸��� ������ �ֽʽÿ�"
Write-Host ""
$script:Set_servername = 'value="' + $script:input_servername + '"'
(Get-Content $script:Filepath1).replace("value=`"My Game Host`"",$script:Set_servername) | Set-Content $script:Filepath1
Write-Host ""
Write-Host "���ݺ��� ���� ���μ����� �����մϴ�." -Foregroundcolor "Green"
Write-Host "�⺻������ ����Ͻ÷��� �׳� ���͸� �����ֽñ� �ٶ��ϴ�." -Foregroundcolor "Green"
Write-Host ""
$script:server_ServerPassword = Read-Host "���� ��й�ȣ ����. ������� ���� "
$script:server_ServerPassword_line = Select-String "ServerPassword" $script:Filepath1
$script:server_ServerPassword_value = '"<property name="ServerPassword"					value="' + $script:ServerPassword + '"/>'
(Get-Content $script:Filepath1).replace($script:ServerPassword_line.Line,$script:ServerPassword_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_difficulty = Read-Host "���� ���̵� ���� (Scavenger:0, Adventurer:1, Nomad(�⺻��):2, Warrior:3, Survivalisk:4, Insane:5) "
$script:server_difficulty_line = Select-String "GameDifficulty" $script:Filepath1
$script:server_difficulty_value = '<property name="GameDifficulty"					value="' + $script:server_difficulty + '"/>'
(Get-Content $script:Filepath1).replace($script:server_difficulty_line.Line,$script:server_difficulty_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BlockDamagePlayer = Read-Host "BlockDamagePlayer (������ ��Ͽ� �ִ� ������ ����. �⺻��:100) "
$script:server_BlockDamagePlayer_line = Select-String "BlockDamagePlayer" $script:Filepath1
$script:server_BlockDamagePlayer_value = '<property name="BlockDamagePlayer"				value="' + $script:server_BlockDamagePlayer + '" />'
(Get-Content $script:Filepath1).replace($script:server_BlockDamagePlayer_line.Line,$script:server_BlockDamagePlayer_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BlockDamageAI = Read-Host "BlockDamageAI (AI(����)�� ��Ͽ� �ִ� ������ ����. �⺻��:100) "
$script:server_BlockDamageAI_line = Select-String "BlockDamageAI" $script:Filepath1
$script:server_BlockDamageAI_value = '<property name="BlockDamageAI"					value="' + $script:server_BlockDamageAI + '" />'
(Get-Content $script:Filepath1).replace($script:server_BlockDamageAI_line.Line[0],$script:server_BlockDamageAI_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BlockDamageAIBM = Read-Host "BlockDamageAIBM (AI(����)�� ���幮 �Ⱓ���� ��Ͽ� �ִ� ������ ����. �⺻��:100) "
$script:server_BlockDamageAIBM_line = Select-String "BlockDamageAIBM" $script:Filepath1
$script:server_BlockDamageAIBM_value = '<property name="BlockDamageAIBM"				value="' + $script:server_BlockDamageAIBM + '" />'
(Get-Content $script:Filepath1).replace($script:server_BlockDamageAIBM_line.Line,$script:server_BlockDamageAIBM_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_XPMultiplier = Read-Host "XPMultiplier (AI(����)�� ���幮 �Ⱓ���� ��Ͽ� �ִ� ������ ����. �⺻��:100) "
$script:server_XPMultiplier_line = Select-String "XPMultiplier" $script:Filepath1
$script:server_XPMultiplier_value = '<property name="XPMultiplier"					value="' + $script:server_XPMultiplier + '" />'
(Get-Content $script:Filepath1).replace($script:server_XPMultiplier_line.Line,$script:server_XPMultiplier_value) | Set-Content $script:Filepath1
Write-Host ""

$script:server_DayNightLength = Read-Host "DayNightLength (�ΰ��� 24�ð��� �귯���µ� �ҿ�Ǵ� �ð�. ����: ��, �⺻��: 60) "
$script:server_DayNightLength_line = Select-String "DayNightLength" $script:Filepath1
$script:server_DayNightLength_value = '<property name="DayNightLength"					value="' + $script:server_DayNightLength + '" />'
(Get-Content $script:Filepath1).replace($script:server_DayNightLength_line.Line,$script:server_DayNightLength_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_DayLightLength = Read-Host "DayLightLength (�ΰ��� 24�ð��� ���� �����ϴ� �ð�. ����: �ð�, �⺻��: 18) "
$script:server_DayLightLength_line = Select-String "DayLightLength" $script:Filepath1
$script:server_DayLightLength_value = '<property name="DayLightLength"					value="' + $script:server_DayLightLength + '" />'
(Get-Content $script:Filepath1).replace($script:server_DayLightLength_line.Line,$script:server_DayLightLength_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_DropOnDeath = Read-Host "DropOnDeath (����� ������ �������. nothing: 0 everything: 1 toolbelt_only: 2 backpack_only: 3 delete_all: 4, �⺻��: 1) "
$script:server_DropOnDeath_line = Select-String "DropOnDeath" $script:Filepath1
$script:server_DropOnDeath_value = '<property name="DropOnDeath"					value="' + $script:server_DropOnDeath + '" />'
(Get-Content $script:Filepath1).replace($script:server_DropOnDeath_line.Line,$script:server_DropOnDeath_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_MaxSpawnedZombies = Read-Host "MaxSpawnedZombies (�ִ� ���� ������. �⺻��: 64) "
$script:server_MaxSpawnedZombies_line = Select-String "MaxSpawnedZombies" $script:Filepath1
$script:server_MaxSpawnedZombies_value = '<property name="MaxSpawnedZombies"				value="' + $script:server_MaxSpawnedZombies + '" />'
(Get-Content $script:Filepath1).replace($script:server_MaxSpawnedZombies_line.Line[0],$script:server_MaxSpawnedZombies_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_MaxSpawnedAnimals = Read-Host "MaxSpawnedAnimals (�ִ� ���� ������. �⺻��: 50) "
$script:server_MaxSpawnedAnimals_line = Select-String "MaxSpawnedAnimals" $script:Filepath1
$script:server_MaxSpawnedAnimals_value = '<property name="MaxSpawnedAnimals"				value="' + $script:server_MaxSpawnedAnimals + '" />'
(Get-Content $script:Filepath1).replace($script:server_MaxSpawnedAnimals_line.Line,$script:server_MaxSpawnedAnimals_value) | Set-Content $script:Filepath1
Write-Host ""

$script:server_ZombieMove = Read-Host "ZombieMove (���� �̵� �ӵ�. �⺻��: 0, 0-4 (walk, jog, run, sprint, nightmare)) "
$script:server_ZombieMove_line = Select-String "ZombieMove" $script:Filepath1
$script:server_ZombieMove_value = '<property name="ZombieMove"						value="' + $script:server_ZombieMove + '" />'
(Get-Content $script:Filepath1).replace($script:server_ZombieMove_line.Line[0],$script:server_ZombieMove_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_ZombieMoveNight = Read-Host "ZombieMoveNight (�߰� ���� �̵� �ӵ�. �⺻��: 3, 0-4 (walk, jog, run, sprint, nightmare)) "
$script:server_ZombieMoveNight_line = Select-String "ZombieMoveNight" $script:Filepath1
$script:server_ZombieMoveNight_value = '<property name="ZombieMoveNight"				value="' + $script:server_ZombieMoveNight + '" />'
(Get-Content $script:Filepath1).replace($script:server_ZombieMoveNight_line.Line,$script:server_ZombieMoveNight_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_ZombieFeralMove = Read-Host "ZombieFeralMove (����(?) �̵� �ӵ�. �⺻��: 3, 0-4 (walk, jog, run, sprint, nightmare)) "
$script:server_ZombieFeralMove_line = Select-String "ZombieFeralMove" $script:Filepath1
$script:server_ZombieFeralMove_value = '<property name="ZombieFeralMove"				value="' + $script:server_ZombieFeralMove + '" />'
(Get-Content $script:Filepath1).replace($script:server_ZombieFeralMove_line.Line,$script:server_ZombieFeralMove_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_ZombieBMMove = Read-Host "ZombieBMMove (���幮 �̵� �ӵ�. �⺻��: 3, 0-4 (walk, jog, run, sprint, nightmare)) "
$script:server_ZombieBMMove_line = Select-String "ZombieBMMove" $script:Filepath1
$script:server_ZombieBMMove_value = '<property name="ZombieBMMove"					value="' + $script:server_ZombieBMMove + '" />'
(Get-Content $script:Filepath1).replace($script:server_ZombieBMMove_line.Line,$script:server_ZombieBMMove_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BloodMoonFrequency = Read-Host "BloodMoonFrequency (���幮 ��. ����: ��, �⺻��: 7) "
$script:server_BloodMoonFrequency_line = Select-String "BloodMoonFrequency" $script:Filepath1
$script:server_BloodMoonFrequency_value = '<property name="BloodMoonFrequency"				value="' + $script:server_BloodMoonFrequency + '" />'
(Get-Content $script:Filepath1).replace($script:server_BloodMoonFrequency_line.Line[0],$script:server_BloodMoonFrequency_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_BloodMoonEnemyCount = Read-Host "BloodMoonEnemyCount (1�δ� ���幮 ���� ����. �⺻��: 8) "
$script:server_BloodMoonEnemyCount_line = Select-String "BloodMoonEnemyCount" $script:Filepath1
$script:server_BloodMoonEnemyCount_value = '<property name="BloodMoonEnemyCount"			value="' + $script:server_BloodMoonEnemyCount + '" />'
(Get-Content $script:Filepath1).replace($script:server_BloodMoonEnemyCount_line.Line,$script:server_BloodMoonEnemyCount_value) | Set-Content $script:Filepath1
Write-Host ""

$script:server_LootAbundance = Read-Host "LootAbundance (���� ���� ����. ���� �����ϸ� �� ������ ������. �⺻��: 100) "
$script:server_LootAbundance_line = Select-String "LootAbundance" $script:Filepath1
$script:server_LootAbundance_value = '<property name="LootAbundance"					value="' + $script:server_LootAbundance + '" />'
(Get-Content $script:Filepath1).replace($script:server_LootAbundance_line.Line,$script:server_LootAbundance_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_LootRespawnDays = Read-Host "LootRespawnDays (���� �� �������Ǵµ� �ҿ�Ǵ� �ð�. �⺻��: 30) "
$script:server_LootRespawnDays_line = Select-String "LootRespawnDays" $script:Filepath1
$script:server_LootRespawnDays_value = '<property name="LootRespawnDays"				value="' + $script:server_LootRespawnDays + '" />'
(Get-Content $script:Filepath1).replace($script:server_LootRespawnDays_line.Line,$script:server_LootRespawnDays_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_AirDropFrequency = Read-Host "AirDropFrequency (������ ��. ����: �ð�, �⺻��: 72, 0�̸� ������ ����) "
$script:server_AirDropFrequency_line = Select-String "AirDropFrequency" $script:Filepath1
$script:server_AirDropFrequency_value = '<property name="AirDropFrequency"				value="' + $script:server_AirDropFrequency + '" />'
(Get-Content $script:Filepath1).replace($script:server_AirDropFrequency_line.Line,$script:server_AirDropFrequency_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_AirDropMarker = Read-Host "AirDropMarker (������ ��Ŀ ǥ�ÿ���. Ȱ��ȭ: true, ��Ȱ��ȭ: false, �⺻��: false) "
$script:server_AirDropMarker_line = Select-String "AirDropMarker" $script:Filepath1
$script:server_AirDropMarker_value = '<property name="AirDropMarker"					value="' + $script:server_AirDropMarker + '" />'
(Get-Content $script:Filepath1).replace($script:server_AirDropMarker_line.Line,$script:server_AirDropMarker_value) | Set-Content $script:Filepath1
Write-Host ""

$script:server_PartySharedKillRange = Read-Host "PartySharedKillRange (��Ƽ�� ����ġ ���� �Ÿ�. ����: M, �⺻��: 100) "
$script:server_PartySharedKillRange_line = Select-String "PartySharedKillRange" $script:Filepath1
$script:server_PartySharedKillRange_value = '<property name="PartySharedKillRange"			value="' + $script:server_PartySharedKillRange + '" />'
(Get-Content $script:Filepath1).replace($script:server_PartySharedKillRange_line.Line,$script:server_PartySharedKillRange_value) | Set-Content $script:Filepath1
Write-Host ""
$script:server_PlayerKillingMode = Read-Host "PlayerKillingMode (PK�ɼ�. PK����: 0, ��Ƽ��������: 1, �ܺ��θ�: 2, ���Ѿ���(���): 3, �⺻��: 3) "
$script:server_PlayerKillingMode_line = Select-String "PlayerKillingMode" $script:Filepath1
$script:server_PlayerKillingMode_value = '<property name="PlayerKillingMode"				value="' + $script:server_PlayerKillingMode + '" />'
(Get-Content $script:Filepath1).replace($script:server_PlayerKillingMode_line.Line,$script:server_PlayerKillingMode_value) | Set-Content $script:Filepath1
Write-Host ""
}


 function Install_done {
#$script:server_start_bat = $script:install + "\7DTD.bat"
#wget https://raw.githubusercontent.com/mkco5162/steamcmd/main/workshoplist.txt -outfile $script:server_start_bat
Write-Host "���� ������ ���� ��ġ ������ ���� " -Foregroundcolor "Green" -NoNewline
Write-Host "7DTD.bat" -Foregroundcolor "Red" -NoNewline
Write-Host "�� �ֽ��ϴ� �ش� ������ ����Ŭ���Ͽ� �����մϴ�." -Foregroundcolor "Green"
Read-Host '������ �Ϸ�Ǿ����ϴ�. ���͸� ���� ��ġ�� �����մϴ�'
 }

function open_appdata {
    ii $env:appdata\7DaysToDie
}

Info
MainMenu
pause