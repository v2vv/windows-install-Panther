@echo off
::chcp 65001
echo.
echo ------ ��װ��Ϣ -----
echo EFI ������Ϊ %efiDriver%
echo Windows ��װ��Ϊ %imageDriver%
echo wim �ļ�·��Ϊ %wimPath%
echo driver �ļ�·��Ϊ %importDriverPath%
echo unattend �ļ�·��Ϊ %unattendPath%
echo Microsoft.UI.Xaml.2.8 �ļ�·��Ϊ %MicrosoftUIXamlPath%
echo �Ƿ��ʽ��(0:����ʽ�� 1:��ʽ��) ֵ: %format%
echo �Ƿ�װ���� (0:����װ 1:��װ) ֵ: %installImage%
echo �Ƿ���������ļ� (0:���ؽ� 1:�ؽ�) ֵ:%rebuildEFI%
echo �����ļ������Ƿ񱣴�ԭ��ϵͳ���� (0:������ 1:����) ֵ: %otherBOOT%
echo ��ɺ�ػ� (0:������ 1:����) ֵ: %reboot%
echo �Ƿ�������� (0:����� 1:���) ֵ: %addDriver%
echo �Ƿ��������ֵ�� (0:����� 1:���) ֵ: %addAttend%
echo �Ƿ�װ Microsoft.UI.Xaml.2.8 apx (0:����װ 1:��װ) ֵ: %addMicrosoftUIXaml%

::��ʽ��Ӳ��

if %format%==1 (
    echo.
    echo --- 3.1. ���ڸ�ʽ��Ӳ�� %imageDriver% ---
    echo select VOLUME %imageDriver% >temp.txt
    echo format fs=ntfs quick OVERRIDE >>temp.txt
    diskpart /s temp.txt 
    del temp.txt
) else (
    echo.
    echo ������ʽ��������
)

::��װ����
if %installImage%==1 (
    echo.
    echo --- 3.2. ���ڰ�װ���� %imageDriver%---
    dism /Apply-Image /ImageFile:"%wimPath%" /Index:3 /ApplyDir:%imageDriver%\
) else (
    echo.
    echo ������װ���񵽾�����
)

::�������
if %addDriver%==1 (
    echo.
    echo --- 3.3. ����������� %importDriverPath%---
    dism /Image:%imageDriver%\ /Add-Driver /Driver:%importDriverPath% /recurse 
) else (
    echo.
    echo δ�������
)

:: �������ֵ��Ӧ���ļ�
if %addAttend%==1 (
    echo.
    echo --- �����������ֵ��Ӧ���ļ� %unattendPath% ---
    ::dism /Image:%imageDriver%\  /Apply-Unattend:"%unattendPath%"
    xcopy /E /Y "%unattendPath%" "%imageDriver%\Windows\Panther\"
) else (
    echo.
    echo δ�������ֵ��Ӧ���ļ�
)

::��װ Microsoft.UI.Xaml.2.8 apx
if %addMicrosoftUIXaml%==1 (
    echo.
    echo --- 3.4. ���ڰ�װ Microsoft.UI.Xaml.2.8 apx %MicrosoftUIXamlPath%---
    dism /Image:%imageDriver%\ /Add-ProvisionedAppxPackage /PackagePath:%MicrosoftUIXamlPath% /SkipLicense
) else (
    echo.
    echo ������װ Microsoft.UI.Xaml.2.8 apx
)

::���� EFI ����
if %rebuildEFI%==1 (
    echo.
    echo --- 3.5. �����ؽ� EFI ���� ������ %efiDriver% ---
    if %otherBOOT%==0 (
        ::����ɾ��ԭ�������ļ�
        echo.
        echo ����ɾ��ԭ�������ļ�
        rmdir /s /q %efiDriver%\EFI
    ) else (
    echo.
    echo �ѱ�����������ѡ��
)
    bcdboot %imageDriver%\windows /s %efiDriver% /f uefi /l zh-cn
) else (
    echo.
    echo δ���� EFI ����
)

:: ����
if %reboot%==1 (
    echo.
    echo --- 3.6. 30s ������ ---
    TIMEOUT /T 30 /NOBREAK
    shutdown /r /t 0
)



