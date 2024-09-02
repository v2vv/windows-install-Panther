@echo off
::chcp 65001


echo EFI ������Ϊ %efiDriver%
echo Windows ��װ��Ϊ %imageDriver%
echo wim �ļ�·��Ϊ %wimPath%
echo driver �ļ�·��Ϊ %importDriverPath%
echo unattend �ļ�·��Ϊ %unattendPath%
echo Microsoft.UI.Xaml.2.8 �ļ�·��Ϊ %MicrosoftUIXamlPath%
echo �Ƿ��ؽ������ļ� (0:���ؽ� 1:�ؽ�) ֵ:%rebuildEFI%
echo �����ļ��ؽ��Ƿ񱣴�ԭ��ϵͳ���� (0:������ 1:����) ֵ: %otherBOOT%
echo ��ɺ�ػ� (0:������ 1:����) ֵ: %reboot%
echo �Ƿ�������� (0:����� 1:���) ֵ: %addDriver%
echo �Ƿ��������ֵ�� (0:����� 1:���) ֵ: %addAttend%
echo �Ƿ�װ Microsoft.UI.Xaml.2.8 apx (0:����װ 1:��װ) ֵ: %addMicrosoftUIXaml%

::��ʽ��Ӳ��
echo ���ڸ�ʽ��Ӳ�� %imageDriver%
echo select VOLUME %imageDriver% >temp.txt
echo format fs=ntfs quick OVERRIDE >>temp.txt
diskpart /s temp.txt 
del temp.txt

::��װ����
dism /Apply-Image /ImageFile:"%wimPath%" /Index:3 /ApplyDir:%imageDriver%\

::�������
if %addDriver%==1 (
    dism /Image:%imageDriver%\ /Add-Driver /Driver:%importDriverPath% /recurse 
)

:: �������ֵ��Ӧ���ļ�
if %addAttend%==1 (
	::dism /Image:%imageDriver%\  /Apply-Unattend:"%unattendPath%"
	xcopy /E /Y "%unattendPath%" "%imageDriver%\Windows\Panther\"
)

:: ��� Microsoft.UI.Xaml.2.8 appx �����
if %addMicrosoftUIXaml%==1 (
    dism /Image:%imageDriver%\ /Add-ProvisionedAppxPackage /PackagePath:%MicrosoftUIXamlPath% /SkipLicense
)

::�ؽ� EFI ����
if %rebuildEFI%==1 (
    echo �����ؽ� EFI ����
    if %otherBOOT%==0 (
        ::����ɾ��ԭ�������ļ�
        echo ����ɾ��ԭ�������ļ�
        rmdir /s /q %efiDriver%\EFI
    )
    bcdboot %imageDriver%\windows /s %efiDriver% /f uefi /l zh-cn
)

:: ����
if %reboot%==1 (
    echo 30s ������
    TIMEOUT /T 30 /NOBREAK
    shutdown /r /t 0
)



